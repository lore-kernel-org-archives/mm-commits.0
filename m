From: akpm@linux-foundation.org
Subject: - mips-eisa-registration-with-config_eisa.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:25:32 -0800
Message-ID: <200702100525.l1A5PWdh004611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbXBJF3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: EISA registration with !CONFIG_EISA
has been removed from the -mm tree.  Its filename was
     mips-eisa-registration-with-config_eisa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: EISA registration with !CONFIG_EISA
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change for the EISA bus support to permit drivers to call
un/registration functions even if EISA support has not been enabled.  This is
similar to what PCI (and now TC) does and reduces the need for #ifdef clutter.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
