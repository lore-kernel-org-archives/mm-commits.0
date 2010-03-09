From: akpm@linux-foundation.org
Subject: [merged] cryptocop-fix-assertion-in-create_output_descriptors.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:15 -0800
Message-ID: <201003091905.o29J5Fnb031112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0CITGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cryptocop: fix assertion in create_output_descriptors()
has been removed from the -mm tree.  Its filename was
     cryptocop-fix-assertion-in-create_output_descriptors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cryptocop: fix assertion in create_output_descriptors()
From: Roel Kluin <roel.kluin@gmail.com>

size_t desc_len cannot be less than 0, test before the subtraction.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/cryptocop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/drivers/cryptocop.c~cryptocop-fix-assertion-in-create_output_descriptors arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~cryptocop-fix-assertion-in-create_output_descriptors
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -628,9 +628,9 @@ static int create_output_descriptors(str
 		cdesc->dma_descr->buf = (char*)virt_to_phys(operation->tfrm_op.indata[*iniov_ix].iov_base + *iniov_offset);
 		cdesc->dma_descr->after = cdesc->dma_descr->buf + dlength;
 
+		assert(desc_len >= dlength);
 		desc_len -= dlength;
 		*iniov_offset += dlength;
-		assert(desc_len >= 0);
 		if (*iniov_offset >= operation->tfrm_op.indata[*iniov_ix].iov_len) {
 			*iniov_offset = 0;
 			++(*iniov_ix);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

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
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

