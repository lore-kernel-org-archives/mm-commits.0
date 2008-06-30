From: akpm@linux-foundation.org
Subject: + fsl_diu_fb-fix-build-with-config_pm=y-plus-fix-some-warnings.patch added to -mm tree
Date: Mon, 30 Jun 2008 12:40:30 -0700
Message-ID: <200806301940.m5UJeVA1021965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYF3Tkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, adaplas@gmail.com, krzysztof.h1@poczta.fm, timur@freescale.com, yorksun@freescale.com


The patch titled
     fsl_diu_fb: fix build with CONFIG_PM=y, plus fix some warnings
has been added to the -mm tree.  Its filename is
     fsl_diu_fb-fix-build-with-config_pm=y-plus-fix-some-warnings.patch

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
Subject: fsl_diu_fb: fix build with CONFIG_PM=y, plus fix some warnings
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch fixes following build error when CONFIG_PM is set.

  CC      drivers/video/fsl-diu-fb.o
drivers/video/fsl-diu-fb.c: In function 'fsl_diu_suspend':
drivers/video/fsl-diu-fb.c:1327: error: 'ofdev' undeclared (first use in this function)
drivers/video/fsl-diu-fb.c:1327: error: (Each undeclared identifier is reported only once
drivers/video/fsl-diu-fb.c:1327: error: for each function it appears in.)
drivers/video/fsl-diu-fb.c: In function 'fsl_diu_resume':
drivers/video/fsl-diu-fb.c:1337: error: 'ofdev' undeclared (first use in this function)

While I'm at it, also fix this warning:

drivers/video/fsl-diu-fb.c: In function 'fsl_diu_alloc':
drivers/video/fsl-diu-fb.c:314: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'phys_addr_t'

And these section mismatches:

..from the function fsl_diu_remove() to the function .exit.text:uninstall_fb()
..from the function fsl_diu_remove() to the function .exit.text:uninstall_fb()
..from the function install_fb() to the variable .devinit.data:fsl_diu_mode_db
..from the function install_fb() to the variable .devinit.data:fsl_diu_mode_db
..from the function fsl_diu_probe() to the function .exit.text:uninstall_fb()
..from the function fsl_diu_probe() to the function .exit.text:uninstall_fb()

Also, some sparse fixes: make two functions static, and use NULL where
appropriate. There are still a lot of sparse warnings, mainly wrt absence
of __iomem annotations, but some will require ugly __force stuff. I'll leave
them for now, since proper fix would be not that trivial as few one-liners
below.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: York Sun <yorksun@freescale.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~fsl_diu_fb-fix-build-with-config_pm=y-plus-fix-some-warnings drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fsl_diu_fb-fix-build-with-config_pm=y-plus-fix-some-warnings
+++ a/drivers/video/fsl-diu-fb.c
@@ -286,7 +286,7 @@ static struct diu_pool pool;
  *	rheap and make the furture large allocation fail.
  */
 
-void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
+static void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
 {
 	void *virt;
 
@@ -311,12 +311,12 @@ void *fsl_diu_alloc(unsigned long size, 
 		memset(virt, 0, size);
 	}
 
-	pr_debug("rh virt=%p phys=%lx\n", virt, *phys);
+	pr_debug("rh virt=%p phys=%llx\n", virt, (unsigned long long)*phys);
 
 	return virt;
 }
 
-void fsl_diu_free(void *p, unsigned long size)
+static void fsl_diu_free(void *p, unsigned long size)
 {
 	pr_debug("p=%p size=%lu\n", p, size);
 
@@ -770,7 +770,7 @@ static int map_video_memory(struct fb_in
 	info->fix.smem_len = info->fix.line_length * info->var.yres_virtual;
 	pr_debug("MAP_VIDEO_MEMORY: smem_len = %d\n", info->fix.smem_len);
 	info->screen_base = fsl_diu_alloc(info->fix.smem_len, &phys);
-	if (info->screen_base == 0) {
+	if (info->screen_base == NULL) {
 		printk(KERN_ERR "Unable to allocate fb memory\n");
 		return -ENOMEM;
 	}
@@ -788,7 +788,7 @@ static int map_video_memory(struct fb_in
 static void unmap_video_memory(struct fb_info *info)
 {
 	fsl_diu_free(info->screen_base, info->fix.smem_len);
-	info->screen_base = 0;
+	info->screen_base = NULL;
 	info->fix.smem_start = 0;
 	info->fix.smem_len = 0;
 }
@@ -1158,7 +1158,7 @@ static int init_fbinfo(struct fb_info *i
 	return 0;
 }
 
-static int install_fb(struct fb_info *info)
+static int __devinit install_fb(struct fb_info *info)
 {
 	int rc;
 	struct mfb_info *mfbi = info->par;
@@ -1233,7 +1233,7 @@ static int install_fb(struct fb_info *in
 	return 0;
 }
 
-static void __exit uninstall_fb(struct fb_info *info)
+static void uninstall_fb(struct fb_info *info)
 {
 	struct mfb_info *mfbi = info->par;
 
@@ -1287,7 +1287,7 @@ static int request_irq_local(int irq)
 	/* Read to clear the status */
 	status = in_be32(&hw->int_status);
 
-	ret = request_irq(irq, fsl_diu_isr, 0, "diu", 0);
+	ret = request_irq(irq, fsl_diu_isr, 0, "diu", NULL);
 	if (ret)
 		pr_info("Request diu IRQ failed.\n");
 	else {
@@ -1312,7 +1312,7 @@ static void free_irq_local(int irq)
 	/* Disable all LCDC interrupt */
 	out_be32(&hw->int_mask, 0x1f);
 
-	free_irq(irq, 0);
+	free_irq(irq, NULL);
 }
 
 #ifdef CONFIG_PM
@@ -1324,7 +1324,7 @@ static int fsl_diu_suspend(struct of_dev
 {
 	struct fsl_diu_data *machine_data;
 
-	machine_data = dev_get_drvdata(&ofdev->dev);
+	machine_data = dev_get_drvdata(&dev->dev);
 	disable_lcdc(machine_data->fsl_diu_info[0]);
 
 	return 0;
@@ -1334,7 +1334,7 @@ static int fsl_diu_resume(struct of_devi
 {
 	struct fsl_diu_data *machine_data;
 
-	machine_data = dev_get_drvdata(&ofdev->dev);
+	machine_data = dev_get_drvdata(&dev->dev);
 	enable_lcdc(machine_data->fsl_diu_info[0]);
 
 	return 0;
@@ -1353,7 +1353,8 @@ static int allocate_buf(struct diu_addr 
 	dma_addr_t paddr = 0;
 
 	ssize = size + bytes_align;
-	buf->vaddr = dma_alloc_coherent(0, ssize, &paddr, GFP_DMA | __GFP_ZERO);
+	buf->vaddr = dma_alloc_coherent(NULL, ssize, &paddr, GFP_DMA |
+							     __GFP_ZERO);
 	if (!buf->vaddr)
 		return -ENOMEM;
 
@@ -1371,7 +1372,7 @@ static int allocate_buf(struct diu_addr 
 
 static void free_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
 {
-	dma_free_coherent(0, size + bytes_align,
+	dma_free_coherent(NULL, size + bytes_align,
 				buf->vaddr, (buf->paddr - buf->offset));
 	return;
 }
@@ -1411,7 +1412,7 @@ static ssize_t show_monitor(struct devic
 	return diu_ops.show_monitor_port(machine_data->monitor_port, buf);
 }
 
-static int fsl_diu_probe(struct of_device *ofdev,
+static int __devinit fsl_diu_probe(struct of_device *ofdev,
 	const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->node;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

fsl_diu_fb-fix-build-with-config_pm=y-plus-fix-some-warnings.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g-fix.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch

