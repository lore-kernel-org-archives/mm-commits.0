From: akpm@linux-foundation.org
Subject: - refine-screen_info-sanity-check-for-vgacon-initialization.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:15 -0700
Message-ID: <200705180706.l4I76Ea0010163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbXERHLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@redhat.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Refine SCREEN_INFO sanity check for vgacon initialization
has been removed from the -mm tree.  Its filename was
     refine-screen_info-sanity-check-for-vgacon-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Refine SCREEN_INFO sanity check for vgacon initialization
From: Gerd Hoffmann <kraxel@redhat.com>

Refine SCREEN_INFO sanity check for vgacon initialization.

Checking video mode field only to see whenever SCREEN_INFO is
initialized is not enougth, in some cases it is zero although
a vga card is present.  Lets additionally check cols and lines.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/vgacon.c~refine-screen_info-sanity-check-for-vgacon-initialization drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~refine-screen_info-sanity-check-for-vgacon-initialization
+++ a/drivers/video/console/vgacon.c
@@ -368,9 +368,14 @@ static const char *vgacon_startup(void)
 #endif
 	}
 
+	/* SCREEN_INFO initialized? */
+	if ((ORIG_VIDEO_MODE  == 0) &&
+	    (ORIG_VIDEO_LINES == 0) &&
+	    (ORIG_VIDEO_COLS  == 0))
+		goto no_vga;
+
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
-	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */
_

Patches currently in -mm which might be from kraxel@redhat.com are

origin.patch
