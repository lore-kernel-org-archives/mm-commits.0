From: akpm@linux-foundation.org
Subject: + v4l-dvb-wrong-variable-tested.patch added to -mm tree
Date: Thu, 07 Jan 2010 15:08:04 -0800
Message-ID: <201001072308.o07N840X023002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856Ab0AGXIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 18:08:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org, stoth@kernellabs.com


The patch titled
     v4l/dvb: wrong variable tested
has been added to the -mm tree.  Its filename is
     v4l-dvb-wrong-variable-tested.patch

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
Subject: v4l/dvb: wrong variable tested
From: Roel Kluin <roel.kluin@gmail.com>

The return of saa7164_i2caddr_to_reglen() was not tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7164/saa7164-api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/saa7164/saa7164-api.c~v4l-dvb-wrong-variable-tested drivers/media/video/saa7164/saa7164-api.c
--- a/drivers/media/video/saa7164/saa7164-api.c~v4l-dvb-wrong-variable-tested
+++ a/drivers/media/video/saa7164/saa7164-api.c
@@ -523,7 +523,7 @@ int saa7164_api_i2c_write(struct saa7164
 	}
 
 	reglen = saa7164_i2caddr_to_reglen(bus, addr);
-	if (unitid < 0) {
+	if (reglen < 0) {
 		printk(KERN_ERR
 			"%s() error, cannot translate regaddr to reglen\n",
 			__func__);
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

