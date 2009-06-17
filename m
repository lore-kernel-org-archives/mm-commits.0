From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-drop-unnecessary-calls-to-memset.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:57 -0700
Message-ID: <200906171839.n5HIdvsD005946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756896AbZFQSqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vivek.kutal@azingo.com, krzysztof.h1@poczta.fm, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: *bfin*: drop unnecessary calls to memset
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-drop-unnecessary-calls-to-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: *bfin*: drop unnecessary calls to memset
From: Vivek Kutal <vivek.kutal@azingo.com>

The dma_alloc_* functions sets the memory to 0 before returning so there
is no need to call memset after the allocation.  Also no point in clearing
the memory when disabling the buffer.

Signed-off-by: Vivek Kutal <vivek.kutal@azingo.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c    |    3 ---
 drivers/video/bfin-t350mcqb-fb.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~fbdev-bfin-drop-unnecessary-calls-to-memset drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~fbdev-bfin-drop-unnecessary-calls-to-memset
+++ a/drivers/video/bf54x-lq043fb.c
@@ -323,7 +323,6 @@ static int bfin_bf54x_fb_release(struct 
 		bfin_write_EPPI0_CONTROL(0);
 		SSYNC();
 		disable_dma(CH_EPPI0);
-		memset(fbi->fb_buffer, 0, info->fix.smem_len);
 	}
 
 	spin_unlock(&fbi->lock);
@@ -626,8 +625,6 @@ static int __init bfin_bf54x_probe(struc
 		goto out3;
 	}
 
-	memset(info->fb_buffer, 0, fbinfo->fix.smem_len);
-
 	fbinfo->screen_base = (void *)info->fb_buffer;
 	fbinfo->fix.smem_start = (int)info->fb_buffer;
 
diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-drop-unnecessary-calls-to-memset drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-drop-unnecessary-calls-to-memset
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -242,7 +242,6 @@ static int bfin_t350mcqb_fb_release(stru
 		SSYNC();
 		disable_dma(CH_PPI);
 		bfin_t350mcqb_stop_timers();
-		memset(fbi->fb_buffer, 0, info->fix.smem_len);
 	}
 
 	spin_unlock(&fbi->lock);
@@ -527,8 +526,6 @@ static int __devinit bfin_t350mcqb_probe
 		goto out3;
 	}
 
-	memset(info->fb_buffer, 0, fbinfo->fix.smem_len);
