From: akpm@linux-foundation.org
Subject: [merged] mmap-avoid-merging-cloned-vmas.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:15 -0700
Message-ID: <201105252025.p4PKPcOG014409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab1EYU0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, andi@firstfloor.org, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mmap: avoid merging cloned VMAs
has been removed from the -mm tree.  Its filename was
     mmap-avoid-merging-cloned-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: avoid merging cloned VMAs
From: Shaohua Li <shaohua.li@intel.com>

Avoid merging a VMA with another VMA which is cloned from the parent process.

The cloned VMA shares the anon_vma lock with the parent process's VMA.  If
we do the merge, more vmas (even the new range is only for current
process) use the perent process's anon_vma lock.  This introduces
scalability issues.  find_mergeable_anon_vma() already considers this
case.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mmap-avoid-merging-cloned-vmas mm/mmap.c
--- a/mm/mmap.c~mmap-avoid-merging-cloned-vmas
+++ a/mm/mmap.c
@@ -703,9 +703,17 @@ static inline int is_mergeable_vma(struc
 }
 
 static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
-					struct anon_vma *anon_vma2)
+					struct anon_vma *anon_vma2,
+					struct vm_area_struct *vma)
 {
-	return !anon_vma1 || !anon_vma2 || (anon_vma1 == anon_vma2);
+	/*
+	 * The list_is_singular() test is to avoid merging VMA cloned from
+	 * parents. This can improve scalability caused by anon_vma lock.
+	 */
+	if ((!anon_vma1 || !anon_vma2) && (!vma ||
+		list_is_singular(&vma->anon_vma_chain)))
+		return 1;
+	return anon_vma1 == anon_vma2;
 }
 
 /*
@@ -724,7 +732,7 @@ can_vma_merge_before(struct vm_area_stru
 	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
 {
 	if (is_mergeable_vma(vma, file, vm_flags) &&
-	    is_mergeable_anon_vma(anon_vma, vma->anon_vma)) {
+	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
 			return 1;
 	}
@@ -743,7 +751,7 @@ can_vma_merge_after(struct vm_area_struc
 	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
 {
 	if (is_mergeable_vma(vma, file, vm_flags) &&
-	    is_mergeable_anon_vma(anon_vma, vma->anon_vma)) {
+	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
@@ -821,7 +829,7 @@ struct vm_area_struct *vma_merge(struct 
 				can_vma_merge_before(next, vm_flags,
 					anon_vma, file, pgoff+pglen) &&
 				is_mergeable_anon_vma(prev->anon_vma,
-						      next->anon_vma)) {
+						      next->anon_vma, NULL)) {
 							/* cases 1, 6 */
 			err = vma_adjust(prev, prev->vm_start,
 				next->vm_end, prev->vm_pgoff, NULL);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

