From: akpm@linux-foundation.org
Subject: - change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:10 -0700
Message-ID: <200710180701.l9I71App031155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbXJRHTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:19:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: major@openvz.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     change inotifyfs magic as the same magic is used for futexfs
has been removed from the -mm tree.  Its filename was
     change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change inotifyfs magic as the same magic is used for futexfs
From: Andrey Mirkin <major@openvz.org>

Right now futexfs and inotifyfs have one magic 0xBAD1DEA, that looks a
little bit confusing.  Use 0xBAD1DEA as magic for futexfs and 0x2BAD1DEA as
magic for inotifyfs.

Signed-off-by: Andrey Mirkin <major@openvz.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c     |    4 +++-
 include/linux/magic.h |    3 +++
 kernel/futex.c        |    3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/inotify_user.c~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2 fs/inotify_user.c
--- a/fs/inotify_user.c~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2
+++ a/fs/inotify_user.c
@@ -31,6 +31,7 @@
 #include <linux/list.h>
 #include <linux/inotify.h>
 #include <linux/syscalls.h>
+#include <linux/magic.h>
 
 #include <asm/ioctls.h>
 
@@ -684,7 +685,8 @@ static int
 inotify_get_sb(struct file_system_type *fs_type, int flags,
 	       const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "inotify", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "inotify", NULL,
+			INOTIFYFS_SUPER_MAGIC, mnt);
 }
 
 static struct file_system_type inotify_fs_type = {
diff -puN include/linux/magic.h~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2 include/linux/magic.h
--- a/include/linux/magic.h~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2
+++ a/include/linux/magic.h
@@ -38,4 +38,7 @@
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
 
+#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
+#define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
+
 #endif /* __LINUX_MAGIC_H__ */
diff -puN kernel/futex.c~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2 kernel/futex.c
--- a/kernel/futex.c~change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2
+++ a/kernel/futex.c
@@ -52,6 +52,7 @@
 #include <linux/syscalls.h>
 #include <linux/signal.h>
 #include <linux/module.h>
+#include <linux/magic.h>
 #include <asm/futex.h>
 
 #include "rtmutex_common.h"
@@ -2080,7 +2081,7 @@ static int futexfs_get_sb(struct file_sy
 			  int flags, const char *dev_name, void *data,
 			  struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "futex", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "futex", NULL, FUTEXFS_SUPER_MAGIC, mnt);
 }
 
 static struct file_system_type futex_fs_type = {
_

Patches currently in -mm which might be from major@openvz.org are

origin.patch
