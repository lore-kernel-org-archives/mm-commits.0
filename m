From: akpm@linux-foundation.org
Subject: [merged] autofs-add-command-enum-macros-for-root-dir-ioctls.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:50 -0800
Message-ID: <58b5e26e.5iKvLdMCHtz5BDrX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: add command enum/macros for root-dir ioctls
has been removed from the -mm tree.  Its filename was
     autofs-add-command-enum-macros-for-root-dir-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: add command enum/macros for root-dir ioctls

Sync root-dir ioctl with misc-char-dev ioctl's enum/macro format since
these two types of ioctls aren't completely independent of each other in
terms of command nr.  No functional changes.

Link: http://lkml.kernel.org/r/148577166143.9801.15511796506678428145.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    2 --
 include/uapi/linux/auto_fs.h        |   25 ++++++++++++++++++-------
 include/uapi/linux/auto_fs4.h       |   16 +++++++++++-----
 3 files changed, 29 insertions(+), 14 deletions(-)

diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-add-command-enum-macros-for-root-dir-ioctls include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-add-command-enum-macros-for-root-dir-ioctls
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -156,8 +156,6 @@ enum {
 	AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD,
 };
 
-#define AUTOFS_IOCTL 0x93
-
 #define AUTOFS_DEV_IOCTL_VERSION \
 	_IOWR(AUTOFS_IOCTL, \
 	      AUTOFS_DEV_IOCTL_VERSION_CMD, struct autofs_dev_ioctl)
diff -puN include/uapi/linux/auto_fs.h~autofs-add-command-enum-macros-for-root-dir-ioctls include/uapi/linux/auto_fs.h
--- a/include/uapi/linux/auto_fs.h~autofs-add-command-enum-macros-for-root-dir-ioctls
+++ a/include/uapi/linux/auto_fs.h
@@ -61,12 +61,23 @@ struct autofs_packet_expire {
 	char name[NAME_MAX+1];
 };
 
-#define AUTOFS_IOC_READY      _IO(0x93, 0x60)
-#define AUTOFS_IOC_FAIL       _IO(0x93, 0x61)
-#define AUTOFS_IOC_CATATONIC  _IO(0x93, 0x62)
-#define AUTOFS_IOC_PROTOVER   _IOR(0x93, 0x63, int)
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93, 0x64, compat_ulong_t)
-#define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93, 0x64, unsigned long)
-#define AUTOFS_IOC_EXPIRE     _IOR(0x93, 0x65, struct autofs_packet_expire)
+#define AUTOFS_IOCTL 0x93
+
+enum {
+	AUTOFS_IOC_READY_CMD = 0x60,
+	AUTOFS_IOC_FAIL_CMD,
+	AUTOFS_IOC_CATATONIC_CMD,
+	AUTOFS_IOC_PROTOVER_CMD,
+	AUTOFS_IOC_SETTIMEOUT_CMD,
+	AUTOFS_IOC_EXPIRE_CMD,
+};
+
+#define AUTOFS_IOC_READY        _IO(AUTOFS_IOCTL, AUTOFS_IOC_READY_CMD)
+#define AUTOFS_IOC_FAIL         _IO(AUTOFS_IOCTL, AUTOFS_IOC_FAIL_CMD)
+#define AUTOFS_IOC_CATATONIC    _IO(AUTOFS_IOCTL, AUTOFS_IOC_CATATONIC_CMD)
+#define AUTOFS_IOC_PROTOVER     _IOR(AUTOFS_IOCTL, AUTOFS_IOC_PROTOVER_CMD, int)
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(AUTOFS_IOCTL, AUTOFS_IOC_SETTIMEOUT_CMD, compat_ulong_t)
+#define AUTOFS_IOC_SETTIMEOUT   _IOWR(AUTOFS_IOCTL, AUTOFS_IOC_SETTIMEOUT_CMD, unsigned long)
+#define AUTOFS_IOC_EXPIRE       _IOR(AUTOFS_IOCTL, AUTOFS_IOC_EXPIRE_CMD, struct autofs_packet_expire)
 
 #endif /* _UAPI_LINUX_AUTO_FS_H */
diff -puN include/uapi/linux/auto_fs4.h~autofs-add-command-enum-macros-for-root-dir-ioctls include/uapi/linux/auto_fs4.h
--- a/include/uapi/linux/auto_fs4.h~autofs-add-command-enum-macros-for-root-dir-ioctls
+++ a/include/uapi/linux/auto_fs4.h
@@ -148,10 +148,16 @@ union autofs_v5_packet_union {
 	autofs_packet_expire_direct_t expire_direct;
 };
 
-#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93, 0x66, int)
-#define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93, 0x67, int)
-#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93, 0x70, int)
+enum {
+	AUTOFS_IOC_EXPIRE_MULTI_CMD = 0x66, /* AUTOFS_IOC_EXPIRE_CMD + 1 */
+	AUTOFS_IOC_PROTOSUBVER_CMD,
+	AUTOFS_IOC_ASKUMOUNT_CMD = 0x70, /* AUTOFS_DEV_IOCTL_VERSION_CMD - 1 */
+};
+
+#define AUTOFS_IOC_EXPIRE_MULTI    _IOW(AUTOFS_IOCTL, AUTOFS_IOC_EXPIRE_MULTI_CMD, int)
+#define AUTOFS_IOC_EXPIRE_INDIRECT AUTOFS_IOC_EXPIRE_MULTI
+#define AUTOFS_IOC_EXPIRE_DIRECT   AUTOFS_IOC_EXPIRE_MULTI
+#define AUTOFS_IOC_PROTOSUBVER     _IOR(AUTOFS_IOCTL, AUTOFS_IOC_PROTOSUBVER_CMD, int)
+#define AUTOFS_IOC_ASKUMOUNT       _IOR(AUTOFS_IOCTL, AUTOFS_IOC_ASKUMOUNT_CMD, int)
 
 #endif /* _LINUX_AUTO_FS4_H */
_

Patches currently in -mm which might be from tkusumi@tuxera.com are


