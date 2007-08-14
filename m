From: akpm@linux-foundation.org
Subject: - drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:52 -0700
Message-ID: <200708141912.l7EJCqFs016442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932486AbXHNTUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wan/hdlc_fr.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/net/wan/hdlc_fr.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/wan/hdlc_fr.c | 31260 -> 31223 (-37 bytes)
 drivers/net/wan/hdlc_fr.o | 144872 -> 144728 (-144 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_fr.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/wan/hdlc_fr.c~drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc drivers/net/wan/hdlc_fr.c
--- a/drivers/net/wan/hdlc_fr.c~drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/net/wan/hdlc_fr.c
@@ -212,14 +212,13 @@ static pvc_device* add_pvc(struct net_de
 		pvc_p = &(*pvc_p)->next;
 	}
 
-	pvc = kmalloc(sizeof(pvc_device), GFP_ATOMIC);
+	pvc = kzalloc(sizeof(pvc_device), GFP_ATOMIC);
 #ifdef DEBUG_PVC
 	printk(KERN_DEBUG "add_pvc: allocated pvc %p, frad %p\n", pvc, dev);
 #endif
 	if (!pvc)
 		return NULL;
 
-	memset(pvc, 0, sizeof(pvc_device));
 	pvc->dlci = dlci;
 	pvc->frad = dev;
 	pvc->next = *pvc_p;	/* Put it in the chain */
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
