From: akpm@linux-foundation.org
Subject: + drivers-video-pnx4008-eliminate-double-free.patch added to -mm tree
Date: Tue, 06 May 2008 13:01:26 -0700
Message-ID: <200805062001.m46K1R6t024692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbYEFUBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, adaplas@gmail.com, gtolstolytkin@ru.mvista.com, krzysztof.h1@wp.pl, vitalywool@gmail.com


The patch titled
     drivers/video/pnx4008: eliminate double free
has been added to the -mm tree.  Its filename is
     drivers-video-pnx4008-eliminate-double-free.patch

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
Subject: drivers/video/pnx4008: eliminate double free
From: Julia Lawall <julia@diku.dk>

The function framebuffer_release just calls kfree, so calling kfree
subsequently on the same argument represents a double free.  The comments with
the definition of framebuffer_release in drivers/video/fbsysfs.c suggest that
a more elaborate definition of this function is planned, such that the
splitting up of framebuffer_release and kfree as done in the second instance
might someday make sense, but it does not make sense now.

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
@@

* kfree(E);
...
* framebuffer_release(E);

@@
expression E;
@@

* framebuffer_release(E);
...
* kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Grigory Tolstolytkin <gtolstolytkin@ru.mvista.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pnx4008/pnxrgbfb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/video/pnx4008/pnxrgbfb.c~drivers-video-pnx4008-eliminate-double-free drivers/video/pnx4008/pnxrgbfb.c
--- a/drivers/video/pnx4008/pnxrgbfb.c~drivers-video-pnx4008-eliminate-double-free
+++ a/drivers/video/pnx4008/pnxrgbfb.c
@@ -100,7 +100,6 @@ static int rgbfb_remove(struct platform_
 		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 		platform_set_drvdata(pdev, NULL);
-		kfree(info);
 	}
 
 	pnx4008_free_dum_channel(channel_owned, pdev->id);
@@ -168,23 +167,21 @@ static int __devinit rgbfb_probe(struct 
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret < 0)
-		goto err2;
+		goto err1;
 
 	ret = register_framebuffer(info);
 	if (ret < 0)
-		goto err3;
+		goto err2;
 	platform_set_drvdata(pdev, info);
 
 	return 0;
 
-err3:
-	fb_dealloc_cmap(&info->cmap);
 err2:
-	framebuffer_release(info);
+	fb_dealloc_cmap(&info->cmap);
 err1:
 	pnx4008_free_dum_channel(channel_owned, pdev->id);
 err0:
-	kfree(info);
+	framebuffer_release(info);
 err:
 	return ret;
 }
_

Patches currently in -mm which might be from julia@diku.dk are

drivers-video-pnx4008-eliminate-double-free.patch
fs-ext4-use-bug_on.patch

