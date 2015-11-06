From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-calculate-start-order-with-reserved-in-consideration.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:07:06 -0800
Message-ID: <563d086a.laPAmLkMlJogijQt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbbKFUHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: calculate start order with reserved in consideration
has been removed from the -mm tree.  Its filename was
     mm-slub-calculate-start-order-with-reserved-in-consideration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/slub: calculate start order with reserved in consideration

In slub_order(), the order starts from max(min_order,
get_order(min_objects * size)).  When (min_objects * size) has different
order from (min_objects * size + reserved), it will skip this order via a
check in the loop.

This patch optimizes this a little by calculating the start order with
`reserved' in consideration and removing the check in loop.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/slub.c~mm-slub-calculate-start-order-with-reserved-in-consideration mm/slub.c
--- a/mm/slub.c~mm-slub-calculate-start-order-with-reserved-in-consideration
+++ a/mm/slub.c
@@ -2912,19 +2912,15 @@ static inline int slab_order(int size, i
 	if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
 		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
 
-	for (order = max(min_order, get_order(min_objects * size));
+	for (order = max(min_order, get_order(min_objects * size + reserved));
 			order <= max_order; order++) {
 
 		unsigned long slab_size = PAGE_SIZE << order;
 
-		if (slab_size < min_objects * size + reserved)
-			continue;
-
 		rem = (slab_size - reserved) % size;
 
 		if (rem <= slab_size / fract_leftover)
 			break;
