From: akpm@linux-foundation.org
Subject: - mm-fix-madvise-infinine-loop.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:00 -0800
Message-ID: <200703180909.l2I99010019987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXCRJK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, pbadari@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix madvise infinine loop
has been removed from the -mm tree.  Its filename was
     mm-fix-madvise-infinine-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: fix madvise infinine loop
From: Nick Piggin <npiggin@suse.de>

madvise(MADV_REMOVE) can go into an infinite loop or cause an oops if the
call covers a region from the start of a vma, and extending past that vma.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-fix-madvise-infinine-loop mm/madvise.c
--- a/mm/madvise.c~mm-fix-madvise-infinine-loop
+++ a/mm/madvise.c
@@ -155,11 +155,14 @@ static long madvise_dontneed(struct vm_a
  * Other filesystems return -ENOSYS.
  */
 static long madvise_remove(struct vm_area_struct *vma,
+				struct vm_area_struct **prev,
 				unsigned long start, unsigned long end)
 {
 	struct address_space *mapping;
         loff_t offset, endoff;
 
+	*prev = vma;
+
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
 
@@ -199,7 +202,7 @@ madvise_vma(struct vm_area_struct *vma, 
 		error = madvise_behavior(vma, prev, start, end, behavior);
 		break;
 	case MADV_REMOVE:
-		error = madvise_remove(vma, start, end);
+		error = madvise_remove(vma, prev, start, end);
 		break;
 
 	case MADV_WILLNEED:
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
splice-dont-steal.patch
splice-dont-readpage.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-filemapc-fix-mark_page_accessed-logic.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
