From: akpm@linux-foundation.org
Subject: - mtd-fix-m25p80-printk-formats.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:10 -0800
Message-ID: <200812291919.mBTJJAH4031427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYL2TW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix m25p80 printk formats
has been removed from the -mm tree.  Its filename was
     mtd-fix-m25p80-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix m25p80 printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:172: warning: format '%d' expects type 'int', but argument 4 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:236: warning: format '%d' expects type 'int', but argument 6 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:680: warning: format '%d' expects type 'int', but argument 5 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:683: warning: format '%.8x' expects type 'unsigned int', but argument 3 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:683: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:693: warning: format '%.8x' expects type 'unsigned int', but argument 3 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:724: warning: format '%.8x' expects type 'unsigned int', but argument 4 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:724: warning: format '%.8x' expects type 'unsigned int', but argument 5 has type 'uint64_t'
build-r7150.out:/local/linsrc/linux-next-20081215/drivers/mtd/devices/m25p80.c:724: warning: format '%u' expects type 'unsigned int', but argument 6 has type 'uint64_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   34 +++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-fix-m25p80-printk-formats drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-fix-m25p80-printk-formats
+++ a/drivers/mtd/devices/m25p80.c
@@ -169,9 +169,9 @@ static int wait_till_ready(struct m25p *
  */
 static int erase_chip(struct m25p *flash)
 {
-	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB\n",
+	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %lluKiB\n",
 			dev_name(&flash->spi->dev), __func__,
-			flash->mtd.size / 1024);
+			(unsigned long long)flash->mtd.size / 1024);
 
 	/* Wait until finished previous write command. */
 	if (wait_till_ready(flash))
@@ -233,9 +233,9 @@ static int m25p80_erase(struct mtd_info 
 	struct m25p *flash = mtd_to_m25p(mtd);
 	u32 addr,len;
 
-	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %d\n",
+	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %u\n",
 			dev_name(&flash->spi->dev), __func__, "at",
-			(u32)instr->addr, instr->len);
+			(u32)instr->addr, (u32)instr->len);
 
 	/* sanity checks */
 	if (instr->addr + instr->len > flash->mtd.size)
@@ -677,24 +677,26 @@ static int __devinit m25p_probe(struct s
 		flash->mtd.erasesize = info->sector_size;
 	}
 
-	dev_info(&spi->dev, "%s (%d Kbytes)\n", info->name,
-			flash->mtd.size / 1024);
+	dev_info(&spi->dev, "%s (%llu Kbytes)\n", info->name,
+			(unsigned long long)flash->mtd.size / 1024);
 
 	DEBUG(MTD_DEBUG_LEVEL2,
-		"mtd .name = %s, .size = 0x%.8x (%uMiB) "
+		"mtd .name = %s, .size = 0x%.8llx (%lluMiB) "
 			".erasesize = 0x%.8x (%uKiB) .numeraseregions = %d\n",
 		flash->mtd.name,
-		flash->mtd.size, flash->mtd.size / (1024*1024),
+		(unsigned long long)flash->mtd.size,
+		(unsigned long long)flash->mtd.size / (1024*1024),
 		flash->mtd.erasesize, flash->mtd.erasesize / 1024,
 		flash->mtd.numeraseregions);
 
 	if (flash->mtd.numeraseregions)
 		for (i = 0; i < flash->mtd.numeraseregions; i++)
 			DEBUG(MTD_DEBUG_LEVEL2,
-				"mtd.eraseregions[%d] = { .offset = 0x%.8x, "
+				"mtd.eraseregions[%d] = { .offset = 0x%.8llx, "
 				".erasesize = 0x%.8x (%uKiB), "
-				".numblocks = %d }\n",
-				i, flash->mtd.eraseregions[i].offset,
+				".numblocks = %d }\n", i,
+				(unsigned long long)
+				  flash->mtd.eraseregions[i].offset,
 				flash->mtd.eraseregions[i].erasesize,
 				flash->mtd.eraseregions[i].erasesize / 1024,
 				flash->mtd.eraseregions[i].numblocks);
@@ -722,12 +724,12 @@ static int __devinit m25p_probe(struct s
 		if (nr_parts > 0) {
 			for (i = 0; i < nr_parts; i++) {
 				DEBUG(MTD_DEBUG_LEVEL2, "partitions[%d] = "
-					"{.name = %s, .offset = 0x%.8x, "
-						".size = 0x%.8x (%uKiB) }\n",
+					"{.name = %s, .offset = 0x%.8llx, "
+						".size = 0x%.8llx (%lluKiB) }\n",
 					i, parts[i].name,
-					parts[i].offset,
-					parts[i].size,
-					parts[i].size / 1024);
+					(unsigned long long)parts[i].offset,
+					(unsigned long long)parts[i].size,
+					(unsigned long long)(parts[i].size / 1024));
 			}
 			flash->partitioned = 1;
 			return add_mtd_partitions(&flash->mtd, parts, nr_parts);
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

