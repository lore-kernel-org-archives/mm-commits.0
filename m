From: akpm@linux-foundation.org
Subject: [merged] asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:47 -0400
Message-ID: <201003150656.o2F6uK8Z016276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab0COG4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dilinger@debian.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     asiliantfb: fix test of unsigned in asiliant_calc_dclk2()
has been removed from the -mm tree.  Its filename was
     asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asiliantfb: fix test of unsigned in asiliant_calc_dclk2()
From: Roel Kluin <roel.kluin@gmail.com>

Ftarget, Fret, n and m are unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/asiliantfb.c~asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2 drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2
+++ a/drivers/video/asiliantfb.c
@@ -140,7 +140,7 @@ static void asiliant_calc_dclk2(u32 *ppi
 
 		/* 3 <= m <= 257 */
 		if (m >= 3 && m <= 257) {
-			unsigned new_error = ((Ftarget * n) - (Fref * m)) >= 0 ?
+			unsigned new_error = Ftarget * n >= Fref * m ?
 					       ((Ftarget * n) - (Fref * m)) : ((Fref * m) - (Ftarget * n));
 			if (new_error < best_error) {
 				best_n = n;
@@ -152,7 +152,7 @@ static void asiliant_calc_dclk2(u32 *ppi
 		else if (m <= 1028) {
 			/* remember there are still only 8-bits of precision in m, so
 			 * avoid over-optimistic error calculations */
-			unsigned new_error = ((Ftarget * n) - (Fref * (m & ~3))) >= 0 ?
+			unsigned new_error = Ftarget * n >= Fref * (m & ~3) ?
 					       ((Ftarget * n) - (Fref * (m & ~3))) : ((Fref * (m & ~3)) - (Ftarget * n));
 			if (new_error < best_error) {
 				best_n = n;
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

