From: akpm@linux-foundation.org
Subject: + ignore-vgacon-if-hardware-not-present.patch added to -mm tree
Date: Thu, 29 Mar 2007 14:56:39 -0700
Message-ID: <200703292156.l2TLudkH013083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422650AbXC2V4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 17:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@suse.de, adaplas@pol.net, alan@lxorguk.ukuu.org.uk, jeremy@xensource.com, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     ignore vgacon if hardware not present
has been added to the -mm tree.  Its filename is
     ignore-vgacon-if-hardware-not-present.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ignore vgacon if hardware not present
From: Gerd Hoffmann <kraxel@suse.de>

Avoid trying to set up vgacon if there's no vga hardware present.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~ignore-vgacon-if-hardware-not-present drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~ignore-vgacon-if-hardware-not-present
+++ a/drivers/video/console/vgacon.c
@@ -371,7 +371,8 @@ static const char *vgacon_startup(void)
 	}
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
+	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */
_

Patches currently in -mm which might be from kraxel@suse.de are

fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-vgacon-if-hardware-not-present.patch
