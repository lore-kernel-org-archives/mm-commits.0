From: akpm@linux-foundation.org
Subject: [merged] rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu.patch removed from -mm tree
Date: Wed, 06 Jan 2010 13:33:52 -0800
Message-ID: <201001062133.o06LXq3S019149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932873Ab0AFVeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 16:34:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rt2860: test off by one in RtmpAsicSendCommandToMcu()
has been removed from the -mm tree.  Its filename was
     rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rt2860: test off by one in RtmpAsicSendCommandToMcu()
From: Roel Kluin <roel.kluin@gmail.com>

`i' reaches 101 after the loop, so if it was 100 then it succeeded in
the last iteration. This is probably unlikely to cause problems.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2860/common/rtmp_mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rt2860/common/rtmp_mcu.c~rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu drivers/staging/rt2860/common/rtmp_mcu.c
--- a/drivers/staging/rt2860/common/rtmp_mcu.c~rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu
+++ a/drivers/staging/rt2860/common/rtmp_mcu.c
@@ -221,7 +221,7 @@ int RtmpAsicSendCommandToMcu(struct rt_r
 				 ("AsicSendCommanToMcu::Mail box is busy\n"));
 		} while (i++ < 100);
 
-		if (i >= 100) {
+		if (i > 100) {
 			DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
 			return FALSE;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
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
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

