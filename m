From: akpm@linux-foundation.org
Subject: + v4l-compat-layer-guard-a-divide.patch added to -mm tree
Date: Mon, 25 Oct 2010 15:45:11 -0700
Message-ID: <201010252245.o9PMjBC1020680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757479Ab0JYWpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 18:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@treblig.org, mchehab@infradead.org


The patch titled
     v4l compat layer: guard a divide
has been added to the -mm tree.  Its filename is
     v4l-compat-layer-guard-a-divide.patch

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
Subject: v4l compat layer: guard a divide
From: "Dr. David Alan Gilbert" <linux@treblig.org>

I managed to trigger a divide by 0 in the v4l compat code with the mem2mem
test module; I suspect perhaps it shouldn't have been returning a 0 pixel
wide picture, but either way it seems right to guard this divide by 0 in
the compatibility layer.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l1-compat.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/v4l1-compat.c~v4l-compat-layer-guard-a-divide drivers/media/video/v4l1-compat.c
--- a/drivers/media/video/v4l1-compat.c~v4l-compat-layer-guard-a-divide
+++ a/drivers/media/video/v4l1-compat.c
@@ -645,9 +645,16 @@ static noinline long v4l1_compat_get_pic
 		goto done;
 	}
 
-	pict->depth   = ((fmt->fmt.pix.bytesperline << 3)
-			 + (fmt->fmt.pix.width - 1))
-			 / fmt->fmt.pix.width;
+	if (fmt->fmt.pix.width)
+	{
+		pict->depth   = ((fmt->fmt.pix.bytesperline << 3)
+				 + (fmt->fmt.pix.width - 1))
+				 / fmt->fmt.pix.width;
+	} else {
+		err = -EINVAL;
+		goto done;
+	}
+
 	pict->palette = pixelformat_to_palette(
 		fmt->fmt.pix.pixelformat);
 done:
_

Patches currently in -mm which might be from linux@treblig.org are

origin.patch
v4l-compat-layer-guard-a-divide.patch

