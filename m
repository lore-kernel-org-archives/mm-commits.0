From: akpm@linux-foundation.org
Subject: [merged] mm-slub-use-get_order-instead-of-fls.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:07:04 -0800
Message-ID: <563d0868.kRxuJaar61poTzSx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbbKFUHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use get_order() instead of fls()
has been removed from the -mm tree.  Its filename was
     mm-slub-use-get_order-instead-of-fls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/slub: use get_order() instead of fls()

get_order() is more easy to understand.

This patch just replaces it.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slub.c~mm-slub-use-get_order-instead-of-fls mm/slub.c
--- a/mm/slub.c~mm-slub-use-get_order-instead-of-fls
+++ a/mm/slub.c
@@ -2912,8 +2912,7 @@ static inline int slab_order(int size, i
 	if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
 		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
 
-	for (order = max(min_order,
-				fls(min_objects * size - 1) - PAGE_SHIFT);
+	for (order = max(min_order, get_order(min_objects * size));
 			order <= max_order; order++) {
 
 		unsigned long slab_size = PAGE_SIZE << order;
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


