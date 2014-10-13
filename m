From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 15:38:19 -0700
Message-ID: <543c545b.FrjOfz84gbgrUnDp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-bq32k.c fix warnings I introduced
has been removed from the -mm tree.  Its filename was
     rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch

This patch was dropped because it was folded into rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: drivers/rtc/rtc-bq32k.c fix warnings I introduced

Sorry about that, I somehow failed to notice rather severe warnings.

Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix
+++ a/drivers/rtc/rtc-bq32k.c
@@ -132,9 +132,7 @@ static const struct rtc_class_ops bq32k_
 
 static int trickle_charger_of_init(struct device *dev, struct device_node *node)
 {
-	int plen = 0;
-	const uint32_t *setup;
-	const uint32_t *reg;
+	unsigned char reg;
 	int error;
 	u32 ohms = 0;
 
@@ -166,7 +164,7 @@ static int trickle_charger_of_init(struc
 		break;
 
 	default:
-		dev_err(dev, "invalid resistor value (%d)\n", *setup);
+		dev_err(dev, "invalid resistor value (%d)\n", ohms);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch

