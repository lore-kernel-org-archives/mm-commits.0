From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-fix-section-mismatches.patch added to -mm tree
Date: Mon, 27 Jun 2011 13:33:43 -0700
Message-ID: <201106272033.p5RKXhBk025126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab1F0UeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 16:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5523.c: fix section mismatches
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-fix-section-mismatches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-leds-leds-lp5521c-fix-section-mismatches.patch
drivers-leds-leds-lp5523c-fix-section-mismatches.patch
drivers-misc-ioc4c-fix-section-mismatch-race-condition.patch
linux-next.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

