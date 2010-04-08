From: akpm@linux-foundation.org
Subject: [obsolete] powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:12:17 -0400
Message-ID: <201004081813.o38IDj6F032291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045Ab0DHSNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, gorcunov@gmail.com, waite@skycomputers.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: Sky CPU: redundant or incorrect tests on unsigned
has been removed from the -mm tree.  Its filename was
     powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: Sky CPU: redundant or incorrect tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

count is unsigned and cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -121,8 +121,6 @@ static ssize_t cpustate_read(struct file
 {
 	unsigned char data;
 
-	if (count < 0)
-		return -EFAULT;
 	if (count == 0)
 		return 0;
 
@@ -137,9 +135,6 @@ static ssize_t cpustate_write(struct fil
 {
 	unsigned char data;
 
-	if (count < 0)
-		return -EFAULT;
-
 	if (count == 0)
 		return 0;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
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
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
vt6655-cgi-csi-confusion-in-device_ioctl.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

