From: akpm@linux-foundation.org
Subject: [merged] parport-use-kmemdup-instead-of-kmalloc-memcpy.patch removed from -mm tree
Date: Wed, 27 Mar 2013 11:57:49 -0700
Message-ID: <20130327185749.7732A5A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:51917 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3C0S5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 14:57:50 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so415216yen.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 11:57:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: silviupopescu1990@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parport: use kmemdup instead of kmalloc + memcpy
has been removed from the -mm tree.  Its filename was
     parport-use-kmemdup-instead-of-kmalloc-memcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: parport: use kmemdup instead of kmalloc + memcpy

This replaces calls to kmalloc followed by memcpy with a single call to
kmemdup.  This was found via make coccicheck.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_gsc.c    |    4 ++--
 drivers/parport/parport_sunbpp.c |    5 ++---
 drivers/parport/procfs.c         |    6 ++----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/parport/parport_gsc.c~parport-use-kmemdup-instead-of-kmalloc-memcpy drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c~parport-use-kmemdup-instead-of-kmalloc-memcpy
+++ a/drivers/parport/parport_gsc.c
@@ -246,14 +246,14 @@ struct parport *parport_gsc_probe_port(u
 		printk (KERN_DEBUG "parport (0x%lx): no memory!\n", base);
 		return NULL;
 	}
-	ops = kmalloc (sizeof (struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_gsc_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
 	if (!ops) {
 		printk (KERN_DEBUG "parport (0x%lx): no memory for ops!\n",
 			base);
 		kfree (priv);
 		return NULL;
 	}
-	memcpy (ops, &parport_gsc_ops, sizeof (struct parport_operations));
 	priv->ctr = 0xc;
 	priv->ctr_writable = 0xff;
 	priv->dma_buf = 0;
diff -puN drivers/parport/parport_sunbpp.c~parport-use-kmemdup-instead-of-kmalloc-memcpy drivers/parport/parport_sunbpp.c
--- a/drivers/parport/parport_sunbpp.c~parport-use-kmemdup-instead-of-kmalloc-memcpy
+++ a/drivers/parport/parport_sunbpp.c
@@ -284,12 +284,11 @@ static int bpp_probe(struct platform_dev
 	size = resource_size(&op->resource[0]);
 	dma = PARPORT_DMA_NONE;
 
-	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_sunbpp_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
         if (!ops)
 		goto out_unmap;
 
-        memcpy (ops, &parport_sunbpp_ops, sizeof(struct parport_operations));
-
 	dprintk(("register_port\n"));
 	if (!(p = parport_register_port((unsigned long)base, irq, dma, ops)))
 		goto out_free_ops;
diff -puN drivers/parport/procfs.c~parport-use-kmemdup-instead-of-kmalloc-memcpy drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~parport-use-kmemdup-instead-of-kmalloc-memcpy
+++ a/drivers/parport/procfs.c
@@ -476,10 +476,9 @@ int parport_proc_register(struct parport
 	struct parport_sysctl_table *t;
 	int i;
 
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_sysctl_template, sizeof(*t));
 
 	t->device_dir[0].extra1 = port;
 
@@ -523,10 +522,9 @@ int parport_device_proc_register(struct
 	struct parport_device_sysctl_table *t;
 	struct parport * port = device->port;
 	
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_device_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_device_sysctl_template, sizeof(*t));
 
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
_

Patches currently in -mm which might be from silviupopescu1990@gmail.com are

linux-next.patch

