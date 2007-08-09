From: akpm@linux-foundation.org
Subject: + v4l-add-additional-ioctls-to-compat_ioctl32.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:17:43 -0700
Message-ID: <200708091917.l79JHhun015006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759925AbXHITRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stevenrwalter@gmail.com


The patch titled
     V4L: Add additional ioctls to compat_ioctl32
has been added to the -mm tree.  Its filename is
     v4l-add-additional-ioctls-to-compat_ioctl32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

v4l-add-additional-ioctls-to-compat_ioctl32.patch
