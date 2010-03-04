From: akpm@linux-foundation.org
Subject: + mm-add-comment-on-swap_duplicates-error-code.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:40:21 -0800
Message-ID: <201003042140.o24LeLud031482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab0CDVka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, hughd@google.com, shijie8@gmail.com


The patch titled
     mm: add comment on swap_duplicate's error code
has been added to the -mm tree.  Its filename is
     mm-add-comment-on-swap_duplicates-error-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2164,7 +2164,11 @@ void swap_shmem_alloc(swp_entry_t entry)
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
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-swapfilec-fix-swapon-size-off-by-one.patch
mm-add-comment-on-swap_duplicates-error-code.patch
prio_tree-debugging-patch.patch

