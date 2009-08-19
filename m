From: akpm@linux-foundation.org
Subject: + video-console-use-div_round_up.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:44:21 -0700
Message-ID: <200908191844.n7JIiLq6015717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbZHSSoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, andi@firstfloor.org, krzysztof.h1@poczta.fm, sergey.senozhatsky@gmail.com


The patch titled
     video: console, use DIV_ROUND_UP
has been added to the -mm tree.  Its filename is
     video-console-use-div_round_up.patch

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
Subject: video: console, use DIV_ROUND_UP
From: Jiri Slaby <jirislaby@gmail.com>

Use DIV_ROUND_UP explicitly instead of manual shifts and adds.  It makes
the code more readable and consistent (sometimes there were shifts,
sometimes divs).

There is no change on the assembly level (compilers should do the right
job).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/bitblit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/bitblit.c~video-console-use-div_round_up drivers/video/console/bitblit.c
--- a/drivers/video/console/bitblit.c~video-console-use-div_round_up
+++ a/drivers/video/console/bitblit.c
@@ -25,7 +25,7 @@ static inline void update_attr(u8 *dst, 
 			       struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
-	int width = (vc->vc_font.width + 7) >> 3;
+	int width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	unsigned int cellsize = vc->vc_font.height * width;
 	u8 c;
 
@@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc
 		      int fg, int bg)
 {
 	struct fb_image image;
-	u32 width = (vc->vc_font.width + 7)/8;
+	u32 width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
 	u32 scan_align = info->pixmap.scan_align - 1;
@@ -173,7 +173,7 @@ static void bit_putcs(struct vc_data *vc
 			cnt = count;
 
 		image.width = vc->vc_font.width * cnt;
-		pitch = ((image.width + 7) >> 3) + scan_align;
+		pitch = DIV_ROUND_UP(image.width, 8) + scan_align;
 		pitch &= ~scan_align;
 		size = pitch * image.height + buf_align;
 		size &= ~buf_align;
@@ -239,7 +239,7 @@ static void bit_cursor(struct vc_data *v
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
 	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
-	int w = (vc->vc_font.width + 7) >> 3, c;
+	int w = DIV_ROUND_UP(vc->vc_font.width, 8), c;
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
 	int err = 1;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch

