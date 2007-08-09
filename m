From: akpm@linux-foundation.org
Subject: + message-fusion-remove-redundant-memset.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:42:01 -0700
Message-ID: <200708091942.l79Jg1ri016066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbXHITmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, Eric.Moore@lsil.com


The patch titled
     message/fusion: remove redundant memset
has been added to the -mm tree.  Its filename is
     message-fusion-remove-redundant-memset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: message/fusion: remove redundant memset
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

alloc_fcdev() calls alloc_netdev() which uses kzalloc to alloc all the
memory together with dev->priv region hence no zeroing of structs inside
struct mpt_lan_priv needed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptlan.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset drivers/message/fusion/mptlan.c
--- a/drivers/message/fusion/mptlan.c~message-fusion-remove-redundant-memset
+++ a/drivers/message/fusion/mptlan.c
@@ -1351,10 +1351,11 @@ mpt_lan_post_receive_buckets_work(struct
 static struct net_device *
 mpt_register_lan_device (MPT_ADAPTER *mpt_dev, int pnum)
 {
-	struct net_device *dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
-	struct mpt_lan_priv *priv = NULL;
+	struct net_device *dev;
+	struct mpt_lan_priv *priv;
 	u8 HWaddr[FC_ALEN], *a;
 
+	dev = alloc_fcdev(sizeof(struct mpt_lan_priv));
 	if (!dev)
 		return NULL;
 
@@ -1366,7 +1367,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	priv->mpt_dev = mpt_dev;
 	priv->pnum = pnum;
 
-	memset(&priv->post_buckets_task, 0, sizeof(priv->post_buckets_task));
 	INIT_DELAYED_WORK(&priv->post_buckets_task,
 			  mpt_lan_post_receive_buckets_work);
 	priv->post_buckets_active = 0;
@@ -1391,8 +1391,6 @@ mpt_register_lan_device (MPT_ADAPTER *mp
 	spin_lock_init(&priv->txfidx_lock);
 	spin_lock_init(&priv->rxfidx_lock);
 
-	memset(&priv->stats, 0, sizeof(priv->stats));
-
 	/*  Grab pre-fetched LANPage1 stuff. :-) */
 	a = (u8 *) &mpt_dev->lan_cnfg_page1.HardwareAddressLow;
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

emu10k1-remove-redundant-memset.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-media-video-arvc-fix-memset-in-ioctl.patch
drivers-media-video-videodevc-memset-fix.patch
drivers-media-video-zoran_driverc-fix-memset-in-ioctl.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
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
message-fusion-remove-redundant-memset.patch
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
