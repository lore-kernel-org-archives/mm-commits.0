From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:35:27 -0700
Message-ID: <590a4d1f.3h1QV2qzOKMXPnnn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVf2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mhocko@suse.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use VM_WARN_ON_ONCE as if condition
has been removed from the -mm tree.  Its filename was
     mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch

This patch was dropped because it was folded into mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not use VM_WARN_ON_ONCE as if condition

Sergey reported VM_WARN_ON_ONCE returns void with !CONFIG_DEBUG_VM
so we cannot use it as if's condition unlike WARN_ON.

This patch fixes it.

Link: http://lkml.kernel.org/r/20170309060226.GB854@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix mm/rmap.c
--- a/mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix
+++ a/mm/rmap.c
@@ -1418,12 +1418,11 @@ static int try_to_unmap_one(struct page
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
-			if (VM_WARN_ON_ONCE(PageSwapBacked(page) !=
-						PageSwapCache(page))) {
+			if (unlikely(PageSwapBacked(page) != PageSwapCache(page))) {
+				WARN_ON_ONCE(1);
 				ret = SWAP_FAIL;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
-
 			}
 
 			/* MADV_FREE page check */
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

