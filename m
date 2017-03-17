From: akpm@linux-foundation.org
Subject: + mm-swap-fix-comment-in-__read_swap_cache_async.patch added to
 -mm tree
Date: Fri, 17 Mar 2017 14:38:22 -0700
Message-ID: <58cc574e.VzrhkBBbWnwp6myz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdCQViY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2017 17:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aquini@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Fix comment in __read_swap_cache_async
has been added to the -mm tree.  Its filename is
     mm-swap-fix-comment-in-__read_swap_cache_async.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-comment-in-__read_swap_cache_async.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-comment-in-__read_swap_cache_async.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Fix comment in __read_swap_cache_async

cbab0e4eec29 ("swap: avoid read_swap_cache_async() race to deadlock while
waiting on discard I/O completion") fixed a deadlock in
read_swap_cache_async().  Because at that time, in swap allocation path, a
swap entry may be set as SWAP_HAS_CACHE, then wait for discarding to
complete before the page for the swap entry is added to the swap cache. 
But in 815c2c543d3a ("swap: make swap discard async"), the discarding for
swap become asynchronous, waiting for discarding to complete will be done
before the swap entry is set as SWAP_HAS_CACHE.  So the comments in code
is incorrect now.  This patch fixes the comments.

The cond_resched() added in the commit cbab0e4eec29 is not necessary now
too.  But if we added some sleep in swap allocation path in the future,
there may be some hard to debug/reproduce deadlock bug.  So it is kept.

Link: http://lkml.kernel.org/r/20170317064635.12792-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN mm/swap_state.c~mm-swap-fix-comment-in-__read_swap_cache_async mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-fix-comment-in-__read_swap_cache_async
+++ a/mm/swap_state.c
@@ -360,17 +360,7 @@ struct page *__read_swap_cache_async(swp
 			/*
 			 * We might race against get_swap_page() and stumble
 			 * across a SWAP_HAS_CACHE swap_map entry whose page
-			 * has not been brought into the swapcache yet, while
-			 * the other end is scheduled away waiting on discard
-			 * I/O completion at scan_swap_map().
-			 *
-			 * In order to avoid turning this transitory state
-			 * into a permanent loop around this -EEXIST case
-			 * if !CONFIG_PREEMPT and the I/O completion happens
-			 * to be waiting on the CPU waitqueue where we are now
-			 * busy looping, we just conditionally invoke the
-			 * scheduler here, if there are some more important
-			 * tasks to run.
+			 * has not been brought into the swapcache yet.
 			 */
 			cond_resched();
 			continue;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch

