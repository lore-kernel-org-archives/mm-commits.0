From: akpm@linux-foundation.org
Subject: + drivers-media-video-v4l2-ctrlsc-fix-build.patch added to -mm tree
Date: Thu, 12 Aug 2010 14:24:49 -0700
Message-ID: <201008122124.o7CLOnCK013513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760718Ab0HLVY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 17:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee, mchehab@infradead.org


The patch titled
     drivers/media/video/v4l2-ctrls.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-media-video-v4l2-ctrlsc-fix-build.patch

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
Subject: drivers/media/video/v4l2-ctrls.c: fix build
From: Meelis Roos <mroos@linux.ee>

Current git has broken v4l2-ctrls compilation - kzalloc et al are missing
prototypes.  Fix it by including linux/slab.h that contains the
definitions.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l2-ctrls.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/v4l2-ctrls.c~drivers-media-video-v4l2-ctrlsc-fix-build drivers/media/video/v4l2-ctrls.c
--- a/drivers/media/video/v4l2-ctrls.c~drivers-media-video-v4l2-ctrlsc-fix-build
+++ a/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
_

Patches currently in -mm which might be from mroos@linux.ee are

drivers-media-video-v4l2-ctrlsc-fix-build.patch

