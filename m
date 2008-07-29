From: akpm@linux-foundation.org
Subject: + misc-replace-__function__-with-__func__.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:47:54 -0700
Message-ID: <200807292347.m6TNlsNX028492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbYG2Xr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     misc: replace __FUNCTION__ with __func__
has been added to the -mm tree.  Its filename is
     misc-replace-__function__-with-__func__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/process.c                 |    2 +-
 arch/x86/kvm/x86.c                         |    2 +-
 drivers/gpu/drm/i915/i915_dma.c            |    4 ++--
 drivers/gpu/drm/i915/i915_irq.c            |    2 +-
 drivers/input/joystick/xpad.c              |    4 ++--
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c           |    2 +-
 drivers/s390/net/ctcm_mpc.c                |    2 +-
 mm/bootmem.c                               |    2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/m32r/kernel/process.c~misc-replace-__function__-with-__func__ arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~misc-replace-__function__-with-__func__
+++ a/arch/m32r/kernel/process.c
@@ -11,7 +11,7 @@
 #undef DEBUG_PROCESS
 #ifdef DEBUG_PROCESS
 #define DPRINTK(fmt, args...)  printk("%s:%d:%s: " fmt, __FILE__, __LINE__, \
-  __FUNCTION__, ##args)
+  __func__, ##args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff -puN arch/x86/kvm/x86.c~misc-replace-__function__-with-__func__ arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~misc-replace-__function__-with-__func__
+++ a/arch/x86/kvm/x86.c
@@ -567,7 +567,7 @@ static void kvm_set_time_scale(uint32_t 
 	hv_clock->tsc_to_system_mul = div_frac(nsecs, tps32);
 
 	pr_debug("%s: tsc_khz %u, tsc_shift %d, tsc_mul %u\n",
-		 __FUNCTION__, tsc_khz, hv_clock->tsc_shift,
+		 __func__, tsc_khz, hv_clock->tsc_shift,
 		 hv_clock->tsc_to_system_mul);
 }
 
diff -puN drivers/gpu/drm/i915/i915_dma.c~misc-replace-__function__-with-__func__ drivers/gpu/drm/i915/i915_dma.c
--- a/drivers/gpu/drm/i915/i915_dma.c~misc-replace-__function__-with-__func__
+++ a/drivers/gpu/drm/i915/i915_dma.c
@@ -517,7 +517,7 @@ static int i915_dispatch_flip(struct drm
 	RING_LOCALS;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+		  __func__,
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);
 
@@ -642,7 +642,7 @@ static int i915_cmdbuffer(struct drm_dev
 static int i915_flip_bufs(struct drm_device *dev, void *data,
 			  struct drm_file *file_priv)
 {
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
diff -puN drivers/gpu/drm/i915/i915_irq.c~misc-replace-__function__-with-__func__ drivers/gpu/drm/i915/i915_irq.c
--- a/drivers/gpu/drm/i915/i915_irq.c~misc-replace-__function__-with-__func__
+++ a/drivers/gpu/drm/i915/i915_irq.c
@@ -243,7 +243,7 @@ irqreturn_t i915_driver_irq_handler(DRM_
 
 	temp &= (USER_INT_FLAG | VSYNC_PIPEA_FLAG | VSYNC_PIPEB_FLAG);
 
-	DRM_DEBUG("%s flag=%08x\n", __FUNCTION__, temp);
+	DRM_DEBUG("%s flag=%08x\n", __func__, temp);
 
 	if (temp == 0)
 		return IRQ_NONE;
diff -puN drivers/input/joystick/xpad.c~misc-replace-__function__-with-__func__ drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~misc-replace-__function__-with-__func__
+++ a/drivers/input/joystick/xpad.c
@@ -454,10 +454,10 @@ static void xpad_bulk_out(struct urb *ur
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		break;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 	}
 }
 
diff -puN drivers/media/video/cx23885/cx23885-core.c~misc-replace-__function__-with-__func__ drivers/media/video/cx23885/cx23885-core.c
--- a/drivers/media/video/cx23885/cx23885-core.c~misc-replace-__function__-with-__func__
+++ a/drivers/media/video/cx23885/cx23885-core.c
@@ -1442,7 +1442,7 @@ void cx23885_cancel_buffers(struct cx238
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_dmaqueue *q = &port->mpegq;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	del_timer_sync(&q->timeout);
 	cx23885_stop_dma(port);
 	do_cancel_buffers(port, "cancel", 0);
diff -puN drivers/pci/hotplug/pciehp_hpc.c~misc-replace-__function__-with-__func__ drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~misc-replace-__function__-with-__func__
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -765,7 +765,7 @@ static irqreturn_t pcie_isr(int irq, voi
 		}
 	} while (detected);
 
-	dbg("%s: intr_loc %x\n", __FUNCTION__, intr_loc);
+	dbg("%s: intr_loc %x\n", __func__, intr_loc);
 
 	/* Check Command Complete Interrupt Pending */
 	if (intr_loc & CMD_COMPLETED) {
diff -puN drivers/s390/net/ctcm_mpc.c~misc-replace-__function__-with-__func__ drivers/s390/net/ctcm_mpc.c
--- a/drivers/s390/net/ctcm_mpc.c~misc-replace-__function__-with-__func__
+++ a/drivers/s390/net/ctcm_mpc.c
@@ -1674,7 +1674,7 @@ static int mpc_validate_xid(struct mpcg_
 
 done:
 	if (rc) {
-		ctcm_pr_info("ctcmpc	   :  %s() failed\n", __FUNCTION__);
+		ctcm_pr_info("ctcmpc	   :  %s() failed\n", __func__);
 		priv->xid->xid2_flag2 = 0x40;
 		grp->saved_xid2->xid2_flag2 = 0x40;
 	}
diff -puN mm/bootmem.c~misc-replace-__function__-with-__func__ mm/bootmem.c
--- a/mm/bootmem.c~misc-replace-__function__-with-__func__
+++ a/mm/bootmem.c
@@ -48,7 +48,7 @@ early_param("bootmem_debug", bootmem_deb
 	if (unlikely(bootmem_debug))			\
 		printk(KERN_INFO			\
 			"bootmem::%s " fmt,		\
-			__FUNCTION__, ## args);		\
+			__func__, ## args);		\
 })
 
 static unsigned long __init bootmap_bytes(unsigned long pages)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

omfs-sparse-annotations.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
irda-replace-__function__-with-__func__.patch
isdn-use-the-common-ascii-hex-helpers.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

