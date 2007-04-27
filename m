From: akpm@linux-foundation.org
Subject: + update-documentation-driver-model-platformtxt.patch added to -mm tree
Date: Thu, 26 Apr 2007 22:17:53 -0700
Message-ID: <200704270517.l3R5Hrh3020087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbXD0FSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 01:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dilinger@debian.org, dtor@mail.ru, gregkh@suse.de, rmk@arm.linux.org.uk


The patch titled
     update Documentation/driver-model/platform.txt
has been added to the -mm tree.  Its filename is
     update-documentation-driver-model-platformtxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update Documentation/driver-model/platform.txt
From: David Brownell <david-b@pacbell.net>

Make note of the legacy "probe-the-hardware" drivers, and some APIs that
are mostly unused except by such drivers.  We probably can't escape having
legacy drivers for a while (e.g.  old ISA drivers), but we can at least
discourage this style code for new drivers, and unless it's unavoidable.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg KH <gregkh@suse.de>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-model/platform.txt |   40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN Documentation/driver-model/platform.txt~update-documentation-driver-model-platformtxt Documentation/driver-model/platform.txt
--- a/Documentation/driver-model/platform.txt~update-documentation-driver-model-platformtxt
+++ a/Documentation/driver-model/platform.txt
@@ -96,6 +96,46 @@ System setup also associates those clock
 calls to clk_get(&pdev->dev, clock_name) return them as needed.
 
 
+Legacy Drivers:  Device Probing
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Some drivers are not fully converted to the driver model, because they take
+on a non-driver role:  the driver registers its platform device, rather than
+leaving that for system infrastructure.  Such drivers can't be hotplugged
+or coldplugged, since those mechanisms require device creation to be in a
+different system component than the driver.
+
+The only "good" reason for this is to handle older system designs which, like
+original IBM PCs, rely on error-prone "probe-the-hardware" models for hardware
+configuration.  Newer systems have largely abandoned that model, in favor of
+bus-level support for dynamic configuration (PCI, USB), or device tables
+provided by the boot firmware (e.g. PNPACPI on x86).  There are too many
+conflicting options about what might be where, and even educated guesses by
+an operating system will be wrong often enough to make trouble.
+
+This style of driver is discouraged.  If you're updating such a driver,
+please try to move the device enumeration to a more appropriate location,
+outside the driver.  This will usually be cleanup, since such drivers
+tend to already have "normal" modes, such as ones using device nodes that
+were created by PNP or by platform device setup.
+
+None the less, there are some APIs to support such legacy drivers.  Avoid
+using these calls except with such hotplug-deficient drivers.
+
+	struct platform_device *platform_device_alloc(
+			char *name, unsigned id);
+
+You can use platform_device_alloc() to dynamically allocate a device, which
+you will then initialize with resources and platform_device_register().
+A better solution is usually:
+
+	struct platform_device *platform_device_register_simple(
+			char *name, unsigned id,
+			struct resource *res, unsigned nres);
+
+You can use platform_device_register_simple() as a one-step call to allocate
+and register a device.
+
+
 Device Naming and Driver Binding
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 The platform_device.dev.bus_id is the canonical name for the devices.
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
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
