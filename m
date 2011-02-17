From: akpm@linux-foundation.org
Subject: + leds-make-struct-gpio_led_platform_dataleds-const.patch added to -mm tree
Date: Thu, 17 Feb 2011 13:08:07 -0800
Message-ID: <201102172108.p1HL88k5011822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab1BQVIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 16:08:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, lars@metafoo.de, rpurdie@rpsys.net


The patch titled
     leds: make *struct gpio_led_platform_data.leds const
has been added to the -mm tree.  Its filename is
     leds-make-struct-gpio_led_platform_dataleds-const.patch

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
Subject: leds: make *struct gpio_led_platform_data.leds const
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

And fix a typo.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-net5501.c |    2 +-
 include/linux/leds.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-net5501.c~leds-make-struct-gpio_led_platfor=
m_dataleds-const drivers/leds/leds-net5501.c
--- a/drivers/leds/leds-net5501.c~leds-make-struct-gpio_led_platform_da=
taleds-const
+++ a/drivers/leds/leds-net5501.c
@@ -19,7 +19,7 @@
=20
 #include <asm/geode.h>
=20
-static struct gpio_led net5501_leds[] =3D {
+static const struct gpio_led net5501_leds[] =3D {
 	{
 		.name =3D "error",
 		.gpio =3D 6,
diff -puN include/linux/leds.h~leds-make-struct-gpio_led_platform_datal=
eds-const include/linux/leds.h
--- a/include/linux/leds.h~leds-make-struct-gpio_led_platform_dataleds-=
const
+++ a/include/linux/leds.h
@@ -197,11 +197,11 @@ struct gpio_led {
=20
 struct gpio_led_platform_data {
 	int 		num_leds;
-	struct gpio_led *leds;
+	const struct gpio_led *leds;
=20
 #define GPIO_LED_NO_BLINK_LOW	0	/* No blink GPIO state low */
 #define GPIO_LED_NO_BLINK_HIGH	1	/* No blink GPIO state high */
-#define GPIO_LED_BLINK		2	/* Plase, blink */
+#define GPIO_LED_BLINK		2	/* Please, blink */
 	int		(*gpio_blink_set)(unsigned gpio, int state,
 					unsigned long *delay_on,
 					unsigned long *delay_off);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
leds-make-struct-gpio_led_platform_dataleds-const.patch
include-linux-errh-add-a-function-to-cast-error-pointers-to-a-return-va=
lue.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
