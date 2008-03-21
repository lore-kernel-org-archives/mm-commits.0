From: akpm@linux-foundation.org
Subject: + input-core-driver-for-wm97xx-touchscreens-race-fix.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:57:40 -0700
Message-ID: <200803212157.m2LLve08012366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759086AbYCUV7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, jkosina@suse.cz, liam.girdwood@wolfsonmicro.com


The patch titled
     wm97xx-core: fix race in pen up reporting
has been added to the -mm tree.  Its filename is
     input-core-driver-for-wm97xx-touchscreens-race-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm97xx-core: fix race in pen up reporting
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Since the ts_reader will only report changes in pen down status avoid reseting
the pen down flag once it is running.  While we're at it, only schedule the
ts_reader when the pen goes down - if the pen is already down then it is
already scheduled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-race-fix drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-race-fix
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -267,6 +267,7 @@ EXPORT_SYMBOL_GPL(wm97xx_config_gpio);
 static void wm97xx_pen_irq_worker(struct work_struct *work)
 {
 	struct wm97xx *wm = container_of(work, struct wm97xx, pen_event_work);
+	int pen_was_down = wm->pen_is_down;
 
 	/* do we need to enable the touch panel reader */
 	if (wm->id == WM9705_ID2) {
@@ -301,16 +302,24 @@ static void wm97xx_pen_irq_worker(struct
 	}
 
 	/* If the system is not using continuous mode or it provides a
-	 * pen down operation then start scheduling polls.  Otherwise
-	 * the machine driver is responsible for scheduling reads.
+	 * pen down operation then we need to schedule polls while the
+	 * pen is down.  Otherwise the machine driver is responsible
+	 * for scheduling reads.
 	 */
 	if (!wm->mach_ops->acc_enabled || wm->mach_ops->acc_pen_down) {
-		/* Data is not availiable immediately after pen down. */
-		queue_delayed_work(wm->ts_workq, &wm->ts_reader, 1);
+		if (wm->pen_is_down && !pen_was_down) {
+			/* Data is not availiable immediately on pen down */
+			queue_delayed_work(wm->ts_workq, &wm->ts_reader, 1);
+		}
+
+		/* Let ts_reader report the pen up for debounce. */
+		if (!wm->pen_is_down && pen_was_down)
+			wm->pen_is_down = 1;
 	}
 
 	if (!wm->pen_is_down && wm->mach_ops->acc_enabled)
 		wm->mach_ops->acc_pen_up(wm);
+
 	wm->mach_ops->irq_enable(wm, 1);
 }
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa-tiwai.patch
git-arm.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-core-driver-for-wm97xx-touchscreens-fix.patch
input-core-driver-for-wm97xx-touchscreens-race-fix.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

