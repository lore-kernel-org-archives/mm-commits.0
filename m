From: akpm@linux-foundation.org
Subject: + drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:42:57 -0800
Message-ID: <200902092342.n19Ngvrd032673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbZBIXni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:43:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     drivers/video/sgivwfb.c: fix memory leaks in removal path
has been added to the -mm tree.  Its filename is
     drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch

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
Subject: drivers/video/sgivwfb.c: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking both the cmap memory and the info struct memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sgivwfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/sgivwfb.c~drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path drivers/video/sgivwfb.c
--- a/drivers/video/sgivwfb.c~drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path
+++ a/drivers/video/sgivwfb.c
@@ -837,6 +837,8 @@ static int sgivwfb_remove(struct platfor
 		iounmap(par->regs);
 		iounmap(info->screen_base);
 		release_mem_region(DBE_REG_PHYS, DBE_REG_SIZE);
+		fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch

