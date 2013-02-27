From: akpm@linux-foundation.org
Subject: [merged] fs-change-return-values-from-eacces-to-eperm.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:51:11 -0800
Message-ID: <20130227205112.19D365A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61351 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3B0UvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:13 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so127757qaj.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaohongjiang@huawei.com, jack@suse.cz, raven@themaw.net, swhiteho@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: change return values from -EACCES to -EPERM
has been removed from the -mm tree.  Its filename was
     fs-change-return-values-from-eacces-to-eperm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: fs: change return values from -EACCES to -EPERM

According to SUSv3:

[EACCES] Permission denied. An attempt was made to access a file in a way
forbidden by its file access permissions.

[EPERM] Operation not permitted. An attempt was made to perform an operation
limited to processes with appropriate privileges or to the owner of a file
or other resource.

So -EPERM should be returned if capability checks fails.

Strictly speaking this is an API change since the error code user sees is
altered.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 fs/dlm/config.c   |    2 +-
 fs/gfs2/sys.c     |   18 +++++++++---------
 fs/ncpfs/ioctl.c  |    2 +-
 fs/proc/base.c    |    6 +++---
 fs/udf/file.c     |    2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/autofs4/root.c~fs-change-return-values-from-eacces-to-eperm fs/autofs4/root.c
--- a/fs/autofs4/root.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/autofs4/root.c
@@ -587,7 +587,7 @@ static int autofs4_dir_unlink(struct ino
 	
 	/* This allows root to remove symlinks */
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
diff -puN fs/dlm/config.c~fs-change-return-values-from-eacces-to-eperm fs/dlm/config.c
--- a/fs/dlm/config.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/dlm/config.c
@@ -158,7 +158,7 @@ static ssize_t cluster_set(struct dlm_cl
 	unsigned int x;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	x = simple_strtoul(buf, NULL, 0);
 
diff -puN fs/gfs2/sys.c~fs-change-return-values-from-eacces-to-eperm fs/gfs2/sys.c
--- a/fs/gfs2/sys.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/gfs2/sys.c
@@ -103,7 +103,7 @@ static ssize_t freeze_store(struct gfs2_
 	int n = simple_strtol(buf, NULL, 0);
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	switch (n) {
 	case 0:
@@ -133,7 +133,7 @@ static ssize_t withdraw_show(struct gfs2
 static ssize_t withdraw_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -148,7 +148,7 @@ static ssize_t statfs_sync_store(struct 
 				 size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -161,7 +161,7 @@ static ssize_t quota_sync_store(struct g
 				size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -178,7 +178,7 @@ static ssize_t quota_refresh_user_store(
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	id = simple_strtoul(buf, NULL, 0);
 
@@ -198,7 +198,7 @@ static ssize_t quota_refresh_group_store
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	id = simple_strtoul(buf, NULL, 0);
 
@@ -221,7 +221,7 @@ static ssize_t demote_rq_store(struct gf
 	int rv;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	rv = sscanf(buf, "%u:%llu %15s", &gltype, &glnum,
 		    mode);
@@ -532,7 +532,7 @@ static ssize_t quota_scale_store(struct 
 	unsigned int x, y;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (sscanf(buf, "%u %u", &x, &y) != 2 || !y)
 		return -EINVAL;
@@ -551,7 +551,7 @@ static ssize_t tune_set(struct gfs2_sbd 
 	unsigned int x;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	x = simple_strtoul(buf, NULL, 0);
 
diff -puN fs/ncpfs/ioctl.c~fs-change-return-values-from-eacces-to-eperm fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/ncpfs/ioctl.c
@@ -822,7 +822,7 @@ long ncp_ioctl(struct file *filp, unsign
 	case NCP_IOC_CONN_LOGGED_IN:
 	case NCP_IOC_SETROOT:
 		if (!capable(CAP_SYS_ADMIN)) {
-			ret = -EACCES;
+			ret = -EPERM;
 			goto out;
 		}
 		break;
diff -puN fs/proc/base.c~fs-change-return-values-from-eacces-to-eperm fs/proc/base.c
--- a/fs/proc/base.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/proc/base.c
@@ -1711,7 +1711,7 @@ static int map_files_d_revalidate(struct
 		return -ECHILD;
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		status = -EACCES;
+		status = -EPERM;
 		goto out_notask;
 	}
 
@@ -1844,7 +1844,7 @@ static struct dentry *proc_map_files_loo
 	struct dentry *result;
 	struct mm_struct *mm;
 
-	result = ERR_PTR(-EACCES);
+	result = ERR_PTR(-EPERM);
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
@@ -1900,7 +1900,7 @@ proc_map_files_readdir(struct file *filp
 	ino_t ino;
 	int ret;
 
-	ret = -EACCES;
+	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
diff -puN fs/udf/file.c~fs-change-return-values-from-eacces-to-eperm fs/udf/file.c
--- a/fs/udf/file.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/udf/file.c
@@ -204,7 +204,7 @@ long udf_ioctl(struct file *filp, unsign
 		goto out;
 	case UDF_RELOCATE_BLOCKS:
 		if (!capable(CAP_SYS_ADMIN)) {
-			result = -EACCES;
+			result = -EPERM;
 			goto out;
 		}
 		if (get_user(old_block, (long __user *)arg)) {
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
linux-next.patch

