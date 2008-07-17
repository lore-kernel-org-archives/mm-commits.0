From: akpm@linux-foundation.org
Subject: + fbdev-add-new-cobalt-lcd-framebuffer-driver-v3.patch added to -mm tree
Date: Wed, 16 Jul 2008 17:32:01 -0700
Message-ID: <200807170032.m6H0W234021728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbYGQAcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 20:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, adaplas@pol.net, krzysztof.h1@poczta.fm, ralf@linux-mips.org


The patch titled
     add new Cobalt LCD framebuffer driver
has been added to the -mm tree.  Its filename is
     fbdev-add-new-cobalt-lcd-framebuffer-driver-v3.patch

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
Subject: add new Cobalt LCD framebuffer driver
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

- fix read/write count boundary check.
- add <include/uaccess.h>.
- fix MODULE_AUTHOR.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig        |    2 +-
 drivers/video/cobalt_lcdfb.c |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-add-new-cobalt-lcd-framebuffer-driver-v3 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-add-new-cobalt-lcd-framebuffer-driver-v3
+++ a/drivers/video/Kconfig
@@ -1989,7 +1989,7 @@ config FB_AM200EPD
 
 config FB_COBALT
 	tristate "Cobalt server LCD frame buffer support"
-	depends on FB
+	depends on FB && MIPS_COBALT
 
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
diff -puN drivers/video/cobalt_lcdfb.c~fbdev-add-new-cobalt-lcd-framebuffer-driver-v3 drivers/video/cobalt_lcdfb.c
--- a/drivers/video/cobalt_lcdfb.c~fbdev-add-new-cobalt-lcd-framebuffer-driver-v3
+++ a/drivers/video/cobalt_lcdfb.c
@@ -137,13 +137,16 @@ static ssize_t cobalt_lcdfb_read(struct 
 {
 	char src[LCD_CHARS_MAX];
 	unsigned long pos;
-	int len, retval;
+	int len, retval = 0;
 
 	pos = *ppos;
-	if (pos >= LCD_CHARS_MAX)
+	if (pos >= LCD_CHARS_MAX || count == 0)
 		return 0;
 
-	if (pos + count >= LCD_CHARS_MAX)
+	if (count > LCD_CHARS_MAX)
+		count = LCD_CHARS_MAX;
+
+	if (pos + count > LCD_CHARS_MAX)
 		count = LCD_CHARS_MAX - pos;
 
 	for (len = 0; len < count; len++) {
@@ -164,6 +167,9 @@ static ssize_t cobalt_lcdfb_read(struct 
 			pos++;
 	}
 
+	if (retval < 0 && signal_pending(current))
+		return -ERESTARTSYS;
+
 	if (copy_to_user(buf, src, len))
 		return -EFAULT;
 
@@ -177,13 +183,16 @@ static ssize_t cobalt_lcdfb_write(struct
 {
 	char dst[LCD_CHARS_MAX];
 	unsigned long pos;
-	int len, retval;
+	int len, retval = 0;
 
 	pos = *ppos;
-	if (pos >= LCD_CHARS_MAX)
+	if (pos >= LCD_CHARS_MAX || count == 0)
 		return 0;
 
-	if (pos + count >= LCD_CHARS_MAX)
+	if (count > LCD_CHARS_MAX)
+		count = LCD_CHARS_MAX;
+
+	if (pos + count > LCD_CHARS_MAX)
 		count = LCD_CHARS_MAX - pos;
 
 	if (copy_from_user(dst, buf, count))
@@ -207,6 +216,9 @@ static ssize_t cobalt_lcdfb_write(struct
 			pos++;
 	}
 
+	if (retval < 0 && signal_pending(current))
+		return -ERESTARTSYS;
+
 	*ppos += len;
 
 	return len;
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
linux-next.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver-v3.patch
drivers-char-remove-old-broken-cobalt-lcd-driver.patch

