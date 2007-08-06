From: akpm@linux-foundation.org
Subject: - drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:07 -0700
Message-ID: <200708060753.l767r7BL016310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758732AbXHFHzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/msp3400-driver.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/video/msp3400-driver.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/media/video/msp3400-driver.c | 28945 -> 28898 (-47 bytes)
 drivers/media/video/msp3400-driver.o | 125620 -> 125320 (-300 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/msp3400-driver.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/msp3400-driver.c~drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc drivers/media/video/msp3400-driver.c
--- a/drivers/media/video/msp3400-driver.c~drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/media/video/msp3400-driver.c
@@ -813,8 +813,9 @@ static int msp_attach(struct i2c_adapter
 	int msp_rom;
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (client == NULL)
+	if (!client)
 		return -ENOMEM;
+
 	client->addr = address;
 	client->adapter = adapter;
 	client->driver = &i2c_driver;
@@ -826,14 +827,14 @@ static int msp_attach(struct i2c_adapter
 		return 0;
 	}
 
-	state = kmalloc(sizeof(*state), GFP_KERNEL);
-	if (state == NULL) {
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state) {
 		kfree(client);
 		return -ENOMEM;
 	}
+
 	i2c_set_clientdata(client, state);
 
-	memset(state, 0, sizeof(*state));
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
 	state->volume = 58880;	/* 0db gain */
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
usb-remove-redundant-memset-from-amd5536udc.patch
drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
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
