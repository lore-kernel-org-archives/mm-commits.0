From: akpm@linux-foundation.org
Subject: - update-documentation-driver-model-platformtxt.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:00 -0700
Message-ID: <200705212317.l4LNH2W9022437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762216AbXEUXWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dilinger@debian.org, dtor@mail.ru, gregkh@suse.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     update Documentation/driver-model/platform.txt
has been removed from the -mm tree.  Its filename was
     update-documentation-driver-model-platformtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

spi-doc-update-describe-clock-mode-bits.patch
git-leds.patch
git-mmc.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
rtc-ds1307-cleanups.patch
