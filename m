From: akpm@linux-foundation.org
Subject: + kconfig-mentioneds-hibernation-not-just-swsusp.patch added to -mm tree
Date: Sat, 21 Apr 2007 20:22:14 -0700
Message-ID: <200704220322.l3M3MEBh018582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbXDVDWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 23:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     kconfig: mention 'hibernation' not just swsusp
has been added to the -mm tree.  Its filename is
     kconfig-mentioneds-hibernation-not-just-swsusp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
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

maintainers-use-listslinux-foundationorg.patch
make-proc-acpi-wakeup-more-useful.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-update.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
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
