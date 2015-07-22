From: akpm@linux-foundation.org
Subject: +
 iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch added to -mm tree
Date: Wed, 22 Jul 2015 14:06:15 -0700
Message-ID: <55b005c7.lLEuhlpG50KNKaUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbGVVGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 17:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sowmini.varadhan@oracle.com, benh@kernel.crashing.org, davem@davemloft.net, linux@rasmusvillemoes.dk, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iommu-common.c: do not use 0xffffffffffffffffl for computing align_mask
has been added to the -mm tree.  Its filename is
     iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: lib/iommu-common.c: do not use 0xffffffffffffffffl for computing align_mask

Using a 64 bit constant generates "warning: integer constant is too large
for 'long' type" on 32 bit platforms.  Instead use ~0ul and BITS_PER_LONG.

Detected by Andrew Morton on ARMD.

Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iommu-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/iommu-common.c~iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask lib/iommu-common.c
--- a/lib/iommu-common.c~iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask
+++ a/lib/iommu-common.c
@@ -119,7 +119,7 @@ unsigned long iommu_tbl_range_alloc(stru
 	unsigned long align_mask = 0;
 
 	if (align_order > 0)
-		align_mask = 0xffffffffffffffffl >> (64 - align_order);
+		align_mask = ~0ul >> (BITS_PER_LONG - align_order);
 
 	/* Sanity check */
 	if (unlikely(npages == 0)) {
_

Patches currently in -mm which might be from sowmini.varadhan@oracle.com are

iommu-common-do-not-use-64-bit-constant-0xffffffffffffffffl-for-computing-align_mask.patch
linux-next.patch

