From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:03:03 -0700
Message-ID: <53a9cb67.yZNnrE/ZXplEUdI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaFXTDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
has been removed from the -mm tree.  Its filename was
     ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod

When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
ocfs2_mknod(), iput() will not be called during dput(dentry) because no
d_instantiate(), and this will lead to umount hung.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod
+++ a/fs/ocfs2/namei.c
@@ -205,6 +205,21 @@ static struct inode *ocfs2_get_init_inod
 	return inode;
 }
 
+static void ocfs2_cleanup_add_entry_failure(struct ocfs2_super *osb,
+		struct dentry *dentry, struct inode *inode)
+{
+	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
+
+	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+	ocfs2_lock_res_free(&dl->dl_lockres);
+	BUG_ON(dl->dl_count != 1);
+	spin_lock(&dentry_attach_lock);
+	dentry->d_fsdata = NULL;
+	spin_unlock(&dentry_attach_lock);
+	kfree(dl);
+	iput(inode);
+}
+
 static int ocfs2_mknod(struct inode *dir,
 		       struct dentry *dentry,
 		       umode_t mode,
@@ -231,6 +246,7 @@ static int ocfs2_mknod(struct inode *dir
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct posix_acl *default_acl = NULL, *acl = NULL;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -423,6 +439,8 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 &lookup);
@@ -469,6 +487,9 @@ leave:
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
 	if ((status < 0) && inode) {
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
@@ -1734,6 +1755,7 @@ static int ocfs2_symlink(struct inode *d
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_symlink_begin(dir, dentry, symname,
 				  dentry->d_name.len, dentry->d_name.name);
@@ -1922,6 +1944,8 @@ static int ocfs2_symlink(struct inode *d
 		goto bail;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
 				 &lookup);
@@ -1956,6 +1980,9 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

origin.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch

