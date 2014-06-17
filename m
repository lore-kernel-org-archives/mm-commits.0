From: akpm@linux-foundation.org
Subject: +
 ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch added to -mm tree
Date: Tue, 17 Jun 2014 15:57:08 -0700
Message-ID: <53a0c7c4.Vc+Y0OJHOcB3PrN3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaFQW5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, jiangyiwen@huawei.com


The patch titled
     Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
has been added to the -mm tree.  Its filename is
     ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch

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
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2
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
@@ -472,16 +487,9 @@ leave:
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
 	if ((status < 0) && inode) {
-		if (dl) {
-			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
-			ocfs2_lock_res_free(&dl->dl_lockres);
-			BUG_ON(dl->dl_count != 1);
-			spin_lock(&dentry_attach_lock);
-			dentry->d_fsdata = NULL;
-			spin_unlock(&dentry_attach_lock);
-			kfree(dl);
-			iput(inode);
-		}
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
@@ -1972,16 +1980,9 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
-		if (dl) {
-			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
-			ocfs2_lock_res_free(&dl->dl_lockres);
-			BUG_ON(dl->dl_count != 1);
-			spin_lock(&dentry_attach_lock);
-			dentry->d_fsdata = NULL;
-			spin_unlock(&dentry_attach_lock);
-			kfree(dl);
-			iput(inode);
-		}
+		if (dl)
+			ocfs2_cleanup_add_entry_failure(osb, dentry, inode);
+
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-dlm-fix-misuse-of-list_move_tail-in-dlm_run_purge_list.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer-v2.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod.patch
ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod-v2.patch

