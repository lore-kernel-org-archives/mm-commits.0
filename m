From: akpm@linux-foundation.org
Subject: + fsldma-fix-incorrect-exit-path-for-initialization.patch added to -mm tree
Date: Wed, 21 May 2008 17:22:23 -0700
Message-ID: <200805220022.m4M0MN55008250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbYEVAXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 20:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leoli@freescale.com, dan.j.williams@intel.com, zw@zh-kernel.org


The patch titled
     fsldma: fix incorrect exit path for initialization
has been added to the -mm tree.  Its filename is
     fsldma-fix-incorrect-exit-path-for-initialization.patch

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
Subject: fsldma: fix incorrect exit path for initialization
From: Li Yang <leoli@freescale.com>

Signed-off-by: Li Yang <leoli@freescale.com>
Acked-by: Zhang Wei <zw@zh-kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN drivers/dma/fsldma.c~fsldma-fix-incorrect-exit-path-for-initialization drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-fix-incorrect-exit-path-for-initialization
+++ a/drivers/dma/fsldma.c
@@ -809,8 +809,7 @@ static int fsl_dma_self_test(struct fsl_
 	if (!src) {
 		dev_err(fsl_chan->dev,
 				"selftest: Cannot alloc memory for test!\n");
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	dest = src + test_size;
@@ -842,7 +841,7 @@ static int fsl_dma_self_test(struct fsl_
 	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
 		dev_err(fsl_chan->dev, "selftest: Time out!\n");
 		err = -ENODEV;
-		goto out;
+		goto free_resources;
 	}
 
 	/* Test free and re-alloc channel resources */
@@ -927,8 +926,7 @@ static int __devinit of_fsl_dma_chan_pro
 	if (!new_fsl_chan) {
 		dev_err(&dev->dev, "No free memory for allocating "
 				"dma channels!\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	/* get dma channel register base */
@@ -936,7 +934,7 @@ static int __devinit of_fsl_dma_chan_pro
 	if (err) {
 		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
 				dev->node->full_name);
-		goto err;
+		goto err_no_reg;
 	}
 
 	new_fsl_chan->feature = *(u32 *)match->data;
@@ -958,7 +956,7 @@ static int __devinit of_fsl_dma_chan_pro
 		dev_err(&dev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
-		goto err;
+		goto err_no_chan;
 	}
 	fdev->chan[new_fsl_chan->id] = new_fsl_chan;
 	tasklet_init(&new_fsl_chan->tasklet, dma_do_tasklet,
@@ -997,23 +995,26 @@ static int __devinit of_fsl_dma_chan_pro
 		if (err) {
 			dev_err(&dev->dev, "DMA channel %s request_irq error "
 				"with return %d\n", dev->node->full_name, err);
-			goto err;
+			goto err_no_irq;
 		}
 	}
 
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
-		goto err;
+		goto err_self_test;
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
 
 	return 0;
-err:
-	dma_halt(new_fsl_chan);
-	iounmap(new_fsl_chan->reg_base);
+
+err_self_test:
 	free_irq(new_fsl_chan->irq, new_fsl_chan);
+err_no_irq:
 	list_del(&new_fsl_chan->common.device_node);
+err_no_chan:
+	iounmap(new_fsl_chan->reg_base);
+err_no_reg:
 	kfree(new_fsl_chan);
 	return err;
 }
@@ -1054,8 +1055,7 @@ static int __devinit of_fsl_dma_probe(st
 	fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
 	if (!fdev) {
 		dev_err(&dev->dev, "No enough memory for 'priv'\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 	fdev->dev = &dev->dev;
 	INIT_LIST_HEAD(&fdev->common.channels);
@@ -1065,7 +1065,7 @@ static int __devinit of_fsl_dma_probe(st
 	if (err) {
 		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
 				dev->node->full_name);
-		goto err;
+		goto err_no_reg;
 	}
 
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
@@ -1103,6 +1103,7 @@ static int __devinit of_fsl_dma_probe(st
 
 err:
 	iounmap(fdev->reg_base);
+err_no_reg:
 	kfree(fdev);
 	return err;
 }
_

Patches currently in -mm which might be from leoli@freescale.com are

origin.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
fsldma-fix-incorrect-exit-path-for-initialization.patch

