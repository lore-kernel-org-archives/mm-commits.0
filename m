From: akpm@linux-foundation.org
Subject: + mm-introduce-vm_lockonfault-v9.patch added to -mm tree
Date: Fri, 11 Sep 2015 15:12:06 -0700
Message-ID: <55f351b6.VaM6Ypc2qcaZM4iB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbbIKWMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-vm_lockonfault-v9
has been added to the -mm tree.  Its filename is
     mm-introduce-vm_lockonfault-v9.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-vm_lockonfault-v9.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-vm_lockonfault-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-introduce-vm_lockonfault-v9

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 -
 drivers/gpu/drm/drm_vm.c           |    8 +-------
 fs/proc/task_mmu.c                 |    1 -
 include/linux/mm.h                 |    3 +++
 kernel/fork.c                      |    4 ++--
 mm/hugetlb.c                       |    4 ++--
 mm/mlock.c                         |    2 +-
 mm/mmap.c                          |    2 +-
 mm/rmap.c                          |    6 ++----
 9 files changed, 12 insertions(+), 19 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-introduce-vm_lockonfault-v9 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-introduce-vm_lockonfault-v9
+++ a/Documentation/filesystems/proc.txt
@@ -471,7 +471,6 @@ manner. The codes are the following:
     rr  - random read advise provided
     dc  - do not copy area on fork
     de  - do not expand area on remapping
-    lf  - mark area to lock pages when faulted in, do not pre-populate
     ac  - area is accountable
     nr  - swap space is not reserved for the area
     ht  - area uses huge tlb pages
diff -puN drivers/gpu/drm/drm_vm.c~mm-introduce-vm_lockonfault-v9 drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-introduce-vm_lockonfault-v9
+++ a/drivers/gpu/drm/drm_vm.c
@@ -699,15 +699,9 @@ int drm_vma_info(struct seq_file *m, voi
 		   (void *)(unsigned long)virt_to_phys(high_memory));
 
 	list_for_each_entry(pt, &dev->vmalist, head) {
-		char lock_flag = '-';
-
 		vma = pt->vma;
 		if (!vma)
 			continue;
-		if (vma->vm_flags & VM_LOCKONFAULT)
-			lock_flag = 'f';
-		else if (vma->vm_flags & VM_LOCKED)
-			lock_flag = 'l';
 		seq_printf(m,
 			   "\n%5d 0x%pK-0x%pK %c%c%c%c%c%c 0x%08lx000",
 			   pt->pid,
@@ -716,7 +710,7 @@ int drm_vma_info(struct seq_file *m, voi
 			   vma->vm_flags & VM_WRITE ? 'w' : '-',
 			   vma->vm_flags & VM_EXEC ? 'x' : '-',
 			   vma->vm_flags & VM_MAYSHARE ? 's' : 'p',
-			   lock_flag,
+			   vma->vm_flags & VM_LOCKED ? 'l' : '-',
 			   vma->vm_flags & VM_IO ? 'i' : '-',
 			   vma->vm_pgoff);
 
diff -puN fs/proc/task_mmu.c~mm-introduce-vm_lockonfault-v9 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-introduce-vm_lockonfault-v9
+++ a/fs/proc/task_mmu.c
@@ -598,7 +598,6 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_RAND_READ)]	= "rr",
 		[ilog2(VM_DONTCOPY)]	= "dc",
 		[ilog2(VM_DONTEXPAND)]	= "de",
-		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_ACCOUNT)]	= "ac",
 		[ilog2(VM_NORESERVE)]	= "nr",
 		[ilog2(VM_HUGETLB)]	= "ht",
diff -puN include/linux/mm.h~mm-introduce-vm_lockonfault-v9 include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vm_lockonfault-v9
+++ a/include/linux/mm.h
@@ -202,6 +202,9 @@ extern unsigned int kobjsize(const void
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
+/* This mask is used to clear all the VMA flags used by mlock */
+#define VM_LOCKED_CLEAR_MASK	(~(VM_LOCKED | VM_LOCKONFAULT))
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff -puN kernel/fork.c~mm-introduce-vm_lockonfault-v9 kernel/fork.c
--- a/kernel/fork.c~mm-introduce-vm_lockonfault-v9
+++ a/kernel/fork.c
@@ -454,8 +454,8 @@ static int dup_mmap(struct mm_struct *mm
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED | VM_UFFD_MISSING | VM_UFFD_WP |
-					VM_LOCKONFAULT);
+		tmp->vm_flags &=
+			~(VM_LOCKED|VM_LOCKONFAULT|VM_UFFD_MISSING|VM_UFFD_WP);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
diff -puN mm/hugetlb.c~mm-introduce-vm_lockonfault-v9 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-introduce-vm_lockonfault-v9
+++ a/mm/hugetlb.c
@@ -4020,8 +4020,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED|VM_LOCKONFAULT);
-	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED|VM_LOCKONFAULT);
+	unsigned long vm_flags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	unsigned long svm_flags = svma->vm_flags & VM_LOCKED_CLEAR_MASK;
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN mm/mlock.c~mm-introduce-vm_lockonfault-v9 mm/mlock.c
--- a/mm/mlock.c~mm-introduce-vm_lockonfault-v9
+++ a/mm/mlock.c
@@ -422,7 +422,7 @@ static unsigned long __munlock_pagevec_f
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
-	vma->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
 	while (start < end) {
 		struct page *page = NULL;
diff -puN mm/mmap.c~mm-introduce-vm_lockonfault-v9 mm/mmap.c
--- a/mm/mmap.c~mm-introduce-vm_lockonfault-v9
+++ a/mm/mmap.c
@@ -1670,7 +1670,7 @@ out:
 					vma == get_gate_vma(current->mm)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 		else
-			vma->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 	}
 
 	if (file)
diff -puN mm/rmap.c~mm-introduce-vm_lockonfault-v9 mm/rmap.c
--- a/mm/rmap.c~mm-introduce-vm_lockonfault-v9
+++ a/mm/rmap.c
@@ -848,8 +848,7 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			spin_unlock(ptl);
-			pra->vm_flags |=
-				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |= VM_LOCKED;
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -870,8 +869,7 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |=
-				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |= VM_LOCKED;
 			return SWAP_FAIL; /* To break the loop */
 		}
 
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-introduce-vm_lockonfault-v9.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v9.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v9.patch
mips-add-entry-for-new-mlock2-syscall.patch

