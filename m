From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:19 -0700
Message-ID: <20120731185519.C93661E006E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2GaSzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:21 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, dcb314@hotmail.com, hans.verkuil@cisco.com, leonidsbox@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/video/cx25821/cx25821-medusa-video.c: incorrect check on decoder type
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/media/video/cx25821/cx25821-medusa-video.c: incorrect check on decoder type

Unsupported requests should be ignored but in fact affected VDEC_A

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44051

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx25821/cx25821-medusa-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx25821/cx25821-medusa-video.c~drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type drivers/media/video/cx25821/cx25821-medusa-video.c
--- a/drivers/media/video/cx25821/cx25821-medusa-video.c~drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type
+++ a/drivers/media/video/cx25821/cx25821-medusa-video.c
@@ -499,7 +499,7 @@ static void medusa_set_decoderduration(s
 	mutex_lock(&dev->lock);
 
 	/* no support */
-	if (decoder < VDEC_A && decoder > VDEC_H) {
+	if (decoder < VDEC_A || decoder > VDEC_H) {
 		mutex_unlock(&dev->lock);
 		return;
 	}
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

