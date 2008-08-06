From: akpm@linux-foundation.org
Subject: - vt8623fb-fix-kernel-oops.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:07 -0700
Message-ID: <200808062056.m76Ku7tf014639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbYHFVRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, MadLoisae@gmx.net, adaplas@pol.net, adobriyan@gmail.com, krzysztof.h1@poczta.fm, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vt8623fb: fix kernel oops
has been removed from the -mm tree.  Its filename was
     vt8623fb-fix-kernel-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt8623fb: fix kernel oops
From: Ondrej Zajicek <santiago@crfreenet.org>

  commit 20e061fb750d36ec0ffcb2e44ed7dafa9018223b
  Author: Ondrej Zajicek <santiago@crfreenet.org>
  Date:   Mon Apr 28 02:15:18 2008 -0700

      fbdev: framebuffer_alloc() fixes
    
      Correct the dev arg of framebuffer_alloc() in arkfb, s3fb and vt8623fb.

causes a null-pointer deref because "info->dev is NULL, info was just
kzallocated".

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Reported-by: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Tested-by: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c    |   18 +++++++++---------
 drivers/video/s3fb.c     |   18 +++++++++---------
 drivers/video/vt8623fb.c |   20 ++++++++++----------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff -puN drivers/video/arkfb.c~vt8623fb-fix-kernel-oops drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~vt8623fb-fix-kernel-oops
+++ a/drivers/video/arkfb.c
@@ -958,20 +958,20 @@ static int __devinit ark_pci_probe(struc
 	/* Prepare PCI device */
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "arkfb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
 	par->dac = ics5342_init(ark_dac_read_regs, ark_dac_write_regs, info);
 	if (! par->dac) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "RAMDAC initialization failed\n");
+		dev_err(info->device, "RAMDAC initialization failed\n");
 		goto err_dac;
 	}
 
@@ -982,7 +982,7 @@ static int __devinit ark_pci_probe(struc
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap;
 	}
 
@@ -1004,19 +1004,19 @@ static int __devinit ark_pci_probe(struc
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebugger\n");
 		goto err_reg_fb;
 	}
 
@@ -1090,7 +1090,7 @@ static int ark_pci_suspend (struct pci_d
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct arkfb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1121,7 +1121,7 @@ static int ark_pci_resume (struct pci_de
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct arkfb_info *par = info->par;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
diff -puN drivers/video/s3fb.c~vt8623fb-fix-kernel-oops drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~vt8623fb-fix-kernel-oops
+++ a/drivers/video/s3fb.c
@@ -903,13 +903,13 @@ static int __devinit s3_pci_probe(struct
 	/* Prepare PCI device */
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "s3fb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
@@ -921,7 +921,7 @@ static int __devinit s3_pci_probe(struct
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap;
 	}
 
@@ -965,19 +965,19 @@ static int __devinit s3_pci_probe(struct
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebuffer\n");
+		dev_err(info->device, "cannot register framebuffer\n");
 		goto err_reg_fb;
 	}
 
@@ -1053,7 +1053,7 @@ static int s3_pci_suspend(struct pci_dev
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct s3fb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1085,7 +1085,7 @@ static int s3_pci_resume(struct pci_dev*
 	struct s3fb_info *par = info->par;
 	int err;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1102,7 +1102,7 @@ static int s3_pci_resume(struct pci_dev*
 	if (err) {
 		mutex_unlock(&(par->open_lock));
 		release_console_sem();
-		dev_err(info->dev, "error %d enabling device for resume\n", err);
+		dev_err(info->device, "error %d enabling device for resume\n", err);
 		return err;
 	}
 	pci_set_master(dev);
diff -puN drivers/video/vt8623fb.c~vt8623fb-fix-kernel-oops drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fb-fix-kernel-oops
+++ a/drivers/video/vt8623fb.c
@@ -677,13 +677,13 @@ static int __devinit vt8623_pci_probe(st
 
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "vt8623fb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
@@ -696,14 +696,14 @@ static int __devinit vt8623_pci_probe(st
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap_1;
 	}
 
 	par->mmio_base = pci_iomap(dev, 1, 0);
 	if (! par->mmio_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for MMIO failed\n");
+		dev_err(info->device, "iomap for MMIO failed\n");
 		goto err_iomap_2;
 	}
 
@@ -714,7 +714,7 @@ static int __devinit vt8623_pci_probe(st
 	if ((16 <= memsize1) && (memsize1 <= 64) && (memsize1 == memsize2))
 		info->screen_size = memsize1 << 20;
 	else {
-		dev_err(info->dev, "memory size detection failed (%x %x), suppose 16 MB\n", memsize1, memsize2);
+		dev_err(info->device, "memory size detection failed (%x %x), suppose 16 MB\n", memsize1, memsize2);
 		info->screen_size = 16 << 20;
 	}
 
@@ -731,19 +731,19 @@ static int __devinit vt8623_pci_probe(st
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebugger\n");
 		goto err_reg_fb;
 	}
 
@@ -817,7 +817,7 @@ static int vt8623_pci_suspend(struct pci
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct vt8623fb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -848,7 +848,7 @@ static int vt8623_pci_resume(struct pci_
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct vt8623fb_info *par = info->par;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
_

Patches currently in -mm which might be from santiago@crfreenet.org are


