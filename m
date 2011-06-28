From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5523c-fix-section-mismatches.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:48 -0700
Message-ID: <201106282042.p5SKgUU4003019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab1F1Umq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5523.c: fix section mismatches
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5523c-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5523.c: fix section mismatches
From: Ralf Baechle <ralf@linux-mips.org>

WARNING: drivers/leds/leds-lp5523.o(.text+0x12f4): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led()
The function lp5523_probe() references
the function __init lp5523_init_led().
This is often because lp5523_probe lacks a __init
annotation or the annotation of lp5523_init_led is wrong.

Fixing this one triggers one more mismatch, fix that one as well.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-fix-section-mismatches drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-fix-section-mismatches
+++ a/drivers/leds/leds-lp5523.c
@@ -826,7 +826,7 @@ static int __init lp5523_init_engine(str
 	return 0;
 }
 
-static int __init lp5523_init_led(struct lp5523_led *led, struct device *dev,
+static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 			   int chan, struct lp5523_platform_data *pdata)
 {
 	char name[32];
@@ -872,7 +872,7 @@ static int __init lp5523_init_led(struct
 
 static struct i2c_driver lp5523_driver;
 
-static int lp5523_probe(struct i2c_client *client,
+static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5523_chip		*chip;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

