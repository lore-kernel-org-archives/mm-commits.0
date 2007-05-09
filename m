From: akpm@linux-foundation.org
Subject: - pm2fb-fix-of-jumps-in-pm2fb_probe.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:56 -0700
Message-ID: <200705090302.l4932uY6010901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032997AbXEIDC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: fix of jumps in pm2fb_probe
has been removed from the -mm tree.  Its filename was
     pm2fb-fix-of-jumps-in-pm2fb_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
