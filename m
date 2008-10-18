From: akpm@linux-foundation.org
Subject: - misc-replace-__function__-with-__func__.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:06 -0700
Message-ID: <200810182311.m9INB6rn027676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYJRXLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     misc: replace __FUNCTION__ with __func__
has been removed from the -mm tree.  Its filename was
     misc-replace-__function__-with-__func__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/process.c      |    2 +-
 arch/x86/kvm/x86.c              |    2 +-
 drivers/gpu/drm/i915/i915_dma.c |    4 ++--
 drivers/input/joystick/xpad.c   |    4 ++--
 drivers/s390/net/ctcm_mpc.c     |    2 +-
 mm/bootmem.c                    |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

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
@@ -564,7 +564,7 @@ static void kvm_set_time_scale(uint32_t 
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
 
diff -puN drivers/input/joystick/xpad.c~misc-replace-__function__-with-__func__ drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~misc-replace-__function__-with-__func__
+++ a/drivers/input/joystick/xpad.c
@@ -455,10 +455,10 @@ static void xpad_bulk_out(struct urb *ur
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
 
diff -puN drivers/s390/net/ctcm_mpc.c~misc-replace-__function__-with-__func__ drivers/s390/net/ctcm_mpc.c
--- a/drivers/s390/net/ctcm_mpc.c~misc-replace-__function__-with-__func__
+++ a/drivers/s390/net/ctcm_mpc.c
@@ -1673,7 +1673,7 @@ static int mpc_validate_xid(struct mpcg_
 
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

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

