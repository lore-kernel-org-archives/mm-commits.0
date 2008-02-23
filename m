From: akpm@linux-foundation.org
Subject: + pm2fb-correct-error-values-returned-from-probe-function.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:48 -0800
Message-ID: <200802230735.m1N7ZbJI018366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYBWHx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     pm2fb: correct error values returned from probe function
has been added to the -mm tree.  Its filename is
     pm2fb-correct-error-values-returned-from-probe-function.patch

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

pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
