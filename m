From: akpm@linux-foundation.org
Subject: - v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch removed from -mm tree
Date: Wed, 03 Sep 2008 08:32:26 -0700
Message-ID: <200809031532.m83FWQGH022207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYICPdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 11:33:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     v4l: fix retval in vivi driver for more than one device
has been removed from the -mm tree.  Its filename was
     v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch

This patch was dropped because an alternative patch was merged

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
@@ -1120,7 +1120,7 @@ static struct video_device vivi_template
  */
 static int __init vivi_init(void)
 {
-	int ret = -ENOMEM, i;
+	int ret, i;
 	struct vivi_dev *dev;
 	struct video_device *vfd;
 
@@ -1128,6 +1128,7 @@ static int __init vivi_init(void)
 		n_devs = 1;
 
 	for (i = 0; i < n_devs; i++) {
+		ret = -ENOMEM;
 		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 		if (!dev)
 			break;
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
v4l-fix-retval-in-vivi-driver-for-more-than-one-device.patch

