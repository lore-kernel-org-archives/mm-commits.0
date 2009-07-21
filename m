From: akpm@linux-foundation.org
Subject: + input-tsc2007-remove-hr-timer-fix.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:24:34 -0700
Message-ID: <200907212324.n6LNOYsY002253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbZGUXYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, dtor@mail.ru, kwangwoo.lee@gmail.com, soni.trilok@gmail.com, thierry.reding@avionic-design.de


The patch titled
     tsc2007: Cancel work sync, increase polling frequency, make exit p=
latform hw callback optional
has been added to the -mm tree.  Its filename is
     input-tsc2007-remove-hr-timer-fix.patch

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

video-initial-support-for-adv7180.patch
input-tsc2007-remove-hr-timer.patch
input-tsc2007-remove-hr-timer-fix.patch
input-tsc2007-make-platform-callbacks-optional.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
