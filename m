From: akpm@linux-foundation.org
Subject: [patch 018/115] mm: make PR_SET_THP_DISABLE immediately
 active
Date: Mon, 10 Jul 2017 15:48:02 -0700
Message-ID: <20170710224802.YTFc5WBX2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755039AbdGJWsI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, vbabka@suse.cz, xemul@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: make PR_SET_THP_DISABLE immediately active

PR_SET_THP_DISABLE has a rather subtle semantic.  It doesn't affect any
existing mapping because it only updated mm->def_flags which is a template
for new mappings.  The mappings created after prctl(PR_SET_THP_DISABLE)
have VM_NOHUGEPAGE flag set.  This can be quite surprising for all those
applications which do not do prctl(); fork() & exec() and want to control
their own THP behavior.

Another usecase when the immediate semantic of the prctl might be useful
is a combination of pre- and post-copy migration of containers with CRIU. 
In this case CRIU populates a part of a memory region with data that was
saved during the pre-copy stage.  Afterwards, the region is registered
with userfaultfd and CRIU expects to get page faults for the parts of the
region that were not yet populated.  However, khugepaged collapses the
pages and the expected page faults do not occur.

In more general case, the prctl(PR_SET_THP_DISABLE) could be used as a
temporary mechanism for enabling/disabling THP process wide.

Implementation wise, a new MMF_DISABLE_THP flag is added.  This flag is
tested when decision whether to use huge pages is taken either during page
fault of at the time of THP collapse.

It should be noted, that the new implementation makes PR_SET_THP_DISABLE
master override to any per-VMA setting, which was not the case previously.

Fixes: a0715cc22601 ("mm, thp: add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE")
Link: http://lkml.kernel.org/r/1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h        |    1 +
 include/linux/khugepaged.h     |    3 ++-
 include/linux/sched/coredump.h |    5 ++++-
 kernel/sys.c                   |    6 +++---
 mm/khugepaged.c                |    3 ++-
 mm/shmem.c                     |    8 +++++---
 6 files changed, 17 insertions(+), 9 deletions(-)

diff -puN include/linux/huge_mm.h~mm-make-pr_set_thp_disable-immediately-active include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-make-pr_set_thp_disable-immediately-active
+++ a/include/linux/huge_mm.h
@@ -92,6 +92,7 @@ extern bool is_vma_temporary_stack(struc
 	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
 	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
 	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
+	 !test_bit(MMF_DISABLE_THP, &(__vma)->vm_mm->flags) &&		\
 	 !is_vma_temporary_stack(__vma))
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
diff -puN include/linux/khugepaged.h~mm-make-pr_set_thp_disable-immediately-active include/linux/khugepaged.h
--- a/include/linux/khugepaged.h~mm-make-pr_set_thp_disable-immediately-active
+++ a/include/linux/khugepaged.h
@@ -48,7 +48,8 @@ static inline int khugepaged_enter(struc
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
 		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
-		    !(vm_flags & VM_NOHUGEPAGE))
+		    !(vm_flags & VM_NOHUGEPAGE) &&
+		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
diff -puN include/linux/sched/coredump.h~mm-make-pr_set_thp_disable-immediately-active include/linux/sched/coredump.h
--- a/include/linux/sched/coredump.h~mm-make-pr_set_thp_disable-immediately-active
+++ a/include/linux/sched/coredump.h
@@ -68,7 +68,10 @@ static inline int get_dumpable(struct mm
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 #define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
+#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
+				 MMF_DISABLE_THP_MASK)
 
 #endif /* _LINUX_SCHED_COREDUMP_H */
diff -puN kernel/sys.c~mm-make-pr_set_thp_disable-immediately-active kernel/sys.c
--- a/kernel/sys.c~mm-make-pr_set_thp_disable-immediately-active
+++ a/kernel/sys.c
@@ -2360,7 +2360,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	case PR_GET_THP_DISABLE:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
-		error = !!(me->mm->def_flags & VM_NOHUGEPAGE);
+		error = !!test_bit(MMF_DISABLE_THP, &me->mm->flags);
 		break;
 	case PR_SET_THP_DISABLE:
 		if (arg3 || arg4 || arg5)
@@ -2368,9 +2368,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		if (down_write_killable(&me->mm->mmap_sem))
 			return -EINTR;
 		if (arg2)
-			me->mm->def_flags |= VM_NOHUGEPAGE;
+			set_bit(MMF_DISABLE_THP, &me->mm->flags);
 		else
-			me->mm->def_flags &= ~VM_NOHUGEPAGE;
+			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
 		up_write(&me->mm->mmap_sem);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
diff -puN mm/khugepaged.c~mm-make-pr_set_thp_disable-immediately-active mm/khugepaged.c
--- a/mm/khugepaged.c~mm-make-pr_set_thp_disable-immediately-active
+++ a/mm/khugepaged.c
@@ -816,7 +816,8 @@ khugepaged_alloc_page(struct page **hpag
 static bool hugepage_vma_check(struct vm_area_struct *vma)
 {
 	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
-	    (vma->vm_flags & VM_NOHUGEPAGE))
+	    (vma->vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 	if (shmem_file(vma->vm_file)) {
 		if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
diff -puN mm/shmem.c~mm-make-pr_set_thp_disable-immediately-active mm/shmem.c
--- a/mm/shmem.c~mm-make-pr_set_thp_disable-immediately-active
+++ a/mm/shmem.c
@@ -1977,10 +1977,12 @@ static int shmem_fault(struct vm_fault *
 	}
 
 	sgp = SGP_CACHE;
-	if (vma->vm_flags & VM_HUGEPAGE)
-		sgp = SGP_HUGE;
-	else if (vma->vm_flags & VM_NOHUGEPAGE)
+
+	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		sgp = SGP_NOHUGE;
+	else if (vma->vm_flags & VM_HUGEPAGE)
+		sgp = SGP_HUGE;
 
 	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
 				  gfp, vma, vmf, &ret);
_
