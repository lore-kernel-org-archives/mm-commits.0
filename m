From: akpm@linux-foundation.org
Subject: + ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:12:42 -0700
Message-ID: <200707201812.l6KICgFo009482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765272AbXGTSOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:14:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, paulus@samba.org


The patch titled
     ps3fb: Set FBINFO_READS_FAST to speed up text console scrolling
has been added to the -mm tree.  Its filename is
     ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
ps3-disk-storage-driver.patch
ps3-disk-storage-driver-use-correct-bio-vector-size.patch
ps3-disk-storage-driver-updates-after-final-review.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch
ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch
ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch
