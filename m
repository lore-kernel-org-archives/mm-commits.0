From: akpm@linux-foundation.org
Subject: - v4l-add-additional-ioctls-to-compat_ioctl32.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:50:22 -0700
Message-ID: <200708092250.l79MoMOS023576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbXHIWuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stevenrwalter@gmail.com, mm-commits@vger.kernel.org


The patch titled
     V4L: Add additional ioctls to compat_ioctl32
has been removed from the -mm tree.  Its filename was
     v4l-add-additional-ioctls-to-compat_ioctl32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: V4L: Add additional ioctls to compat_ioctl32
From: Steven Walter <stevenrwalter@gmail.com>

With the addition of these ioctls, I'm able to watch TV with a 32-bit
version of tvtime on x86_64

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/compat_ioctl32.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/media/video/compat_ioctl32.c~v4l-add-additional-ioctls-to-compat_ioctl32 drivers/media/video/compat_ioctl32.c
--- a/drivers/media/video/compat_ioctl32.c~v4l-add-additional-ioctls-to-compat_ioctl32
+++ a/drivers/media/video/compat_ioctl32.c
@@ -848,6 +848,8 @@ long v4l_compat_ioctl32(struct file *fil
 	case VIDIOCSFREQ32:
 	case VIDIOCGAUDIO:
 	case VIDIOCSAUDIO:
+	case VIDIOCGVBIFMT:
+	case VIDIOCSVBIFMT:
 #endif
 	case VIDIOC_QUERYCAP:
 	case VIDIOC_ENUM_FMT:
@@ -874,7 +876,10 @@ long v4l_compat_ioctl32(struct file *fil
 	case VIDIOC_ENUMINPUT:
 	case VIDIOC_ENUMINPUT32:
 	case VIDIOC_G_CTRL:
+	case VIDIOC_S_CTRL:
 	case VIDIOC_S_CTRL32:
+	case VIDIOC_S_FREQUENCY:
+	case VIDIOC_G_FREQUENCY:
 	case VIDIOC_QUERYCTRL:
 	case VIDIOC_G_INPUT32:
 	case VIDIOC_S_INPUT32:
_

Patches currently in -mm which might be from stevenrwalter@gmail.com are

git-dvb.patch
