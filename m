From: akpm@linux-foundation.org
Subject: + remove-sb-s_files-and-file_list_lock-usage-in-dquotc.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:50:08 -0800
Message-ID: <200702062350.l16No8PY000762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965590AbXBFXuR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jack@suse.cz


The patch titled
     remove sb->s_files and file_list_lock usage in dquot.c
has been added to the -mm tree.  Its filename is
     remove-sb-s_files-and-file_list_lock-usage-in-dquotc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove sb->s_files and file_list_lock usage in dquot.c
From: Christoph Hellwig <hch@lst.de>

Iterate over sb->s_inodes instead of sb->s_files in add_dquot_ref.  This
reduces list search and lock hold time aswell as getting rid of one of the
few uses of file_list_lock which Ingo identified as a scalability problem.

Previously we called dq_op->initialize for every inode handing of a
writeable file that wasn't initialized before.  Now we're calling it for
every inode that has a non-zero i_writecount, aka a writeable file
descriptor refering to it.

Thanks a lot to Jan Kara for running this patch through his quota test
harness.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff -puN fs/dquot.c~remove-sb-s_files-and-file_list_lock-usage-in-dquotc fs/dquot.c
--- a/fs/dquot.c~remove-sb-s_files-and-file_list_lock-usage-in-dquotc
+++ a/fs/dquot.c
@@ -688,23 +688,27 @@ static int dqinit_needed(struct inode *i
 /* This routine is guarded by dqonoff_mutex mutex */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
-	struct list_head *p;
+	struct inode *inode;
 
 restart:
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *filp = list_entry(p, struct file, f_u.fu_list);
-		struct inode *inode = filp->f_path.dentry->d_inode;
-		if (filp->f_mode & FMODE_WRITE && dqinit_needed(inode, type)) {
-			struct dentry *dentry = dget(filp->f_path.dentry);
-			file_list_unlock();
-			sb->dq_op->initialize(inode, type);
-			dput(dentry);
-			/* As we may have blocked we had better restart... */
-			goto restart;
-		}
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (!atomic_read(&inode->i_writecount))
+			continue;
+		if (!dqinit_needed(inode, type))
+			continue;
+		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+			continue;
+
+		__iget(inode);
+		spin_unlock(&inode_lock);
+
+		sb->dq_op->initialize(inode, type);
+		iput(inode);
+		/* As we may have blocked we had better restart... */
+		goto restart;
 	}
-	file_list_unlock();
+	spin_unlock(&inode_lock);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */
_

Patches currently in -mm which might be from hch@lst.de are

git-drm.patch
git-scsi-misc.patch
slab-cache-alloc-cleanups.patch
simplify-the-stacktrace-code.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
tty-cleanup-release_mem.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
fix-d_path-for-lazy-unmounts.patch
move-remove_dquot_ref-to-dqoutc.patch
remove-sb-s_files-and-file_list_lock-usage-in-dquotc.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
