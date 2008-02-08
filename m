From: akpm@linux-foundation.org
Subject: - mount-options-fix-capifs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:46 -0800
Message-ID: <200802082019.m18KJRK5011049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935364AbYBHUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     mount options: fix capifs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-capifs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix capifs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to capifs.

Use generic_show_options() and save the complete option string in
capifs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capifs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/isdn/capi/capifs.c~mount-options-fix-capifs drivers/isdn/capi/capifs.c
--- a/drivers/isdn/capi/capifs.c~mount-options-fix-capifs
+++ a/drivers/isdn/capi/capifs.c
@@ -52,6 +52,7 @@ static int capifs_remount(struct super_b
 	gid_t gid = 0;
 	umode_t mode = 0600;
 	char *this_char;
+	char *new_opt = kstrdup(data, GFP_KERNEL);
 
 	this_char = NULL;
 	while ((this_char = strsep(&data, ",")) != NULL) {
@@ -72,11 +73,16 @@ static int capifs_remount(struct super_b
 			return -EINVAL;
 		}
 	}
+
+	kfree(s->s_options);
+	s->s_options = new_opt;
+
 	config.setuid  = setuid;
 	config.setgid  = setgid;
 	config.uid     = uid;
 	config.gid     = gid;
 	config.mode    = mode;
+
 	return 0;
 }
 
@@ -84,6 +90,7 @@ static struct super_operations capifs_so
 {
 	.statfs		= simple_statfs,
 	.remount_fs	= capifs_remount,
+	.show_options	= generic_show_options,
 };
 
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
