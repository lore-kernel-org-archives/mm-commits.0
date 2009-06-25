From: akpm@linux-foundation.org
Subject: + input-tsc2007-make-platform-callbacks-optional.patch added to -mm tree
Date: Thu, 25 Jun 2009 14:24:04 -0700
Message-ID: <200906252124.n5PLO4q6021894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbZFYVYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 17:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, dtor@mail.ru, kwangwoo.lee@gmail.com, soni.trilok@gmail.com, thierry.reding@avionic-design.de


The patch titled
     input: tsc2007: make platform callbacks optional
has been added to the -mm tree.  Its filename is
     input-tsc2007-make-platform-callbacks-optional.patch

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
Subject: input: tsc2007: make platform callbacks optional
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

The platform callbacks are only called if supplied.  Makes the driver t=
o
fallback on only pressure calculation to decide when the pen is up.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: <kwangwoo.lee@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/tsc2007.c |   34 +++++++++++++++++++-------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff -puN drivers/input/touchscreen/tsc2007.c~input-tsc2007-make-platfo=
rm-callbacks-optional drivers/input/touchscreen/tsc2007.c
--- a/drivers/input/touchscreen/tsc2007.c~input-tsc2007-make-platform-c=
allbacks-optional
+++ a/drivers/input/touchscreen/tsc2007.c
@@ -59,6 +59,10 @@
 #define READ_X		(ADC_ON_12BIT | TSC2007_MEASURE_X)
 #define PWRDOWN		(TSC2007_12BIT | TSC2007_POWER_OFF_IRQ_EN)
=20
+#define PEN_STATE_UP	0x00
+#define PEN_STATE_DOWN	0x01
+#define PEN_STATE_IRQ	0x01
+
 struct ts_event {
 	u16	x;
 	u16	y;
@@ -76,7 +80,7 @@ struct tsc2007 {
 	u16			model;
 	u16			x_plate_ohms;
=20
-	unsigned		pendown;
+	unsigned		penstate;
 	int			irq;
=20
 	int			(*get_pendown_state)(void);
@@ -149,15 +153,18 @@ static void tsc2007_send_event(void *tsc
 	 *
 	 * The only safe way to check for the pen up condition is in the
 	 * work function by reading the pen signal state (it's a GPIO and IRQ=
).
+	 *
+	 * But sadly we don't always have the possibility to use such callbac=
k
+	 * in that case rely on the pressure anyway
 	 */
 	if (rt) {
 		struct input_dev *input =3D ts->input;
=20
-		if (!ts->pendown) {
+		if (ts->penstate !=3D PEN_STATE_DOWN) {
 			dev_dbg(&ts->client->dev, "DOWN\n");
=20
 			input_report_key(input, BTN_TOUCH, 1);
-			ts->pendown =3D 1;
+			ts->penstate =3D PEN_STATE_DOWN;
 		}
=20
 		input_report_abs(input, ABS_X, x);
@@ -168,7 +175,9 @@ static void tsc2007_send_event(void *tsc
=20
 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
 			x, y, rt);
-	}
+	} else if (!ts->get_pendown_state)
+		/* no callback to check pendown state, use pressure */
+		ts->penstate =3D PEN_STATE_UP;
=20
 	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 }
@@ -195,7 +204,14 @@ static void tsc2007_work(struct work_str
 {
 	struct tsc2007 *ts =3D
 		container_of(to_delayed_work(work), struct tsc2007, work);
-	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
+
+	/* either we have the pendown callback, and use it, otherwise
+	 * we look at the pendown variable
+	 */
+	if ((ts->get_pendown_state && unlikely(!ts->get_pendown_state()) &&
+		ts->penstate !=3D PEN_STATE_UP) ||
+		(!ts->get_pendown_state &&
+		unlikely(ts->penstate =3D=3D PEN_STATE_UP))) {
 		struct input_dev *input =3D ts->input;
=20
 		dev_dbg(&ts->client->dev, "UP\n");
@@ -204,7 +220,7 @@ static void tsc2007_work(struct work_str
 		input_report_abs(input, ABS_PRESSURE, 0);
 		input_sync(input);
=20
-		ts->pendown =3D 0;
+		ts->penstate =3D PEN_STATE_UP;
 		enable_irq(ts->irq);
 	} else {
 		/* pen is still down, continue with the measurement */
@@ -219,8 +235,9 @@ static irqreturn_t tsc2007_irq(int irq,=20
 {
 	struct tsc2007 *ts =3D handle;
=20
-	if (likely(ts->get_pendown_state())) {
+	if (!ts->get_pendown_state || likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
+		ts->penstate =3D PEN_STATE_IRQ;
 		schedule_delayed_work(&ts->work, 0);
 	}
=20
@@ -264,7 +281,8 @@ static int tsc2007_probe(struct i2c_clie
 	ts->get_pendown_state =3D pdata->get_pendown_state;
 	ts->clear_penirq      =3D pdata->clear_penirq;
=20
-	pdata->init_platform_hw();
+	if (pdata->init_platform_hw)
+		pdata->init_platform_hw();
=20
 	snprintf(ts->phys, sizeof(ts->phys),
 		 "%s/input0", dev_name(&client->dev));
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

video-initial-support-for-adv7180.patch
input-tsc2007-remove-hr-timer.patch
input-tsc2007-make-platform-callbacks-optional.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
