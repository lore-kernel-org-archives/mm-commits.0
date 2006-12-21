From: akpm@osdl.org
Subject: + mips-eisa-registration-with-config_eisa.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:57:56 -0800
Message-ID: <200612210457.kBL4vuW3016089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38084 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422720AbWLUE6D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, ralf@linux-mips.org


The patch titled
     mips: EISA registration with !CONFIG_EISA
has been added to the -mm tree.  Its filename is
     mips-eisa-registration-with-config_eisa.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: EISA registration with !CONFIG_EISA
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change for the EISA bus support to permit drivers to call
un/registration functions even if EISA support has not been enabled.  This is
similar to what PCI (and now TC) does and reduces the need for #ifdef clutter.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/eisa.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/eisa.h~mips-eisa-registration-with-config_eisa include/linux/eisa.h
--- a/include/linux/eisa.h~mips-eisa-registration-with-config_eisa
+++ a/include/linux/eisa.h
@@ -61,10 +61,20 @@ struct eisa_driver {
 
 #define to_eisa_driver(drv) container_of(drv,struct eisa_driver, driver)
 
+/* These external functions are only available when EISA support is enabled. */
+#ifdef CONFIG_EISA
+
 extern struct bus_type eisa_bus_type;
 int eisa_driver_register (struct eisa_driver *edrv);
 void eisa_driver_unregister (struct eisa_driver *edrv);
 
+#else /* !CONFIG_EISA */
+
+static inline int eisa_driver_register (struct eisa_driver *edrv) { return 0; }
+static inline void eisa_driver_unregister (struct eisa_driver *edrv) { }
+
+#endif /* !CONFIG_EISA */
+
 /* Mimics pci.h... */
 static inline void *eisa_get_drvdata (struct eisa_device *edev)
 {
_

Patches currently in -mm which might be from macro@linux-mips.org are

mips-if_fddih-add-a-missing-inclusion.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch

