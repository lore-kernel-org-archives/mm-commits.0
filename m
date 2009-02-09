From: akpm@linux-foundation.org
Subject: + vfb-fix-memory-leaks-in-removal-path.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:44:12 -0800
Message-ID: <200902092344.n19NiC8I002008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbZBIXov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     vfb: fix memory leaks in removal path
has been added to the -mm tree.  Its filename is
     vfb-fix-memory-leaks-in-removal-path.patch

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
Subject: vfb: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/vfb.c~vfb-fix-memory-leaks-in-removal-path drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-fix-memory-leaks-in-removal-path
+++ a/drivers/video/vfb.c
@@ -543,6 +543,7 @@ static int vfb_remove(struct platform_de
 	if (info) {
 		unregister_framebuffer(info);
 		rvfree(videomemory, videomemorysize);
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 	return 0;
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch

