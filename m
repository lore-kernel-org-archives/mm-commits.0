From: akpm@linux-foundation.org
Subject: [merged] input-tsc2007-remove-hr-timer-fix.patch removed from -mm tree
Date: Mon, 27 Jul 2009 13:36:04 -0700
Message-ID: <200907272036.n6RKa4RR018423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbZG0UgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 16:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, dtor@mail.ru, kwangwoo.lee@gmail.com, soni.trilok@gmail.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     tsc2007: Cancel work sync, increase polling frequency, make exit p=
latform hw callback optional
has been removed from the -mm tree.  Its filename was
     input-tsc2007-remove-hr-timer-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: tsc2007: Cancel work sync, increase polling frequency, make ex=
it platform hw callback optional


In the remove function, ancel the work using the _sync version,
to make sure any running "work" is finished. Make the
exit_platform_hw callback optional since it's not needed on all
platforms.

When the screen is touched, the polling frequency is increased
to reduce the risk of missing taps.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: <kwangwoo.lee@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/tsc2007.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/tsc2007.c~input-tsc2007-remove-hr-t=
imer-fix drivers/input/touchscreen/tsc2007.c
--- a/drivers/input/touchscreen/tsc2007.c~input-tsc2007-remove-hr-timer=
-fix
+++ a/drivers/input/touchscreen/tsc2007.c
@@ -27,7 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>
=20
-#define TS_POLL_PERIOD	msecs_to_jiffies(5) /* ms delay between samples=
 */
+#define TS_POLL_PERIOD	msecs_to_jiffies(1) /* ms delay between samples=
 */
=20
 #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
 #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -314,11 +314,11 @@ static int tsc2007_remove(struct i2c_cli
 	struct tsc2007	*ts =3D i2c_get_clientdata(client);
 	struct tsc2007_platform_data *pdata;
=20
-	/* cancel any work */
-	cancel_delayed_work(&ts->work);
+	cancel_delayed_work_sync(&ts->work);
=20
 	pdata =3D client->dev.platform_data;
-	pdata->exit_platform_hw();
+	if (pdata->exit_platform_hw)
+		pdata->exit_platform_hw();
=20
 	free_irq(ts->irq, ts);
 	input_unregister_device(ts->input);
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
