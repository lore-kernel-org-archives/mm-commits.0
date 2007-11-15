From: akpm@linux-foundation.org
Subject: - drivers-video-ps3fb-fix-memset-size-error.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:05 -0800
Message-ID: <200711152108.lAFL85b9015324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763757AbXKOVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, Geert.Uytterhoeven@sonycom.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/ps3fb: fix memset size error
has been removed from the -mm tree.  Its filename was
     drivers-video-ps3fb-fix-memset-size-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
