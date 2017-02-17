From: akpm@linux-foundation.org
Subject: +
 mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch added to -mm tree
Date: Fri, 17 Feb 2017 13:32:41 -0800
Message-ID: <58a76bf9.VhUhp5/q0WD/P9MS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934415AbdBQVcm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2017 16:32:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hughd@google.com, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Fix memory leak in __read_swap_cache_async()
has been added to the -mm tree.  Its filename is
     mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch

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
Subject: mm, swap: Fix memory leak in __read_swap_cache_async()

The memory may be leaked in __read_swap_cache_async().  For the cases
as below,

CPU 0						CPU 1
-----						-----

find_get_page() == NULL
__swp_swapcount() != 0
new_page = alloc_page_vma()
radix_tree_maybe_preload()
						swap in swap slot
swapcache_prepare() == -EEXIST
cond_resched()
						reclaim the swap slot
find_get_page() == NULL
__swp_swapcount() == 0
return NULL				<- new_page leaked here !!!

The memory leak has been confirmed via checking the value of new_page
when returning inside the loop in __read_swap_cache_async().

This is fixed via replacing return with break inside of loop in
__read_swap_cache_async(), so that there is opportunity for the
new_page to be checked and freed.

Link: http://lkml.kernel.org/r/874lzt6znd.fsf@yhuang-dev.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix
+++ a/mm/swap_state.c
@@ -333,7 +333,7 @@ struct page *__read_swap_cache_async(swp
 		 * else swap_off will be aborted if we return NULL.
 		 */
 		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
-			return NULL;
+			break;
 
 		/*
 		 * Get a new page to read into from swap.
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-kernel-message-in-swap_info_get.patch
mm-swap-add-cluster-lock.patch
mm-swap-add-cluster-lock-v5.patch
mm-swap-split-swap-cache-into-64mb-trunks.patch
mm-swap-add-cache-for-swap-slots-allocation-fix.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch

