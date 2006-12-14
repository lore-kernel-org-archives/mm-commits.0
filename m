From: akpm@osdl.org
Subject: - isicom-fix-build-with-pci-disabled.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:05:38 -0800
Message-ID: <200612140605.kBE65crE001846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51834 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbWLNGGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isicom: fix build with PCI disabled
has been removed from the -mm tree.  Its filename was
     isicom-fix-build-with-pci-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isicom: fix build with PCI disabled
From: Randy Dunlap <randy.dunlap@oracle.com>


With CONFIG_PCI=n:
drivers/char/isicom.c: In function 'isicom_probe':
drivers/char/isicom.c:1793: warning: implicit declaration of function
'pci_request_region'
drivers/char/isicom.c:1827: warning: implicit declaration of function
'pci_release_region'

Let's CONFIG_ISI depend on CONFIG_PCI.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~isicom-fix-build-with-pci-disabled drivers/char/Kconfig
--- a/drivers/char/Kconfig~isicom-fix-build-with-pci-disabled
+++ a/drivers/char/Kconfig
@@ -218,7 +218,7 @@ config MOXA_SMARTIO_NEW
 
 config ISI
 	tristate "Multi-Tech multiport card support (EXPERIMENTAL)"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && PCI
 	select FW_LOADER
 	help
 	  This is a driver for the Multi-Tech cards which provide several
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

