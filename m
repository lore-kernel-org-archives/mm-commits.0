From: akpm@linux-foundation.org
Subject: [patch 15/26] fbdev: color map copying bounds checking
Date: Tue, 24 Jan 2017 15:18:24 -0800
Message-ID: <5887e0c0.j/npPowuHHReaRtY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdAXXS2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, b.zolnierkie@samsung.com, dan.carpenter@oracle.com, mchong@google.com, stable@vger.kernel.org, tomi.valkeinen@ti.com

From: Kees Cook <keescook@chromium.org>
Subject: fbdev: color map copying bounds checking

Copying color maps to userspace doesn't check the value of to->start,
which will cause kernel heap buffer OOB read due to signedness wraps.

CVE-2016-8405

Link: http://lkml.kernel.org/r/20170105224249.GA50925@beast
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Peter Pi (@heisecode) of Trend Micro
Cc: Min Chong <mchong@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fbcmap.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/video/fbdev/core/fbcmap.c~fbdev-color-map-copying-bounds-checking drivers/video/fbdev/core/fbcmap.c
--- a/drivers/video/fbdev/core/fbcmap.c~fbdev-color-map-copying-bounds-checking
+++ a/drivers/video/fbdev/core/fbcmap.c
@@ -163,17 +163,18 @@ void fb_dealloc_cmap(struct fb_cmap *cma
 
 int fb_copy_cmap(const struct fb_cmap *from, struct fb_cmap *to)
 {
-	int tooff = 0, fromoff = 0;
-	int size;
+	unsigned int tooff = 0, fromoff = 0;
+	size_t size;
 
 	if (to->start > from->start)
 		fromoff = to->start - from->start;
 	else
 		tooff = from->start - to->start;
-	size = to->len - tooff;
-	if (size > (int) (from->len - fromoff))
-		size = from->len - fromoff;
-	if (size <= 0)
+	if (fromoff >= from->len || tooff >= to->len)
+		return -EINVAL;
+
+	size = min_t(size_t, to->len - tooff, from->len - fromoff);
+	if (size == 0)
 		return -EINVAL;
 	size *= sizeof(u16);
 
@@ -187,17 +188,18 @@ int fb_copy_cmap(const struct fb_cmap *f
 
 int fb_cmap_to_user(const struct fb_cmap *from, struct fb_cmap_user *to)
 {
-	int tooff = 0, fromoff = 0;
-	int size;
+	unsigned int tooff = 0, fromoff = 0;
+	size_t size;
 
 	if (to->start > from->start)
 		fromoff = to->start - from->start;
 	else
 		tooff = from->start - to->start;
-	size = to->len - tooff;
-	if (size > (int) (from->len - fromoff))
-		size = from->len - fromoff;
-	if (size <= 0)
+	if (fromoff >= from->len || tooff >= to->len)
+		return -EINVAL;
+
+	size = min_t(size_t, to->len - tooff, from->len - fromoff);
+	if (size == 0)
 		return -EINVAL;
 	size *= sizeof(u16);
 
_
