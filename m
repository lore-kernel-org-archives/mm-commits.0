From: akpm@linux-foundation.org
Subject: + v4l-usbvideo-fix-module-ref-count-check.patch added to -mm tree
Date: Mon, 22 Dec 2008 14:38:23 -0800
Message-ID: <200812222238.mBMMcNgZ024695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbYLVWia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 17:38:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, mchehab@infradead.org


The patch titled
     v4l: usbvideo, fix module ref count check
has been added to the -mm tree.  Its filename is
     v4l-usbvideo-fix-module-ref-count-check.patch

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
Subject: v4l: usbvideo, fix module ref count check
From: Jiri Slaby <jirislaby@gmail.com>

usbvideo_ClientIncModCount may return value < 0 in the case of error, not > 0.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvideo/usbvideo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/usbvideo/usbvideo.c~v4l-usbvideo-fix-module-ref-count-check drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~v4l-usbvideo-fix-module-ref-count-check
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -1123,7 +1123,7 @@ static int usbvideo_v4l_open(struct inod
 	if (uvd->debug > 1)
 		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, dev);
 
-	if (0 < usbvideo_ClientIncModCount(uvd))
+	if (usbvideo_ClientIncModCount(uvd) < 0)
 		return -ENODEV;
 	mutex_lock(&uvd->lock);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
v4l-usbvideo-fix-module-ref-count-check.patch
maintainers-mark-linux-uvc-devel-as-subscribers-only.patch
8250_pci-add-support-for-netmos-9835.patch
dmi-add-dmi_match.patch
ata-piix-cleanup-dmi-strings-checking.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

