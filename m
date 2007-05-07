From: akpm@linux-foundation.org
Subject: + pm2fb-fix-of-jumps-in-pm2fb_probe.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:27 -0700
Message-ID: <200705072227.l47MRRHI007001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967049AbXEGW14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: fix of jumps in pm2fb_probe
has been added to the -mm tree.  Its filename is
     pm2fb-fix-of-jumps-in-pm2fb_probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: fix of jumps in pm2fb_probe
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes incorrect targets of jumps when an error occurs in the
pm2fb_probe.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-fix-of-jumps-in-pm2fb_probe drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-fix-of-jumps-in-pm2fb_probe
+++ a/drivers/video/pm2fb.c
@@ -1335,10 +1335,10 @@ static int __devinit pm2fb_probe(struct 
 		info->var = pm2fb_var;
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
-		goto err_exit_all;
+		goto err_exit_both;
 
 	if (register_framebuffer(info) < 0)
-		goto err_exit_both;
+		goto err_exit_all;
 
 	printk(KERN_INFO "fb%d: %s frame buffer device, memory = %dK.\n",
 	       info->node, info->fix.id, pm2fb_fix.smem_len / 1024);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
