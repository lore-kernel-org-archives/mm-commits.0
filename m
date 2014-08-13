From: akpm@linux-foundation.org
Subject: + fix-checkpatch-errors-for-mm-mmapc.patch added to -mm tree
Date: Wed, 13 Aug 2014 13:42:50 -0700
Message-ID: <53ebcdca.cNT87/LNT5dr8/Lv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:53318 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMUmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:42:51 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so92950pab.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:42:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: whitespace fixes
has been added to the -mm tree.  Its filename is
     fix-checkpatch-errors-for-mm-mmapc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-checkpatch-errors-for-mm-mmapc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-checkpatch-errors-for-mm-mmapc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "vishnu.ps" <vishnu.ps@samsung.com>
Subject: mm/mmap.c: whitespace fixes

Signed-off-by: vishnu.ps <vishnu.ps@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff -puN mm/mmap.c~fix-checkpatch-errors-for-mm-mmapc mm/mmap.c
--- a/mm/mmap.c~fix-checkpatch-errors-for-mm-mmapc
+++ a/mm/mmap.c
@@ -70,7 +70,7 @@ static void unmap_region(struct mm_struc
  * MAP_SHARED	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
  *		w: (no) no	w: (no) no	w: (yes) yes	w: (no) no
  *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *		
+ *
  * MAP_PRIVATE	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
  *		w: (no) no	w: (no) no	w: (copy) copy	w: (no) no
  *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
@@ -741,7 +741,7 @@ again:			remove_next = 1 + (end > next->
 			 * split_vma inserting another: so it must be
 			 * mprotect case 4 shifting the boundary down.
 			 */
-			adjust_next = - ((vma->vm_end - end) >> PAGE_SHIFT);
+			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
 			exporter = vma;
 			importer = next;
 		}
@@ -1010,7 +1010,7 @@ can_vma_merge_after(struct vm_area_struc
 struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
 			unsigned long end, unsigned long vm_flags,
-		     	struct anon_vma *anon_vma, struct file *file,
+			struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
@@ -1036,7 +1036,7 @@ struct vm_area_struct *vma_merge(struct
 	 * Can it merge with the predecessor?
 	 */
 	if (prev && prev->vm_end == addr &&
-  			mpol_equal(vma_policy(prev), policy) &&
+			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
 						anon_vma, file, pgoff)) {
 		/*
@@ -1064,7 +1064,7 @@ struct vm_area_struct *vma_merge(struct
 	 * Can this new request be merged in front of next?
 	 */
 	if (next && end == next->vm_start &&
- 			mpol_equal(policy, vma_policy(next)) &&
+			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
 					anon_vma, file, pgoff+pglen)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
@@ -1235,7 +1235,7 @@ unsigned long do_mmap_pgoff(struct file
 			unsigned long flags, unsigned long pgoff,
 			unsigned long *populate)
 {
-	struct mm_struct * mm = current->mm;
+	struct mm_struct *mm = current->mm;
 	vm_flags_t vm_flags;
 
 	*populate = 0;
@@ -1263,7 +1263,7 @@ unsigned long do_mmap_pgoff(struct file
 
 	/* offset overflow? */
 	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
-               return -EOVERFLOW;
+		return -EOVERFLOW;
 
 	/* Too many mappings? */
 	if (mm->map_count > sysctl_max_map_count)
@@ -1921,7 +1921,7 @@ arch_get_unmapped_area(struct file *filp
 	info.align_mask = 0;
 	return vm_unmapped_area(&info);
 }
-#endif	
+#endif
 
 /*
  * This mmap-allocator allocates new areas top-down from below the
@@ -2321,13 +2321,13 @@ int expand_stack(struct vm_area_struct *
 }
 
 struct vm_area_struct *
-find_extend_vma(struct mm_struct * mm, unsigned long addr)
+find_extend_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 	unsigned long start;
 
 	addr &= PAGE_MASK;
-	vma = find_vma(mm,addr);
+	vma = find_vma(mm, addr);
 	if (!vma)
 		return NULL;
 	if (vma->vm_start <= addr)
@@ -2376,7 +2376,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
+	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -2423,7 +2423,7 @@ detach_vmas_to_be_unmapped(struct mm_str
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
  * munmap path where it doesn't make sense to fail.
  */
-static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
+static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	      unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
@@ -2512,7 +2512,8 @@ int do_munmap(struct mm_struct *mm, unsi
 	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
 
-	if ((len = PAGE_ALIGN(len)) == 0)
+	len = PAGE_ALIGN(len);
+	if (len == 0)
 		return -EINVAL;
 
 	/* Find the first overlapping VMA */
@@ -2558,7 +2559,7 @@ int do_munmap(struct mm_struct *mm, unsi
 		if (error)
 			return error;
 	}
-	vma = prev? prev->vm_next: mm->mmap;
+	vma = prev ? prev->vm_next : mm->mmap;
 
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
@@ -2621,10 +2622,10 @@ static inline void verify_mm_writelocked
  */
 static unsigned long do_brk(unsigned long addr, unsigned long len)
 {
-	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * vma, * prev;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
 	unsigned long flags;
-	struct rb_node ** rb_link, * rb_parent;
+	struct rb_node **rb_link, *rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
 
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

fix-checkpatch-errors-for-mm-mmapc.patch

