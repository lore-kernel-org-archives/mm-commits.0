From: akpm@osdl.org
Subject: - use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:40 -0800
Message-ID: <200701302146.l0ULkeiT030119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXA3Vqs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     use __u8 rather than u8 in userspace SIZE defines in hdreg.h
has been removed from the -mm tree.  Its filename was
     use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
translate-dashes-in-filenames-for-headers-install.patch
search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
use-__u32-in-asm-x86_64-msrh.patch
some-rtc-documentation-updates.patch
