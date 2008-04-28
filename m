From: akpm@linux-foundation.org
Subject: - pm2fb-correct-error-values-returned-from-probe-function.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:21 -0700
Message-ID: <200804282157.m3SLvLY0018392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965105AbYD1V5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     pm2fb: correct error values returned from probe function
has been removed from the -mm tree.  Its filename was
     pm2fb-correct-error-values-returned-from-probe-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm2fb: correct error values returned from probe function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix error values returned in some code branches in the pm2fb_probe() function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-correct-error-values-returned-from-probe-function drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-correct-error-values-returned-from-probe-function
+++ a/drivers/video/pm2fb.c
@@ -1687,10 +1687,12 @@ static int __devinit pm2fb_probe(struct 
 	if (!err || err == 4)
 		info->var = pm2fb_var;
 
-	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+	retval = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (retval < 0)
 		goto err_exit_both;
 
-	if (register_framebuffer(info) < 0)
+	retval = register_framebuffer(info);
+	if (retval < 0)
 		goto err_exit_all;
 
 	printk(KERN_INFO "fb%d: %s frame buffer device, memory = %dK.\n",
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

