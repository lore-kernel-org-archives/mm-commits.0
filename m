From: akpm@linux-foundation.org
Subject: - b43-avoid-unregistering-device-objects-during-suspend.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:24 -0800
Message-ID: <200802052234.m15MY5Gh012484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762853AbYBEWpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     b43: avoid unregistering device objects during suspend
has been removed from the -mm tree.  Its filename was
     b43-avoid-unregistering-device-objects-during-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b43: avoid unregistering device objects during suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the b43 driver to avoid deadlocking suspend and resume, which happens
as a result of attempting to unregister device objects locked by the PM core
during suspend/resume cycles.  Also, make it use a suspend-safe method of
unregistering device object in the resume error path.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/b43.h  |    1 +
 drivers/net/wireless/b43/leds.c |    5 ++++-
 drivers/net/wireless/b43/main.c |   25 ++++++++++++++++---------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff -puN drivers/net/wireless/b43/b43.h~b43-avoid-unregistering-device-objects-during-suspend drivers/net/wireless/b43/b43.h
--- a/drivers/net/wireless/b43/b43.h~b43-avoid-unregistering-device-objects-during-suspend
+++ a/drivers/net/wireless/b43/b43.h
@@ -724,6 +724,7 @@ struct b43_wldev {
 	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
+	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
diff -puN drivers/net/wireless/b43/leds.c~b43-avoid-unregistering-device-objects-during-suspend drivers/net/wireless/b43/leds.c
--- a/drivers/net/wireless/b43/leds.c~b43-avoid-unregistering-device-objects-during-suspend
+++ a/drivers/net/wireless/b43/leds.c
@@ -116,7 +116,10 @@ static void b43_unregister_led(struct b4
 {
 	if (!led->dev)
 		return;
-	led_classdev_unregister(&led->led_dev);
+	if (led->dev->suspend_in_progress)
+		led_classdev_unregister_suspended(&led->led_dev);
+	else
+		led_classdev_unregister(&led->led_dev);
 	b43_led_turn_off(led->dev, led->index, led->activelow);
 	led->dev = NULL;
 }
diff -puN drivers/net/wireless/b43/main.c~b43-avoid-unregistering-device-objects-during-suspend drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~b43-avoid-unregistering-device-objects-during-suspend
+++ a/drivers/net/wireless/b43/main.c
@@ -2555,10 +2555,10 @@ static int b43_rng_read(struct hwrng *rn
 	return (sizeof(u16));
 }
 
-static void b43_rng_exit(struct b43_wl *wl)
+static void b43_rng_exit(struct b43_wl *wl, bool suspended)
 {
 	if (wl->rng_initialized)
-		hwrng_unregister(&wl->rng);
+		__hwrng_unregister(&wl->rng, suspended);
 }
 
 static int b43_rng_init(struct b43_wl *wl)
@@ -3418,8 +3418,10 @@ static void b43_wireless_core_exit(struc
 	macctl |= B43_MACCTL_PSM_JMP0;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 
-	b43_leds_exit(dev);
-	b43_rng_exit(dev->wl);
+	if (!dev->suspend_in_progress) {
+		b43_leds_exit(dev);
+		b43_rng_exit(dev->wl, false);
+	}
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
 	b43_radio_turn_off(dev, 1);
@@ -3535,11 +3537,13 @@ static int b43_wireless_core_init(struct
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
-	b43_rng_init(wl);
+	if (!dev->suspend_in_progress)
+		b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	b43_leds_init(dev);
+	if (!dev->suspend_in_progress)
+		b43_leds_init(dev);
 out:
 	return err;
 
@@ -4136,6 +4140,7 @@ static int b43_suspend(struct ssb_device
 	b43dbg(wl, "Suspending...\n");
 
 	mutex_lock(&wl->mutex);
+	wldev->suspend_in_progress = true;
 	wldev->suspend_init_status = b43_status(wldev);
 	if (wldev->suspend_init_status >= B43_STAT_STARTED)
 		b43_wireless_core_stop(wldev);
@@ -4167,15 +4172,17 @@ static int b43_resume(struct ssb_device 
 	if (wldev->suspend_init_status >= B43_STAT_STARTED) {
 		err = b43_wireless_core_start(wldev);
 		if (err) {
+			b43_leds_exit(wldev);
+			b43_rng_exit(wldev->wl, true);
 			b43_wireless_core_exit(wldev);
 			b43err(wl, "Resume failed at core start\n");
 			goto out;
 		}
 	}
-	mutex_unlock(&wl->mutex);
-
 	b43dbg(wl, "Device resumed.\n");
-      out:
+ out:
+	wldev->suspend_in_progress = false;
+	mutex_unlock(&wl->mutex);
 	return err;
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
git-x86.patch
git-xfs.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
