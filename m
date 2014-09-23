From: akpm@linux-foundation.org
Subject: +
 rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch
 added to -mm tree
Date: Tue, 23 Sep 2014 12:44:03 -0700
Message-ID: <5421cd83.G/Ynravoztc4N4PJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaIWToE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 15:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-bq32k.c fix warnings I introduced
has been added to the -mm tree.  Its filename is
     rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-fix.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch

