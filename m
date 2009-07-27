From: akpm@linux-foundation.org
Subject: [merged] input-tsc2007-remove-hr-timer.patch removed from -mm tree
Date: Mon, 27 Jul 2009 13:36:00 -0700
Message-ID: <200907272036.n6RKa0q4018304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbZG0UgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 16:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, dtor@mail.ru, kwangwoo.lee@gmail.com, soni.trilok@gmail.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     input: tsc2007: remove HR timer
has been removed from the -mm tree.  Its filename was
     input-tsc2007-remove-hr-timer.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: tsc2007: remove HR timer
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

Remove the HR timer, since it's bad to do synchronous I2C in the HR tim=
er
callback context.  The new implementation makes use of the global
workqueue.  The work is scheduled every 5ms when polling rather than 5 =
us.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: <kwangwoo.lee@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/tsc2007.c |   49 +++++++-------------------
 1 file changed, 14 insertions(+), 35 deletions(-)

diff -puN drivers/input/touchscreen/tsc2007.c~input-tsc2007-remove-hr-t=
imer drivers/input/touchscreen/tsc2007.c
--- a/drivers/input/touchscreen/tsc2007.c~input-tsc2007-remove-hr-timer
+++ a/drivers/input/touchscreen/tsc2007.c
@@ -21,15 +21,13 @@
  */
=20
 #include <linux/module.h>
-#include <linux/hrtimer.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>
=20
-#define TS_POLL_DELAY	(10 * 1000)	/* ns delay before the first sample =
*/
-#define TS_POLL_PERIOD	(5 * 1000)	/* ns delay between samples */
+#define TS_POLL_PERIOD	msecs_to_jiffies(5) /* ms delay between samples=
 */
=20
 #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
 #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -70,13 +68,11 @@ struct ts_event {
 struct tsc2007 {
 	struct input_dev	*input;
 	char			phys[32];
-	struct hrtimer		timer;
+	struct delayed_work	work;
 	struct ts_event		tc;
=20
 	struct i2c_client	*client;
=20
-	spinlock_t		lock;
-
 	u16			model;
 	u16			x_plate_ohms;
=20
@@ -142,8 +138,7 @@ static void tsc2007_send_event(void *tsc
 	if (rt > MAX_12BIT) {
 		dev_dbg(&ts->client->dev, "ignored pressure %d\n", rt);
=20
-		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			      HRTIMER_MODE_REL);
+		schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 		return;
 	}
=20
@@ -153,7 +148,7 @@ static void tsc2007_send_event(void *tsc
 	 * in some cases may not even settle at the expected value.
 	 *
 	 * The only safe way to check for the pen up condition is in the
-	 * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
+	 * work function by reading the pen signal state (it's a GPIO and IRQ=
).
 	 */
 	if (rt) {
 		struct input_dev *input =3D ts->input;
@@ -175,8 +170,7 @@ static void tsc2007_send_event(void *tsc
 			x, y, rt);
 	}
=20
-	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			HRTIMER_MODE_REL);
+	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
 }
=20
 static int tsc2007_read_values(struct tsc2007 *tsc)
@@ -197,13 +191,10 @@ static int tsc2007_read_values(struct ts
 	return 0;
 }
=20
-static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
+static void tsc2007_work(struct work_struct *work)
 {
-	struct tsc2007 *ts =3D container_of(handle, struct tsc2007, timer);
-	unsigned long flags;
-
-	spin_lock_irqsave(&ts->lock, flags);
-
+	struct tsc2007 *ts =3D
+		container_of(to_delayed_work(work), struct tsc2007, work);
 	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
 		struct input_dev *input =3D ts->input;
=20
@@ -222,30 +213,20 @@ static enum hrtimer_restart tsc2007_time
 		tsc2007_read_values(ts);
 		tsc2007_send_event(ts);
 	}
-
-	spin_unlock_irqrestore(&ts->lock, flags);
-
-	return HRTIMER_NORESTART;
 }
=20
 static irqreturn_t tsc2007_irq(int irq, void *handle)
 {
 	struct tsc2007 *ts =3D handle;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ts->lock, flags);
=20
 	if (likely(ts->get_pendown_state())) {
 		disable_irq_nosync(ts->irq);
-		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
-					HRTIMER_MODE_REL);
+		schedule_delayed_work(&ts->work, 0);
 	}
=20
 	if (ts->clear_penirq)
 		ts->clear_penirq();
=20
-	spin_unlock_irqrestore(&ts->lock, flags);
-
 	return IRQ_HANDLED;
 }
=20
@@ -278,11 +259,6 @@ static int tsc2007_probe(struct i2c_clie
=20
 	ts->input =3D input_dev;
=20
-	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	ts->timer.function =3D tsc2007_timer;
-
-	spin_lock_init(&ts->lock);
-
 	ts->model             =3D pdata->model;
 	ts->x_plate_ohms      =3D pdata->x_plate_ohms;
 	ts->get_pendown_state =3D pdata->get_pendown_state;
@@ -308,6 +284,8 @@ static int tsc2007_probe(struct i2c_clie
=20
 	ts->irq =3D client->irq;
=20
+	INIT_DELAYED_WORK(&ts->work, tsc2007_work);
+
 	err =3D request_irq(ts->irq, tsc2007_irq, 0,
 			client->dev.driver->name, ts);
 	if (err < 0) {
@@ -325,7 +303,6 @@ static int tsc2007_probe(struct i2c_clie
=20
  err_free_irq:
 	free_irq(ts->irq, ts);
-	hrtimer_cancel(&ts->timer);
  err_free_mem:
 	input_free_device(input_dev);
 	kfree(ts);
@@ -337,11 +314,13 @@ static int tsc2007_remove(struct i2c_cli
 	struct tsc2007	*ts =3D i2c_get_clientdata(client);
 	struct tsc2007_platform_data *pdata;
=20
+	/* cancel any work */
+	cancel_delayed_work(&ts->work);
+
 	pdata =3D client->dev.platform_data;
 	pdata->exit_platform_hw();
=20
 	free_irq(ts->irq, ts);
-	hrtimer_cancel(&ts->timer);
 	input_unregister_device(ts->input);
 	kfree(ts);
=20
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
video-initial-support-for-adv7180.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
