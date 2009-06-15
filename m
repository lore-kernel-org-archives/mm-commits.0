From: akpm@linux-foundation.org
Subject: + fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch added to -mm tree
Date: Mon, 15 Jun 2009 13:05:00 -0700
Message-ID: <200906152005.n5FK50nH014691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724AbZFOUFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 16:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, krzysztof.h1@poczta.fm


The patch titled
     fbdev: bf54x-lq043fb: use kzalloc over kmalloc/memset
has been added to the -mm tree.  Its filename is
     fbdev-bf54x-lq043fb-use-kzalloc-over-kmalloc-memset.patch

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
