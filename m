From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-fix-section-mismatches.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:46 -0700
Message-ID: <201106282042.p5SKgS93003014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1F1Umq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: fix section mismatches
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: fix section mismatches
From: Ralf Baechle <ralf@linux-mips.org>

WARNING: drivers/leds/leds-lp5521.o(.text+0xf2c): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led()
The function lp5521_probe() references
the function __init lp5521_init_led().
This is often because lp5521_probe lacks a __init
annotation or the annotation of lp5521_init_led is wrong.

Fixing this mismatch triggers one more mismatch, fix that one as well.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-section-mismatches drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-section-mismatches
+++ a/drivers/leds/leds-lp5521.c
@@ -593,7 +593,7 @@ static void lp5521_unregister_sysfs(stru
 				&lp5521_led_attribute_group);
 }
 
-static int __init lp5521_init_led(struct lp5521_led *led,
+static int __devinit lp5521_init_led(struct lp5521_led *led,
 				struct i2c_client *client,
 				int chan, struct lp5521_platform_data *pdata)
 {
@@ -637,7 +637,7 @@ static int __init lp5521_init_led(struct
 	return 0;
 }
 
-static int lp5521_probe(struct i2c_client *client,
+static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*chip;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

