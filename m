From: akpm@osdl.org
Subject: + x86-64-define-dma-noncoherent-api-functions.patch added to -mm tree
Date: Wed, 31 Jan 2007 16:01:08 -0800
Message-ID: <200702010001.l11018Hk030642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbXBAABT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 19:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org


The patch titled
     x86-64: define dma noncoherent API functions
has been added to the -mm tree.  Its filename is
     x86-64-define-dma-noncoherent-api-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: define dma noncoherent API functions
From: Jeff Garzik <jeff@garzik.org>

x86-64 is missing these:

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN include/asm-x86_64/dma-mapping.h~x86-64-define-dma-noncoherent-api-functions include/asm-x86_64/dma-mapping.h
--- a/include/asm-x86_64/dma-mapping.h~x86-64-define-dma-noncoherent-api-functions
+++ a/include/asm-x86_64/dma-mapping.h
@@ -63,6 +63,9 @@ static inline int dma_mapping_error(dma_
 	return (dma_addr == bad_dma_address);
 }
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
_

Patches currently in -mm which might be from jeff@garzik.org are

r8169-fix-a-race-between-pci-probe-and-dev_open.patch
git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-use-adma-for-nodata-commands.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
tulip-fix-shutdown-dma-irq-race.patch
z85230-spinlock-logic.patch
remove-unused-kernel-config-option-dlci_count.patch
git-ioat.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch
x86-64-define-dma-noncoherent-api-functions.patch
uml-network-driver-whitespace-and-style-fixes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
add-is_power_of_2-checking-to-log2h.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch
