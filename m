From: akpm@osdl.org
Subject: + use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:15:24 -0800
Message-ID: <200701290015.l0T0FORI006805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbXA2AP1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, greg@kroah.com


The patch titled
     use __u32 rather than u32 in userspace ioctls in usbdevice_fs.h
has been added to the -mm tree.  Its filename is
     use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __u32 rather than u32 in userspace ioctls in usbdevice_fs.h
From: Mike Frysinger <vapier@gentoo.org>

Use __u32 rather than u32 in userspace ioctl defines.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/usbdevice_fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/usbdevice_fs.h~use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh include/linux/usbdevice_fs.h
--- a/include/linux/usbdevice_fs.h~use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh
+++ a/include/linux/usbdevice_fs.h
@@ -159,9 +159,9 @@ struct usbdevfs_ioctl32 {
 #define USBDEVFS_SUBMITURB32       _IOR('U', 10, struct usbdevfs_urb32)
 #define USBDEVFS_DISCARDURB        _IO('U', 11)
 #define USBDEVFS_REAPURB           _IOW('U', 12, void *)
-#define USBDEVFS_REAPURB32         _IOW('U', 12, u32)
+#define USBDEVFS_REAPURB32         _IOW('U', 12, __u32)
 #define USBDEVFS_REAPURBNDELAY     _IOW('U', 13, void *)
-#define USBDEVFS_REAPURBNDELAY32   _IOW('U', 13, u32)
+#define USBDEVFS_REAPURBNDELAY32   _IOW('U', 13, __u32)
 #define USBDEVFS_DISCSIGNAL        _IOR('U', 14, struct usbdevfs_disconnectsignal)
 #define USBDEVFS_CLAIMINTERFACE    _IOR('U', 15, unsigned int)
 #define USBDEVFS_RELEASEINTERFACE  _IOR('U', 16, unsigned int)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
search-a-little-harder-for-mkimage.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
some-rtc-documentation-updates.patch
