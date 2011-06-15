From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-atmel-sscc-use-resource_size.patch removed from -mm tree
Date: Wed, 15 Jun 2011 11:03:26 -0700
Message-ID: <201106151803.p5FI3JYC010397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1FOSDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 14:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/atmel-ssc.c: use resource_size()
has been removed from the -mm tree.  Its filename was
     drivers-misc-atmel-sscc-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/atmel-ssc.c: use resource_size()
From: H Hartley Sweeten <hartleys@visionengravers.com>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel-ssc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/atmel-ssc.c~drivers-misc-atmel-sscc-use-resource_size drivers/misc/atmel-ssc.c
--- a/drivers/misc/atmel-ssc.c~drivers-misc-atmel-sscc-use-resource_size
+++ a/drivers/misc/atmel-ssc.c
@@ -95,7 +95,7 @@ static int __init ssc_probe(struct platf
 	}
 
 	ssc->pdev = pdev;
-	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	ssc->regs = ioremap(regs->start, resource_size(regs));
 	if (!ssc->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -EINVAL;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch

