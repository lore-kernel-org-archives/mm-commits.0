From: akpm@osdl.org
Subject: + ks0127-status-flags.patch added to -mm tree
Date: Thu, 04 Jan 2007 18:42:25 -0800
Message-ID: <200701050242.l052gPBa007306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030297AbXAECm6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 21:42:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@home.se, mchehab@infradead.org


The patch titled
     ks0127 status flags
has been added to the -mm tree.  Its filename is
     ks0127-status-flags.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ks0127 status flags
From: Martin Samuelsson <sam@home.se>

Or status flags together in DECODER_GET_STATUS instead of and-zapping them.

Signed-off-by: Martin Samuelsson <sam@home.se>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/ks0127.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/ks0127.c~ks0127-status-flags drivers/media/video/ks0127.c
--- a/drivers/media/video/ks0127.c~ks0127-status-flags
+++ a/drivers/media/video/ks0127.c
@@ -712,13 +712,13 @@ static int ks0127_command(struct i2c_cli
 		*iarg = 0;
 		status = ks0127_read(ks, KS_STAT);
 		if (!(status & 0x20))		 /* NOVID not set */
-			*iarg = (*iarg & DECODER_STATUS_GOOD);
+			*iarg = (*iarg | DECODER_STATUS_GOOD);
 		if ((status & 0x01))		      /* CLOCK set */
-			*iarg = (*iarg & DECODER_STATUS_COLOR);
+			*iarg = (*iarg | DECODER_STATUS_COLOR);
 		if ((status & 0x08))		   /* PALDET set */
-			*iarg = (*iarg & DECODER_STATUS_PAL);
+			*iarg = (*iarg | DECODER_STATUS_PAL);
 		else
-			*iarg = (*iarg & DECODER_STATUS_NTSC);
+			*iarg = (*iarg | DECODER_STATUS_NTSC);
 		break;
 
 	//Catch any unknown command
_

Patches currently in -mm which might be from sam@home.se are

ks0127-status-flags.patch
