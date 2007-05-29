From: akpm@linux-foundation.org
Subject: - w100fb-fix-compile-warnings.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:18 -0700
Message-ID: <200705291851.l4TIpHgD008334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbXE2Svs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpurdie@rpsys.net, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     w100fb: fix compile warnings
has been removed from the -mm tree.  Its filename was
     w100fb-fix-compile-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w100fb: fix compile warnings
From: Richard Purdie <rpurdie@rpsys.net>

Fix compile warnings from w100fb.c.  Attribute registration failure doesn't
stop the driver working so just warn about it.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/w100fb.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/video/w100fb.c~w100fb-fix-compile-warnings drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~w100fb-fix-compile-warnings
+++ a/drivers/video/w100fb.c
@@ -660,7 +660,7 @@ int __init w100fb_probe(struct platform_
 			err = -ENODEV;
 			goto out;
 	}
-	printk(" at 0x%08lx.\n", mem->start+W100_CFG_BASE);
+	printk(" at 0x%08lx.\n", (unsigned long) mem->start+W100_CFG_BASE);
 
 	/* Remap the framebuffer */
 	remapped_fbuf = ioremap_nocache(mem->start+MEM_WINDOW_BASE, MEM_WINDOW_SIZE);
@@ -753,10 +753,14 @@ int __init w100fb_probe(struct platform_
 		goto out;
 	}
 
-	device_create_file(&pdev->dev, &dev_attr_fastpllclk);
-	device_create_file(&pdev->dev, &dev_attr_reg_read);
-	device_create_file(&pdev->dev, &dev_attr_reg_write);
-	device_create_file(&pdev->dev, &dev_attr_flip);
+	err = device_create_file(&pdev->dev, &dev_attr_fastpllclk);
+	err |= device_create_file(&pdev->dev, &dev_attr_reg_read);
+	err |= device_create_file(&pdev->dev, &dev_attr_reg_write);
+	err |= device_create_file(&pdev->dev, &dev_attr_flip);
+
+	if (err != 0)
+		printk(KERN_WARNING "fb%d: failed to register attributes (%d)\n",
+				info->node, err);
 
 	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node, info->fix.id);
 	return 0;
_

Patches currently in -mm which might be from rpurdie@rpsys.net are

git-leds.patch
git-leds-fixup.patch
