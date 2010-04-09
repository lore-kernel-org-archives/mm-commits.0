From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-gdthc-fix-buffer-overflow.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:46 -0400
Message-ID: <201004091754.o39HsGlo002181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062Ab0DIRyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/gdth.c: fix buffer overflow
has been removed from the -mm tree.  Its filename was
     drivers-scsi-gdthc-fix-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/gdth.c: fix buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

This allows i == MAXHA, which is out of range

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~drivers-scsi-gdthc-fix-buffer-overflow drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~drivers-scsi-gdthc-fix-buffer-overflow
+++ a/drivers/scsi/gdth.c
@@ -3842,7 +3842,7 @@ int __init option_setup(char *str)
 
     TRACE2(("option_setup() str %s\n", str ? str:"NULL")); 
 
-    while (cur && isdigit(*cur) && i <= MAXHA) {
+    while (cur && isdigit(*cur) && i < MAXHA) {
         ints[i++] = simple_strtoul(cur, NULL, 0);
         if ((cur = strchr(cur, ',')) != NULL) cur++;
     }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
vt6655-cgi-csi-confusion-in-device_ioctl.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

