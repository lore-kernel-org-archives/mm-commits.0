From: akpm@linux-foundation.org
Subject: + b43-avoid-unregistering-device-objects-during-suspend.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:12:42 -0800
Message-ID: <200801270512.m0R5CdKR030930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYA0FPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:15:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu


The patch titled
     b43: avoid unregistering device objects during suspend
has been added to the -mm tree.  Its filename is
     b43-avoid-unregistering-device-objects-during-suspend.patch

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
@@ -706,6 +706,7 @@ struct b43_wldev {
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
@@ -2470,10 +2470,10 @@ static int b43_rng_read(struct hwrng *rn
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
@@ -3298,8 +3298,10 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
-	b43_leds_exit(dev);
-	b43_rng_exit(dev->wl);
+	if (!dev->suspend_in_progress) {
+		b43_leds_exit(dev);
+		b43_rng_exit(dev->wl, false);
+	}
 	b43_pio_free(dev);
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
@@ -3420,11 +3422,13 @@ static int b43_wireless_core_init(struct
 	memset(wl->mac_addr, 0, ETH_ALEN);
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
 
@@ -4024,6 +4028,7 @@ static int b43_suspend(struct ssb_device
 	b43dbg(wl, "Suspending...\n");
 
 	mutex_lock(&wl->mutex);
+	wldev->suspend_in_progress = true;
 	wldev->suspend_init_status = b43_status(wldev);
 	if (wldev->suspend_init_status >= B43_STAT_STARTED)
 		b43_wireless_core_stop(wldev);
@@ -4055,15 +4060,17 @@ static int b43_resume(struct ssb_device 
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
cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-xfs.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
pm-export-device_pm_schedule_removal.patch
misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch
hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch
leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch
b43-avoid-unregistering-device-objects-during-suspend.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
