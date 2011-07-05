From: akpm@linux-foundation.org
Subject: + w1-ds1wm-add-a-reset-recovery-parameter.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:46:22 -0700
Message-ID: <201107052146.p65LkM2x026006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab1GEVrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, lost.distance@yahoo.com


The patch titled
     w1: ds1wm: add a reset recovery parameter
has been added to the -mm tree.  Its filename is
     w1-ds1wm-add-a-reset-recovery-parameter.patch

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
Subject: w1: ds1wm: add a reset recovery parameter
=46rom: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>

This fixes a regression in 3.0 reported by Paul Parsons regarding the
removal of the msleep(1) in the ds1wm_reset() function:

: The linux-3.0-rc4 DS1WM 1-wire driver is logging "bus error, retrying=
"
: error messages on an HP iPAQ hx4700 PDA (XScale-PXA270):
:=20
: <snip>
: Driver for 1-wire Dallas network protocol.
: DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
: 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, =
Szabolcs Gyurko
: ds1wm ds1wm: pass: 1 bus error, retrying
: ds1wm ds1wm: pass: 2 bus error, retrying
: ds1wm ds1wm: pass: 3 bus error, retrying
: ds1wm ds1wm: pass: 4 bus error, retrying
: ds1wm ds1wm: pass: 5 bus error, retrying
: ...
:=20
: The visible result is that the battery charging LED is erratic; somet=
imes
: it works, mostly it doesn't.
:=20
: The linux-2.6.39 DS1WM 1-wire driver worked OK.  I haven't tried 3.0-=
rc1,
: 3.0-rc2, or 3.0-rc3.

This sleep should not be required on normal circuitry provided the
pull-ups on the bus are correctly adapted to the slaves.  Unfortunately=
,
this is not always the case.  The sleep is restored but as a parameter =
to
the probe function in the pdata.

Reported-by: Paul Parsons <lost.distance@yahoo.com>
Tested-by: Paul Parsons <lost.distance@yahoo.com>
Signed-off-by: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c        |    1 +
 drivers/mfd/htc-pasic3.c   |    1 +
 drivers/w1/masters/ds1wm.c |    5 +++++
 include/linux/mfd/ds1wm.h  |    7 +++++++
 4 files changed, 14 insertions(+)

diff -puN drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter d=
rivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/drivers/mfd/asic3.c
@@ -619,6 +619,7 @@ static void asic3_clk_disable(struct asi
 /* MFD cells (SPI, PWM, LED, DS1WM, MMC) */
 static struct ds1wm_driver_data ds1wm_pdata =3D {
 	.active_high =3D 1,
+	.reset_recover_delay =3D 1,
 };
=20
 static struct resource ds1wm_resources[] =3D {
diff -puN drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parame=
ter drivers/mfd/htc-pasic3.c
--- a/drivers/mfd/htc-pasic3.c~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/drivers/mfd/htc-pasic3.c
@@ -99,6 +99,7 @@ static int ds1wm_disable(struct platform
=20
 static struct ds1wm_driver_data ds1wm_pdata =3D {
 	.active_high =3D 0,
+	.reset_recover_delay =3D 1,
 };
=20
 static struct resource ds1wm_resources[] __initdata =3D {
diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-para=
meter drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-paramete=
r
+++ a/drivers/w1/masters/ds1wm.c
@@ -109,6 +109,7 @@ struct ds1wm_data {
 	/* byte to write that makes all intr disabled, */
 	/* considering active_state (IAS) (optimization) */
 	u8       int_en_reg_none;
+	unsigned int reset_recover_delay; /* see ds1wm.h */
 };
=20
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data,=
 u32 reg,
@@ -187,6 +188,9 @@ static int ds1wm_reset(struct ds1wm_data
 		return 1;
 	}
=20
+	if(ds1wm_data->reset_recover_delay)
+		msleep(ds1wm_data->reset_recover_delay);
+
 	return 0;
 }
=20
@@ -490,6 +494,7 @@ static int ds1wm_probe(struct platform_d
 	}
 	ds1wm_data->irq =3D res->start;
 	ds1wm_data->int_en_reg_none =3D (plat->active_high ? DS1WM_INTEN_IAS =
: 0);
+	ds1wm_data->reset_recover_delay =3D plat->reset_recover_delay;
=20
 	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
 		irq_set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
diff -puN include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-param=
eter include/linux/mfd/ds1wm.h
--- a/include/linux/mfd/ds1wm.h~w1-ds1wm-add-a-reset-recovery-parameter
+++ a/include/linux/mfd/ds1wm.h
@@ -3,4 +3,11 @@
 struct ds1wm_driver_data {
 	int active_high;
 	int clock_rate;
+	/* in milliseconds, the amount of time to */
+	/* sleep following a reset pulse. Zero    */
+	/* should work if your bus devices recover*/
+	/* time respects the 1-wire spec since the*/
+	/* ds1wm implements the precise timings of*/
+	/* a reset pulse/presence detect sequence.*/
+	unsigned int reset_recover_delay;
 };
_

Patches currently in -mm which might be from dagenaisj@sonatest.com are

w1-ds1wm-add-a-reset-recovery-parameter.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
