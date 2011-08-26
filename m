From: akpm@linux-foundation.org
Subject: + mfd-mc13xxx-remove-mc13783-api-functions-and-symbols.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:15:18 -0700
Message-ID: <201108260015.p7Q0FIPu021994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab1HZAP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david@protonic.nl, dmitry.torokhov@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, rpurdie@rpsys.net, s.hauer@pengutronix.de, sameo@linux.intel.com


The patch titled
     mfd/mc13xxx: remove mc13783 API functions and symbols
has been added to the -mm tree.  Its filename is
     mfd-mc13xxx-remove-mc13783-api-functions-and-symbols.patch

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
Subject: mfd/mc13xxx: remove mc13783 API functions and symbols
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Now that all in-tree users are fixed to use the more general mc13xxx AP=
I
the obsolete stuff can go away.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Jander <david@protonic.nl>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/mc13xxx-core.c  |   12 ---
 include/linux/mfd/mc13783.h |  112 ----------------------------------
 2 files changed, 124 deletions(-)

diff -puN drivers/mfd/mc13xxx-core.c~mfd-mc13xxx-remove-mc13783-api-fun=
ctions-and-symbols drivers/mfd/mc13xxx-core.c
--- a/drivers/mfd/mc13xxx-core.c~mfd-mc13xxx-remove-mc13783-api-functio=
ns-and-symbols
+++ a/drivers/mfd/mc13xxx-core.c
@@ -30,16 +30,6 @@ struct mc13xxx {
 	int adcflags;
 };
=20
-struct mc13783 {
-	struct mc13xxx mc13xxx;
-};
-
-struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783)
-{
-	return &mc13783->mc13xxx;
-}
-EXPORT_SYMBOL(mc13783_to_mc13xxx);
-
 #define MC13XXX_IRQSTAT0	0
 #define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
 #define MC13XXX_IRQSTAT0_ADCBISDONEI	(1 << 1)
@@ -558,8 +548,6 @@ static const char *mc13xxx_get_chipname(
 	return mc13xxx_chipname[devid->driver_data];
 }
=20
-#include <linux/mfd/mc13783.h>
-
 int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
 {
 	struct mc13xxx_platform_data *pdata =3D
diff -puN include/linux/mfd/mc13783.h~mfd-mc13xxx-remove-mc13783-api-fu=
nctions-and-symbols include/linux/mfd/mc13783.h
--- a/include/linux/mfd/mc13783.h~mfd-mc13xxx-remove-mc13783-api-functi=
ons-and-symbols
+++ a/include/linux/mfd/mc13783.h
@@ -12,118 +12,6 @@
=20
 #include <linux/mfd/mc13xxx.h>
=20
-struct mc13783;
-
-struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783);
-
-static inline void mc13783_lock(struct mc13783 *mc13783)
-{
-	mc13xxx_lock(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline void mc13783_unlock(struct mc13783 *mc13783)
-{
-	mc13xxx_unlock(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline int mc13783_reg_read(struct mc13783 *mc13783,
-		unsigned int offset, u32 *val)
-{
-	return mc13xxx_reg_read(mc13783_to_mc13xxx(mc13783), offset, val);
-}
-
-static inline int mc13783_reg_write(struct mc13783 *mc13783,
-		unsigned int offset, u32 val)
-{
-	return mc13xxx_reg_write(mc13783_to_mc13xxx(mc13783), offset, val);
-}
-
-static inline int mc13783_reg_rmw(struct mc13783 *mc13783,
-		unsigned int offset, u32 mask, u32 val)
-{
-	return mc13xxx_reg_rmw(mc13783_to_mc13xxx(mc13783), offset, mask, val=
);
-}
-
-static inline int mc13783_get_flags(struct mc13783 *mc13783)
-{
-	return mc13xxx_get_flags(mc13783_to_mc13xxx(mc13783));
-}
-
-static inline int mc13783_irq_request(struct mc13783 *mc13783, int irq=
,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	return mc13xxx_irq_request(mc13783_to_mc13xxx(mc13783), irq,
-			handler, name, dev);
-}
-
-static inline int mc13783_irq_request_nounmask(struct mc13783 *mc13783=
, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	return mc13xxx_irq_request_nounmask(mc13783_to_mc13xxx(mc13783), irq,
-			handler, name, dev);
-}
-
-static inline int mc13783_irq_free(struct mc13783 *mc13783, int irq, v=
oid *dev)
-{
-	return mc13xxx_irq_free(mc13783_to_mc13xxx(mc13783), irq, dev);
-}
-
-static inline int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_mask(mc13783_to_mc13xxx(mc13783), irq);
-}
-
-static inline int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_unmask(mc13783_to_mc13xxx(mc13783), irq);
-}
-static inline int mc13783_irq_status(struct mc13783 *mc13783, int irq,
-		int *enabled, int *pending)
-{
-	return mc13xxx_irq_status(mc13783_to_mc13xxx(mc13783),
-			irq, enabled, pending);
-}
-
-static inline int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
-{
-	return mc13xxx_irq_ack(mc13783_to_mc13xxx(mc13783), irq);
-}
-
-#define MC13783_ADC0		MC13XXX_ADC0
-#define MC13783_ADC0_ADREFEN		MC13XXX_ADC0_ADREFEN
-#define MC13783_ADC0_TSMOD0		MC13XXX_ADC0_TSMOD0
-#define MC13783_ADC0_TSMOD1		MC13XXX_ADC0_TSMOD1
-#define MC13783_ADC0_TSMOD2		MC13XXX_ADC0_TSMOD2
-#define MC13783_ADC0_ADINC1		MC13XXX_ADC0_ADINC1
-#define MC13783_ADC0_ADINC2		MC13XXX_ADC0_ADINC2
-
-#define MC13783_ADC0_TSMOD_MASK		MC13XXX_ADC0_TSMOD_MASK
-
-#define mc13783_regulator_init_data mc13xxx_regulator_init_data
-#define mc13783_regulator_platform_data mc13xxx_regulator_platform_dat=
a
-#define mc13783_led_platform_data mc13xxx_led_platform_data
-#define mc13783_leds_platform_data mc13xxx_leds_platform_data
-
-#define mc13783_platform_data mc13xxx_platform_data
-#define MC13783_USE_TOUCHSCREEN	MC13XXX_USE_TOUCHSCREEN
-#define MC13783_USE_CODEC	MC13XXX_USE_CODEC
-#define MC13783_USE_ADC		MC13XXX_USE_ADC
-#define MC13783_USE_RTC		MC13XXX_USE_RTC
-#define MC13783_USE_REGULATOR	MC13XXX_USE_REGULATOR
-#define MC13783_USE_LED		MC13XXX_USE_LED
-
-#define MC13783_ADC_MODE_TS		MC13XXX_ADC_MODE_TS
-#define MC13783_ADC_MODE_SINGLE_CHAN	MC13XXX_ADC_MODE_SINGLE_CHAN
-#define MC13783_ADC_MODE_MULT_CHAN	MC13XXX_ADC_MODE_MULT_CHAN
-
-static inline int mc13783_adc_do_conversion(struct mc13783 *mc13783,
-		unsigned int mode, unsigned int channel, unsigned int *sample)
-{
-	return mc13xxx_adc_do_conversion(mc13783_to_mc13xxx(mc13783), mode,
-			channel, sample);
-}
-
