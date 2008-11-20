From: akpm@linux-foundation.org
Subject: - lcd-fix-oops-if-driver-only-interested-in-set_power.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:43 -0800
Message-ID: <200811202042.mAKKghUW007091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350AbYKTUnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     lcd: fix oops if driver only interested in .set_power
has been removed from the -mm tree.  Its filename was
     lcd-fix-oops-if-driver-only-interested-in-set_power.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lcd: fix oops if driver only interested in .set_power
From: Ben Dooks <ben-linux@fluff.org>

The LCD driver core calls LCD drivers when either the blanking state or
the display mode has changed, but does not make any check to see if the
called driver has a .set_mode method.

This means if a driver only has a .set_power method then the system will
OOPS on changing mode (and with the console semaphore held so you cannot
easily see the problem).

Fix the problem by ensuring that either callback is valid before use.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/lcd.c~lcd-fix-oops-if-driver-only-interested-in-set_power drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~lcd-fix-oops-if-driver-only-interested-in-set_power
+++ a/drivers/video/backlight/lcd.c
@@ -42,10 +42,13 @@ static int fb_notifier_callback(struct n
 
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
-		if (event == FB_EVENT_BLANK)
-			ld->ops->set_power(ld, *(int *)evdata->data);
-		else
-			ld->ops->set_mode(ld, evdata->data);
+		if (event == FB_EVENT_BLANK) {
+			if (ld->ops->set_power)
+				ld->ops->set_power(ld, *(int *)evdata->data);
+		} else {
+			if (ld->ops->set_mode)
+				ld->ops->set_mode(ld, evdata->data);
+		}
 	}
 	mutex_unlock(&ld->ops_lock);
 	return 0;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch

