From: akpm@linux-foundation.org
Subject: + gpio-adp5588-gpio-add-i2c-forward-declaration.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:52:31 -0700
Message-ID: <201010212152.o9LLqVPB005826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070Ab0JUVwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     gpio: adp5588-gpio: add i2c forward declaration
has been added to the -mm tree.  Its filename is
     gpio-adp5588-gpio-add-i2c-forward-declaration.patch

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
Subject: gpio: adp5588-gpio: add i2c forward declaration
From: Michael Hennerich <michael.hennerich@analog.com>

Some ADP5588 functions take a pointer to an i2c_client, but if the i2c
header doesn't happen to be included first, we hit the standard "struct
declared inside parameter list" warnings from gcc.  So add a simple
forward decl of the i2c_client struct.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/i2c/adp5588.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/i2c/adp5588.h~gpio-adp5588-gpio-add-i2c-forward-declaration include/linux/i2c/adp5588.h
--- a/include/linux/i2c/adp5588.h~gpio-adp5588-gpio-add-i2c-forward-declaration
+++ a/include/linux/i2c/adp5588.h
@@ -140,6 +140,8 @@ struct adp5588_kpad_platform_data {
 	const struct adp5588_gpio_platform_data *gpio_data;
 };
 
+struct i2c_client; /* forward declaration */
+
 struct adp5588_gpio_platform_data {
 	int gpio_start;		/* GPIO Chip base # */
 	unsigned irq_base;	/* interrupt base # */
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
video-backlight-adp8860-fix-ambient-light-zone-overwrite-handling.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252.patch
misc-devices-do-not-enable-by-default.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-support-interrupt-controller-update.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch
gpio-adp5588-gpio-add-i2c-forward-declaration.patch

