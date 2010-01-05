From: akpm@linux-foundation.org
Subject: + w1-fix-test-in-ds2482_wait_1wire_idle.patch added to -mm tree
Date: Mon, 04 Jan 2010 16:33:19 -0800
Message-ID: <201001050033.o050XJq5027850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751Ab0AEAd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 19:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     w1: fix test in ds2482_wait_1wire_idle()
has been added to the -mm tree.  Its filename is
     w1-fix-test-in-ds2482_wait_1wire_idle.patch

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
zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
omap3-add-missing-parentheses.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
i2c-fix-off-by-one-in-piix4vt596_transaction.patch
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
ieee80211-add-missing-parentheses.patch
rt2860-test-off-by-one-in-rtmpasicsendcommandtomcu.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

