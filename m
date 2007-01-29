From: akpm@osdl.org
Subject: + use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:14:22 -0800
Message-ID: <200701290014.l0T0EM0I006779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbXA2AO2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:14:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com


The patch titled
     use __u8 rather than u8 in userspace SIZE defines in hdreg.h
has been added to the -mm tree.  Its filename is
     use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __u8 rather than u8 in userspace SIZE defines in hdreg.h
From: Mike Frysinger <vapier@gentoo.org>

Use __u8 rather than u8 in SIZE defines exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hdreg.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/hdreg.h~use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh include/linux/hdreg.h
--- a/include/linux/hdreg.h~use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh
+++ a/include/linux/hdreg.h
@@ -60,13 +60,15 @@
 #define TAG_MASK		0xf8
 #endif /* __KERNEL__ */
 
+#include <linux/types.h>
+
 /*
  * Command Header sizes for IOCTL commands
  */
 
-#define HDIO_DRIVE_CMD_HDR_SIZE		(4 * sizeof(u8))
-#define HDIO_DRIVE_HOB_HDR_SIZE		(8 * sizeof(u8))
-#define HDIO_DRIVE_TASK_HDR_SIZE	(8 * sizeof(u8))
+#define HDIO_DRIVE_CMD_HDR_SIZE		(4 * sizeof(__u8))
+#define HDIO_DRIVE_HOB_HDR_SIZE		(8 * sizeof(__u8))
+#define HDIO_DRIVE_TASK_HDR_SIZE	(8 * sizeof(__u8))
 
 #define IDE_DRIVE_TASK_INVALID		-1
 #define IDE_DRIVE_TASK_NO_DATA		0
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
search-a-little-harder-for-mkimage.patch
some-rtc-documentation-updates.patch
