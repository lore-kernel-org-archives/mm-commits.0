From: akpm@linux-foundation.org
Subject: + pm-remove-destroy_suspended_device.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:39:08 -0700
Message-ID: <200803242239.m2OMd8jZ028985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYCXWkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, mb@bu3sch.de, pavel@ucw.cz, stern@rowland.harvard.edu


The patch titled
     pm: remove destroy_suspended_device()
has been added to the -mm tree.  Its filename is
     pm-remove-destroy_suspended_device.patch

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
Subject: pm: remove destroy_suspended_device()
From: Rafael J. Wysocki <rjw@sisk.pl>

After 2.6.24 there was a plan to make the PM core acquire all device
semaphores during a suspend/hibernation to protect itself from concurrent
operations involving device objects.  That proved to be too heavy-handed and
we found a better way to achieve the goal, but before it happened, we had
introduced the functions device_pm_schedule_removal() and
destroy_suspended_device() to allow drivers to "safely" destroy a suspended
device and we had adapted some drivers to use them.  Now that these functions
are no longer necessary, it seems reasonable to remove them and modify their
users to use the normal device unregistration instead.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpuid.c         |    4 ---
 arch/x86/kernel/msr.c           |    4 ---
 drivers/base/core.c             |   29 ---------------------
 drivers/base/power/main.c       |   40 ------------------------------
 drivers/char/hw_random/core.c   |   10 +++----
 drivers/char/misc.c             |   13 +++------
 drivers/leds/led-class.c        |   11 ++------
 drivers/net/wireless/b43/leds.c |    5 ---
 drivers/net/wireless/b43/main.c |    8 +++---
 include/linux/device.h          |   14 ----------
 include/linux/hw_random.h       |   10 -------
 include/linux/leds.h            |   10 -------
 include/linux/miscdevice.h      |   10 -------
 13 files changed, 22 insertions(+), 146 deletions(-)

diff -puN arch/x86/kernel/cpuid.c~pm-remove-destroy_suspended_device arch/x86/kernel/cpuid.c
--- a/arch/x86/kernel/cpuid.c~pm-remove-destroy_suspended_device
+++ a/arch/x86/kernel/cpuid.c
@@ -154,12 +154,10 @@ static int __cpuinit cpuid_class_cpu_cal
 		err = cpuid_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 		cpuid_device_destroy(cpu);
 		break;
-	case CPU_UP_CANCELED_FROZEN:
-		destroy_suspended_device(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
-		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff -puN arch/x86/kernel/msr.c~pm-remove-destroy_suspended_device arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~pm-remove-destroy_suspended_device
+++ a/arch/x86/kernel/msr.c
@@ -162,12 +162,10 @@ static int __cpuinit msr_class_cpu_callb
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 		msr_device_destroy(cpu);
 		break;
-	case CPU_UP_CANCELED_FROZEN:
-		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
-		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
diff -puN drivers/base/core.c~pm-remove-destroy_suspended_device drivers/base/core.c
--- a/drivers/base/core.c~pm-remove-destroy_suspended_device
+++ a/drivers/base/core.c
@@ -1164,35 +1164,6 @@ void device_destroy(struct class *class,
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
-#ifdef CONFIG_PM_SLEEP
-/**
- * destroy_suspended_device - asks the PM core to remove a suspended device
- * @class: pointer to the struct class that this device was registered with
- * @devt: the dev_t of the device that was previously registered
- *
- * This call notifies the PM core of the necessity to unregister a suspended
- * device created with a call to device_create() (devices cannot be
- * unregistered directly while suspended, since the PM core holds their
- * semaphores at that time).
- *
- * It can only be called within the scope of a system sleep transition.  In
- * practice this means it has to be directly or indirectly invoked either by
- * a suspend or resume method, or by the PM core (e.g. via
- * disable_nonboot_cpus() or enable_nonboot_cpus()).
- */
-void destroy_suspended_device(struct class *class, dev_t devt)
-{
-	struct device *dev;
-
-	dev = class_find_device(class, &devt, __match_devt);
-	if (dev) {
-		device_pm_schedule_removal(dev);
-		put_device(dev);
-	}
-}
-EXPORT_SYMBOL_GPL(destroy_suspended_device);
-#endif /* CONFIG_PM_SLEEP */
-
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
diff -puN drivers/base/power/main.c~pm-remove-destroy_suspended_device drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-remove-destroy_suspended_device
+++ a/drivers/base/power/main.c
@@ -50,7 +50,6 @@
 LIST_HEAD(dpm_active);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
-static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 
@@ -104,24 +103,6 @@ void device_pm_remove(struct device *dev
 	mutex_unlock(&dpm_list_mtx);
 }
 
-/**
- *	device_pm_schedule_removal - schedule the removal of a suspended device
- *	@dev:	Device to destroy
- *
- *	Moves the device to the dpm_destroy list for further processing by
- *	unregister_dropped_devices().
- */
-void device_pm_schedule_removal(struct device *dev)
-{
-	pr_debug("PM: Preparing for removal: %s:%s\n",
-		dev->bus ? dev->bus->name : "No Bus",
-		kobject_name(&dev->kobj));
-	mutex_lock(&dpm_list_mtx);
-	list_move_tail(&dev->power.entry, &dpm_destroy);
-	mutex_unlock(&dpm_list_mtx);
-}
-EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
-
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -246,26 +227,6 @@ static void dpm_resume(void)
 }
 
 /**
- *	unregister_dropped_devices - Unregister devices scheduled for removal
- *
- *	Unregister all devices on the dpm_destroy list.
- */
-static void unregister_dropped_devices(void)
-{
-	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_destroy)) {
-		struct list_head *entry = dpm_destroy.next;
-		struct device *dev = to_device(entry);
-
-		mutex_unlock(&dpm_list_mtx);
-		/* This also removes the device from the list */
-		device_unregister(dev);
-		mutex_lock(&dpm_list_mtx);
-	}
-	mutex_unlock(&dpm_list_mtx);
-}
-
-/**
  *	device_resume - Restore state of each device in system.
  *
  *	Resume all the devices, unlock them all, and allow new
@@ -275,7 +236,6 @@ void device_resume(void)
 {
 	might_sleep();
 	dpm_resume();
-	unregister_dropped_devices();
 }
 EXPORT_SYMBOL_GPL(device_resume);
 
diff -puN drivers/char/hw_random/core.c~pm-remove-destroy_suspended_device drivers/char/hw_random/core.c
--- a/drivers/char/hw_random/core.c~pm-remove-destroy_suspended_device
+++ a/drivers/char/hw_random/core.c
@@ -234,11 +234,11 @@ static DEVICE_ATTR(rng_available, S_IRUG
 		   NULL);
 
 
-static void unregister_miscdev(bool suspended)
+static void unregister_miscdev(void)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
-	__misc_deregister(&rng_miscdev, suspended);
+	misc_deregister(&rng_miscdev);
 }
 
 static int register_miscdev(void)
@@ -313,7 +313,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(hwrng_register);
 
-void __hwrng_unregister(struct hwrng *rng, bool suspended)
+void hwrng_unregister(struct hwrng *rng)
 {
 	int err;
 
@@ -332,11 +332,11 @@ void __hwrng_unregister(struct hwrng *rn
 		}
 	}
 	if (list_empty(&rng_list))
-		unregister_miscdev(suspended);
+		unregister_miscdev();
 
 	mutex_unlock(&rng_mutex);
 }
-EXPORT_SYMBOL_GPL(__hwrng_unregister);
+EXPORT_SYMBOL_GPL(hwrng_unregister);
 
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
diff -puN drivers/char/misc.c~pm-remove-destroy_suspended_device drivers/char/misc.c
--- a/drivers/char/misc.c~pm-remove-destroy_suspended_device
+++ a/drivers/char/misc.c
@@ -232,9 +232,8 @@ int misc_register(struct miscdevice * mi
 }
 
 /**
- *	__misc_deregister - unregister a miscellaneous device
+ *	misc_deregister - unregister a miscellaneous device
  *	@misc: device to unregister
- *	@suspended: to be set if the function is used during suspend/resume
  *
  *	Unregister a miscellaneous device that was previously
  *	successfully registered with misc_register(). Success
@@ -242,7 +241,7 @@ int misc_register(struct miscdevice * mi
  *	indicates an error.
  */
 
-int __misc_deregister(struct miscdevice *misc, bool suspended)
+int misc_deregister(struct miscdevice *misc)
 {
 	int i = misc->minor;
 
@@ -251,11 +250,7 @@ int __misc_deregister(struct miscdevice 
 
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
-	if (suspended)
-		destroy_suspended_device(misc_class,
-					MKDEV(MISC_MAJOR, misc->minor));
-	else
-		device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
+	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i>0) {
 		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
 	}
@@ -264,7 +259,7 @@ int __misc_deregister(struct miscdevice 
 }
 
 EXPORT_SYMBOL(misc_register);
-EXPORT_SYMBOL(__misc_deregister);
+EXPORT_SYMBOL(misc_deregister);
 
 static int __init misc_init(void)
 {
diff -puN drivers/leds/led-class.c~pm-remove-destroy_suspended_device drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~pm-remove-destroy_suspended_device
+++ a/drivers/leds/led-class.c
@@ -139,12 +139,10 @@ EXPORT_SYMBOL_GPL(led_classdev_register)
 /**
  * __led_classdev_unregister - unregisters a object of led_properties class.
  * @led_cdev: the led device to unregister
- * @suspended: indicates whether system-wide suspend or resume is in progress
  *
  * Unregisters a previously registered via led_classdev_register object.
  */
-void __led_classdev_unregister(struct led_classdev *led_cdev,
-				      bool suspended)
+void led_classdev_unregister(struct led_classdev *led_cdev)
 {
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -155,16 +153,13 @@ void __led_classdev_unregister(struct le
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	if (suspended)
-		device_pm_schedule_removal(led_cdev->dev);
-	else
-		device_unregister(led_cdev->dev);
+	device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
 }
-EXPORT_SYMBOL_GPL(__led_classdev_unregister);
+EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
 static int __init leds_init(void)
 {
diff -puN drivers/net/wireless/b43/leds.c~pm-remove-destroy_suspended_device drivers/net/wireless/b43/leds.c
--- a/drivers/net/wireless/b43/leds.c~pm-remove-destroy_suspended_device
+++ a/drivers/net/wireless/b43/leds.c
@@ -116,10 +116,7 @@ static void b43_unregister_led(struct b4
 {
 	if (!led->dev)
 		return;
-	if (led->dev->suspend_in_progress)
-		led_classdev_unregister_suspended(&led->led_dev);
-	else
-		led_classdev_unregister(&led->led_dev);
+	led_classdev_unregister(&led->led_dev);
 	b43_led_turn_off(led->dev, led->index, led->activelow);
 	led->dev = NULL;
 }
diff -puN drivers/net/wireless/b43/main.c~pm-remove-destroy_suspended_device drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~pm-remove-destroy_suspended_device
+++ a/drivers/net/wireless/b43/main.c
@@ -2557,10 +2557,10 @@ static int b43_rng_read(struct hwrng *rn
 	return (sizeof(u16));
 }
 
-static void b43_rng_exit(struct b43_wl *wl, bool suspended)
+static void b43_rng_exit(struct b43_wl *wl)
 {
 	if (wl->rng_initialized)
-		__hwrng_unregister(&wl->rng, suspended);
+		hwrng_unregister(&wl->rng);
 }
 
 static int b43_rng_init(struct b43_wl *wl)
@@ -3422,7 +3422,7 @@ static void b43_wireless_core_exit(struc
 
 	if (!dev->suspend_in_progress) {
 		b43_leds_exit(dev);
-		b43_rng_exit(dev->wl, false);
+		b43_rng_exit(dev->wl);
 	}
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
@@ -4175,7 +4175,7 @@ static int b43_resume(struct ssb_device 
 		err = b43_wireless_core_start(wldev);
 		if (err) {
 			b43_leds_exit(wldev);
-			b43_rng_exit(wldev->wl, true);
+			b43_rng_exit(wldev->wl);
 			b43_wireless_core_exit(wldev);
 			b43err(wl, "Resume failed at core start\n");
 			goto out;
diff -puN include/linux/device.h~pm-remove-destroy_suspended_device include/linux/device.h
--- a/include/linux/device.h~pm-remove-destroy_suspended_device
+++ a/include/linux/device.h
@@ -448,20 +448,6 @@ extern struct device *device_create(stru
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf, 4, 5)));
 extern void device_destroy(struct class *cls, dev_t devt);
-#ifdef CONFIG_PM_SLEEP
-extern void destroy_suspended_device(struct class *cls, dev_t devt);
-extern void device_pm_schedule_removal(struct device *);
-#else /* !CONFIG_PM_SLEEP */
-static inline void destroy_suspended_device(struct class *cls, dev_t devt)
-{
-	device_destroy(cls, devt);
-}
-
-static inline void device_pm_schedule_removal(struct device *dev)
-{
-	device_unregister(dev);
-}
-#endif /* !CONFIG_PM_SLEEP */
 
 /*
  * Platform "fixup" functions - allow the platform to have their say
diff -puN include/linux/hw_random.h~pm-remove-destroy_suspended_device include/linux/hw_random.h
--- a/include/linux/hw_random.h~pm-remove-destroy_suspended_device
+++ a/include/linux/hw_random.h
@@ -44,15 +44,7 @@ struct hwrng {
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
-extern void __hwrng_unregister(struct hwrng *rng, bool suspended);
-static inline void hwrng_unregister(struct hwrng *rng)
-{
-	__hwrng_unregister(rng, false);
-}
-static inline void hwrng_unregister_suspended(struct hwrng *rng)
-{
-	__hwrng_unregister(rng, true);
-}
+extern void hwrng_unregister(struct hwrng *rng);
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */
diff -puN include/linux/leds.h~pm-remove-destroy_suspended_device include/linux/leds.h
--- a/include/linux/leds.h~pm-remove-destroy_suspended_device
+++ a/include/linux/leds.h
@@ -59,15 +59,7 @@ struct led_classdev {
 
 extern int led_classdev_register(struct device *parent,
 				 struct led_classdev *led_cdev);
-extern void __led_classdev_unregister(struct led_classdev *led_cdev, bool sus);
-static inline void led_classdev_unregister(struct led_classdev *lcd)
-{
-	__led_classdev_unregister(lcd, false);
-}
-static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
-{
-	__led_classdev_unregister(lcd, true);
-}
+extern void led_classdev_unregister(struct led_classdev *lcd);
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
 
diff -puN include/linux/miscdevice.h~pm-remove-destroy_suspended_device include/linux/miscdevice.h
--- a/include/linux/miscdevice.h~pm-remove-destroy_suspended_device
+++ a/include/linux/miscdevice.h
@@ -43,15 +43,7 @@ struct miscdevice  {
 };
 
 extern int misc_register(struct miscdevice * misc);
-extern int __misc_deregister(struct miscdevice *misc, bool suspended);
-static inline int misc_deregister(struct miscdevice *misc)
-{
-	return __misc_deregister(misc, false);
-}
-static inline int misc_deregister_suspended(struct miscdevice *misc)
-{
-	return __misc_deregister(misc, true);
-}
+extern int misc_deregister(struct miscdevice *misc);
 
 #define MODULE_ALIAS_MISCDEV(minor)				\
 	MODULE_ALIAS("char-major-" __stringify(MISC_MAJOR)	\
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
pm-remove-legacy-pm-fix.patch
power-replace-remaining-__function__-occurrences.patch
pm-remove-destroy_suspended_device.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
shrink_slab-handle-bad-shrinkers.patch

