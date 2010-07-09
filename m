From: akpm@linux-foundation.org
Subject: + s3c-fb-add-wait-for-vsync-ioctl.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:09 -0700
Message-ID: <201007092309.o69N99Mg030984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889Ab0GIXJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: add wait for VSYNC ioctl
has been added to the -mm tree.  Its filename is
     s3c-fb-add-wait-for-vsync-ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c-fb: add wait for VSYNC ioctl
From: Pawel Osciak <p.osciak@samsung.com>

Add VSYNC interrupt support and an ioctl that allows waiting for it. 
Interrupts are turned on only when needed.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-fb.h |    1 
 drivers/video/s3c-fb.c                       |  166 ++++++++++++++++-
 2 files changed, 166 insertions(+), 1 deletion(-)

diff -puN arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-wait-for-vsync-ioctl arch/arm/plat-samsung/include/plat/regs-fb.h
--- a/arch/arm/plat-samsung/include/plat/regs-fb.h~s3c-fb-add-wait-for-vsync-ioctl
+++ a/arch/arm/plat-samsung/include/plat/regs-fb.h
@@ -300,6 +300,7 @@
 #define VIDINTCON0_FRAMESEL0_FRONTPORCH		(0x3 << 15)
 
 #define VIDINTCON0_FRAMESEL1			(1 << 13)
+#define VIDINTCON0_FRAMESEL1_MASK		(0x3 << 13)
 #define VIDINTCON0_FRAMESEL1_NONE		(0x0 << 13)
 #define VIDINTCON0_FRAMESEL1_BACKPORCH		(0x1 << 13)
 #define VIDINTCON0_FRAMESEL1_VSYNC		(0x2 << 13)
diff -puN drivers/video/s3c-fb.c~s3c-fb-add-wait-for-vsync-ioctl drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-add-wait-for-vsync-ioctl
+++ a/drivers/video/s3c-fb.c
@@ -21,6 +21,8 @@
 #include <linux/clk.h>
 #include <linux/fb.h>
 #include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/interrupt.h>
 
 #include <mach/map.h>
 #include <plat/regs-fb-v4.h>
@@ -48,6 +50,11 @@
 	__raw_writel(v, r); } while(0)
 #endif /* FB_S3C_DEBUG_REGWRITE */
 
+/* irq_flags bits */
+#define S3C_FB_VSYNC_IRQ_EN	0
+
+#define VSYNC_TIMEOUT_MSEC 50
+
 struct s3c_fb;
 
 #define VALID_BPP(x) (1 << ((x) - 1))
@@ -156,6 +163,16 @@ struct s3c_fb_win {
 };
 
 /**
+ * struct s3c_fb_vsync - vsync information
+ * @wait:	a queue for processes waiting for vsync
+ * @count:	vsync interrupt count
+ */
+struct s3c_fb_vsync {
+	wait_queue_head_t	wait;
+	unsigned int		count;
+};
+
+/**
  * struct s3c_fb - overall hardware state of the hardware
  * @dev: The device that we bound to, for printing, etc.
  * @regs_res: The resource we claimed for the IO registers.
@@ -165,6 +182,9 @@ struct s3c_fb_win {
  * @enabled: A bitmask of enabled hardware windows.
  * @pdata: The platform configuration data passed with the device.
  * @windows: The hardware windows that have been claimed.
+ * @irq_no: IRQ line number
+ * @irq_flags: irq flags
+ * @vsync_info: VSYNC-related information (count, queues...)
  */
 struct s3c_fb {
 	struct device		*dev;
@@ -177,6 +197,10 @@ struct s3c_fb {
 
 	struct s3c_fb_platdata	*pdata;
 	struct s3c_fb_win	*windows[S3C_FB_MAX_WIN];
+
+	int			 irq_no;
+	unsigned long		 irq_flags;
+	struct s3c_fb_vsync	 vsync_info;
 };
 
 /**
@@ -798,6 +822,124 @@ static int s3c_fb_pan_display(struct fb_
 	return 0;
 }
 
+/**
+ * s3c_fb_enable_irq() - enable framebuffer interrupts
+ * @sfb: main hardware state
+ */
+static void s3c_fb_enable_irq(struct s3c_fb *sfb)
+{
+	void __iomem *regs = sfb->regs;
+	u32 irq_ctrl_reg;
+
+	if (!test_and_set_bit(S3C_FB_VSYNC_IRQ_EN, &sfb->irq_flags)) {
+		/* IRQ disabled, enable it */
+		irq_ctrl_reg = readl(regs + VIDINTCON0);
+
+		irq_ctrl_reg |= VIDINTCON0_INT_ENABLE;
+		irq_ctrl_reg |= VIDINTCON0_INT_FRAME;
+
+		irq_ctrl_reg &= ~VIDINTCON0_FRAMESEL0_MASK;
+		irq_ctrl_reg |= VIDINTCON0_FRAMESEL0_VSYNC;
+		irq_ctrl_reg &= ~VIDINTCON0_FRAMESEL1_MASK;
+		irq_ctrl_reg |= VIDINTCON0_FRAMESEL1_NONE;
+
+		writel(irq_ctrl_reg, regs + VIDINTCON0);
+	}
+}
+
+/**
+ * s3c_fb_disable_irq() - disable framebuffer interrupts
+ * @sfb: main hardware state
+ */
+static void s3c_fb_disable_irq(struct s3c_fb *sfb)
+{
+	void __iomem *regs = sfb->regs;
+	u32 irq_ctrl_reg;
+
+	if (test_and_clear_bit(S3C_FB_VSYNC_IRQ_EN, &sfb->irq_flags)) {
+		/* IRQ enabled, disable it */
+		irq_ctrl_reg = readl(regs + VIDINTCON0);
+
+		irq_ctrl_reg &= ~VIDINTCON0_INT_FRAME;
+		irq_ctrl_reg &= ~VIDINTCON0_INT_ENABLE;
+
+		writel(irq_ctrl_reg, regs + VIDINTCON0);
+	}
+}
+
+static irqreturn_t s3c_fb_irq(int irq, void *dev_id)
+{
+	struct s3c_fb *sfb = dev_id;
+	void __iomem  *regs = sfb->regs;
+	u32 irq_sts_reg;
+
+	irq_sts_reg = readl(regs + VIDINTCON1);
+
+	if (irq_sts_reg & VIDINTCON1_INT_FRAME) {
+
+		/* VSYNC interrupt, accept it */
+		writel(VIDINTCON1_INT_FRAME, regs + VIDINTCON1);
+
+		sfb->vsync_info.count++;
+		wake_up_interruptible(&sfb->vsync_info.wait);
+	}
+
+	/* We only support waiting for VSYNC for now, so it's safe
+	 * to always disable irqs here.
+	 */
+	s3c_fb_disable_irq(sfb);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * s3c_fb_wait_for_vsync() - sleep until next VSYNC interrupt or timeout
+ * @sfb: main hardware state
+ * @crtc: head index.
+ */
+static int s3c_fb_wait_for_vsync(struct s3c_fb *sfb, u32 crtc)
+{
+	unsigned long count;
+	int ret;
+
+	if (crtc != 0)
+		return -ENODEV;
+
+	count = sfb->vsync_info.count;
+	s3c_fb_enable_irq(sfb);
+	ret = wait_event_interruptible_timeout(sfb->vsync_info.wait,
+				       count != sfb->vsync_info.count,
+				       msecs_to_jiffies(VSYNC_TIMEOUT_MSEC));
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int s3c_fb_ioctl(struct fb_info *info, unsigned int cmd,
+			unsigned long arg)
+{
+	struct s3c_fb_win *win = info->par;
+	struct s3c_fb *sfb = win->parent;
+	int ret;
+	u32 crtc;
+
+	switch (cmd) {
+	case FBIO_WAITFORVSYNC:
+		if (get_user(crtc, (u32 __user *)arg)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret = s3c_fb_wait_for_vsync(sfb, crtc);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	return ret;
+}
+
 static struct fb_ops s3c_fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_check_var	= s3c_fb_check_var,
@@ -808,6 +950,7 @@ static struct fb_ops s3c_fb_ops = {
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
 	.fb_pan_display	= s3c_fb_pan_display,
+	.fb_ioctl	= s3c_fb_ioctl,
 };
 
 /**
@@ -914,6 +1057,8 @@ static int __devinit s3c_fb_probe_win(st
 
 	dev_dbg(sfb->dev, "probing window %d, variant %p\n", win_no, variant);
 
+	init_waitqueue_head(&sfb->vsync_info.wait);
+
 	palette_size = variant->palette_sz * 4;
 
 	fbinfo = framebuffer_alloc(sizeof(struct s3c_fb_win) +
@@ -1093,6 +1238,20 @@ static int __devinit s3c_fb_probe(struct
 		goto err_req_region;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "failed to acquire irq resource\n");
+		ret = -ENOENT;
+		goto err_ioremap;
+	}
+	sfb->irq_no = res->start;
+	ret = request_irq(sfb->irq_no, s3c_fb_irq,
+			  0, "s3c_fb", sfb);
+	if (ret) {
+		dev_err(dev, "irq request failed\n");
+		goto err_ioremap;
+	}
+
 	dev_dbg(dev, "got resources (regs %p), probing windows\n", sfb->regs);
 
 	/* setup gpio and output polarity controls */
@@ -1127,7 +1286,7 @@ static int __devinit s3c_fb_probe(struct
 			dev_err(dev, "failed to create window %d\n", win);
 			for (; win >= 0; win--)
 				s3c_fb_release_win(sfb, sfb->windows[win]);
-			goto err_ioremap;
+			goto err_irq;
 		}
 	}
 
@@ -1135,6 +1294,9 @@ static int __devinit s3c_fb_probe(struct
 
 	return 0;
 
+err_irq:
+	free_irq(sfb->irq_no, sfb);
+
 err_ioremap:
 	iounmap(sfb->regs);
 
@@ -1167,6 +1329,8 @@ static int __devexit s3c_fb_remove(struc
 		if (sfb->windows[win])
 			s3c_fb_release_win(sfb, sfb->windows[win]);
 
+	free_irq(sfb->irq_no, sfb);
+
 	iounmap(sfb->regs);
 
 	clk_disable(sfb->bus_clk);
_

Patches currently in -mm which might be from p.osciak@samsung.com are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

