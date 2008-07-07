From: akpm@linux-foundation.org
Subject: - asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:06:09 -0700
Message-ID: <200807070306.m67369qa004885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYGGDGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: fix asic3 config array initialisation
has been removed from the -mm tree.  Its filename was
     asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: fix asic3 config array initialisation
From: Philipp Zabel <philipp.zabel@gmail.com>

Our memset length was incorrect.

Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation
+++ a/drivers/mfd/asic3.c
@@ -477,9 +477,9 @@ static int asic3_gpio_probe(struct platf
 	u16 dir_reg[ASIC3_NUM_GPIO_BANKS];
 	int i;
 
-	memset(alt_reg, 0, ASIC3_NUM_GPIO_BANKS);
-	memset(out_reg, 0, ASIC3_NUM_GPIO_BANKS);
-	memset(dir_reg, 0, ASIC3_NUM_GPIO_BANKS);
+	memzero(alt_reg, ASIC3_NUM_GPIO_BANKS * sizeof(u16));
+	memzero(out_reg, ASIC3_NUM_GPIO_BANKS * sizeof(u16));
+	memzero(dir_reg, ASIC3_NUM_GPIO_BANKS * sizeof(u16));
 
 	/* Enable all GPIOs */
 	asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, Mask), 0xffff);
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

