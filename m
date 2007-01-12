From: akpm@osdl.org
Subject: - intel-rng-workarounds.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:13 -0800
Message-ID: <200701122218.l0CMIDlh030778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161147AbXALWTE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, jeff@garzik.org, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     intel-rng workarounds
has been removed from the -mm tree.  Its filename was
     intel-rng-workarounds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel-rng workarounds
From: "Jan Beulich" <jbeulich@novell.com>

Add a load option to intel-rng to allow skipping the FWH detection,
necessary in case the BIOS has locked read-only the firmware hub space. 
Also prevent any attempt to write to firmware space if it cannot be write
enabled (apparently caused hangs on some systems not having an FWH and thus
also not having a respective RNG).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/hw_random/intel-rng.c |   32 +++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff -puN drivers/char/hw_random/intel-rng.c~intel-rng-workarounds drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c~intel-rng-workarounds
+++ a/drivers/char/hw_random/intel-rng.c
@@ -143,6 +143,11 @@ static const struct pci_device_id pci_tb
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
+static __initdata int no_fwh_detect;
+module_param(no_fwh_detect, int, 0);
+MODULE_PARM_DESC(no_fwh_detect, "Skip FWH detection:\n"
+                                " positive value - skip if FWH space locked read-only\n"
+                                " negative value - skip always");
 
 static inline u8 hwstatus_get(void __iomem *mem)
 {
@@ -240,6 +245,11 @@ static int __init mod_init(void)
 	if (!dev)
 		goto out; /* Device not found. */
 
+	if (no_fwh_detect < 0) {
+		pci_dev_put(dev);
+		goto fwh_done;
+	}
+
 	/* Check for Intel 82802 */
 	if (dev->device < 0x2640) {
 		fwh_dec_en1_off = FWH_DEC_EN1_REG_OLD;
@@ -252,6 +262,23 @@ static int __init mod_init(void)
 	pci_read_config_byte(dev, fwh_dec_en1_off, &fwh_dec_en1_val);
 	pci_read_config_byte(dev, bios_cntl_off, &bios_cntl_val);
 
+	if ((bios_cntl_val &
+	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
+	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
+		static __initdata /*const*/ char warning[] =
+			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
+			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
+			KERN_WARNING PFX "you are certain that your system has a functional\n"
+			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
+
+		pci_dev_put(dev);
+		if (no_fwh_detect)
+			goto fwh_done;
+		printk(warning);
+		err = -EBUSY;
+		goto out;
+	}
+
 	mem = ioremap_nocache(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
 	if (mem == NULL) {
 		pci_dev_put(dev);
@@ -280,8 +307,7 @@ static int __init mod_init(void)
 		pci_write_config_byte(dev,
 		                      fwh_dec_en1_off,
 		                      fwh_dec_en1_val | FWH_F8_EN_MASK);
-	if (!(bios_cntl_val &
-	      (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK)))
+	if (!(bios_cntl_val & BIOS_CNTL_WRITE_ENABLE_MASK))
 		pci_write_config_byte(dev,
 		                      bios_cntl_off,
 		                      bios_cntl_val | BIOS_CNTL_WRITE_ENABLE_MASK);
@@ -315,6 +341,8 @@ static int __init mod_init(void)
 		goto out;
 	}
 
+fwh_done:
+
 	err = -ENOMEM;
 	mem = ioremap(INTEL_RNG_ADDR, INTEL_RNG_ADDR_LEN);
 	if (!mem)
_

Patches currently in -mm which might be from jbeulich@novell.com are

ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
ia64-enable-swiotlb-only-when-needed.patch
i386-adjustments-to-page-table-dump-during-oops.patch
