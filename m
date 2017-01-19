From: akpm@linux-foundation.org
Subject: + fbdev-color-map-copying-bounds-checking.patch added to -mm tree
Date: Thu, 19 Jan 2017 12:43:31 -0800
Message-ID: <588124f3.X35D4BWXcvyXKlIh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbdASUoc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 15:44:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, b.zolnierkie@samsung.com, dan.carpenter@oracle.com, mchong@google.com, stable@vger.kernel.org, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fbdev: color map copying bounds checking
has been added to the -mm tree.  Its filename is
     fbdev-color-map-copying-bounds-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fbdev-color-map-copying-bounds-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fbdev-color-map-copying-bounds-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are

fbdev-color-map-copying-bounds-checking.patch
rbtree-use-designated-initializers.patch

