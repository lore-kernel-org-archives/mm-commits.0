From: akpm@osdl.org
Subject: + geode-crypto-is-pci-device.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:18:17 -0800
Message-ID: <200612090018.kB90IHeV010694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56193 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947572AbWLIASi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jordan.crouse@amd.com


The patch titled
     geode crypto is PCI device
has been added to the -mm tree.  Its filename is
     geode-crypto-is-pci-device.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode crypto is PCI device
From: Randy Dunlap <randy.dunlap@oracle.com>

This driver seems to be for a PCI device.

drivers/crypto/geode-aes.c:384: warning: implicit declaration of function 'pci_release_regions'
drivers/crypto/geode-aes.c:397: warning: implicit declaration of function 'pci_request_regions'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/crypto/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

