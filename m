From: akpm@linux-foundation.org
Subject: + leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:12:40 -0800
Message-ID: <200801270512.m0R5Cb8g030927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbYA0FQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu


The patch titled
     leds: add possibility to remove leds classdevs during suspend/resume
has been added to the -mm tree.  Its filename is
     leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch

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
Subject: leds: add possibility to remove leds classdevs during suspend/resume
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to unregister a led classdev object in a safe way during a
suspend/resume cycle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c |   13 +++++++++----
 include/linux/leds.h     |   10 +++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/leds/led-class.c~leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume
+++ a/drivers/leds/led-class.c
@@ -137,12 +137,14 @@ err_out:
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
 /**
- * led_classdev_unregister - unregisters a object of led_properties class.
+ * __led_classdev_unregister - unregisters a object of led_properties class.
  * @led_cdev: the led device to unregister
+ * @suspended: indicates whether system-wide suspend or resume is in progress
  *
  * Unregisters a previously registered via led_classdev_register object.
  */
-void led_classdev_unregister(struct led_classdev *led_cdev)
+void __led_classdev_unregister(struct led_classdev *led_cdev,
+				      bool suspended)
 {
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -153,13 +155,16 @@ void led_classdev_unregister(struct led_
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	device_unregister(led_cdev->dev);
+	if (suspended)
+		device_pm_schedule_removal(led_cdev->dev);
+	else
+		device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
 }
-EXPORT_SYMBOL_GPL(led_classdev_unregister);
+EXPORT_SYMBOL_GPL(__led_classdev_unregister);
 
 static int __init leds_init(void)
 {
diff -puN include/linux/leds.h~leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume include/linux/leds.h
--- a/include/linux/leds.h~leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume
+++ a/include/linux/leds.h
@@ -59,7 +59,15 @@ struct led_classdev {
 
 extern int led_classdev_register(struct device *parent,
 				 struct led_classdev *led_cdev);
-extern void led_classdev_unregister(struct led_classdev *led_cdev);
+extern void __led_classdev_unregister(struct led_classdev *led_cdev, bool sus);
+static inline void led_classdev_unregister(struct led_classdev *lcd)
+{
+	__led_classdev_unregister(lcd, false);
+}
+static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
+{
+	__led_classdev_unregister(lcd, true);
+}
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
 
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
