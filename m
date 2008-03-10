From: akpm@linux-foundation.org
Subject: - v4l1-fix-v4l_compat_translate_ioctl-possible-null-deref.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:21 -0700
Message-ID: <200803101805.m2AI5LIr030083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbYCJSGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     V4L1: fix v4l_compat_translate_ioctl possible NULL deref
has been removed from the -mm tree.  Its filename was
     v4l1-fix-v4l_compat_translate_ioctl-possible-null-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: V4L1: fix v4l_compat_translate_ioctl possible NULL deref
From: Cyrill Gorcunov <gorcunov@gmail.com>

There are possible NULL pointer derefs in case of kzalloc fails so fix them.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l1-compat.c |   50 ++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff -puN drivers/media/video/v4l1-compat.c~v4l1-fix-v4l_compat_translate_ioctl-possible-null-deref drivers/media/video/v4l1-compat.c
--- a/drivers/media/video/v4l1-compat.c~v4l1-fix-v4l_compat_translate_ioctl-possible-null-deref
+++ a/drivers/media/video/v4l1-compat.c
@@ -303,7 +303,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_capability *cap = arg;
 
-		cap2 = kzalloc(sizeof(*cap2),GFP_KERNEL);
+		cap2 = kzalloc(sizeof(*cap2), GFP_KERNEL);
+		if (!cap2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(cap, 0, sizeof(*cap));
 		memset(&fbuf2, 0, sizeof(fbuf2));
 
@@ -426,7 +430,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_window	*win = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(win,0,sizeof(*win));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
@@ -464,7 +472,11 @@ v4l_compat_translate_ioctl(struct inode 
 		struct video_window	*win = arg;
 		int err1,err2;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		drv(inode, file, VIDIOC_STREAMOFF, &fmt2->type);
 		err1 = drv(inode, file, VIDIOC_G_FMT, fmt2);
@@ -586,6 +598,12 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_picture	*pict = arg;
 
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
+
 		pict->brightness = get_v4l_control(inode, file,
 						   V4L2_CID_BRIGHTNESS,drv);
 		pict->hue = get_v4l_control(inode, file,
@@ -597,7 +615,6 @@ v4l_compat_translate_ioctl(struct inode 
 		pict->whiteness = get_v4l_control(inode, file,
 						  V4L2_CID_WHITENESS, drv);
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0) {
@@ -617,6 +634,11 @@ v4l_compat_translate_ioctl(struct inode 
 		struct video_picture	*pict = arg;
 		int mem_err = 0, ovl_err = 0;
 
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(&fbuf2, 0, sizeof(fbuf2));
 
 		set_v4l_control(inode, file,
@@ -636,7 +658,6 @@ v4l_compat_translate_ioctl(struct inode 
 		 * different pixel formats for memory vs overlay.
 		 */
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		/* If VIDIOC_G_FMT failed, then the driver likely doesn't
@@ -890,7 +911,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct video_mmap	*mm = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		memset(&buf2,0,sizeof(buf2));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -986,7 +1011,11 @@ v4l_compat_translate_ioctl(struct inode 
 	{
 		struct vbi_format      *fmt = arg;
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
+		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
+		if (!fmt2) {
+			err = -ENOMEM;
+			break;
+		}
 		fmt2->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
@@ -1018,8 +1047,11 @@ v4l_compat_translate_ioctl(struct inode 
 			break;
 		}
 
-		fmt2 = kzalloc(sizeof(*fmt2),GFP_KERNEL);
