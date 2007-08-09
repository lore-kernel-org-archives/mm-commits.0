From: akpm@linux-foundation.org
Subject: + net-tulip-xircom_cbc-remove-superfulous-priv-assignment.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:53:34 -0700
Message-ID: <200708091953.l79JrYRe016553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbXHITxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, arjan@linux.intel.com


The patch titled
     net/tulip/xircom_cb.c: remove superfulous priv assignment
has been added to the -mm tree.  Its filename is
     net-tulip-xircom_cbc-remove-superfulous-priv-assignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/tulip/xircom_cb.c: remove superfulous priv assignment
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

It does

dev = alloc_etherdev(...
private = netdev_priv(dev);
...
dev->priv = private;

which doesn't make much sense (does it?) because this is done in
alloc_netdev() already.

struct net_device *alloc_netdev(...
{
...
	if (sizeof_priv)
		dev->priv = netdev_priv(dev);

This patch removes superfluous code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/xircom_cb.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/net/tulip/xircom_cb.c~net-tulip-xircom_cbc-remove-superfulous-priv-assignment drivers/net/tulip/xircom_cb.c
--- a/drivers/net/tulip/xircom_cb.c~net-tulip-xircom_cbc-remove-superfulous-priv-assignment
+++ a/drivers/net/tulip/xircom_cb.c
@@ -271,7 +271,6 @@ static int __devinit xircom_probe(struct
 	dev->hard_start_xmit = &xircom_start_xmit;
 	dev->stop = &xircom_close;
 	dev->get_stats = &xircom_get_stats;
-	dev->priv = private;
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = &xircom_poll_controller;
 #endif
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
drivers-net-remove-superfluous-memset.patch
net-tulip-xircom_cbc-remove-superfulous-priv-assignment.patch
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
