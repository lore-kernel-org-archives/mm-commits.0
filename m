From: akpm@linux-foundation.org
Subject: + gpiolib-make-names-array-and-its-values-const.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:25:34 -0700
Message-ID: <201003241825.o2OIPZKh017063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695Ab0CXS0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david-b@pacbell.net, kevin.wells@nxp.com


The patch titled
     gpiolib: make names array and its values const
has been added to the -mm tree.  Its filename is
     gpiolib-make-names-array-and-its-values-const.patch

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
Subject: gpiolib: make names array and its values const
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

gpiolib doesn't need to modify the names and I assume most initializers
use string constants that shouldn't be modified anyhow.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c      |    2 +-
 drivers/gpio/pca953x.c      |    2 +-
 include/asm-generic/gpio.h  |    2 +-
 include/linux/i2c/pca953x.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-make-names-array-and-its-value=
s-const drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-make-names-array-and-its-values-co=
nst
+++ a/drivers/gpio/gpiolib.c
@@ -721,7 +721,7 @@ int gpio_export(unsigned gpio, bool dire
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 	int			status =3D -EINVAL;
-	char			*ioname =3D NULL;
+	const char		*ioname =3D NULL;
=20
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
diff -puN drivers/gpio/pca953x.c~gpiolib-make-names-array-and-its-value=
s-const drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpiolib-make-names-array-and-its-values-co=
nst
+++ a/drivers/gpio/pca953x.c
@@ -72,7 +72,7 @@ struct pca953x_chip {
 	struct i2c_client *client;
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
-	char **names;
+	const char *const *names;
 };
=20
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint1=
6_t val)
diff -puN include/asm-generic/gpio.h~gpiolib-make-names-array-and-its-v=
alues-const include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-make-names-array-and-its-value=
s-const
+++ a/include/asm-generic/gpio.h
@@ -99,7 +99,7 @@ struct gpio_chip {
 						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
-	char			**names;
+	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
 };
diff -puN include/linux/i2c/pca953x.h~gpiolib-make-names-array-and-its-=
values-const include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~gpiolib-make-names-array-and-its-valu=
es-const
+++ a/include/linux/i2c/pca953x.h
@@ -24,7 +24,7 @@ struct pca953x_platform_data {
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
-	char		**names;
+	const char	*const *names;
 };
=20
 #endif /* _LINUX_PCA953X_H */
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
