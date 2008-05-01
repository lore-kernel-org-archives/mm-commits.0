From: akpm@linux-foundation.org
Subject: - drivers-char-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:17 -0700
Message-ID: <200805010933.m419XHDq031128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbYEAJdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     drivers-char-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h          |    2 -
 drivers/char/cyclades.c         |    4 +-
 drivers/char/drm/drmP.h         |    8 ++--
 drivers/char/drm/drm_sysfs.c    |    2 -
 drivers/char/drm/i830_dma.c     |   18 +++++-----
 drivers/char/drm/i830_drv.h     |    2 -
 drivers/char/drm/i830_irq.c     |    8 ++--
 drivers/char/drm/i915_dma.c     |    4 +-
 drivers/char/drm/i915_drv.h     |    2 -
 drivers/char/drm/radeon_cp.c    |    2 -
 drivers/char/esp.c              |    4 +-
 drivers/char/generic_serial.c   |    4 +-
 drivers/char/hpet.c             |   10 ++---
 drivers/char/hvsi.c             |   52 +++++++++++++++---------------
 drivers/char/nozomi.c           |    2 -
 drivers/char/pcmcia/cm4000_cs.c |    2 -
 drivers/char/pcmcia/cm4040_cs.c |    2 -
 drivers/char/rio/rio_linux.h    |    6 +--
 drivers/char/riscom8.c          |    4 +-
 drivers/char/snsc.c             |   18 +++++-----
 drivers/char/snsc_event.c       |    6 +--
 drivers/char/sonypi.c           |    2 -
 drivers/char/specialix.c        |   10 ++---
 drivers/char/sx.c               |    8 ++--
 24 files changed, 91 insertions(+), 91 deletions(-)

diff -puN drivers/char/agp/agp.h~drivers-char-replace-remaining-__function__-occurrences drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/agp/agp.h
@@ -35,7 +35,7 @@
 
 //#define AGP_DEBUG 1
 #ifdef AGP_DEBUG
-#define DBG(x,y...) printk (KERN_DEBUG PFX "%s: " x "\n", __FUNCTION__ , ## y)
+#define DBG(x,y...) printk (KERN_DEBUG PFX "%s: " x "\n", __func__ , ## y)
 #else
 #define DBG(x,y...) do { } while (0)
 #endif
diff -puN drivers/char/cyclades.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/cyclades.c
@@ -3490,7 +3490,7 @@ static int cy_tiocmget(struct tty_struct
 	struct BOARD_CTRL __iomem *board_ctrl;
 	struct CH_CTRL __iomem *ch_ctrl;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	lock_kernel();
@@ -3561,7 +3561,7 @@ cy_tiocmset(struct tty_struct *tty, stru
 	struct CH_CTRL __iomem *ch_ctrl;
 	int retval;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	card = info->card;
diff -puN drivers/char/drm/drmP.h~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/drmP.h
--- a/drivers/char/drm/drmP.h~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/drmP.h
@@ -160,7 +160,7 @@ struct drm_device;
  * \param arg arguments
  */
 #define DRM_ERROR(fmt, arg...) \
-	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __FUNCTION__ , ##arg)
+	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
 
 /**
  * Memory error output.
@@ -170,7 +170,7 @@ struct drm_device;
  * \param arg arguments
  */
 #define DRM_MEM_ERROR(area, fmt, arg...) \
-	printk(KERN_ERR "[" DRM_NAME ":%s:%s] *ERROR* " fmt , __FUNCTION__, \
+	printk(KERN_ERR "[" DRM_NAME ":%s:%s] *ERROR* " fmt , __func__, \
 	       drm_mem_stats[area].name , ##arg)
 
 #define DRM_INFO(fmt, arg...)  printk(KERN_INFO "[" DRM_NAME "] " fmt , ##arg)
@@ -187,7 +187,7 @@ struct drm_device;
 		if ( drm_debug )			\
 			printk(KERN_DEBUG				\
 			       "[" DRM_NAME ":%s] " fmt ,	\
-			       __FUNCTION__ , ##arg);			\
+			       __func__ , ##arg);			\
 	} while (0)
 #else
 #define DRM_DEBUG(fmt, arg...)		 do { } while (0)
@@ -238,7 +238,7 @@ do {									\
 	if ( !_DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ) ||		\
 	     dev->lock.file_priv != file_priv )	{			\
 		DRM_ERROR( "%s called without lock held, held  %d owner %p %p\n",\
-			   __FUNCTION__, _DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ),\
+			   __func__, _DRM_LOCK_IS_HELD( dev->lock.hw_lock->lock ),\
 			   dev->lock.file_priv, file_priv );		\
 		return -EINVAL;						\
 	}								\
diff -puN drivers/char/drm/drm_sysfs.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/drm_sysfs.c
--- a/drivers/char/drm/drm_sysfs.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/drm_sysfs.c
@@ -34,7 +34,7 @@ static int drm_sysfs_suspend(struct devi
 	struct drm_minor *drm_minor = to_drm_minor(dev);
 	struct drm_device *drm_dev = drm_minor->dev;
 
-	printk(KERN_ERR "%s\n", __FUNCTION__);
+	printk(KERN_ERR "%s\n", __func__);
 
 	if (drm_dev->driver->suspend)
 		return drm_dev->driver->suspend(drm_dev, state);
diff -puN drivers/char/drm/i830_dma.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/i830_dma.c
@@ -692,7 +692,7 @@ static void i830EmitState(struct drm_dev
 	drm_i830_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
 
-	DRM_DEBUG("%s %x\n", __FUNCTION__, dirty);
+	DRM_DEBUG("%s %x\n", __func__, dirty);
 
 	if (dirty & I830_UPLOAD_BUFFERS) {
 		i830EmitDestVerified(dev, sarea_priv->BufferState);
@@ -1043,7 +1043,7 @@ static void i830_dma_dispatch_flip(struc
 	RING_LOCALS;
 
 	DRM_DEBUG("%s: page=%d pfCurrentPage=%d\n",
-		  __FUNCTION__,
+		  __func__,
 		  dev_priv->current_page,
 		  dev_priv->sarea_priv->pf_current_page);
 
@@ -1206,7 +1206,7 @@ static void i830_dma_quiescent(struct dr
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	i830_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	i830_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 }
 
 static int i830_flush_queue(struct drm_device * dev)
@@ -1223,7 +1223,7 @@ static int i830_flush_queue(struct drm_d
 	OUT_RING(0);
 	ADVANCE_LP_RING();
 
-	i830_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	i830_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 
 	for (i = 0; i < dma->buf_count; i++) {
 		struct drm_buf *buf = dma->buflist[i];
@@ -1344,7 +1344,7 @@ static void i830_do_init_pageflip(struct
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 	dev_priv->page_flipping = 1;
 	dev_priv->current_page = 0;
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
@@ -1354,7 +1354,7 @@ static int i830_do_cleanup_pageflip(stru
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 	if (dev_priv->current_page != 0)
 		i830_dma_dispatch_flip(dev);
 
@@ -1367,7 +1367,7 @@ static int i830_flip_bufs(struct drm_dev
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
@@ -1437,7 +1437,7 @@ static int i830_getparam(struct drm_devi
 	int value;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1464,7 +1464,7 @@ static int i830_setparam(struct drm_devi
 	drm_i830_setparam_t *param = data;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
diff -puN drivers/char/drm/i830_drv.h~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/i830_drv.h
--- a/drivers/char/drm/i830_drv.h~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/i830_drv.h
@@ -158,7 +158,7 @@ extern int i830_driver_device_is_agp(str
 	if (I830_VERBOSE)				\
 		printk("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < n*4)			\
-		i830_wait_ring(dev, n*4, __FUNCTION__);		\
+		i830_wait_ring(dev, n*4, __func__);		\
 	outcount = 0;					\
 	outring = dev_priv->ring.tail;			\
 	ringmask = dev_priv->ring.tail_mask;		\
diff -puN drivers/char/drm/i830_irq.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/i830_irq.c
--- a/drivers/char/drm/i830_irq.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/i830_irq.c
@@ -58,7 +58,7 @@ static int i830_emit_irq(struct drm_devi
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	atomic_inc(&dev_priv->irq_emitted);
 
@@ -77,7 +77,7 @@ static int i830_wait_irq(struct drm_devi
 	unsigned long end = jiffies + HZ * 3;
 	int ret = 0;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	if (atomic_read(&dev_priv->irq_received) >= irq_nr)
 		return 0;
@@ -124,7 +124,7 @@ int i830_irq_emit(struct drm_device *dev
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
@@ -147,7 +147,7 @@ int i830_irq_wait(struct drm_device *dev
 	drm_i830_irq_wait_t *irqwait = data;
 
 	if (!dev_priv) {
-		DRM_ERROR("%s called with no initialization\n", __FUNCTION__);
+		DRM_ERROR("%s called with no initialization\n", __func__);
 		return -EINVAL;
 	}
 
diff -puN drivers/char/drm/i915_dma.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/i915_dma.c
--- a/drivers/char/drm/i915_dma.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/i915_dma.c
@@ -194,7 +194,7 @@ static int i915_dma_resume(struct drm_de
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 
-	DRM_DEBUG("%s\n", __FUNCTION__);
+	DRM_DEBUG("%s\n", __func__);
 
 	if (!dev_priv->sarea) {
 		DRM_ERROR("can not find sarea!\n");
@@ -609,7 +609,7 @@ static int i915_quiescent(struct drm_dev
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
 	i915_kernel_lost_context(dev);
-	return i915_wait_ring(dev, dev_priv->ring.Size - 8, __FUNCTION__);
+	return i915_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 }
 
 static int i915_flush_ioctl(struct drm_device *dev, void *data,
diff -puN drivers/char/drm/i915_drv.h~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/i915_drv.h
--- a/drivers/char/drm/i915_drv.h~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/i915_drv.h
@@ -272,7 +272,7 @@ extern void i915_mem_release(struct drm_
 	if (I915_VERBOSE)				\
 		DRM_DEBUG("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < (n)*4)		\
-		i915_wait_ring(dev, (n)*4, __FUNCTION__);		\
+		i915_wait_ring(dev, (n)*4, __func__);		\
 	outcount = 0;					\
 	outring = dev_priv->ring.tail;			\
 	ringmask = dev_priv->ring.tail_mask;		\
diff -puN drivers/char/drm/radeon_cp.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/drm/radeon_cp.c
--- a/drivers/char/drm/radeon_cp.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/drm/radeon_cp.c
@@ -894,7 +894,7 @@ static u32 RADEON_READ_IGPGART(drm_radeo
 #if RADEON_FIFO_DEBUG
 static void radeon_status(drm_radeon_private_t * dev_priv)
 {
-	printk("%s:\n", __FUNCTION__);
+	printk("%s:\n", __func__);
 	printk("RBBM_STATUS = 0x%08x\n",
 	       (unsigned int)RADEON_READ(RADEON_RBBM_STATUS));
 	printk("CP_RB_RTPR = 0x%08x\n",
diff -puN drivers/char/esp.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/esp.c
--- a/drivers/char/esp.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/esp.c
@@ -1671,7 +1671,7 @@ static int esp_tiocmget(struct tty_struc
 	unsigned char control, status;
 	unsigned long flags;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1697,7 +1697,7 @@ static int esp_tiocmset(struct tty_struc
 	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
diff -puN drivers/char/generic_serial.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/generic_serial.c
@@ -40,8 +40,8 @@ static int gs_debug;
 #define gs_dprintk(f, str...) /* nothing */
 #endif
 
-#define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __FUNCTION__)
-#define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __FUNCTION__)
+#define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __func__)
+#define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __func__)
 
 #define RS_EVENT_WRITE_WAKEUP	1
 
diff -puN drivers/char/hpet.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/hpet.c
--- a/drivers/char/hpet.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/hpet.c
@@ -308,7 +308,7 @@ static int hpet_mmap(struct file *file, 
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 					PAGE_SIZE, vma->vm_page_prot)) {
 		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
-			__FUNCTION__);
+			__func__);
 		return -EAGAIN;
 	}
 
@@ -748,7 +748,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	 */
 	if (hpet_is_known(hdp)) {
 		printk(KERN_DEBUG "%s: duplicate HPET ignored\n",
-			__FUNCTION__);
+			__func__);
 		return 0;
 	}
 
@@ -869,7 +869,7 @@ static acpi_status hpet_resources(struct
 
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__FUNCTION__, hdp->hd_phys_address);
+				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -886,7 +886,7 @@ static acpi_status hpet_resources(struct
 
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__FUNCTION__, hdp->hd_phys_address);
+				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -925,7 +925,7 @@ static int hpet_acpi_add(struct acpi_dev
 		return -ENODEV;
 
 	if (!data.hd_address || !data.hd_nirqs) {
-		printk("%s: no address or irqs in _CRS\n", __FUNCTION__);
+		printk("%s: no address or irqs in _CRS\n", __func__);
 		return -ENODEV;
 	}
 
diff -puN drivers/char/hvsi.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/hvsi.c
--- a/drivers/char/hvsi.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/hvsi.c
@@ -246,7 +246,7 @@ static void compact_inbuf(struct hvsi_st
 {
 	int remaining = (int)(hp->inbuf_end - read_to);
 
-	pr_debug("%s: %i chars remain\n", __FUNCTION__, remaining);
+	pr_debug("%s: %i chars remain\n", __func__, remaining);
 
 	if (read_to != hp->inbuf)
 		memmove(hp->inbuf, read_to, remaining);
@@ -365,7 +365,7 @@ static int hvsi_version_respond(struct h
 	packet.u.version = HVSI_VERSION;
 	packet.query_seqno = query_seqno+1;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -437,7 +437,7 @@ static struct tty_struct *hvsi_recv_data
 		return NULL;
 
 	if (overflow > 0) {
-		pr_debug("%s: got >TTY_THRESHOLD_THROTTLE bytes\n", __FUNCTION__);
+		pr_debug("%s: got >TTY_THRESHOLD_THROTTLE bytes\n", __func__);
 		datalen = TTY_THRESHOLD_THROTTLE;
 	}
 
@@ -448,7 +448,7 @@ static struct tty_struct *hvsi_recv_data
 		 * we still have more data to deliver, so we need to save off the
 		 * overflow and send it later
 		 */
-		pr_debug("%s: deferring overflow\n", __FUNCTION__);
+		pr_debug("%s: deferring overflow\n", __func__);
 		memcpy(hp->throttle_buf, data + TTY_THRESHOLD_THROTTLE, overflow);
 		hp->n_throttle = overflow;
 	}
@@ -474,11 +474,11 @@ static int hvsi_load_chunk(struct hvsi_s
 
 	chunklen = hvsi_read(hp, hp->inbuf_end, HVSI_MAX_READ);
 	if (chunklen == 0) {
-		pr_debug("%s: 0-length read\n", __FUNCTION__);
+		pr_debug("%s: 0-length read\n", __func__);
 		return 0;
 	}
 
-	pr_debug("%s: got %i bytes\n", __FUNCTION__, chunklen);
+	pr_debug("%s: got %i bytes\n", __func__, chunklen);
 	dbg_dump_hex(hp->inbuf_end, chunklen);
 
 	hp->inbuf_end += chunklen;
@@ -495,7 +495,7 @@ static int hvsi_load_chunk(struct hvsi_s
 			continue;
 		}
 
-		pr_debug("%s: handling %i-byte packet\n", __FUNCTION__,
+		pr_debug("%s: handling %i-byte packet\n", __func__,
 				len_packet(packet));
 		dbg_dump_packet(packet);
 
@@ -526,7 +526,7 @@ static int hvsi_load_chunk(struct hvsi_s
 		packet += len_packet(packet);
 
 		if (*hangup || *handshake) {
-			pr_debug("%s: hangup or handshake\n", __FUNCTION__);
+			pr_debug("%s: hangup or handshake\n", __func__);
 			/*
 			 * we need to send the hangup now before receiving any more data.
 			 * If we get "data, hangup, data", we can't deliver the second
@@ -543,7 +543,7 @@ static int hvsi_load_chunk(struct hvsi_s
 
 static void hvsi_send_overflow(struct hvsi_struct *hp)
 {
-	pr_debug("%s: delivering %i bytes overflow\n", __FUNCTION__,
+	pr_debug("%s: delivering %i bytes overflow\n", __func__,
 			hp->n_throttle);
 
 	hvsi_insert_chars(hp, hp->throttle_buf, hp->n_throttle);
@@ -563,7 +563,7 @@ static irqreturn_t hvsi_interrupt(int ir
 	unsigned long flags;
 	int again = 1;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	while (again) {
 		spin_lock_irqsave(&hp->lock, flags);
@@ -647,7 +647,7 @@ static int hvsi_query(struct hvsi_struct
 	packet.seqno = atomic_inc_return(&hp->seqno);
 	packet.verb = verb;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -674,7 +674,7 @@ static int hvsi_get_mctrl(struct hvsi_st
 		return ret;
 	}
 
-	pr_debug("%s: mctrl 0x%x\n", __FUNCTION__, hp->mctrl);
+	pr_debug("%s: mctrl 0x%x\n", __func__, hp->mctrl);
 
 	return 0;
 }
@@ -694,7 +694,7 @@ static int hvsi_set_mctrl(struct hvsi_st
 	if (mctrl & TIOCM_DTR)
 		packet.word = HVSI_TSDTR;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	wrote = hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -790,7 +790,7 @@ static void hvsi_close_protocol(struct h
 	packet.len = 6;
 	packet.verb = VSV_CLOSE_PROTOCOL;
 
-	pr_debug("%s: sending %i bytes\n", __FUNCTION__, packet.len);
+	pr_debug("%s: sending %i bytes\n", __func__, packet.len);
 	dbg_dump_hex((uint8_t*)&packet, packet.len);
 
 	hvc_put_chars(hp->vtermno, (char *)&packet, packet.len);
@@ -803,7 +803,7 @@ static int hvsi_open(struct tty_struct *
 	int line = tty->index;
 	int ret;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (line < 0 || line >= hvsi_count)
 		return -ENODEV;
@@ -868,7 +868,7 @@ static void hvsi_close(struct tty_struct
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (tty_hung_up_p(filp))
 		return;
@@ -920,7 +920,7 @@ static void hvsi_hangup(struct tty_struc
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	spin_lock_irqsave(&hp->lock, flags);
 
@@ -942,7 +942,7 @@ static void hvsi_push(struct hvsi_struct
 	n = hvsi_put_chars(hp, hp->outbuf, hp->n_outbuf);
 	if (n > 0) {
 		/* success */
-		pr_debug("%s: wrote %i chars\n", __FUNCTION__, n);
+		pr_debug("%s: wrote %i chars\n", __func__, n);
 		hp->n_outbuf = 0;
 	} else if (n == -EIO) {
 		__set_state(hp, HVSI_FSP_DIED);
@@ -965,7 +965,7 @@ static void hvsi_write_worker(struct wor
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	pr_debug("%s: %i chars in buffer\n", __FUNCTION__, hp->n_outbuf);
+	pr_debug("%s: %i chars in buffer\n", __func__, hp->n_outbuf);
 
 	if (!is_open(hp)) {
 		/*
@@ -983,7 +983,7 @@ static void hvsi_write_worker(struct wor
 		schedule_delayed_work(&hp->writer, 10);
 	else {
 #ifdef DEBUG
-		pr_debug("%s: outbuf emptied after %li jiffies\n", __FUNCTION__,
+		pr_debug("%s: outbuf emptied after %li jiffies\n", __func__,
 				jiffies - start_j);
 		start_j = 0;
 #endif /* DEBUG */
@@ -1020,11 +1020,11 @@ static int hvsi_write(struct tty_struct 
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	pr_debug("%s: %i chars in buffer\n", __FUNCTION__, hp->n_outbuf);
+	pr_debug("%s: %i chars in buffer\n", __func__, hp->n_outbuf);
 
 	if (!is_open(hp)) {
 		/* we're either closing or not yet open; don't accept data */
-		pr_debug("%s: not open\n", __FUNCTION__);
+		pr_debug("%s: not open\n", __func__);
 		goto out;
 	}
 
@@ -1058,7 +1058,7 @@ out:
 	spin_unlock_irqrestore(&hp->lock, flags);
 
 	if (total != origcount)
-		pr_debug("%s: wanted %i, only wrote %i\n", __FUNCTION__, origcount,
+		pr_debug("%s: wanted %i, only wrote %i\n", __func__, origcount,
 			total);
 
 	return total;
@@ -1072,7 +1072,7 @@ static void hvsi_throttle(struct tty_str
 {
 	struct hvsi_struct *hp = (struct hvsi_struct *)tty->driver_data;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	h_vio_signal(hp->vtermno, VIO_IRQ_DISABLE);
 }
@@ -1083,7 +1083,7 @@ static void hvsi_unthrottle(struct tty_s
 	unsigned long flags;
 	int shouldflip = 0;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->n_throttle) {
@@ -1302,7 +1302,7 @@ static int __init hvsi_console_init(void
 		hp->virq = irq_create_mapping(NULL, irq[0]);
 		if (hp->virq == NO_IRQ) {
 			printk(KERN_ERR "%s: couldn't create irq mapping for 0x%x\n",
-				__FUNCTION__, irq[0]);
+				__func__, irq[0]);
 			continue;
 		}
 
diff -puN drivers/char/nozomi.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/nozomi.c
@@ -73,7 +73,7 @@ do {								\
 	char tmp[P_BUF_SIZE];					\
 	snprintf(tmp, sizeof(tmp), ##args);			\
 	printk(_err_flag_ "[%d] %s(): %s\n", __LINE__,		\
-		__FUNCTION__, tmp);				\
+		__func__, tmp);				\
 } while (0)
 
 #define DBG1(args...) D_(0x01, ##args)
diff -puN drivers/char/pcmcia/cm4000_cs.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -53,7 +53,7 @@ module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
 	if (pc_debug >= (n))						\
 		dev_printk(KERN_DEBUG, reader_to_dev(rdr), "%s:" x, 	\
-			   __FUNCTION__ , ## args);			\
+			   __func__ , ## args);			\
 	} while (0)
 #else
 #define DEBUGP(n, rdr, x, args...)
diff -puN drivers/char/pcmcia/cm4040_cs.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -47,7 +47,7 @@ module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
 	if (pc_debug >= (n)) 						\
 		dev_printk(KERN_DEBUG, reader_to_dev(rdr), "%s:" x, 	\
-			   __FUNCTION__ , ##args); 			\
+			   __func__ , ##args); 			\
 	} while (0)
 #else
 #define DEBUGP(n, rdr, x, args...)
diff -puN drivers/char/rio/rio_linux.h~drivers-char-replace-remaining-__function__-occurrences drivers/char/rio/rio_linux.h
--- a/drivers/char/rio/rio_linux.h~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/rio/rio_linux.h
@@ -186,9 +186,9 @@ static inline void *rio_memcpy_fromio(vo
 
 #ifdef DEBUG
 #define rio_dprintk(f, str...) do { if (rio_debug & f) printk (str);} while (0)
-#define func_enter() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s\n", __FUNCTION__)
-#define func_exit()  rio_dprintk (RIO_DEBUG_FLOW, "rio: exit  %s\n", __FUNCTION__)
-#define func_enter2() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s (port %d)\n",__FUNCTION__, port->line)
+#define func_enter() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s\n", __func__)
+#define func_exit()  rio_dprintk (RIO_DEBUG_FLOW, "rio: exit  %s\n", __func__)
+#define func_enter2() rio_dprintk (RIO_DEBUG_FLOW, "rio: enter %s (port %d)\n",__func__, port->line)
 #else
 #define rio_dprintk(f, str...)	/* nothing */
 #define func_enter()
diff -puN drivers/char/riscom8.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/riscom8.c
@@ -1222,7 +1222,7 @@ static int rc_tiocmget(struct tty_struct
 	unsigned int result;
 	unsigned long flags;
 
-	if (rc_paranoia_check(port, tty->name, __FUNCTION__))
+	if (rc_paranoia_check(port, tty->name, __func__))
 		return -ENODEV;
 
 	bp = port_Board(port);
@@ -1250,7 +1250,7 @@ static int rc_tiocmset(struct tty_struct
 	unsigned long flags;
 	struct riscom_board *bp;
 
-	if (rc_paranoia_check(port, tty->name, __FUNCTION__))
+	if (rc_paranoia_check(port, tty->name, __func__))
 		return -ENODEV;
 
 	bp = port_Board(port);
diff -puN drivers/char/snsc.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/snsc.c
--- a/drivers/char/snsc.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/snsc.c
@@ -80,7 +80,7 @@ scdrv_open(struct inode *inode, struct f
 	sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
 	if (sd == NULL) {
 		printk("%s: couldn't allocate subchannel data\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENOMEM;
 	}
 
@@ -90,7 +90,7 @@ scdrv_open(struct inode *inode, struct f
 
 	if (sd->sd_subch < 0) {
 		kfree(sd);
-		printk("%s: couldn't allocate subchannel\n", __FUNCTION__);
+		printk("%s: couldn't allocate subchannel\n", __func__);
 		return -EBUSY;
 	}
 
@@ -110,7 +110,7 @@ scdrv_open(struct inode *inode, struct f
 	if (rv) {
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
 		kfree(sd);
-		printk("%s: irq request failed (%d)\n", __FUNCTION__, rv);
+		printk("%s: irq request failed (%d)\n", __func__, rv);
 		return -EBUSY;
 	}
 
@@ -215,7 +215,7 @@ scdrv_read(struct file *file, char __use
 		 */
 		if (count < len) {
 			pr_debug("%s: only accepting %d of %d bytes\n",
-				 __FUNCTION__, (int) count, len);
+				 __func__, (int) count, len);
 		}
 		len = min((int) count, len);
 		if (copy_to_user(buf, sd->sd_rb, len))
@@ -384,7 +384,7 @@ scdrv_init(void)
 	if (alloc_chrdev_region(&first_dev, 0, num_cnodes,
 				SYSCTL_BASENAME) < 0) {
 		printk("%s: failed to register SN system controller device\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENODEV;
 	}
 	snsc_class = class_create(THIS_MODULE, SYSCTL_BASENAME);
@@ -403,7 +403,7 @@ scdrv_init(void)
 				      GFP_KERNEL);
 			if (!scd) {
 				printk("%s: failed to allocate device info"
-				       "for %s/%s\n", __FUNCTION__,
+				       "for %s/%s\n", __func__,
 				       SYSCTL_BASENAME, devname);
 				continue;
 			}
@@ -412,7 +412,7 @@ scdrv_init(void)
 			scd->scd_nasid = cnodeid_to_nasid(cnode);
 			if (!(salbuf = kmalloc(SCDRV_BUFSZ, GFP_KERNEL))) {
 				printk("%s: failed to allocate driver buffer"
-				       "(%s%s)\n", __FUNCTION__,
+				       "(%s%s)\n", __func__,
 				       SYSCTL_BASENAME, devname);
 				kfree(scd);
 				continue;
@@ -424,7 +424,7 @@ scdrv_init(void)
 				    ("%s: failed to initialize SAL for"
 				     " system controller communication"
 				     " (%s/%s): outdated PROM?\n",
-				     __FUNCTION__, SYSCTL_BASENAME, devname);
+				     __func__, SYSCTL_BASENAME, devname);
 				kfree(scd);
 				kfree(salbuf);
 				continue;
@@ -435,7 +435,7 @@ scdrv_init(void)
 			if (cdev_add(&scd->scd_cdev, dev, 1)) {
 				printk("%s: failed to register system"
 				       " controller device (%s%s)\n",
-				       __FUNCTION__, SYSCTL_BASENAME, devname);
+				       __func__, SYSCTL_BASENAME, devname);
 				kfree(scd);
 				kfree(salbuf);
 				continue;
diff -puN drivers/char/snsc_event.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/snsc_event.c
--- a/drivers/char/snsc_event.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/snsc_event.c
@@ -271,7 +271,7 @@ scdrv_event_init(struct sysctl_data_s *s
 	event_sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
 	if (event_sd == NULL) {
 		printk(KERN_WARNING "%s: couldn't allocate subchannel info"
-		       " for event monitoring\n", __FUNCTION__);
+		       " for event monitoring\n", __func__);
 		return;
 	}
 
@@ -285,7 +285,7 @@ scdrv_event_init(struct sysctl_data_s *s
 	if (event_sd->sd_subch < 0) {
 		kfree(event_sd);
 		printk(KERN_WARNING "%s: couldn't open event subchannel\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
@@ -295,7 +295,7 @@ scdrv_event_init(struct sysctl_data_s *s
 			 "system controller events", event_sd);
 	if (rv) {
 		printk(KERN_WARNING "%s: irq request failed (%d)\n",
-		       __FUNCTION__, rv);
+		       __func__, rv);
 		ia64_sn_irtr_close(event_sd->sd_nasid, event_sd->sd_subch);
 		kfree(event_sd);
 		return;
diff -puN drivers/char/sonypi.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/sonypi.c
@@ -506,7 +506,7 @@ static struct sonypi_device {
 	while (--n && (command)) \
 		udelay(1); \
 	if (!n && (verbose || !quiet)) \
-		printk(KERN_WARNING "sonypi command failed at %s : %s (line %d)\n", __FILE__, __FUNCTION__, __LINE__); \
+		printk(KERN_WARNING "sonypi command failed at %s : %s (line %d)\n", __FILE__, __func__, __LINE__); \
 }
 
 #ifdef CONFIG_ACPI
diff -puN drivers/char/specialix.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/specialix.c
--- a/drivers/char/specialix.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/specialix.c
@@ -131,8 +131,8 @@ static int sx_rxfifo = SPECIALIX_RXFIFO;
 #define SX_DEBUG_FIFO    0x0800
 
 
-#define func_enter() dprintk (SX_DEBUG_FLOW, "io8: enter %s\n",__FUNCTION__)
-#define func_exit()  dprintk (SX_DEBUG_FLOW, "io8: exit  %s\n", __FUNCTION__)
+#define func_enter() dprintk (SX_DEBUG_FLOW, "io8: enter %s\n",__func__)
+#define func_exit()  dprintk (SX_DEBUG_FLOW, "io8: exit  %s\n", __func__)
 
 #define jiffies_from_ms(a) ((((a) * HZ)/1000)+1)
 
@@ -874,7 +874,7 @@ static irqreturn_t sx_interrupt(int dumm
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
+	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __func__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
 		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", bp->irq);
 		spin_unlock_irqrestore(&bp->lock, flags);
@@ -1802,7 +1802,7 @@ static int sx_tiocmget(struct tty_struct
 
 	func_enter();
 
-	if (sx_paranoia_check(port, tty->name, __FUNCTION__)) {
+	if (sx_paranoia_check(port, tty->name, __func__)) {
 		func_exit();
 		return -ENODEV;
 	}
@@ -1844,7 +1844,7 @@ static int sx_tiocmset(struct tty_struct
 
 	func_enter();
 
-	if (sx_paranoia_check(port, tty->name, __FUNCTION__)) {
+	if (sx_paranoia_check(port, tty->name, __func__)) {
 		func_exit();
 		return -ENODEV;
 	}
diff -puN drivers/char/sx.c~drivers-char-replace-remaining-__function__-occurrences drivers/char/sx.c
--- a/drivers/char/sx.c~drivers-char-replace-remaining-__function__-occurrences
+++ a/drivers/char/sx.c
@@ -384,11 +384,11 @@ static struct real_driver sx_real_driver
 #define sx_dprintk(f, str...)	/* nothing */
 #endif
 
-#define func_enter()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s\n",__FUNCTION__)
-#define func_exit()	sx_dprintk(SX_DEBUG_FLOW, "sx: exit  %s\n",__FUNCTION__)
+#define func_enter()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s\n",__func__)
+#define func_exit()	sx_dprintk(SX_DEBUG_FLOW, "sx: exit  %s\n",__func__)
 
 #define func_enter2()	sx_dprintk(SX_DEBUG_FLOW, "sx: enter %s (port %d)\n", \
-				__FUNCTION__, port->line)
+				__func__, port->line)
 
 /* 
  *  Firmware loader driver specific routines
@@ -1574,7 +1574,7 @@ static void sx_close(void *ptr)
 		sx_dprintk(SX_DEBUG_CLOSE, "WARNING port count:%d\n",
 				port->gs.count);
 		/*printk("%s SETTING port count to zero: %p count: %d\n",
-				__FUNCTION__, port, port->gs.count);
+				__func__, port, port->gs.count);
 		port->gs.count = 0;*/
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

