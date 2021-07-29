Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39051C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 18:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE2660EFF
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 18:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhG2SaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhG2SaJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 14:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB0C960F01;
        Thu, 29 Jul 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627583405;
        bh=afDsbpLvEQ7mOZtyjH4k60oJ6gyoVUiObgNaM4fFwJw=;
        h=Date:From:To:Subject:From;
        b=eYAsvVnMkIMKEKGY6r6vp94xZb9nt+eJQmkmeYN0QwBCurZKjaM4AJ2MTbHyEt6iO
         zr9eHznacgZmuwQmIGZyY9yx6Me3k+POEZ/0GOV68KoWWj5F2FhwK7ttva8T9WVbxn
         jso2fBnU8BOCMGo/Qq8mT/BPYt7sIRe6nYiK9ZKU=
Date:   Thu, 29 Jul 2021 11:30:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        gechangwei@live.cn, ghe@suse.com
Subject:  +
 =?us-ascii?Q?ocfs2-reflink-deadlock-when-clone-file-to-the-same-direct?=
 =?us-ascii?Q?ory-simultaneously.patch?= added to -mm tree
Message-ID: <20210729183003.eNJ1D%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: reflink deadlock when clone file to the same directory simultaneously
has been added to the -mm tree.  Its filename is
     ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: reflink deadlock when clone file to the same directory simultaneously

Running reflink from multiple nodes simultaneously to clone a file to the
same directory probably triggers a deadlock issue.  For example, there is
a three node ocfs2 cluster, each node mounts the ocfs2 file system to
/mnt/shared, and run the reflink command from each node repeatedly, like

  reflink "/mnt/shared/test" \
  "/mnt/shared/.snapshots/test.`date +%m%d%H%M%S`.`hostname`"
then, reflink command process will be hung on each node, and you
can't list this file system directory.
The problematic reflink command process is blocked at one node,
task:reflink         state:D stack:    0 pid: 1283 ppid:  4154
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0e3e000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_init_security_and_acl+0xbe/0x1d0 [ocfs2]
  ocfs2_reflink+0x436/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
The other reflink command processes are blocked at other nodes,
task:reflink         state:D stack:    0 pid:29759 ppid:  4088
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0b19000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_mv_orphaned_inode_to_new+0x87/0x7e0 [ocfs2]
  ocfs2_reflink+0x335/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
or
task:reflink         state:D stack:    0 pid:18465 ppid:  4156
Call Trace:
  __schedule+0x302/0x940
  ? usleep_range+0x80/0x80
  schedule+0x46/0xb0
  schedule_timeout+0xff/0x140
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0c3b000
  __wait_for_common+0xb9/0x170
  __ocfs2_cluster_lock.constprop.0+0x1d6/0x860 [ocfs2]
  ? ocfs2_wait_for_recovery+0x49/0xd0 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_tracker+0xf2/0x2b0 [ocfs2]
  ? dput+0x32/0x2f0
  ocfs2_permission+0x45/0xe0 [ocfs2]
  inode_permission+0xcc/0x170
  link_path_walk.part.0.constprop.0+0x2a2/0x380
  ? path_init+0x2c1/0x3f0
  path_parentat+0x3c/0x90
  filename_parentat+0xc1/0x1d0
  ? filename_lookup+0x138/0x1c0
  filename_create+0x43/0x160
  ocfs2_reflink_ioctl+0xe6/0x380 [ocfs2]
  ocfs2_ioctl+0x1ea/0x2c0 [ocfs2]
  ? do_sys_openat2+0x81/0x150
  __x64_sys_ioctl+0x82/0xb0
  do_syscall_64+0x61/0xb0

The deadlock is caused by multiple acquiring the destination directory
inode dlm lock in ocfs2_reflink function, we should acquire this directory
inode dlm lock at the beginning, and hold this dlm lock until end of the
function.

Link: https://lkml.kernel.org/r/20210729110230.18983-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c        |   32 +++++++++++++-------------------
 fs/ocfs2/namei.h        |    2 ++
 fs/ocfs2/refcounttree.c |   15 +++++++++++----
 fs/ocfs2/xattr.c        |   12 +-----------
 fs/ocfs2/xattr.h        |    1 +
 5 files changed, 28 insertions(+), 34 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/namei.c
@@ -2489,6 +2489,7 @@ out:
 }
 
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode)
 {
@@ -2597,13 +2598,16 @@ leave:
 
 	brelse(new_di_bh);
 
-	if (!status)
-		*new_inode = inode;
-
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 
-	ocfs2_inode_unlock(dir, 1);
-	brelse(parent_di_bh);
+	if (!status) {
+		*new_inode = inode;
+		*dir_bh = parent_di_bh;
+	} else {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(parent_di_bh);
+	}
+
 	return status;
 }
 
@@ -2760,11 +2764,11 @@ bail:
 }
 
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *inode,
 				   struct dentry *dentry)
 {
 	int status = 0;
-	struct buffer_head *parent_di_bh = NULL;
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dinode *dir_di, *di;
@@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 				(unsigned long long)OCFS2_I(dir)->ip_blkno,
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
-	}
-
-	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
+	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
 	if (!dir_di->i_links_count) {
 		/* can't make a file in a deleted directory. */
 		status = -ENOENT;
@@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 		goto leave;
 
 	/* get a spot inside the dir. */
-	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
+	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
 					      dentry->d_name.name,
 					      dentry->d_name.len, &lookup);
 	if (status < 0) {
@@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
-				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
+				 OCFS2_I(inode)->ip_blkno, dir_bh,
 				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2886,10 +2883,7 @@ orphan_unlock:
 	iput(orphan_dir_inode);
 leave:
 
-	ocfs2_inode_unlock(dir, 1);
-
 	brelse(di_bh);
-	brelse(parent_di_bh);
 	brelse(orphan_dir_bh);
 
 	ocfs2_free_dir_lookup_result(&lookup);
--- a/fs/ocfs2/namei.h~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/namei.h
@@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super
 		     struct buffer_head *orphan_dir_bh,
 		     bool dio);
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode);
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
@@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct o
 		struct inode *inode, struct buffer_head *di_bh,
 		int update_isize, loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
 
--- a/fs/ocfs2/refcounttree.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/refcounttree.c
@@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *
 {
 	int error, had_lock;
 	struct inode *inode = d_inode(old_dentry);
-	struct buffer_head *old_bh = NULL;
+	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
 	struct ocfs2_lock_holder oh;
 
@@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *
 		return -EOPNOTSUPP;
 
 
-	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
 					     &new_orphan_inode);
 	if (error) {
 		mlog_errno(error);
@@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *
 
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
-		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
+		error = ocfs2_init_security_and_acl(dir, dir_bh,
+						    new_orphan_inode,
 						    &new_dentry->d_name);
 		if (error)
 			mlog_errno(error);
 	}
 	if (!error) {
-		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
+		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
+						       new_orphan_inode,
 						       new_dentry);
 		if (error)
 			mlog_errno(error);
@@ -4328,6 +4330,11 @@ out:
 			iput(new_orphan_inode);
 	}
 
+	if (dir_bh) {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(dir_bh);
+	}
+
 	return error;
 }
 
--- a/fs/ocfs2/xattr.c~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/xattr.c
@@ -7203,16 +7203,13 @@ out:
 /*
  * Initialize security and acl for a already created inode.
  * Used for reflink a non-preserve-security file.
- *
- * It uses common api like ocfs2_xattr_set, so the caller
- * must not hold any lock expect i_mutex.
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr)
 {
 	int ret = 0;
-	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct i
 		goto leave;
 	}
 
-	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
 	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
 	if (ret)
 		mlog_errno(ret);
 
-	ocfs2_inode_unlock(dir, 0);
-	brelse(dir_bh);
 leave:
 	return ret;
 }
--- a/fs/ocfs2/xattr.h~ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously
+++ a/fs/ocfs2/xattr.h
@@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *o
 			 struct buffer_head *new_bh,
 			 bool preserve_security);
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr);
 #endif /* OCFS2_XATTR_H */
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-reflink-deadlock-when-clone-file-to-the-same-directory-simultaneously.patch

