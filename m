From: akpm@osdl.org
Subject: - geode-crypto-is-pci-device.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:02 -0800
Message-ID: <200612130652.kBD6q2vn030403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978AbWLMGwa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     geode crypto is PCI device
has been removed from the -mm tree.  Its filename was
     geode-crypto-is-pci-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: geode crypto is PCI device
From: Randy Dunlap <randy.dunlap@oracle.com>

This driver seems to be for a PCI device.

drivers/crypto/geode-aes.c:384: warning: implicit declaration of function 'pci_release_regions'
drivers/crypto/geode-aes.c:397: warning: implicit declaration of function 'pci_request_regions'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/crypto/Kconfig~geode-crypto-is-pci-device drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig~geode-crypto-is-pci-device
+++ a/drivers/crypto/Kconfig
@@ -53,7 +53,7 @@ config CRYPTO_DEV_PADLOCK_SHA
 
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
-	depends on CRYPTO && X86_32
+	depends on CRYPTO && X86_32 && PCI
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	default m
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
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

