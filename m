From: akpm@linux-foundation.org
Subject: [merged] w1-fix-test-in-ds2482_wait_1wire_idle.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:34 -0400
Message-ID: <201003150705.o2F7579a017060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759694Ab0COHFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: fix test in ds2482_wait_1wire_idle()
has been removed from the -mm tree.  Its filename was
     w1-fix-test-in-ds2482_wait_1wire_idle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: fix test in ds2482_wait_1wire_idle()
From: Roel Kluin <roel.kluin@gmail.com>

With `while (++retries < DS2482_WAIT_IDLE_TIMEOUT)' retries reaches
DS2482_WAIT_IDLE_TIMEOUT after the loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2482.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds2482.c~w1-fix-test-in-ds2482_wait_1wire_idle drivers/w1/masters/ds2482.c
--- a/drivers/w1/masters/ds2482.c~w1-fix-test-in-ds2482_wait_1wire_idle
+++ a/drivers/w1/masters/ds2482.c
@@ -214,7 +214,7 @@ static int ds2482_wait_1wire_idle(struct
 			 (++retries < DS2482_WAIT_IDLE_TIMEOUT));
 	}
 
-	if (retries > DS2482_WAIT_IDLE_TIMEOUT)
+	if (retries >= DS2482_WAIT_IDLE_TIMEOUT)
 		printk(KERN_ERR "%s: timeout on channel %d\n",
 		       __func__, pdev->channel);
 
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

