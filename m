From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-on-swap_duplicates-error-code.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:57 -0800
Message-ID: <201003091904.o29J4vbx031081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab0CITFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, hughd@google.com, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: add comment on swap_duplicate's error code
has been removed from the -mm tree.  Its filename was
     mm-add-comment-on-swap_duplicates-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add comment on swap_duplicate's error code
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

swap_duplicate()'s loop appears to miss out on returning the error code
from __swap_duplicate(), except when that's -ENOMEM.  In fact this is
intentional: prior to -ENOMEM for swap_count_continuation,
swap_duplicate() was void (and the case only occurs when copy_one_pte()
hits a corrupt pte).  But that's surprising behaviour, which certainly
deserves a comment.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-add-comment-on-swap_duplicates-error-code mm/swapfile.c
--- a/mm/swapfile.c~mm-add-comment-on-swap_duplicates-error-code
+++ a/mm/swapfile.c
@@ -2161,7 +2161,11 @@ void swap_shmem_alloc(swp_entry_t entry)
 }
 
 /*
- * increase reference count of swap entry by 1.
+ * Increase reference count of swap entry by 1.
+ * Returns 0 for success, or -ENOMEM if a swap_count_continuation is required
+ * but could not be atomically allocated.  Returns 0, just as if it succeeded,
+ * if __swap_duplicate() fails for another reason (-EINVAL or -ENOENT), which
+ * might occur if a page table entry has got corrupted.
  */
 int swap_duplicate(swp_entry_t entry)
 {
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mm-add-swap-slot-free-callback-to-block_device_operations.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
prio_tree-debugging-patch.patch

