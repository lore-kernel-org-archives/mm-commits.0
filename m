From: akpm@linux-foundation.org
Subject: + gpio-adp5588-gpio-gpio_start-must-be-signed.patch added to -mm tree
Date: Mon, 18 Oct 2010 16:09:53 -0700
Message-ID: <201010182309.o9IN9r9U007264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab0JRXKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 19:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     gpio: adp5588-gpio: gpio_start must be signed
has been added to the -mm tree.  Its filename is
     gpio-adp5588-gpio-gpio_start-must-be-signed.patch

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
Subject: gpio: adp5588-gpio: gpio_start must be signed
From: Michael Hennerich <michael.hennerich@analog.com>

Common code interprets this as a signed value (a negative value is used to
request dynamic ID allocation), so make sure the platform data has proper
types to support that.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/i2c/adp5588.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/i2c/adp5588.h~gpio-adp5588-gpio-gpio_start-must-be-signed include/linux/i2c/adp5588.h
--- a/include/linux/i2c/adp5588.h~gpio-adp5588-gpio-gpio_start-must-be-signed
+++ a/include/linux/i2c/adp5588.h
@@ -127,9 +127,9 @@ struct adp5588_kpad_platform_data {
 };
 
 struct adp5588_gpio_platform_data {
-	unsigned gpio_start;		/* GPIO Chip base # */
-	unsigned irq_base;		/* interrupt base # */
-	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
+	int gpio_start;		/* GPIO Chip base # */
+	unsigned irq_base;	/* interrupt base # */
+	unsigned pullup_dis_mask; /* Pull-Up Disable Mask */
 	int	(*setup)(struct i2c_client *client,
 				int gpio, unsigned ngpio,
 				void *context);
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch

