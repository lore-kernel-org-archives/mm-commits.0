From: akpm@linux-foundation.org
Subject: [merged] mm-slub-correct-the-comment-in-calculate_order.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:02 -0800
Message-ID: <563d0866.U6+JivTabYwPY01C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbbKFUHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: correct the comment in calculate_order()
has been removed from the -mm tree.  Its filename was
     mm-slub-correct-the-comment-in-calculate_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/slub: correct the comment in calculate_order()

In calculate_order(), it tries to calculate the best order by adjusting
the fraction and min_objects.  On each iteration on min_objects, fraction
iterates on 16, 8, 4.  Which means the acceptable waste increases with
1/16, 1/8, 1/4.

This patch corrects the comment according to the code.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-correct-the-comment-in-calculate_order mm/slub.c
--- a/mm/slub.c~mm-slub-correct-the-comment-in-calculate_order
+++ a/mm/slub.c
@@ -2943,7 +2943,7 @@ static inline int calculate_order(int si
 	 * works by first attempting to generate a layout with
 	 * the best configuration and backing off gradually.
 	 *
-	 * First we reduce the acceptable waste in a slab. Then
+	 * First we increase the acceptable waste in a slab. Then
 	 * we reduce the minimum objects required in a slab.
 	 */
 	min_objects = slub_min_objects;
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


