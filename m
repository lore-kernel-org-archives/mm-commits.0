From: akpm@linux-foundation.org
Subject: - drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:48 -0800
Message-ID: <200802232021.m1NKLm9g013371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758569AbYBWUWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, luca.risolia@studio.unibo.it, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
has been removed from the -mm tree.  Its filename was
     drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
From: Roel Kluin <12o3l@tiscali.nl>

Fix Unlikely(x) == y

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Reviewed-by: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/sn9c102/sn9c102_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -528,7 +528,7 @@ sn9c102_find_sof_header(struct sn9c102_d
 
 		/* Search for the SOF marker (fixed part) in the header */
 		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
-			if (unlikely(i+j) == len)
+			if (unlikely(i+j == len))
 				return NULL;
 			if (*(m+i+j) == marker[cam->sof.bytesread]) {
 				cam->sof.header[cam->sof.bytesread] = *(m+i+j);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
ufs-fix-parenthesisation-in-ufs_set_fs_state.patch
git-alsa.patch
git-cifs.patch
git-dvb.patch
arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch
