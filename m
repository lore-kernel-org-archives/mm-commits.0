From: akpm@linux-foundation.org
Subject: + gpiolib-a-gpio-is-unsigned-so-use-%u-to-print-it.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:25:38 -0700
Message-ID: <201003241825.o2OIPcMp017069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab0CXS0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david-b@pacbell.net


The patch titled
     gpiolib: a gpio is unsigned, so use %u to print it
has been added to the -mm tree.  Its filename is
     gpiolib-a-gpio-is-unsigned-so-use-%u-to-print-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpiolib: a gpio is unsigned, so use %u to print it
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-a-gpio-is-unsigned-so-use-%u-t=
o-print-it drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-a-gpio-is-unsigned-so-use-%u-to-pr=
int-it
+++ a/drivers/gpio/gpiolib.c
@@ -752,7 +752,7 @@ int gpio_export(unsigned gpio, bool dire
 		struct device	*dev;
=20
 		dev =3D device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				desc, ioname ? ioname : "gpio%d", gpio);
+				desc, ioname ? ioname : "gpio%u", gpio);
 		if (!IS_ERR(dev)) {
 			status =3D sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
gpiolib-make-names-array-and-its-values-const.patch
gpiolib-a-gpio-is-unsigned-so-use-%u-to-print-it.patch
gpiolib-document-that-names-can-contain-printk-format-specifiers.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
