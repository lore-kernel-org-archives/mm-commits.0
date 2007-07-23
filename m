From: akpm@linux-foundation.org
Subject: - spicscan_boardinfo-mustnt-be-__init_or_module.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:49 -0700
Message-ID: <200707230934.l6N9Yn4f016426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759227AbXGWJpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi.c:scan_boardinfo() mustn't be __init_or_module
has been removed from the -mm tree.  Its filename was
     spicscan_boardinfo-mustnt-be-__init_or_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi.c:scan_boardinfo() mustn't be __init_or_module
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x889735): Section mismatch: reference to .init.text:scan_boardinfo (between 'spi_register_master' and '__unregister')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spicscan_boardinfo-mustnt-be-__init_or_module drivers/spi/spi.c
--- a/drivers/spi/spi.c~spicscan_boardinfo-mustnt-be-__init_or_module
+++ a/drivers/spi/spi.c
@@ -303,8 +303,7 @@ spi_register_board_info(struct spi_board
  * creates board info from kernel command lines
  */
 
-static void __init_or_module
-scan_boardinfo(struct spi_master *master)
+static void scan_boardinfo(struct spi_master *master)
 {
 	struct boardinfo	*bi;
 	struct device		*dev = master->cdev.dev;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
