From: akpm@linux-foundation.org
Subject: + mm-slub-correct-the-comment-in-calculate_order.patch added to
 -mm tree
Date: Wed, 21 Oct 2015 13:46:26 -0700
Message-ID: <5627f9a2.8EsuonK6pZIegP5b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbJUUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: correct the comment in calculate_order()
has been added to the -mm tree.  Its filename is
     mm-slub-correct-the-comment-in-calculate_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-correct-the-comment-in-calculate_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-correct-the-comment-in-calculate_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3053,7 +3053,7 @@ static inline int calculate_order(int si
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

mm-slub-correct-the-comment-in-calculate_order.patch
mm-slub-use-get_order-instead-of-fls.patch
mm-slub-calculate-start-order-with-reserved-in-consideration.patch

