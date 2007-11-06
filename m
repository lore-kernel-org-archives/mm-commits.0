From: akpm@linux-foundation.org
Subject: + drivers-video-ps3fb-fix-memset-size-error.patch added to -mm tree
Date: Mon, 05 Nov 2007 17:12:07 -0800
Message-ID: <200711060112.lA61C757029305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756581AbXKFBMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 20:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, Geert.Uytterhoeven@sonycom.com, stable@kernel.org


The patch titled
     drivers/video/ps3fb: fix memset size error
has been added to the -mm tree.  Its filename is
     drivers-video-ps3fb-fix-memset-size-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/ps3fb: fix memset size error
From: Li Zefan <lizf@cn.fujitsu.com>

The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/ps3fb.c~drivers-video-ps3fb-fix-memset-size-error drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~drivers-video-ps3fb-fix-memset-size-error
+++ a/drivers/video/ps3fb.c
@@ -727,7 +727,7 @@ static int ps3fb_blank(int blank, struct
 
 static int ps3fb_get_vblank(struct fb_vblank *vblank)
 {
-	memset(vblank, 0, sizeof(&vblank));
+	memset(vblank, 0, sizeof(*vblank));
 	vblank->flags = FB_VBLANK_HAVE_VSYNC;
 	return 0;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

time-fix-inconsistent-function-names-in-comments.patch
git-drm.patch
arm-fix-memset-size-error.patch
ia64-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
