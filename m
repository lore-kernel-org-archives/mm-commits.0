From: akpm@linux-foundation.org
Subject: - drivers-char-ip2-fix-used-uninitd-bug.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:07 -0700
Message-ID: <200710180702.l9I727Rg031239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762792AbXJRHRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ip2: fix used-uninit'd bug
has been removed from the -mm tree.  Its filename was
     drivers-char-ip2-fix-used-uninitd-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/ip2: fix used-uninit'd bug
From: Jeff Garzik <jeff@garzik.org>

Fix bug flagged by a variable-used-uninitialized warning.

[akpm@linux-foundation.org: coding-style]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~drivers-char-ip2-fix-used-uninitd-bug drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~drivers-char-ip2-fix-used-uninitd-bug
+++ a/drivers/char/ip2/ip2main.c
@@ -619,11 +619,7 @@ ip2_loadmain(int *iop, int *irqp, unsign
 					ip2config.irq[i] = pci_dev_i->irq;
 				} else {	// ann error
 					ip2config.addr[i] = 0;
-					if (status == PCIBIOS_DEVICE_NOT_FOUND) {
-						printk( KERN_ERR "IP2: PCI board %d not found\n", i );
-					} else {
-						printk( KERN_ERR "IP2: PCI error 0x%x \n", status );
-					}
+					printk(KERN_ERR "IP2: PCI board %d not found\n", i);
 				} 
 			}
 #else
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
pata_cs5536-mwdma-fix.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
unify-dma_bit_mask-definitions-v31.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
s2io-rename-bit-macro.patch
define-global-bit-macro.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
