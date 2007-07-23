From: akpm@linux-foundation.org
Subject: - ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:45 -0700
Message-ID: <200707230934.l6N9YjPX016420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759612AbXGWJpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3fb: Set FBINFO_READS_FAST to speed up text console scrolling
has been removed from the -mm tree.  Its filename was
     ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: Set FBINFO_READS_FAST to speed up text console scrolling
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Set FBINFO_READS_FAST to speed up text console scrolling (on average
50%, according to my tests)

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/ps3fb.c~ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling
+++ a/drivers/video/ps3fb.c
@@ -1067,7 +1067,7 @@ static int __devinit ps3fb_probe(struct 
 	info->fix.smem_len = ps3fb_videomemory.size - offset;
 	info->pseudo_palette = info->par;
 	info->par = NULL;
-	info->flags = FBINFO_FLAG_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_READS_FAST;
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (retval < 0)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are
