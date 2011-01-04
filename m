From: akpm@linux-foundation.org
Subject: + gpiolib-add-missing-functions-to-generic-fallback.patch added to -mm tree
Date: Tue, 04 Jan 2011 12:02:04 -0800
Message-ID: <201101042002.p04K24Cc021510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADUCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 15:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, dbrownell@users.sourceforge.net, gregkh@suse.de


The patch titled
     gpiolib: add missing functions to generic fallback
has been added to the -mm tree.  Its filename is
     gpiolib-add-missing-functions-to-generic-fallback.patch

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
Subject: gpiolib: add missing functions to generic fallback
From: Wolfram Sang <w.sang@pengutronix.de>

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gpio.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN include/linux/gpio.h~gpiolib-add-missing-functions-to-generic-fallback include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-add-missing-functions-to-generic-fallback
+++ a/include/linux/gpio.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 
 struct device;
+struct gpio;
 struct gpio_chip;
 
 /*
@@ -34,6 +35,17 @@ static inline int __must_check gpio_requ
 	return -ENOSYS;
 }
 
+static inline int __must_check gpio_request_one(unsigned gpio,
+					unsigned long flags, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline int __must_check gpio_request_array(struct gpio *array, size_t num)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_free(unsigned gpio)
 {
 	might_sleep();
@@ -42,6 +54,14 @@ static inline void gpio_free(unsigned gp
 	WARN_ON(1);
 }
 
+static inline void gpio_free_array(struct gpio *array, size_t num)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
 static inline int __must_check gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
gpiolib-annotate-gpio-intialization-with-__must_check.patch
gpiolib-add-missing-functions-to-generic-fallback.patch

