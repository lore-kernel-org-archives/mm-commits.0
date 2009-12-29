From: akpm@linux-foundation.org
Subject: [merged] drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:16 -0800
Message-ID: <200912292133.nBTLXGXU008697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbZL2Vdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, drbd-dev@lists.linbit.com, jens.axboe@oracle.com, philipp.reisner@linbit.com, mm-commits@vger.kernel.org


The patch titled
     drbd: fix test of unsigned in _drbd_fault_random()
has been removed from the -mm tree.  Its filename was
     drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drbd: fix test of unsigned in _drbd_fault_random()
From: Roel Kluin <roel.kluin@gmail.com>

rsp->count is unsigned so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/drbd/drbd_main.c~drbd-fix-test-of-unsigned-in-_drbd_fault_random drivers/block/drbd/drbd_main.c
--- a/drivers/block/drbd/drbd_main.c~drbd-fix-test-of-unsigned-in-_drbd_fault_random
+++ a/drivers/block/drbd/drbd_main.c
@@ -3623,7 +3623,7 @@ _drbd_fault_random(struct fault_random_s
 {
 	long refresh;
 
-	if (--rsp->count < 0) {
+	if (!rsp->count--) {
 		get_random_bytes(&refresh, sizeof(refresh));
 		rsp->state += refresh;
 		rsp->count = FAULT_RANDOM_REFRESH;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

