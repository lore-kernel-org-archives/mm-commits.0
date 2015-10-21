From: akpm@linux-foundation.org
Subject: + mm-slub-use-get_order-instead-of-fls.patch added to -mm tree
Date: Wed, 21 Oct 2015 13:46:28 -0700
Message-ID: <5627f9a4.B+nwHRc70v1JzzeX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbJUUq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use get_order() instead of fls()
has been added to the -mm tree.  Its filename is
     mm-slub-use-get_order-instead-of-fls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-get_order-instead-of-fls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-get_order-instead-of-fls.patch

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
Subject: mm/slub: use get_order() instead of fls()

get_order() is more easy to understand.

This patch just replaces it.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slub.c~mm-slub-use-get_order-instead-of-fls mm/slub.c
--- a/mm/slub.c~mm-slub-use-get_order-instead-of-fls
+++ a/mm/slub.c
@@ -3022,8 +3022,7 @@ static inline int slab_order(int size, i
 	if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
 		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
 
-	for (order = max(min_order,
-				fls(min_objects * size - 1) - PAGE_SHIFT);
+	for (order = max(min_order, get_order(min_objects * size));
 			order <= max_order; order++) {
 
 		unsigned long slab_size = PAGE_SIZE << order;
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

mm-slub-correct-the-comment-in-calculate_order.patch
mm-slub-use-get_order-instead-of-fls.patch
mm-slub-calculate-start-order-with-reserved-in-consideration.patch

