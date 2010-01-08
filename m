From: akpm@linux-foundation.org
Subject: [withdrawn] bluetooth-wrong-variable-tested.patch removed from -mm tree
Date: Fri, 08 Jan 2010 13:33:47 -0800
Message-ID: <201001082133.o08LXlvx015321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944Ab0AHVd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 16:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: wrong variable tested
has been removed from the -mm tree.  Its filename was
     bluetooth-wrong-variable-tested.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: wrong variable tested
From: Roel Kluin <roel.kluin@gmail.com>

The return of the function sdio_readb() was not tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btmrvl_sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/bluetooth/btmrvl_sdio.c~bluetooth-wrong-variable-tested drivers/bluetooth/btmrvl_sdio.c
--- a/drivers/bluetooth/btmrvl_sdio.c~bluetooth-wrong-variable-tested
+++ a/drivers/bluetooth/btmrvl_sdio.c
@@ -348,7 +348,7 @@ static int btmrvl_sdio_download_fw_w_hel
 		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
 			base0 = sdio_readb(card->func,
 					SQ_READ_BASE_ADDRESS_A0_REG, &ret);
-			if (ret) {
+			if (base0) {
 				BT_ERR("BASE0 register read failed:"
 					" base0 = 0x%04X(%d)."
 					" Terminating download",
@@ -358,7 +358,7 @@ static int btmrvl_sdio_download_fw_w_hel
 			}
 			base1 = sdio_readb(card->func,
 					SQ_READ_BASE_ADDRESS_A1_REG, &ret);
-			if (ret) {
+			if (base1) {
 				BT_ERR("BASE1 register read failed:"
 					" base1 = 0x%04X(%d)."
 					" Terminating download",
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
v4l-dvb-wrong-variable-tested.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
bluetooth-wrong-variable-tested.patch
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
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

