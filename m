From: akpm@linux-foundation.org
Subject: + drivers-char-ip2-fix-used-uninitd-bug.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:53:00 -0700
Message-ID: <200710152253.l9FMr099029424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606AbXJOWxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com


The patch titled
     drivers/char/ip2: fix used-uninit'd bug
has been added to the -mm tree.  Its filename is
     drivers-char-ip2-fix-used-uninitd-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/ip2: fix used-uninit'd bug
From: Jeff Garzik <jeff@garzik.org>

Fix bug flagged by a variable-used-uninitialized warning.

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
+					printk( KERN_ERR "IP2: PCI board %d not found\n", i );
 				} 
 			}
 #else
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-jg-misc.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kbuild.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
tokenring-3c359c-fixed-array-index-problem.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
unify-dma_bit_mask-definitions-v31.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
s2io-rename-bit-macro.patch
define-global-bit-macro.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
drivers-block-cpqarraycciss-kill-unused-var.patch
drivers-char-ip2-fix-used-uninitd-bug.patch
