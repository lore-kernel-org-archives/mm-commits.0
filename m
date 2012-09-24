From: akpm@linux-foundation.org
Subject: + fs-change-return-values-from-eacces-to-eperm.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:09:09 -0700
Message-ID: <20120924220910.67F8E200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52094 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2IXWJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:09:13 -0400
Received: by eekb57 with SMTP id b57so145864eek.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:09:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaohongjiang@huawei.com, jack@suse.cz, raven@themaw.net, swhiteho@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: change return values from -EACCES to -EPERM
has been added to the -mm tree.  Its filename is
     fs-change-return-values-from-eacces-to-eperm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -581,7 +581,7 @@ static int autofs4_dir_unlink(struct ino
 	
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
@@ -107,7 +107,7 @@ static ssize_t freeze_store(struct gfs2_
 	int n = simple_strtol(buf, NULL, 0);
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	switch (n) {
 	case 0:
@@ -135,7 +135,7 @@ static ssize_t withdraw_show(struct gfs2
 static ssize_t withdraw_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -150,7 +150,7 @@ static ssize_t statfs_sync_store(struct 
 				 size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -163,7 +163,7 @@ static ssize_t quota_sync_store(struct g
 				size_t len)
 {
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
@@ -179,7 +179,7 @@ static ssize_t quota_refresh_user_store(
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	id = simple_strtoul(buf, NULL, 0);
 
@@ -194,7 +194,7 @@ static ssize_t quota_refresh_group_store
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	id = simple_strtoul(buf, NULL, 0);
 
@@ -213,7 +213,7 @@ static ssize_t demote_rq_store(struct gf
 	int rv;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	rv = sscanf(buf, "%u:%llu %15s", &gltype, &glnum,
 		    mode);
@@ -502,7 +502,7 @@ static ssize_t quota_scale_store(struct 
 	unsigned int x, y;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	if (sscanf(buf, "%u %u", &x, &y) != 2 || !y)
 		return -EINVAL;
@@ -521,7 +521,7 @@ static ssize_t tune_set(struct gfs2_sbd 
 	unsigned int x;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
+		return -EPERM;
 
 	x = simple_strtoul(buf, NULL, 0);
 
diff -puN fs/ncpfs/ioctl.c~fs-change-return-values-from-eacces-to-eperm fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~fs-change-return-values-from-eacces-to-eperm
+++ a/fs/ncpfs/ioctl.c
@@ -819,7 +819,7 @@ long ncp_ioctl(struct file *filp, unsign
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
@@ -1724,7 +1724,7 @@ static int map_files_d_revalidate(struct
 		return -ECHILD;
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		status = -EACCES;
+		status = -EPERM;
 		goto out_notask;
 	}
 
@@ -1857,7 +1857,7 @@ static struct dentry *proc_map_files_loo
 	struct dentry *result;
 	struct mm_struct *mm;
 
-	result = ERR_PTR(-EACCES);
+	result = ERR_PTR(-EPERM);
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
@@ -1912,7 +1912,7 @@ proc_map_files_readdir(struct file *filp
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

fs-change-return-values-from-eacces-to-eperm.patch

