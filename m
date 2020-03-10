From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch added to -mm tree
Date: Mon, 09 Mar 2020 17:49:01 -0700
Message-ID: <20200310004901.nP_WnsLBs%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbgCJAtC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 20:49:02 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swap_slots.c: don't reset the cache slot after use
has been added to the -mm tree.  Its filename is
     mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/swap_slots.c: don't reset the cache slot after use

Currently we clear the cache slot if it is used.  While this is not
necessary, since this entry would not be used until refilled.

Leave it untouched and assigned the value directly to entry which makes
the code little more neat.

Also this patch merges the else and if, since this is the only case we
refill and repeat swap cache.

Link: http://lkml.kernel.org/r/20200309090940.34130-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/swap_slots.c~mm-swap_slotsc-dont-reset-the-cache-slot-after-use
+++ a/mm/swap_slots.c
@@ -309,7 +309,7 @@ direct_free:
 
 swp_entry_t get_swap_page(struct page *page)
 {
-	swp_entry_t entry, *pentry;
+	swp_entry_t entry;
 	struct swap_slots_cache *cache;
 
 	entry.val = 0;
@@ -336,13 +336,10 @@ swp_entry_t get_swap_page(struct page *p
 		if (cache->slots) {
 repeat:
 			if (cache->nr) {
-				pentry = &cache->slots[cache->cur++];
-				entry = *pentry;
-				pentry->val = 0;
+				entry = cache->slots[cache->cur++];
 				cache->nr--;
-			} else {
-				if (refill_swap_slots_cache(cache))
-					goto repeat;
+			} else if (refill_swap_slots_cache(cache)) {
+				goto repeat;
 			}
 		}
 		mutex_unlock(&cache->alloc_lock);
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch
