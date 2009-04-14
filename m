From: akpm@linux-foundation.org
Subject: [merged] s3fb-fix-color-component-length-for-pseudocolor-modes.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:59 -0700
Message-ID: <200904141948.n3EJmxng019317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbZDNTv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@poczta.fm, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     s3fb: fix color component length for pseudocolor modes
has been removed from the -mm tree.  Its filename was
     s3fb-fix-color-component-length-for-pseudocolor-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3fb: fix color component length for pseudocolor modes
From: Michal Januszewski <spock@gentoo.org>

s3fb incorrectly sets the length of the color fields to 6 bits for
PSEUDOCOLOR modes, even though 8 or 4 bits are used per pixel.  Fix this
by setting the length to 8 or 4, respectively.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-fix-color-component-length-for-pseudocolor-modes drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-fix-color-component-length-for-pseudocolor-modes
+++ a/drivers/video/s3fb.c
@@ -45,11 +45,11 @@ struct s3fb_info {
 static const struct svga_fb_format s3fb_formats[] = {
 	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
 		FB_TYPE_TEXT, FB_AUX_TEXT_SVGA_STEP4,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
+	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 1,
 		FB_TYPE_INTERLEAVED_PLANES, 1,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
-	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+	{ 8,  {0, 8, 0},  {0, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 4, 8},
 	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
 		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
linux-next.patch

