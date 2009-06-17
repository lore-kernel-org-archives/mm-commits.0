From: akpm@linux-foundation.org
Subject: [merged] carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:33 -0700
Message-ID: <200906171839.n5HIdXK9005613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759290AbZFQSqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, bigeasy@linutronix.de, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     carminefb: fix possible access beyond end of carmine_modedb[]
has been removed from the -mm tree.  Its filename was
     carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: carminefb: fix possible access beyond end of carmine_modedb[]
From: Roel Kluin <roel.kluin@gmail.com>

This check is off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/carminefb.c~carminefb-fix-possible-access-beyond-end-of-carmine_modedb drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~carminefb-fix-possible-access-beyond-end-of-carmine_modedb
+++ a/drivers/video/carminefb.c
@@ -562,7 +562,7 @@ static int __devinit alloc_carmine_fb(vo
 	if (ret < 0)
 		goto err_free_fb;
 
-	if (fb_mode > ARRAY_SIZE(carmine_modedb))
+	if (fb_mode >= ARRAY_SIZE(carmine_modedb))
 		fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
 
 	par->cur_mode = par->new_mode = ~0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
spi_bfin5xx-limit-reaches-1.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

