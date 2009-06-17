From: akpm@linux-foundation.org
Subject: [merged] offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:16 -0700
Message-ID: <200906171839.n5HIdGLb005301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416AbZFQSuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, benh@kernel.crashing.org, davem@davemloft.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     offb: use framebuffer_alloc() to allocate fb_info struct
has been removed from the -mm tree.  Its filename was
     offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: offb: use framebuffer_alloc() to allocate fb_info struct
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the framebuffer_alloc() function to allocate the fb_info structure so
the structure is correctly initialized after allocation.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
