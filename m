From: akpm@linux-foundation.org
Subject: +
 ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch added to -mm tree
Date: Tue, 04 Mar 2014 12:49:03 -0800
Message-ID: <53163c3f.TpmoHLOP7Uw63bfO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbaCDUtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: + ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch added to -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:49:03 -0800


The patch titled
     Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
has been added to the -mm tree.  Its filename is
     ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod

When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
ocfs2_mknod(), iput() will not be called during dput(dentry) because no
d_instantiate(), and this will lead to umount hung.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod
+++ a/fs/ocfs2/namei.c
@@ -231,6 +231,7 @@ static int ocfs2_mknod(struct inode *dir
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct posix_acl *default_acl = NULL, *acl = NULL;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -423,6 +424,8 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 &lookup);
@@ -470,6 +473,16 @@ leave:
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
 	if ((status < 0) && inode) {
+		if (dl) {
+			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+			ocfs2_lock_res_free(&dl->dl_lockres);
+			BUG_ON(dl->dl_count != 1);
+			spin_lock(&dentry_attach_lock);
+			dentry->d_fsdata = NULL;
+			spin_unlock(&dentry_attach_lock);
+			kfree(dl);
+			iput(inode);
+		}
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
@@ -1739,6 +1752,7 @@ static int ocfs2_symlink(struct inode *d
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_symlink_begin(dir, dentry, symname,
 				  dentry->d_name.len, dentry->d_name.name);
@@ -1927,6 +1941,8 @@ static int ocfs2_symlink(struct inode *d
 		goto bail;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
 				 &lookup);
@@ -1962,6 +1978,16 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
+		if (dl) {
+			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+			ocfs2_lock_res_free(&dl->dl_lockres);
+			BUG_ON(dl->dl_count != 1);
+			spin_lock(&dentry_attach_lock);
+			dentry->d_fsdata = NULL;
+			spin_unlock(&dentry_attach_lock);
+			kfree(dl);
+			iput(inode);
+		}
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch

