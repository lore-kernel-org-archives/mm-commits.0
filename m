From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-saa5246ac-fix-use-after-free.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:22 -0700
Message-ID: <200904221831.n3MIVMaU006712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZDVSel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/saa5246a.c: fix use-after-free
has been removed from the -mm tree.  Its filename was
     drivers-media-video-saa5246ac-fix-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/saa5246a.c: fix use-after-free
From: Dan Carpenter <error27@gmail.com>

I lowered the kfree(t) down a couple lines and removed the superflous
"t->vdev = NULL;"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa5246a.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/saa5246a.c~drivers-media-video-saa5246ac-fix-use-after-free drivers/media/video/saa5246a.c
--- a/drivers/media/video/saa5246a.c~drivers-media-video-saa5246ac-fix-use-after-free
+++ a/drivers/media/video/saa5246a.c
@@ -1092,9 +1092,8 @@ static int saa5246a_probe(struct i2c_cli
 	/* Register it */
 	err = video_register_device(t->vdev, VFL_TYPE_VTX, -1);
 	if (err < 0) {
-		kfree(t);
 		video_device_release(t->vdev);
-		t->vdev = NULL;
+		kfree(t);
 		return err;
 	}
 	return 0;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch

