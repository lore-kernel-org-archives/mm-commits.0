From: akpm@linux-foundation.org
Subject: + drivers-media-video-saa5249c-fix-use-after-free-and-leak.patch added to -mm tree
Date: Tue, 14 Apr 2009 15:50:33 -0700
Message-ID: <200904142250.n3EMoXRi007234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbZDNWxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 18:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     drivers/media/video/saa5249.c: fix use-after-free and leak
has been added to the -mm tree.  Its filename is
     drivers-media-video-saa5249c-fix-use-after-free-and-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/saa5249.c: fix use-after-free and leak
From: Dan Carpenter <error27@gmail.com>

I moved the kfree() down a couple lines.  t->vdev is going to be in freed
memory so there is no point setting it to NULL.  I added a kfree(t) on a
different error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa5249.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/saa5249.c~drivers-media-video-saa5249c-fix-use-after-free-and-leak drivers/media/video/saa5249.c
--- a/drivers/media/video/saa5249.c~drivers-media-video-saa5249c-fix-use-after-free-and-leak
+++ a/drivers/media/video/saa5249.c
@@ -598,6 +598,7 @@ static int saa5249_probe(struct i2c_clie
 	/* Now create a video4linux device */
 	t->vdev = video_device_alloc();
 	if (t->vdev == NULL) {
+		kfree(t);
 		kfree(client);
 		return -ENOMEM;
 	}
@@ -617,9 +618,8 @@ static int saa5249_probe(struct i2c_clie
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

origin.patch
linux-next.patch
drivers-media-video-saa5249c-fix-use-after-free-and-leak.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch

