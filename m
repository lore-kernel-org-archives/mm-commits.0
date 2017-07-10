From: akpm@linux-foundation.org
Subject: [patch 045/115] mm/page_alloc.c: eliminate unsigned
 confusion in __rmqueue_fallback
Date: Mon, 10 Jul 2017 15:49:26 -0700
Message-ID: <20170710224926.oSalAeKzf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754956AbdGJWt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, haolee.swjtu@gmail.com, linux@rasmusvillemoes.dk, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, weiyang@gmail.com

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/page_alloc.c: eliminate unsigned confusion in __rmqueue_fallback

Since current_order starts as MAX_ORDER-1 and is then only decremented,
the second half of the loop condition seems superfluous.  However, if
order is 0, we may decrement current_order past 0, making it UINT_MAX. 
This is obviously too subtle ([1], [2]).

Since we need to add some comment anyway, change the two variables to
signed, making the counting-down for loop look more familiar, and
apparently also making gcc generate slightly smaller code.

[1] https://lkml.org/lkml/2016/6/20/493
[2] https://lkml.org/lkml/2017/6/19/345

[akpm@linux-foundation.org: fix up reject fixupping]
Link: http://lkml.kernel.org/r/20170621185529.2265-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Hao Lee <haolee.swjtu@gmail.com>
Acked-by: Wei Yang <weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback
+++ a/mm/page_alloc.c
@@ -2206,12 +2206,16 @@ static bool unreserve_highatomic_pageblo
  * list of requested migratetype, possibly along with other pages from the same
  * block, depending on fragmentation avoidance heuristics. Returns true if
  * fallback was found so that __rmqueue_smallest() can grab it.
+ *
+ * The use of signed ints for order and current_order is a deliberate
+ * deviation from the rest of this file, to make the for loop
+ * condition simpler.
  */
 static inline bool
-__rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
+__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 {
 	struct free_area *area;
-	unsigned int current_order;
+	int current_order;
 	struct page *page;
 	int fallback_mt;
 	bool can_steal;
@@ -2221,8 +2225,7 @@ __rmqueue_fallback(struct zone *zone, un
 	 * approximates finding the pageblock with the most free pages, which
 	 * would be too costly to do exactly.
 	 */
-	for (current_order = MAX_ORDER-1;
-				current_order >= order && current_order <= MAX_ORDER-1;
+	for (current_order = MAX_ORDER - 1; current_order >= order;
 				--current_order) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
_
