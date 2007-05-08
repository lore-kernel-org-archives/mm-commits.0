From: akpm@linux-foundation.org
Subject: - kconfig-mentioneds-hibernation-not-just-swsusp.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:35 -0700
Message-ID: <200705080005.l4805Z3b009108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967502AbXEHAMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     kconfig: mention 'hibernation' not just swsusp
has been removed from the -mm tree.  Its filename was
     kconfig-mentioneds-hibernation-not-just-swsusp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: mention 'hibernation' not just swsusp
From: David Brownell <david-b@pacbell.net>

Clarify that "software suspend" is what's called "hibernation" in most user
interfaces, shrinking a terminology gap.  (Examples include Gnome and
MS-Windows.)

Also provide a more succinct description of what it does, so you won't have
to read the whole novel in Kconfig; and highlights just why the lack of
BIOS requirements for swsusp are a big deal.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/Kconfig |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN kernel/power/Kconfig~kconfig-mentioneds-hibernation-not-just-swsusp kernel/power/Kconfig
--- a/kernel/power/Kconfig~kconfig-mentioneds-hibernation-not-just-swsusp
+++ a/kernel/power/Kconfig
@@ -78,17 +78,22 @@ config PM_SYSFS_DEPRECATED
 	  are likely to be bus or driver specific.
 
 config SOFTWARE_SUSPEND
-	bool "Software Suspend"
+	bool "Software Suspend (Hibernation)"
 	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
 	---help---
-	  Enable the suspend to disk (STD) functionality.
+	  Enable the suspend to disk (STD) functionality, which is usually
+	  called "hibernation" in user interfaces.  STD checkpoints the
+	  system and powers it off; and restores that checkpoint on reboot.
 
 	  You can suspend your machine with 'echo disk > /sys/power/state'.
 	  Alternatively, you can use the additional userland tools available
 	  from <http://suspend.sf.net>.
 
 	  In principle it does not require ACPI or APM, although for example
-	  ACPI will be used if available.
+	  ACPI will be used for the final steps when it is available.  One
+	  of the reasons to use software suspend is that the firmware hooks
+	  for suspend states like suspend-to-RAM (STR) often don't work very
+	  well with Linux.
 
 	  It creates an image which is saved in your active swap. Upon the next
 	  boot, pass the 'resume=/dev/swappartition' argument to the kernel to
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
spi-kerneldoc.patch
spi-kerneldoc-fix.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
