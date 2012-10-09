From: akpm@linux-foundation.org
Subject: [merged] mm-kill-vma-flag-vm_insertpage.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:55 -0700
Message-ID: <20121009180556.2049D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35195 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:58 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so661843qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill vma flag VM_INSERTPAGE
has been removed from the -mm tree.  Its filename was
     mm-kill-vma-flag-vm_insertpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: kill vma flag VM_INSERTPAGE

Merge VM_INSERTPAGE into VM_MIXEDMAP.  VM_MIXEDMAP VMA can mix pure-pfn
ptes, special ptes and normal ptes.

Now copy_page_range() always copies VM_MIXEDMAP VMA on fork like
VM_PFNMAP.  If driver populates whole VMA at mmap() it probably not
expects page-faults.

This patch removes special check from vma_wants_writenotify() which
disables pages write tracking for VMA populated via vm_instert_page(). 
BDI below mapped file should not use dirty-accounting, moreover
do_wp_page() can handle this.

vm_insert_page() still marks vma after first usage.  Usually it is called
from f_op->mmap() handler under mm->mmap_sem write-lock, so it able to
change vma->vm_flags.  Caller must set VM_MIXEDMAP at mmap time if it
wants to call this function from other places, for example from page-fault
handler.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/huge_memory.c   |    3 +--
 mm/ksm.c           |    2 +-
 mm/memory.c        |   14 ++++++++++++--
 mm/mmap.c          |    2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-kill-vma-flag-vm_insertpage include/linux/mm.h
--- a/include/linux/mm.h~mm-kill-vma-flag-vm_insertpage
+++ a/include/linux/mm.h
@@ -103,7 +103,6 @@ extern unsigned int kobjsize(const void 
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
diff -puN mm/huge_memory.c~mm-kill-vma-flag-vm_insertpage mm/huge_memory.c
--- a/mm/huge_memory.c~mm-kill-vma-flag-vm_insertpage
+++ a/mm/huge_memory.c
@@ -1491,8 +1491,7 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_INSERTPAGE|VM_MIXEDMAP| \
-		   VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
diff -puN mm/ksm.c~mm-kill-vma-flag-vm_insertpage mm/ksm.c
--- a/mm/ksm.c~mm-kill-vma-flag-vm_insertpage
+++ a/mm/ksm.c
@@ -1469,7 +1469,7 @@ int ksm_madvise(struct vm_area_struct *v
 		 */
 		if (*vm_flags & (VM_MERGEABLE | VM_SHARED  | VM_MAYSHARE   |
 				 VM_PFNMAP    | VM_IO      | VM_DONTEXPAND |
-				 VM_RESERVED  | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_RESERVED  | VM_HUGETLB |
 				 VM_NONLINEAR | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
diff -puN mm/memory.c~mm-kill-vma-flag-vm_insertpage mm/memory.c
--- a/mm/memory.c~mm-kill-vma-flag-vm_insertpage
+++ a/mm/memory.c
@@ -1047,7 +1047,8 @@ int copy_page_range(struct mm_struct *ds
 	 * readonly mappings. The tradeoff is that copy_page_range is more
 	 * efficient than faulting.
 	 */
-	if (!(vma->vm_flags & (VM_HUGETLB|VM_NONLINEAR|VM_PFNMAP|VM_INSERTPAGE))) {
+	if (!(vma->vm_flags & (VM_HUGETLB | VM_NONLINEAR |
+			       VM_PFNMAP | VM_MIXEDMAP))) {
 		if (!vma->anon_vma)
 			return 0;
 	}
@@ -2085,6 +2086,11 @@ out:
  * ask for a shared writable mapping!
  *
  * The page does not need to be reserved.
+ *
+ * Usually this function is called from f_op->mmap() handler
+ * under mm->mmap_sem write-lock, so it can change vma->vm_flags.
+ * Caller must set VM_MIXEDMAP on vma if it wants to call this
+ * function from other places, for example from page-fault handler.
  */
 int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 			struct page *page)
@@ -2093,7 +2099,11 @@ int vm_insert_page(struct vm_area_struct
 		return -EFAULT;
 	if (!page_count(page))
 		return -EINVAL;
-	vma->vm_flags |= VM_INSERTPAGE;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
 	return insert_page(vma, addr, page, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_page);
diff -puN mm/mmap.c~mm-kill-vma-flag-vm_insertpage mm/mmap.c
--- a/mm/mmap.c~mm-kill-vma-flag-vm_insertpage
+++ a/mm/mmap.c
@@ -1190,7 +1190,7 @@ int vma_wants_writenotify(struct vm_area
 		return 0;
 
 	/* Specialty mapping? */
-	if (vm_flags & (VM_PFNMAP|VM_INSERTPAGE))
+	if (vm_flags & VM_PFNMAP)
 		return 0;
 
 	/* Can the mapping track the dirty pages? */
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

