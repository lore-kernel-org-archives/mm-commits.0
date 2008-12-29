From: akpm@linux-foundation.org
Subject: - mtd-fix-dataflash-printk-formats.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:08 -0800
Message-ID: <200812291919.mBTJJ8r3031416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYL2TTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix dataflash printk formats
has been removed from the -mm tree.  Its filename was
     mtd-fix-dataflash-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix dataflash printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:156: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'uint64_t'
build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:156: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'uint64_t'
build-r7137.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/mtd_dataflash.c:670: warning: format '%d' expects type 'int', but argument 5 has type 'uint64_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd-fix-dataflash-printk-formats drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd-fix-dataflash-printk-formats
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -153,9 +153,10 @@ static int dataflash_erase(struct mtd_in
 	unsigned		blocksize = priv->page_size << 3;
 	uint8_t			*command;
 
-	DEBUG(MTD_DEBUG_LEVEL2, "%s: erase addr=0x%x len 0x%x\n",
+	DEBUG(MTD_DEBUG_LEVEL2, "%s: erase addr=0x%llx len 0x%llx\n",
 			dev_name(&spi->dev),
-			instr->addr, instr->len);
+			(unsigned long long)instr->addr,
+			(unsigned long long)instr->len);
 
 	/* Sanity checks */
 	if ((instr->addr + instr->len) > mtd->size
@@ -667,8 +668,8 @@ add_dataflash_otp(struct spi_device *spi
 	if (revision >= 'c')
 		otp_tag = otp_setup(device, revision);
 
-	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes%s\n",
-			name, DIV_ROUND_UP(device->size, 1024),
+	dev_info(&spi->dev, "%s (%llu KBytes) pagesize %d bytes%s\n",
+			name, (unsigned long long)DIV_ROUND_UP(device->size, 1024),
 			pagesize, otp_tag);
 	dev_set_drvdata(&spi->dev, priv);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
docs-add-more-early-params-to-kernel-parameterstxt.patch
doc-reformat-some-long-lines-in-kernel-parameterstxt.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

