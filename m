From: akpm@linux-foundation.org
Subject: [merged] mm-simplify-try_to_unmap_one.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:10 -0800
Message-ID: <200912152154.nBFLsAxH015337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761280AbZLOVys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm: simplify try_to_unmap_one()
has been removed from the -mm tree.  Its filename was
     mm-simplify-try_to_unmap_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: simplify try_to_unmap_one()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
unevictable-lru". So, following code is easy confusable.

        if (vma->vm_flags & VM_LOCKED) {
                ret = SWAP_MLOCK;
                goto out_unmap;
        }

Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
the needed of calling mlock_vma_page().

Also, add some commentary to try_to_unmap_one().

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN mm/rmap.c~mm-simplify-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~mm-simplify-try_to_unmap_one
+++ a/mm/rmap.c
@@ -789,10 +789,9 @@ int try_to_unmap_one(struct page *page, 
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = SWAP_MLOCK;
-			goto out_unmap;
-		}
+		if (vma->vm_flags & VM_LOCKED)
+			goto out_mlock;
+
 		if (TTU_ACTION(flags) == TTU_MUNLOCK)
 			goto out_unmap;
 	}
@@ -865,18 +864,28 @@ int try_to_unmap_one(struct page *page, 
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+out:
+	return ret;
 
-	if (ret == SWAP_MLOCK) {
-		ret = SWAP_AGAIN;
-		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-			if (vma->vm_flags & VM_LOCKED) {
-				mlock_vma_page(page);
-				ret = SWAP_MLOCK;
-			}
-			up_read(&vma->vm_mm->mmap_sem);
+out_mlock:
+	pte_unmap_unlock(pte, ptl);
+
+
+	/*
+	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
+	 * unstable result and race. Plus, We can't wait here because
+	 * we now hold anon_vma->lock or mapping->i_mmap_lock.
+	 * if trylock failed, the page remain in evictable lru and later
+	 * vmscan could retry to move the page to unevictable lru if the
+	 * page is actually mlocked.
+	 */
+	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
+		if (vma->vm_flags & VM_LOCKED) {
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
 		}
+		up_read(&vma->vm_mm->mmap_sem);
 	}
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

