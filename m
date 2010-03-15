From: akpm@linux-foundation.org
Subject: [merged] paride-fix-off-by-one-test.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:37 -0400
Message-ID: <201003150706.o2F76AKh017213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935985Ab0COHGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     paride: fix off-by-one test
has been removed from the -mm tree.  Its filename was
     paride-fix-off-by-one-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: paride: fix off-by-one test
From: Roel Kluin <roel.kluin@gmail.com>

With `while (j++ < PX_SPIN)' j reaches PX_SPIN + 1 after the loop.  This
is probably unlikely to produce a problem.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pcd.c |    4 ++--
 drivers/block/paride/pf.c  |    4 ++--
 drivers/block/paride/pt.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/block/paride/pcd.c~paride-fix-off-by-one-test drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c~paride-fix-off-by-one-test
+++ a/drivers/block/paride/pcd.c
@@ -341,11 +341,11 @@ static int pcd_wait(struct pcd_unit *cd,
 	       && (j++ < PCD_SPIN))
 		udelay(PCD_DELAY);
 
-	if ((r & (IDE_ERR & stop)) || (j >= PCD_SPIN)) {
+	if ((r & (IDE_ERR & stop)) || (j > PCD_SPIN)) {
 		s = read_reg(cd, 7);
 		e = read_reg(cd, 1);
 		p = read_reg(cd, 2);
-		if (j >= PCD_SPIN)
+		if (j > PCD_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
diff -puN drivers/block/paride/pf.c~paride-fix-off-by-one-test drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~paride-fix-off-by-one-test
+++ a/drivers/block/paride/pf.c
@@ -391,11 +391,11 @@ static int pf_wait(struct pf_unit *pf, i
 	       && (j++ < PF_SPIN))
 		udelay(PF_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PF_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PF_SPIN)) {
 		s = read_reg(pf, 7);
 		e = read_reg(pf, 1);
 		p = read_reg(pf, 2);
-		if (j >= PF_SPIN)
+		if (j > PF_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
diff -puN drivers/block/paride/pt.c~paride-fix-off-by-one-test drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~paride-fix-off-by-one-test
+++ a/drivers/block/paride/pt.c
@@ -274,11 +274,11 @@ static int pt_wait(struct pt_unit *tape,
 	       && (j++ < PT_SPIN))
 		udelay(PT_SPIN_DEL);
 
-	if ((r & (STAT_ERR & stop)) || (j >= PT_SPIN)) {
+	if ((r & (STAT_ERR & stop)) || (j > PT_SPIN)) {
 		s = read_reg(pi, 7);
 		e = read_reg(pi, 1);
 		p = read_reg(pi, 2);
-		if (j >= PT_SPIN)
+		if (j > PT_SPIN)
 			e |= 0x100;
 		if (fun)
 			printk("%s: %s %s: alt=0x%x stat=0x%x err=0x%x"
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
isdn-misplaced-parenthesis-in-pof_handle_data.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

