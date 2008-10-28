From: akpm@linux-foundation.org
Subject: + linux-video_deencoderh-cleanup-for-userspace.patch added to -mm tree
Date: Mon, 27 Oct 2008 20:29:18 -0700
Message-ID: <200810280329.m9S3TI2L028889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbYJ1D3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 23:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, mchehab@infradead.org


The patch titled
     linux/video_{de,en}coder.h: cleanup for userspace
has been added to the -mm tree.  Its filename is
     linux-video_deencoderh-cleanup-for-userspace.patch

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
Subject: linux/video_{de,en}coder.h: cleanup for userspace
From: Mike Frysinger <vapier@gentoo.org>

Make sure the linux/video_{de,en}coder.h header files include other header
files that they use (for types and structures).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/video_decoder.h |    3 +++
 include/linux/video_encoder.h |    2 ++
 2 files changed, 5 insertions(+)

diff -puN include/linux/video_decoder.h~linux-video_deencoderh-cleanup-for-userspace include/linux/video_decoder.h
--- a/include/linux/video_decoder.h~linux-video_deencoderh-cleanup-for-userspace
+++ a/include/linux/video_decoder.h
@@ -1,6 +1,9 @@
 #ifndef _LINUX_VIDEO_DECODER_H
 #define _LINUX_VIDEO_DECODER_H
 
+#include <linux/types.h>
+#include <linux/videodev.h>
+
 #define HAVE_VIDEO_DECODER 1
 
 struct video_decoder_capability { /* this name is too long */
diff -puN include/linux/video_encoder.h~linux-video_deencoderh-cleanup-for-userspace include/linux/video_encoder.h
--- a/include/linux/video_encoder.h~linux-video_deencoderh-cleanup-for-userspace
+++ a/include/linux/video_encoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_ENCODER_H
 #define _LINUX_VIDEO_ENCODER_H
 
+#include <linux/types.h>
+
 struct video_encoder_capability { /* this name is too long */
 	__u32	flags;
 #define	VIDEO_ENCODER_PAL	1	/* can encode PAL signal */
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-video_deencoderh-cleanup-for-userspace.patch
linux-timexh-cleanup-for-userspace.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
setlocalversion-dont-include-svn-change-count.patch

