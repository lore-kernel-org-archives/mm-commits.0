From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch removed from -mm
 tree
Date: Wed, 11 Mar 2020 17:25:44 -0700
Message-ID: <20200312002544.E3Wwq9V33%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbgCLAZr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:25:47 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swap_slots.c: don't reset the cache slot after use
has been removed from the -mm tree.  Its filename was
     mm-swap_slotsc-dont-reset-the-cache-slot-after-use.patch

This patch was dropped because an alternative patch was merged

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

mm-swap_slotsc-assignreset-cache-slot-by-value-directly.patch
