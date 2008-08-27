From: akpm@linux-foundation.org
Subject: + v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:09:27 -0700
Message-ID: <200808272009.m7RK9R7L019860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYH0UJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:09:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de


The patch titled
     v4l: fix retval in vivi driver for more than one device
has been added to the -mm tree.  Its filename is
     v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: fix retval in vivi driver for more than one device
From: Henrik Kretzschmar <henne@nachtwindheim.de>

The variable ret should be set for each device to -ENOMEM, not only the
first.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/vivi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/vivi.c~v4l-fix-retval-in-vivi-driver-for-more-than-one-device drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~v4l-fix-retval-in-vivi-driver-for-more-than-one-device
+++ a/drivers/media/video/vivi.c
@@ -1111,11 +1111,12 @@ static struct video_device vivi_template
 
 static int __init vivi_init(void)
 {
-	int ret = -ENOMEM, i;
+	int ret, i;
 	struct vivi_dev *dev;
 	struct video_device *vfd;
 
 	for (i = 0; i < n_devs; i++) {
+		ret = -ENOMEM;
 		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 		if (NULL == dev)
 			break;
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
v4l-fix-return-value-of-meye-probe-callback.patch
v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch

