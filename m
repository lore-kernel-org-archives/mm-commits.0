From: akpm@linux-foundation.org
Subject: - asic3-platform_get_irq-may-return-signed-unnoticed.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:17 -0700
Message-ID: <200807262113.m6QLDHoN019586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbYGZVOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, joe@perches.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     asic3: platform_get_irq() may return signed unnoticed
has been removed from the -mm tree.  Its filename was
     asic3-platform_get_irq-may-return-signed-unnoticed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/mfd/asic3.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-platform_get_irq-may-return-signed-unnoticed drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-platform_get_irq-may-return-signed-unnoticed
+++ a/drivers/mfd/asic3.c
@@ -314,10 +314,12 @@ static int __init asic3_irq_probe(struct
 	unsigned long clksel = 0;
 	unsigned int irq, irq_base;
 	int map_size;
+	int ret;
 
-	asic->irq_nr = platform_get_irq(pdev, 0);
-	if (asic->irq_nr < 0)
-		return asic->irq_nr;
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+	asic->irq_nr = ret;
 
 	/* turn on clock to IRQ controller */
 	clksel |= CLOCK_SEL_CX;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

