From: akpm@osdl.org
Subject: + drivers-media-video-cafe_ccicc-fix-warning.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:49:48 -0800
Message-ID: <200701300049.l0U0nmid004573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXA3AuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org


The patch titled
     drivers/media/video/cafe_ccic.c fix warning
has been added to the -mm tree.  Its filename is
     drivers-media-video-cafe_ccicc-fix-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/media/video/cafe_ccic.c fix warning
From: corbet@lwn.net (Jonathan Corbet)

Quiet a spurious gcc warning.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/cafe_ccic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-warning drivers/media/video/cafe_ccic.c
--- a/drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-warning
+++ a/drivers/media/video/cafe_ccic.c
@@ -1195,7 +1195,7 @@ static int cafe_vidioc_reqbufs(struct fi
 		struct v4l2_requestbuffers *req)
 {
 	struct cafe_camera *cam = filp->private_data;
-	int ret;
+	int ret = 0;  /* Silence warning */
 
 	/*
 	 * Make sure it's something we can do.  User pointers could be
_

Patches currently in -mm which might be from corbet@lwn.net are

drivers-media-video-cafe_ccicc-fix-warning.patch
