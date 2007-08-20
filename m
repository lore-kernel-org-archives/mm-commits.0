From: akpm@linux-foundation.org
Subject: - initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:13 -0700
Message-ID: <200708201912.l7KJCDuP018334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757892AbXHTTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Initialize filp->private_data only once in em28xx_v4l2_open
has been removed from the -mm tree.  Its filename was
     initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Initialize filp->private_data only once in em28xx_v4l2_open
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Some lines later filp->private_data is initialized to dev again.  Since there
are some checks that might fail in the mean time keep the later version.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/em28xx/em28xx-video.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/media/video/em28xx/em28xx-video.c~initialize-filp-private_data-only-once-in-em28xx_v4l2_open drivers/media/video/em28xx/em28xx-video.c
--- a/drivers/media/video/em28xx/em28xx-video.c~initialize-filp-private_data-only-once-in-em28xx_v4l2_open
+++ a/drivers/media/video/em28xx/em28xx-video.c
@@ -268,8 +268,6 @@ static int em28xx_v4l2_open(struct inode
 	if (NULL == dev)
 		return -ENODEV;
 
-	filp->private_data=dev;
-
 	em28xx_videodbg("open minor=%d type=%s users=%d\n",
 				minor,v4l2_type_names[dev->type],dev->users);
 
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

git-dvb.patch
git-r8169.patch
