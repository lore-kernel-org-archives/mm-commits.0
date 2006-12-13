From: akpm@osdl.org
Subject: + isicom-fix-build-with-pci-disabled.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:46:06 -0800
Message-ID: <200612130046.kBD0k663022927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847AbWLMAqM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jirislaby@gmail.com


The patch titled
     isicom: fix build with PCI disabled
has been added to the -mm tree.  Its filename is
     isicom-fix-build-with-pci-disabled.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
git-net.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

