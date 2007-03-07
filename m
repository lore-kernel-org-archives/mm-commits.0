From: akpm@linux-foundation.org
Subject: + b44-warning-fixes.patch added to -mm tree
Date: Wed, 07 Mar 2007 01:21:17 -0800
Message-ID: <200703070922.l279MwKK025138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651AbXCGJXg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 04:23:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, linville@tuxdriver.com


The patch titled
     b44 warning fixes
has been added to the -mm tree.  Its filename is
     b44-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: b44 warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/b44.c: In function 'b44_tx':
drivers/net/b44.c:622: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type
drivers/net/b44.c: In function 'b44_alloc_rx_skb':
drivers/net/b44.c:669: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type
drivers/net/b44.c: In function 'b44_start_xmit':
drivers/net/b44.c:991: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type
drivers/net/b44.c:1003: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type
drivers/net/b44.c: In function 'b44_free_rings':
drivers/net/b44.c:1104: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type
drivers/net/b44.c:1118: warning: passing argument 1 of 'dma_unmap_single' from incompatible pointer type

That's going to crash hard if anyone uses that first arg.

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/net/b44.c~b44-warning-fixes drivers/net/b44.c
--- a/drivers/net/b44.c~b44-warning-fixes
+++ a/drivers/net/b44.c
@@ -616,7 +616,7 @@ static void b44_tx(struct b44 *bp)
 
 		BUG_ON(skb == NULL);
 
-		dma_unmap_single(&bp->sdev->dev,
+		dma_unmap_single(bp->sdev->dev,
 				 rp->mapping,
 				 skb->len,
 				 DMA_TO_DEVICE);
@@ -666,7 +666,8 @@ static int b44_alloc_rx_skb(struct b44 *
 		mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
 		/* Sigh... */
 		if (!dma_mapping_error(mapping))
-			dma_unmap_single(&bp->sdev->dev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
+			dma_unmap_single(bp->sdev->dev, mapping,
+					RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		skb = __dev_alloc_skb(RX_PKT_BUF_SZ,GFP_DMA);
 		if (skb == NULL)
@@ -988,7 +989,8 @@ static int b44_start_xmit(struct sk_buff
 	if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
 		if (!dma_mapping_error(mapping))
-			dma_unmap_single(&bp->sdev->dev, mapping, len, DMA_TO_DEVICE);
+			dma_unmap_single(bp->sdev->dev, mapping, len,
+					DMA_TO_DEVICE);
 
 		bounce_skb = __dev_alloc_skb(TX_PKT_BUF_SZ,
 					     GFP_ATOMIC|GFP_DMA);
@@ -999,7 +1001,7 @@ static int b44_start_xmit(struct sk_buff
 					 len, DMA_TO_DEVICE);
 		if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
 			if (!dma_mapping_error(mapping))
-				dma_unmap_single(&bp->sdev->dev, mapping,
+				dma_unmap_single(bp->sdev->dev, mapping,
 					 len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(bounce_skb);
 			goto err_out;
@@ -1098,10 +1100,8 @@ static void b44_free_rings(struct b44 *b
 
 		if (rp->skb == NULL)
 			continue;
-		dma_unmap_single(&bp->sdev->dev,
-				 rp->mapping,
-				 RX_PKT_BUF_SZ,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(bp->sdev->dev, rp->mapping, RX_PKT_BUF_SZ,
+					DMA_FROM_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
@@ -1112,10 +1112,8 @@ static void b44_free_rings(struct b44 *b
 
 		if (rp->skb == NULL)
 			continue;
-		dma_unmap_single(&bp->sdev->dev,
-				 rp->mapping,
-				 rp->skb->len,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(bp->sdev->dev, rp->mapping, rp->skb->len,
+					DMA_TO_DEVICE);
 		dev_kfree_skb_any(rp->skb);
 		rp->skb = NULL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
b44-warning-fixes.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-fix.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
