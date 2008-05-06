From: akpm@linux-foundation.org
Subject: + asic3-platform_get_irq-may-return-signed-unnoticed.patch added to -mm tree
Date: Tue, 06 May 2008 14:51:58 -0700
Message-ID: <200805062151.m46LpwRt029226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbYEFVxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:53:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, joe@perches.com, sameo@openedhand.com


The patch titled
     asic3: platform_get_irq() may return signed unnoticed
has been added to the -mm tree.  Its filename is
     asic3-platform_get_irq-may-return-signed-unnoticed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asic3: platform_get_irq() may return signed unnoticed
From: Roel Kluin <12o3l@tiscali.nl>

asic->irq_nr is unsigned. platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Joe Perches <joe@perches.com>
Acked-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-platform_get_irq-may-return-signed-unnoticed drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-platform_get_irq-may-return-signed-unnoticed
+++ a/drivers/mfd/asic3.c
@@ -300,10 +300,13 @@ static int asic3_irq_probe(struct platfo
 	struct asic3 *asic = platform_get_drvdata(pdev);
 	unsigned long clksel = 0;
 	unsigned int irq, irq_base;
+	int ret;
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
 
-	asic->irq_nr = platform_get_irq(pdev, 0);
-	if (asic->irq_nr < 0)
-		return asic->irq_nr;
+	asic->irq_nr = ret;
 
 	/* turn on clock to IRQ controller */
 	clksel |= CLOCK_SEL_CX;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

linux-next.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
spi_mpc83xx-much-improved-driver.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

