From: akpm@linux-foundation.org
Subject: + pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:20:58 -0700
Message-ID: <200704070020.l370Kwu1023670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40365 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573AbXDGA3R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, castet.matthieu@free.fr, jt@hpl.hp.com, kaos@ocs.com.au, lenb@kernel.org, mjg59@srcf.ucam.org, rmk+serial@arm.linux.org.uk, samuel@sortiz.org, syrjala@sci.fi


The patch titled
     PNP: notice whether we have PNP devices (PNPBIOS or PNPACPI)
has been added to the -mm tree.  Its filename is
     pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: notice whether we have PNP devices (PNPBIOS or PNPACPI)
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This series converts i386 and x86_64 legacy serial ports to be platform
devices and prevents probing for them if we have PNP.

This prevents double discovery, where a device was found both by the legacy
probe and by 8250_pnp.

This also prevents the serial driver from claiming IRDA devices (unless they
have a UART PNP ID).  The serial legacy probe sometimes assumed the wrong IRQ,
so the user had to use "setserial" to fix it.

Removing the need for setserial to make IRDA devices work seems good, but it
does break some things.  In particular, you may need to keep setserial from
poking legacy UART stuff back in by doing something like "dpkg-reconfigure
setserial" with the "kernel" option.  Otherwise, the setserial-discovered
"UART" will claim resources and prevent the IRDA driver from loading.



This patch:

If we can discover devices using PNP, we can skip some legacy probes.  This
flag ("pnp_platform_devices") indicates that PNPBIOS or PNPACPI is enabled and
should tell us about builtin devices.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/core.c         |    8 ++++++++
 drivers/pnp/pnpacpi/core.c |    1 +
 drivers/pnp/pnpbios/core.c |    1 +
 include/linux/pnp.h        |    2 ++
 4 files changed, 12 insertions(+)

diff -puN drivers/pnp/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi
+++ a/drivers/pnp/core.c
@@ -23,6 +23,14 @@ static LIST_HEAD(pnp_protocols);
 LIST_HEAD(pnp_global);
 DEFINE_SPINLOCK(pnp_lock);
 
+/*
+ * ACPI or PNPBIOS should tell us about all platform devices, so we can
+ * skip some blind probes.  ISAPNP typically enumerates only plug-in ISA
+ * devices, not built-in things like COM ports.
+ */
+int pnp_platform_devices;
+EXPORT_SYMBOL(pnp_platform_devices);
+
 void *pnp_alloc(long size)
 {
 	void *result;
diff -puN drivers/pnp/pnpacpi/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi
+++ a/drivers/pnp/pnpacpi/core.c
@@ -284,6 +284,7 @@ static int __init pnpacpi_init(void)
 	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
 	pnp_info("PnP ACPI: found %d devices", num);
 	unregister_acpi_bus_type(&acpi_pnp_bus);
+	pnp_platform_devices = 1;
 	return 0;
 }
 subsys_initcall(pnpacpi_init);
diff -puN drivers/pnp/pnpbios/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi
+++ a/drivers/pnp/pnpbios/core.c
@@ -574,6 +574,7 @@ static int __init pnpbios_init(void)
 	/* scan for pnpbios devices */
 	build_devlist();
 
+	pnp_platform_devices = 1;
 	return 0;
 }
 
diff -puN include/linux/pnp.h~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi
+++ a/include/linux/pnp.h
@@ -364,6 +364,7 @@ int pnp_add_device(struct pnp_dev *dev);
 int pnp_device_attach(struct pnp_dev *pnp_dev);
 void pnp_device_detach(struct pnp_dev *pnp_dev);
 extern struct list_head pnp_global;
+extern int pnp_platform_devices;
 
 /* multidevice card support */
 int pnp_add_card(struct pnp_card *card);
@@ -411,6 +412,7 @@ static inline int pnp_init_device(struct
 static inline int pnp_add_device(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_device_attach(struct pnp_dev *pnp_dev) { return -ENODEV; }
 static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { ; }
+#define pnp_platform_devices 0
 
 /* multidevice card support */
 static inline int pnp_add_card(struct pnp_card *card) { return -ENODEV; }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-ia64.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
