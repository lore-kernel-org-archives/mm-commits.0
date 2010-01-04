From: akpm@linux-foundation.org
Subject: + dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch added to -mm tree
Date: Mon, 04 Jan 2010 14:49:54 -0800
Message-ID: <201001042249.o04Mnsv2023031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab0ADWua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 17:50:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, oliver@neukum.name


The patch titled
     dc395x: decrease iteration for tag_number of max_command in start_scsi()
has been added to the -mm tree.  Its filename is
     dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dc395x: decrease iteration for tag_number of max_command in start_scsi()
From: Roel Kluin <roel.kluin@gmail.com>

The tag_number reaches dcb->max_command + 1 after the loop, but when
the tag_number equals dcb->max_command an error message is already
issued. The last iteration therefore appears obsolete.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dc395x.c~dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi
+++ a/drivers/scsi/dc395x.c
@@ -1596,7 +1596,7 @@ static u8 start_scsi(struct AdapterCtlBl
 		u32 tag_mask = 1;
 		u8 tag_number = 0;
 		while (tag_mask & dcb->tag_mask
-		       && tag_number <= dcb->max_command) {
+		       && tag_number < dcb->max_command) {
 			tag_mask = tag_mask << 1;
 			tag_number++;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
omap3-add-missing-parentheses.patch
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
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
ieee80211-add-missing-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

