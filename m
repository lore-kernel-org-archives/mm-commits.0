From: akpm@linux-foundation.org
Subject: + fs-affs-use-inode-writecount-instead-of-local-i_opencnt.patch
 added to -mm tree
Date: Wed, 28 Jan 2015 13:45:24 -0800
Message-ID: <54c95874.1pbbCloLAl3wWsPR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbbA2BWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jan 2015 20:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: use inode writecount instead of local i_opencnt
has been added to the -mm tree.  Its filename is
     fs-affs-use-inode-writecount-instead-of-local-i_opencnt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-use-inode-writecount-instead-of-local-i_opencnt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-use-inode-writecount-instead-of-local-i_opencnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: use inode writecount instead of local i_opencnt

atomic_t i_opencnt was used to free allocation in case there were no more
opens.  This patch replaces affs_file_open by generic_file_open and uses
FMODE_WRITE/i_writecount==1 for the task like other FS.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    1 -
 fs/affs/file.c  |   17 ++++-------------
 fs/affs/inode.c |    2 --
 3 files changed, 4 insertions(+), 16 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-use-inode-writecount-instead-of-local-i_opencnt fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-use-inode-writecount-instead-of-local-i_opencnt
+++ a/fs/affs/affs.h
@@ -39,7 +39,6 @@ struct affs_ext_key {
  * affs fs inode data in memory
  */
 struct affs_inode_info {
-	atomic_t i_opencnt;
 	struct semaphore i_link_lock;		/* Protects internal inode access. */
 	struct semaphore i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
diff -puN fs/affs/file.c~fs-affs-use-inode-writecount-instead-of-local-i_opencnt fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-use-inode-writecount-instead-of-local-i_opencnt
+++ a/fs/affs/file.c
@@ -18,21 +18,12 @@
 static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
 
 static int
-affs_file_open(struct inode *inode, struct file *filp)
-{
-	pr_debug("open(%lu,%d)\n",
-		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
-	atomic_inc(&AFFS_I(inode)->i_opencnt);
-	return 0;
-}
-
-static int
 affs_file_release(struct inode *inode, struct file *filp)
 {
-	pr_debug("release(%lu, %d)\n",
-		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
+	pr_debug("release(%lu)\n", inode->i_ino);
 
-	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
+	if ((filp->f_mode & FMODE_WRITE) &&
+	    (atomic_read(&inode->i_writecount) == 1)) {
 		mutex_lock(&inode->i_mutex);
 		if (inode->i_size != AFFS_I(inode)->mmu_private)
 			affs_truncate(inode);
@@ -969,7 +960,7 @@ const struct file_operations affs_file_o
 	.write		= new_sync_write,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.open		= affs_file_open,
+	.open		= generic_file_open,
 	.release	= affs_file_release,
 	.fsync		= affs_file_fsync,
 	.splice_read	= generic_file_splice_read,
diff -puN fs/affs/inode.c~fs-affs-use-inode-writecount-instead-of-local-i_opencnt fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-use-inode-writecount-instead-of-local-i_opencnt
+++ a/fs/affs/inode.c
@@ -56,7 +56,6 @@ struct inode *affs_iget(struct super_blo
 	AFFS_I(inode)->i_extcnt = 1;
 	AFFS_I(inode)->i_ext_last = ~1;
 	AFFS_I(inode)->i_protect = prot;
-	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
@@ -307,7 +306,6 @@ affs_new_inode(struct inode *dir)
 	inode->i_ino     = block;
 	set_nlink(inode, 1);
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
-	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
fs-affs-use-inode-writecount-instead-of-local-i_opencnt.patch
linux-next.patch

