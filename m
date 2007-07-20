From: akpm@linux-foundation.org
Subject: + spicscan_boardinfo-mustnt-be-__init_or_module.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:16:39 -0700
Message-ID: <200707200016.l6K0GdpI030232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbXGTAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dbrownell@users.sourceforge.net


The patch titled
     spi.c:scan_boardinfo() mustn't be __init_or_module
has been added to the -mm tree.  Its filename is
     spicscan_boardinfo-mustnt-be-__init_or_module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi.c:scan_boardinfo() mustn't be __init_or_module
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x889735): Section mismatch: reference to .init.text:scan_boardinfo (between 'spi_register_master' and '__unregister')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

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

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-intel_cacheinfocfind_num_cache_leaves-should.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
spicscan_boardinfo-mustnt-be-__init_or_module.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
