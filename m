From: akpm@linux-foundation.org
Subject: - emu10k1-remove-redundant-memset.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:02 -0700
Message-ID: <200708141912.l7EJC2Se016351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910AbXHNTMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     emu10k1: remove redundant memset
has been removed from the -mm tree.  Its filename was
     emu10k1-remove-redundant-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: emu10k1: remove redundant memset
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch removes memset() from snd_emu10k1_fx8010_info() which apparently
isn't needed there.  Upatched code uses:

memset(info, 0, sizeof(info));

where 'info' is a pointer and therefore only first 4 bytes of 'info' gets
cleared on a 32bit machine.  Anyway looking at the code zeoring this memory
region isn't needed at all because the snd_emu10k1_fx8010_info() function
initializes all the 'info' fields on its own.  So that's why this code works
at all in its original form.

This patch removes this redundant code.  Also snd_emu10k1_fx8010_info() can't
fail so lets save some bytes and change its return type to void.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/emu10k1/emufx.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff -puN sound/pci/emu10k1/emufx.c~emu10k1-remove-redundant-memset sound/pci/emu10k1/emufx.c
--- a/sound/pci/emu10k1/emufx.c~emu10k1-remove-redundant-memset
+++ a/sound/pci/emu10k1/emufx.c
@@ -2440,14 +2440,13 @@ static void copy_string(char *dst, char 
 		strcpy(dst, src);
 }
 
-static int snd_emu10k1_fx8010_info(struct snd_emu10k1 *emu,
+static void snd_emu10k1_fx8010_info(struct snd_emu10k1 *emu,
 				   struct snd_emu10k1_fx8010_info *info)
 {
 	char **fxbus, **extin, **extout;
 	unsigned short fxbus_mask, extin_mask, extout_mask;
 	int res;
 
-	memset(info, 0, sizeof(info));
 	info->internal_tram_size = emu->fx8010.itram_size;
 	info->external_tram_size = emu->fx8010.etram_pages.bytes / 2;
 	fxbus = fxbuses;
@@ -2464,7 +2463,6 @@ static int snd_emu10k1_fx8010_info(struc
 	for (res = 16; res < 32; res++, extout++)
 		copy_string(info->extout_names[res], extout_mask & (1 << res) ? *extout : NULL, "Unused", res);
 	info->gpr_controls = emu->fx8010.gpr_count;
-	return 0;
 }
 
 static int snd_emu10k1_fx8010_ioctl(struct snd_hwdep * hw, struct file *file, unsigned int cmd, unsigned long arg)
@@ -2485,10 +2483,7 @@ static int snd_emu10k1_fx8010_ioctl(stru
 		info = kmalloc(sizeof(*info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
-		if ((res = snd_emu10k1_fx8010_info(emu, info)) < 0) {
-			kfree(info);
-			return res;
-		}
+		snd_emu10k1_fx8010_info(emu, info);
 		if (copy_to_user(argp, info, sizeof(*info))) {
 			kfree(info);
 			return -EFAULT;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
