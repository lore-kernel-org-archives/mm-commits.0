From: akpm@linux-foundation.org
Subject: - ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:30 -0700
Message-ID: <200710162045.l9GKjUqe016271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935163AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static
has been removed from the -mm tree.  Its filename was
     ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Make ps3fb_wait_for_vsync() and ps3fb_flip_ctl() static, as they're no
(longer) used outside ps3fb.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static
+++ a/drivers/video/ps3fb.c
@@ -652,7 +652,7 @@ static int ps3fb_get_vblank(struct fb_vb
 	return 0;
 }
 
-int ps3fb_wait_for_vsync(u32 crtc)
+static int ps3fb_wait_for_vsync(u32 crtc)
 {
 	int ret;
 	u64 count;
@@ -667,9 +667,7 @@ int ps3fb_wait_for_vsync(u32 crtc)
 	return 0;
 }
 
-EXPORT_SYMBOL_GPL(ps3fb_wait_for_vsync);
-
-void ps3fb_flip_ctl(int on, void *data)
+static void ps3fb_flip_ctl(int on, void *data)
 {
 	struct ps3fb_priv *priv = data;
 	if (on)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
