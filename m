From: akpm@linux-foundation.org
Subject: - v4l-usbvideo-fix-module-ref-count-check.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:43 -0800
Message-ID: <200812291918.mBTJIhoQ030983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbYL2TXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: usbvideo, fix module ref count check
has been removed from the -mm tree.  Its filename was
     v4l-usbvideo-fix-module-ref-count-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
8250_pci-add-support-for-netmos-9835.patch
dmi-add-dmi_match.patch
ata-piix-cleanup-dmi-strings-checking.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

