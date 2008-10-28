From: akpm@linux-foundation.org
Subject: - linux-video_deencoderh-cleanup-for-userspace.patch removed from -mm tree
Date: Mon, 27 Oct 2008 20:31:23 -0700
Message-ID: <200810280331.m9S3VOnE029565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYJ1Db1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 23:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     linux/video_{de,en}coder.h: cleanup for userspace
has been removed from the -mm tree.  Its filename was
     linux-video_deencoderh-cleanup-for-userspace.patch

This patch was dropped because it had testing failures

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
maintainers-add-ltp-info-to-the-list.patch

