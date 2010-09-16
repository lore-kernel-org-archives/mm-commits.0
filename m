From: akpm@linux-foundation.org
Subject: + drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory.patch added to -mm tree
Date: Thu, 16 Sep 2010 14:06:50 -0700
Message-ID: <201009162106.o8GL6oRT013584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755510Ab0IPVHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 17:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, stable@kernel.org, thomas@winischhofer.net


The patch titled
     drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
has been added to the -mm tree.  Its filename is
     drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory.patch

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
Subject: drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>

The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16 bytes
of uninitialized stack memory, because the "reserved" member of the
fb_vblank struct declared on the stack is not altered or zeroed before
being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/sis/sis_main.c~drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory
+++ a/drivers/video/sis/sis_main.c
@@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *i
 		break;
 
 	   case FBIOGET_VBLANK:
+
+		memset(&sisvbblank, 0, sizeof(struct fb_vblank));
+
 		sisvbblank.count = 0;
 		sisvbblank.flags = sisfb_setupvbblankflags(ivideo, &sisvbblank.vcount, &sisvbblank.hcount);
 
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

linux-next.patch
drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch
drivers-video-sis-sis_mainc-prevent-reading-uninitialized-stack-memory.patch
drivers-char-amiserialc-prevent-reading-uninitialized-stack-memory.patch
drivers-char-nozomic-prevent-reading-uninitialized-stack-memory.patch

