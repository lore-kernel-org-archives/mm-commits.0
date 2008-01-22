From: akpm@linux-foundation.org
Subject: + pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:42:31 -0800
Message-ID: <200801220942.m0M9gB4d014767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052AbYAVJmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:42:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     PNP: disable Supermicro H8DCE motherboard resources that overlap SATA BARs
has been added to the -mm tree.  Its filename is
     pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars.patch

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
Subject: PNP: disable Supermicro H8DCE motherboard resources that overlap SATA BARs
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Some Supermicro BIOSes describe a SATA PCI BAR as a motherboard resource. 
The PNP system driver claims motherboard resources, and this prevents the
sata_nv driver from requesting it later.

This patch disables the PNP0C01/PNP0C02 resources so they won't be claimed
by the PNP system driver, so they'll available for sata_nv.

This fixes the bugs below, where sata_nv detects only two out of four SATA
drives.  The signature includes dmesg lines similar to these:

  pnp: 00:09: iomem range 0xdfefc000-0xdfefcfff has been reserved
  pnp: 00:09: iomem range 0xdfefd000-0xdfefd3ff has been reserved
  pnp: 00:09: iomem range 0xdfefe000-0xdfefe3ff has been reserved

  PCI: Unable to reserve mem region #6:1000@dfefd000 for device 0000:80:07.0
  sata_nv: probe of 0000:80:07.0 failed with error -16
  PCI: Unable to reserve mem region #6:1000@dfefe000 for device 0000:80:08.0
  sata_nv: probe of 0000:80:08.0 failed with error -16

References:
    https://bugzilla.redhat.com/show_bug.cgi?id=280641
    https://bugzilla.redhat.com/show_bug.cgi?id=313491
    http://lkml.org/lkml/2008/1/9/449
    http://thread.gmane.org/gmane.linux.acpi.devel/27312

This is post-2.6.24 material.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN drivers/pnp/quirks.c~pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars
+++ a/drivers/pnp/quirks.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include <linux/io.h>
+#include <linux/dmi.h>
 #include <linux/kallsyms.h>
 #include "base.h"
 
@@ -108,6 +109,46 @@ static void quirk_sb16audio_resources(st
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
+static void quirk_supermicro_h8dce_system(struct pnp_dev *dev)
+{
+	int i;
+	static struct dmi_system_id supermicro_h8dce[] = {
+		{
+			.ident = "Supermicro H8DCE",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "H8DCE"),
+			},
+		},
+		{ }
+	};
+
+	if (!dmi_check_system(supermicro_h8dce))
+		return;
+
+	/*
+	 * On the Supermicro H8DCE, there's a system device with resources
+	 * that overlap BAR 6 of the built-in SATA PCI adapter.  If the PNP
+	 * system device claims them, the sata_nv driver won't be able to.
+	 * More details at:
+	 *     https://bugzilla.redhat.com/show_bug.cgi?id=280641
+	 *     https://bugzilla.redhat.com/show_bug.cgi?id=313491
+	 *     http://lkml.org/lkml/2008/1/9/449
+	 *     http://thread.gmane.org/gmane.linux.acpi.devel/27312
+	 */
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		if (pnp_mem_valid(dev, i) && pnp_mem_len(dev, i) &&
+		    (pnp_mem_start(dev, i) & 0xdfef0000) == 0xdfef0000) {
+			dev_warn(&dev->dev, "disabling 0x%llx-0x%llx to prevent"
+				" conflict with sata_nv PCI device\n",
+				(unsigned long long) pnp_mem_start(dev, i),
+				(unsigned long long) (pnp_mem_start(dev, i) +
+					pnp_mem_len(dev, i) - 1));
+			pnp_mem_flags(dev, i) = 0;
+		}
+	}
+}
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -128,6 +169,8 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	{"PNP0c01", quirk_supermicro_h8dce_system},
+	{"PNP0c02", quirk_supermicro_h8dce_system},
 	{""}
 };
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
parport_serial-netmos-9855-fix.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
pnp-do-not-test-pnp_driver_res_do_not_change-on-suspend-resume.patch
pnp-disable-supermicro-h8dce-motherboard-resources-that-overlap-sata-bars.patch
dont-touch-fs_struct-in-drivers.patch
