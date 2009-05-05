From: akpm@linux-foundation.org
Subject: + offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch added to -mm tree
Date: Tue, 05 May 2009 12:54:04 -0700
Message-ID: <200905051954.n45Js4b0024083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364AbZEET7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, benh@kernel.crashing.org, davem@davemloft.net, geert@linux-m68k.org


The patch titled
     offb: use framebuffer_alloc() to allocate fb_info struct
has been added to the -mm tree.  Its filename is
     offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch

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
Subject: offb: use framebuffer_alloc() to allocate fb_info struct
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the framebuffer_alloc() function to allocate the fb_info structure so
the structure is correctly initialized after allocation.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/offb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/offb.c~offb-use-framebuffer_alloc-to-allocate-fb_info-struct drivers/video/offb.c
--- a/drivers/video/offb.c~offb-use-framebuffer_alloc-to-allocate-fb_info-struct
+++ a/drivers/video/offb.c
@@ -378,7 +378,6 @@ static void __init offb_init_fb(const ch
 	struct fb_fix_screeninfo *fix;
 	struct fb_var_screeninfo *var;
 	struct fb_info *info;
-	int size;
 
 	if (!request_mem_region(res_start, res_size, "offb"))
 		return;
@@ -393,15 +392,12 @@ static void __init offb_init_fb(const ch
 		return;
 	}
 
-	size = sizeof(struct fb_info) + sizeof(u32) * 16;
