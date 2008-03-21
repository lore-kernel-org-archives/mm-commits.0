From: akpm@linux-foundation.org
Subject: + input-core-driver-for-wm97xx-touchscreens-fix.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:57:01 -0700
Message-ID: <200803212157.m2LLv1uX012354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbYCUV6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, jkosina@suse.cz, liam.girdwood@wolfsonmicro.com


The patch titled
     wm97xx-core: support pen down IRQ for non-continous reads
has been added to the -mm tree.  Its filename is
     input-core-driver-for-wm97xx-touchscreens-fix.patch

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
Subject: wm97xx-core: support pen down IRQ for non-continous reads
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

If the machine driver is not using continuous mode then the ts_reader
needs to be scheduled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-fix drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-fix
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -300,10 +300,11 @@ static void wm97xx_pen_irq_worker(struct
 		mutex_unlock(&wm->codec_mutex);
 	}
 
-	/* If a pen down function is not provided then the driver will
-	 * schedule its own reads.
+	/* If the system is not using continuous mode or it provides a
+	 * pen down operation then start scheduling polls.  Otherwise
+	 * the machine driver is responsible for scheduling reads.
 	 */
-	if (wm->mach_ops->acc_pen_down) {
+	if (!wm->mach_ops->acc_enabled || wm->mach_ops->acc_pen_down) {
 		/* Data is not availiable immediately after pen down. */
 		queue_delayed_work(wm->ts_workq, &wm->ts_reader, 1);
 	}
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa-tiwai.patch
git-arm.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-core-driver-for-wm97xx-touchscreens-fix.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
wm97xx-core-fix-race-in-pen-up-reporting.patch

