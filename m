From: akpm@osdl.org
Subject: - dm-ioctl-add-noflush-suspend.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:16 -0800
Message-ID: <200612082015.kB8KFGxS003285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59981 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947077AbWLHUPZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-ueda@ct.jp.nec.com, agk@redhat.com, j-nomura@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     dm: ioctl: add noflush suspend
has been removed from the -mm tree.  Its filename was
     dm-ioctl-add-noflush-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: ioctl: add noflush suspend
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Provide a dm ioctl option to request noflush suspending.  (See next patch for
what this is for.) As the interface is extended, the version number is
incremented.

Other than accepting the new option through the interface, There is no change
to existing behaviour.

Test results:
Confirmed the option is given from user-space correctly.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-ioctl.c    |    4 ++++
 drivers/md/dm.h          |    1 +
 include/linux/dm-ioctl.h |    9 +++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-ioctl-add-noflush-suspend drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-ioctl-add-noflush-suspend
+++ a/drivers/md/dm-ioctl.c
@@ -774,6 +774,8 @@ static int do_suspend(struct dm_ioctl *p
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
 		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+	if (param->flags & DM_NOFLUSH_FLAG)
+		suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 
 	if (!dm_suspended(md))
 		r = dm_suspend(md, suspend_flags);
@@ -815,6 +817,8 @@ static int do_resume(struct dm_ioctl *pa
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+		if (param->flags & DM_NOFLUSH_FLAG)
+			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended(md))
 			dm_suspend(md, suspend_flags);
 
diff -puN drivers/md/dm.h~dm-ioctl-add-noflush-suspend drivers/md/dm.h
--- a/drivers/md/dm.h~dm-ioctl-add-noflush-suspend
+++ a/drivers/md/dm.h
@@ -47,6 +47,7 @@
  * Suspend feature flags
  */
 #define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
 
 /*
  * List of devices that a metadevice uses and should open/close.
diff -puN include/linux/dm-ioctl.h~dm-ioctl-add-noflush-suspend include/linux/dm-ioctl.h
--- a/include/linux/dm-ioctl.h~dm-ioctl-add-noflush-suspend
+++ a/include/linux/dm-ioctl.h
@@ -285,9 +285,9 @@ typedef char ioctl_struct[308];
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	10
+#define DM_VERSION_MINOR	11
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2006-09-14)"
+#define DM_VERSION_EXTRA	"-ioctl (2006-10-12)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -323,4 +323,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_NOFLUSH_FLAG		(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
_

Patches currently in -mm which might be from k-ueda@ct.jp.nec.com are

dm-ioctl-add-noflush-suspend.patch
dm-suspend-add-noflush-pushback.patch
dm-mpath-use-noflush-suspending.patch

