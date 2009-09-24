From: akpm@linux-foundation.org
Subject: [merged] adfs-remove-redundant-test-on-unsigned.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:02 -0700
Message-ID: <200909241937.n8OJb2Bk003736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbZIXThS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     adfs: remove redundant test on unsigned
has been removed from the -mm tree.  Its filename was
     adfs-remove-redundant-test-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adfs: remove redundant test on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

unsigned block cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/adfs/inode.c~adfs-remove-redundant-test-on-unsigned fs/adfs/inode.c
--- a/fs/adfs/inode.c~adfs-remove-redundant-test-on-unsigned
+++ a/fs/adfs/inode.c
@@ -19,9 +19,6 @@ static int
 adfs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh,
 	       int create)
 {
-	if (block < 0)
-		goto abort_negative;
-
 	if (!create) {
 		if (block >= inode->i_blocks)
 			goto abort_toobig;
@@ -34,10 +31,6 @@ adfs_get_block(struct inode *inode, sect
 	/* don't support allocation of blocks yet */
 	return -EIO;
 
-abort_negative:
-	adfs_error(inode->i_sb, "block %d < 0", block);
-	return -EIO;
-
 abort_toobig:
 	return 0;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

