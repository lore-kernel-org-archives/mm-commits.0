From: akpm@linux-foundation.org
Subject: - mtd-remove-excess-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:07 -0800
Message-ID: <200812152002.mBFK27MC030705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756512AbYLOUC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: remove excess kernel-doc notation
has been removed from the -mm tree.  Its filename was
     mtd-remove-excess-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: remove excess kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Delete extra kernel-doc notation for struct fields and function
parameters that don't exist:

Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'wq' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'datbuf' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'oobbuf' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'oobdirty' description in 'nand_chip'
Warning(include/linux/mtd/nand.h:428): Excess struct/union/enum/typedef member 'data_poi' description in 'nand_chip'
Warning(drivers/mtd/nand/nand_base.c:2527): Excess function parameter 'maxchips' description in 'nand_scan_tail'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    1 -
 include/linux/mtd/nand.h     |    5 -----
 2 files changed, 6 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~mtd-remove-excess-kernel-doc-notation drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-remove-excess-kernel-doc-notation
+++ a/drivers/mtd/nand/nand_base.c
@@ -2517,7 +2517,6 @@ int nand_scan_ident(struct mtd_info *mtd
 /**
  * nand_scan_tail - [NAND Interface] Scan for the NAND device
  * @mtd:	    MTD device structure
- * @maxchips:	    Number of chips to scan for
  *
  * This is the second phase of the normal nand_scan() function. It
  * fills out all the uninitialized function pointers with the defaults
diff -puN include/linux/mtd/nand.h~mtd-remove-excess-kernel-doc-notation include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~mtd-remove-excess-kernel-doc-notation
+++ a/include/linux/mtd/nand.h
@@ -335,17 +335,12 @@ struct nand_buffers {
  * @erase_cmd:		[INTERN] erase command write function, selectable due to AND support
  * @scan_bbt:		[REPLACEABLE] function to scan bad block table
  * @chip_delay:		[BOARDSPECIFIC] chip dependent delay for transfering data from array to read regs (tR)
- * @wq:			[INTERN] wait queue to sleep on if a NAND operation is in progress
  * @state:		[INTERN] the current state of the NAND device
  * @oob_poi:		poison value buffer
  * @page_shift:		[INTERN] number of address bits in a page (column address bits)
  * @phys_erase_shift:	[INTERN] number of address bits in a physical eraseblock
  * @bbt_erase_shift:	[INTERN] number of address bits in a bbt entry
  * @chip_shift:		[INTERN] number of address bits in one chip
- * @datbuf:		[INTERN] internal buffer for one page + oob
- * @oobbuf:		[INTERN] oob buffer for one eraseblock
- * @oobdirty:		[INTERN] indicates that oob_buf must be reinitialized
- * @data_poi:		[INTERN] pointer to a data buffer
  * @options:		[BOARDSPECIFIC] various chip options. They can partly be set to inform nand_scan about
  *			special functionality. See the defines for further explanation
  * @badblockpos:	[INTERN] position of the bad block marker in the oob area
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

