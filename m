From: akpm@linux-foundation.org
Subject: + cio-double-put_device-in-subchannel_register.patch added to -mm tree
Date: Mon, 24 Aug 2009 15:26:50 -0700
Message-ID: <200908242226.n7OMQoX9009913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbZHXW05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 18:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, cornelia.huck@de.ibm.com, schwidefsky@de.ibm.com, sebott@linux.vnet.ibm.com


The patch titled
     cio: double put_device() in subchannel_register()
has been added to the -mm tree.  Its filename is
     cio-double-put_device-in-subchannel_register.patch

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
Subject: cio: double put_device() in subchannel_register()
From: Roel Kluin <roel.kluin@gmail.com>

If the device can't be registered, put_device(&cdev->dev) occured here
and after out_err:.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/device.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/s390/cio/device.c~cio-double-put_device-in-subchannel_register drivers/s390/cio/device.c
--- a/drivers/s390/cio/device.c~cio-double-put_device-in-subchannel_register
+++ a/drivers/s390/cio/device.c
@@ -1027,8 +1027,6 @@ io_subchannel_register(struct work_struc
 		spin_lock_irqsave(sch->lock, flags);
 		sch_set_cdev(sch, NULL);
 		spin_unlock_irqrestore(sch->lock, flags);
-		/* Release initial device reference. */
-		put_device(&cdev->dev);
 		goto out_err;
 	}
 out:
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
nl80211-jump-to-out_err-upon-unsupported-iftype.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
kref-documentation-double-kref_put-in-my_data_handler.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
cio-double-put_device-in-subchannel_register.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch

