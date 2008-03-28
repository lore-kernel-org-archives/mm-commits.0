From: akpm@linux-foundation.org
Subject: - input-core-driver-for-wm97xx-touchscreens-fix.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:29:19 -0700
Message-ID: <200803282129.m2SLTJpN011199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918AbYC1V33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, jkosina@suse.cz, liam.girdwood@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     wm97xx-core: support pen down IRQ for non-continous reads
has been removed from the -mm tree.  Its filename was
     input-core-driver-for-wm97xx-touchscreens-fix.patch

This patch was dropped because it was folded into input-core-driver-for-wm97xx-touchscreens.patch

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
input-core-driver-for-wm97xx-touchscreens-race-fix.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

