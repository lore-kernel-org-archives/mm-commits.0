From: akpm@osdl.org
Subject: + rtc-gets-sysfs-wakealarm-attribute.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:48:50 -0800
Message-ID: <200702012248.l11MmoOD025249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbXBAWtz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, greg@kroah.com, pavel@ucw.cz


The patch titled
     RTC gets sysfs wakealarm attribute
has been added to the -mm tree.  Its filename is
     rtc-gets-sysfs-wakealarm-attribute.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC gets sysfs wakealarm attribute
From: David Brownell <david-b@pacbell.net>

This adds a new "wakealarm" sysfs attribute to RTC class devices which support
alarm operations and are wakeup-capable:

 - It reads as either empty, or the scheduled alarm time as seconds
   since the POSIX epoch.  (That time may already have passed, since
   nothing currently enforces one-shot alarm semantics.)

 - It can be written with an alarm time in the future, again seconds
   since the POSIX epoch, which enables the alarm.

 - It can be written with an alarm time not in the future (such as 0,
   the start of the POSIX epoch) to disable the alarm.

Usage examples (some need GNU date) after "cd /sys/class/rtc/rtcN":

    alarm after 10 minutes:
	# echo $(( $(cat since_epoch) + 10 * 60 )) > wakealarm
    alarm tuesday evening 10pm:
	# date -d '10pm tuesday' "+%s" > wakealarm
    disable alarm:
    	# echo 0 > wakealarm

This resembles the /proc/acpi/alarm file in that nothing happens when the
alarm triggers ...  except possibly waking the system from sleep.  It's also
like that in a nasty way: not much can be done to prevent one task from
clobbering another task's alarm settings.

It differs from that file in that there's no in-kernel date parser.

Note that a few RTCs ignore rtc_wkalrm.enabled when setting alarms, or aren't
set up correctly, so they won't yet behave with this attribute.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-sysfs.c |  103 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 101 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-sysfs.c~rtc-gets-sysfs-wakealarm-attribute drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-gets-sysfs-wakealarm-attribute
+++ a/drivers/rtc/rtc-sysfs.c
@@ -78,6 +78,92 @@ static struct attribute_group rtc_attr_g
 	.attrs = rtc_attrs,
 };
 
+
+static ssize_t
+rtc_sysfs_show_wakealarm(struct class_device *dev, char *buf)
+{
+	ssize_t retval;
+	unsigned long alarm;
+	struct rtc_wkalrm alm;
+
+	/* Don't show disabled alarms; but the RTC could leave the
+	 * alarm enabled after it's already triggered.  Alarms are
+	 * conceptually one-shot, even though some common hardware
+	 * (PCs) doesn't actually work that way.
+	 *
+	 * REVISIT maybe we should require RTC implementations to
+	 * disable the RTC alarm after it triggers, for uniformity.
+	 */
+	retval = rtc_read_alarm(dev, &alm);
+	if (retval == 0 && alm.enabled) {
+		rtc_tm_to_time(&alm.time, &alarm);
+		retval = sprintf(buf, "%lu\n", alarm);
+	}
+
+	return retval;
+}
+
+static ssize_t
+rtc_sysfs_set_wakealarm(struct class_device *dev, const char *buf, size_t n)
+{
+	ssize_t retval;
+	unsigned long now, alarm;
+	struct rtc_wkalrm alm;
+
+	/* Only request alarms that trigger in the future.  Disable them
+	 * by writing another time, e.g. 0 meaning Jan 1 1970 UTC.
+	 */
+	retval = rtc_read_time(dev, &alm.time);
+	if (retval < 0)
+		return retval;
+	rtc_tm_to_time(&alm.time, &now);
+
+	alarm = simple_strtoul(buf, NULL, 0);
+	if (alarm > now) {
+		/* Avoid accidentally clobbering active alarms; we can't
+		 * entirely prevent that here, without even the minimal
+		 * locking from the /dev/rtcN api.
+		 */
+		retval = rtc_read_alarm(dev, &alm);
+		if (retval < 0)
+			return retval;
+		if (alm.enabled)
+			return -EBUSY;
+
+		alm.enabled = 1;
+	} else {
+		alm.enabled = 0;
+
+		/* Provide a valid future alarm time.  Linux isn't EFI,
+		 * this time won't be ignored when disabling the alarm.
+		 */
+		alarm = now + 300;
+	}
+	rtc_time_to_tm(alarm, &alm.time);
+
+	retval = rtc_set_alarm(dev, &alm);
+	return (retval < 0) ? retval : n;
+}
+static const CLASS_DEVICE_ATTR(wakealarm, S_IRUGO | S_IWUSR,
+		rtc_sysfs_show_wakealarm, rtc_sysfs_set_wakealarm);
+
+
+/* The reason to trigger an alarm with no process watching it (via sysfs)
+ * is its side effect:  waking from a system state like suspend-to-RAM or
+ * suspend-to-disk.  So: no attribute unless that side effect is possible.
+ * (Userspace may disable that mechanism later.)
+ */
+static inline int rtc_does_wakealarm(struct class_device *class_dev)
+{
+	struct rtc_device *rtc;
+
+	if (!device_can_wakeup(class_dev->dev))
+		return 0;
+	rtc = to_rtc_device(class_dev);
+	return rtc->ops->set_alarm != NULL;
+}
+
+
 static int rtc_sysfs_add_device(struct class_device *class_dev,
 					struct class_interface *class_intf)
 {
@@ -87,8 +173,18 @@ static int rtc_sysfs_add_device(struct c
 
 	err = sysfs_create_group(&class_dev->kobj, &rtc_attr_group);
 	if (err)
-		dev_err(class_dev->dev,
-			"failed to create sysfs attributes\n");
+		dev_err(class_dev->dev, "failed to create %s\n",
+				"sysfs attributes");
+	else if (rtc_does_wakealarm(class_dev)) {
+		/* not all RTCs support both alarms and wakeup */
+		err = class_device_create_file(class_dev,
+					&class_device_attr_wakealarm);
+		if (err) {
+			dev_err(class_dev->dev, "failed to create %s\n",
+					"alarm attribute");
+			sysfs_remove_group(&class_dev->kobj, &rtc_attr_group);
+		}
+	}
 
 	return err;
 }
@@ -96,6 +192,9 @@ static int rtc_sysfs_add_device(struct c
 static void rtc_sysfs_remove_device(struct class_device *class_dev,
 				struct class_interface *class_intf)
 {
+	if (rtc_does_wakealarm(class_dev))
+		class_device_remove_file(class_dev,
+				&class_device_attr_wakealarm);
 	sysfs_remove_group(&class_dev->kobj, &rtc_attr_group);
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-updates-rtc-cmos-device-platform_data.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
