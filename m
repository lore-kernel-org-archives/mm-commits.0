From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?ocfs2-roll-back-the-reference-count-modification-of-the-p?=
 =?US-ASCII?Q?arent-directory-if-an-error-occurs.patch?= removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:35:35 -0700
Message-ID: <20200403203535.nTLvMoz3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangjian161@huawei.com


The patch titled
     Subject: ocfs2: roll back the reference count modification of the parent directory if an error occurs
has been removed from the -mm tree.  Its filename was
     ocfs2-roll-back-the-reference-count-modification-of-the-parent-directory-if-an-error-occurs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: wangjian <wangjian161@huawei.com>
Subject: ocfs2: roll back the reference count modification of the parent directory if an error occurs

Under some conditions, the directory cannot be deleted.  The specific
scenarios are as follows: (for example, /mnt/ocfs2 is the mount point)

1. Create the /mnt/ocfs2/p_dir directory.  At this time, the i_nlink
   corresponding to the inode of the /mnt/ocfs2/p_dir directory is equal
   to 2.

2. During the process of creating the /mnt/ocfs2/p_dir/s_dir
   directory, if the call to the inc_nlink function in ocfs2_mknod
   succeeds, the functions such as ocfs2_init_acl,
   ocfs2_init_security_set, and ocfs2_dentry_attach_lock fail.  At this
   time, the i_nlink corresponding to the inode of the /mnt/ocfs2/p_dir
   directory is equal to 3, but /mnt/ocfs2/p_dir/s_dir is not added to the
   /mnt/ocfs2/p_dir directory entry.

3. Delete the /mnt/ocfs2/p_dir directory (rm -rf /mnt/ocfs2/p_dir). 
   At this time, it is found that the i_nlink corresponding to the inode
   corresponding to the /mnt/ocfs2/p_dir directory is equal to 3. 
   Therefore, the /mnt/ocfs2/p_dir directory cannot be deleted.

Link: http://lkml.kernel.org/r/a44f6666-bbc4-405e-0e6c-0f4e922eeef6@huawei.com
Signed-off-by: Jian wang <wangjian161@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-roll-back-the-reference-count-modification-of-the-parent-directory-if-an-error-occurs
+++ a/fs/ocfs2/namei.c
@@ -406,7 +406,7 @@ static int ocfs2_mknod(struct inode *dir
 
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto roll_back;
 	}
 
 	if (si.enable) {
@@ -414,7 +414,7 @@ static int ocfs2_mknod(struct inode *dir
 						 meta_ac, data_ac);
 		if (status < 0) {
 			mlog_errno(status);
-			goto leave;
+			goto roll_back;
 		}
 	}
 
@@ -427,7 +427,7 @@ static int ocfs2_mknod(struct inode *dir
 					  OCFS2_I(dir)->ip_blkno);
 	if (status) {
 		mlog_errno(status);
-		goto leave;
+		goto roll_back;
 	}
 
 	dl = dentry->d_fsdata;
@@ -437,12 +437,19 @@ static int ocfs2_mknod(struct inode *dir
 				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto roll_back;
 	}
 
 	insert_inode_hash(inode);
 	d_instantiate(dentry, inode);
 	status = 0;
+
+roll_back:
+	if (status < 0 && S_ISDIR(mode)) {
+		ocfs2_add_links_count(dirfe, -1);
+		drop_nlink(dir);
+	}
+
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
_

Patches currently in -mm which might be from wangjian161@huawei.com are
