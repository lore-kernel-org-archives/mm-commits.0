From: akpm@linux-foundation.org
Subject: [merged] fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:40:01 -0700
Message-ID: <200906171840.n5HIe1Wi006070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbZFQSku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: bf54x-lq043fb: use kzalloc over kmalloc/memset
has been removed from the -mm tree.  Its filename was
     fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bf54x-lq043fb: use kzalloc over kmalloc/memset
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset
+++ a/drivers/video/bf54x-lq043fb.c
@@ -630,7 +630,7 @@ static int __devinit bfin_bf54x_probe(st
 
 	fbinfo->fbops = &bfin_bf54x_fb_ops;
 
-	fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
+	fbinfo->pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbinfo->pseudo_palette) {
 		printk(KERN_ERR DRIVER_NAME
 		       "Fail to allocate pseudo_palette\n");
@@ -639,8 +639,6 @@ static int __devinit bfin_bf54x_probe(st
 		goto out4;
 	}
 
-	memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
