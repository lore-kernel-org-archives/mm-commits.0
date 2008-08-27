From: akpm@linux-foundation.org
Subject: + v4l-fix-return-value-of-meye-probe-callback.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:09:01 -0700
Message-ID: <200808272009.m7RK91Qi019850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbYH0UJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de


The patch titled
     v4l: fix return value of meye probe callback
has been added to the -mm tree.  Its filename is
     v4l-fix-return-value-of-meye-probe-callback.patch

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
Subject: v4l: fix return value of meye probe callback
From: Henrik Kretzschmar <henne@nachtwindheim.de>

The return value of the probe function should return -ENOMEM instead of
-EBUSY if video_device_alloc() fails.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/meye.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/meye.c~v4l-fix-return-value-of-meye-probe-callback drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~v4l-fix-return-value-of-meye-probe-callback
+++ a/drivers/media/video/meye.c
@@ -1779,6 +1779,7 @@ static int __devinit meye_probe(struct p
 		goto outnotdev;
 	}
 
+	ret = -ENOMEM;
 	meye.mchip_dev = pcidev;
 	meye.video_dev = video_device_alloc();
 	if (!meye.video_dev) {
@@ -1786,7 +1787,6 @@ static int __devinit meye_probe(struct p
 		goto outnotdev;
 	}
 
-	ret = -ENOMEM;
 	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
 	if (!meye.grab_temp) {
 		printk(KERN_ERR "meye: grab buffer allocation failed\n");
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
v4l-fix-return-value-of-meye-probe-callback.patch

