From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 056/155] mm/swap_slots.c: assign|reset cache slot
 by value directly
Date: Wed, 01 Apr 2020 21:06:16 -0700
Message-ID: <20200402040616.y_ZhHCgb2%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:18 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/swap_slots.c: assign|reset cache slot by value directly

Currently we use a tmp pointer, pentry, to transfer and reset swap cache
slot, which is a little redundant.  Swap cache slot stores the entry value
directly, assign and reset it by value would be straight forward.

Also this patch merges the else and if, since this is the only case we
refill and repeat swap cache.

Link: http://lkml.kernel.org/r/20200311055352.50574-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/swap_slots.c~mm-swap_slotsc-assignreset-cache-slot-by-value-directly
+++ a/mm/swap_slots.c
@@ -309,7 +309,7 @@ direct_free:
 
 swp_entry_t get_swap_page(struct page *page)
 {
-	swp_entry_t entry, *pentry;
+	swp_entry_t entry;
 	struct swap_slots_cache *cache;
 
 	entry.val = 0;
@@ -336,13 +336,11 @@ swp_entry_t get_swap_page(struct page *p
 		if (cache->slots) {
 repeat:
 			if (cache->nr) {
-				pentry = &cache->slots[cache->cur++];
-				entry = *pentry;
-				pentry->val = 0;
+				entry = cache->slots[cache->cur];
+				cache->slots[cache->cur++].val = 0;
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
