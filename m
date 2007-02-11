From: akpm@linux-foundation.org
Subject: - pnp-export-pnp_bus_type.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:41 -0800
Message-ID: <200702112251.l1BMpfXP015957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762AbXBKWvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ambx1@neo.rr.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     PNP: export pnp_bus_type
has been removed from the -mm tree.  Its filename was
     pnp-export-pnp_bus_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: export pnp_bus_type
From: David Brownell <david-b@pacbell.net>

The PNP framework doesn't export "pnp_bus_type", which is an unfortunate
exception to the policy followed by pretty much every other bus.  I noticed
this when I had to find a device in order to provide its platform_data.

Note that per advice from Arjan, the "export" scope has been been minimized to
avoid the hundred-plus bytes needed to support access from modules.  In this
case, the symbol is only needed by statically linked kernel code that lives
outside the drivers/pnp directory.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h  |    1 -
 include/linux/pnp.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/base.h~pnp-export-pnp_bus_type drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-export-pnp_bus_type
+++ a/drivers/pnp/base.h
@@ -1,4 +1,3 @@
-extern struct bus_type pnp_bus_type;
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
 int pnp_interface_attach_device(struct pnp_dev *dev);
diff -puN include/linux/pnp.h~pnp-export-pnp_bus_type include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-export-pnp_bus_type
+++ a/include/linux/pnp.h
@@ -352,6 +352,8 @@ struct pnp_protocol {
 	(dev) = protocol_to_pnp_dev((dev)->protocol_list.next))
 
 
+extern struct bus_type pnp_bus_type;
+
 #if defined(CONFIG_PNP)
 
 /* device management */
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
spi-eeprom-driver-cleanups.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
