From: akpm@linux-foundation.org
Subject: + unionfs-build-fixes.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:17:44 -0700
Message-ID: <200807300017.m6U0HibO029656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbYG3ASU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ezk@cs.sunysb.edu


The patch titled
     unionfs: build fixes
has been added to the -mm tree.  Its filename is
     unionfs-build-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unionfs: build fixes
From: Hugh Dickins <hugh@veritas.com>

Get unionfs building and working in mmotm with the 2.6.27-rc1 VFS changes:
permission() has been replaced by inode_permission() without nameidata
arg; unionfs_permission() without nameidata arg; vfs_symlink() without
mode arg; LOOKUP_ACCESS no longer defined; and kmem_cache_create() no
longer passes kmem_cachep to the init_once() constructor.

Note: while okay for inclusion in -mm for now, unionfs_permission() mods
will need review and perhaps correction by Erez: without a nameidata arg,
some locking vanishes from unionfs_permission(), and a MNT_NOEXEC check on
its lower_inode; I have not studied the VFS changes enough to tell whether
that amounts to a real issue for unionfs, or just removal of dead code.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/dirhelper.c |    2 +-
 fs/unionfs/inode.c     |   16 +++-------------
 fs/unionfs/lookup.c    |    5 +----
 fs/unionfs/sioq.c      |    2 +-
 fs/unionfs/super.c     |    2 +-
 5 files changed, 7 insertions(+), 20 deletions(-)

diff -puN fs/unionfs/dirhelper.c~unionfs-build-fixes fs/unionfs/dirhelper.c
--- a/fs/unionfs/dirhelper.c~unionfs-build-fixes
+++ a/fs/unionfs/dirhelper.c
@@ -110,7 +110,7 @@ int delete_whiteouts(struct dentry *dent
 	lower_dir = lower_dir_dentry->d_inode;
 	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
-	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_dir, MAY_WRITE | MAY_EXEC)) {
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	} else {
 		args.deletewh.namelist = namelist;
diff -puN fs/unionfs/inode.c~unionfs-build-fixes fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~unionfs-build-fixes
+++ a/fs/unionfs/inode.c
@@ -462,7 +462,6 @@ static int unionfs_symlink(struct inode 
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
 	int valid = 0;
-	umode_t mode;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -497,9 +496,7 @@ static int unionfs_symlink(struct inode 
 		goto out;
 	}
 
-	mode = S_IALLUGO;
-	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry,
-			  symname, mode);
+	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry, symname);
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
@@ -872,8 +869,7 @@ static void unionfs_put_link(struct dent
  * unionfs_permission, or anything it calls, will use stale branch
  * information.
  */
-static int unionfs_permission(struct inode *inode, int mask,
-			      struct nameidata *nd)
+static int unionfs_permission(struct inode *inode, int mask)
 {
 	struct inode *lower_inode = NULL;
 	int err = 0;
@@ -881,9 +877,6 @@ static int unionfs_permission(struct ino
 	const int is_file = !S_ISDIR(inode->i_mode);
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
-	if (nd)
-		unionfs_lock_dentry(nd->path.dentry, UNIONFS_DMUTEX_CHILD);
-
 	if (!UNIONFS_I(inode)->lower_inodes) {
 		if (is_file)	/* dirs can be unlinked but chdir'ed to */
 			err = -ESTALE;	/* force revalidate */
@@ -923,7 +916,7 @@ static int unionfs_permission(struct ino
 		 * readonly, because those conditions should lead to a
 		 * copyup taking place later on.
 		 */
-		err = permission(lower_inode, mask, nd);
+		err = inode_permission(lower_inode, mask);
 		if (err && bindex > 0) {
 			umode_t mode = lower_inode->i_mode;
 			if (is_robranch_super(inode->i_sb, bindex) &&
@@ -955,9 +948,6 @@ static int unionfs_permission(struct ino
 
 out:
 	unionfs_check_inode(inode);
-	unionfs_check_nd(nd);
-	if (nd)
-		unionfs_unlock_dentry(nd->path.dentry);
 	return err;
 }
 
diff -puN fs/unionfs/lookup.c~unionfs-build-fixes fs/unionfs/lookup.c
--- a/fs/unionfs/lookup.c~unionfs-build-fixes
+++ a/fs/unionfs/lookup.c
@@ -47,7 +47,7 @@ static noinline_for_stack int is_opaque_
 
 	mutex_lock(&lower_inode->i_mutex);
 
-	if (!permission(lower_inode, MAY_EXEC, NULL)) {
+	if (!inode_permission(lower_inode, MAY_EXEC)) {
 		wh_lower_dentry =
 			lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				       sizeof(UNIONFS_DIR_OPAQUE) - 1);
@@ -636,9 +636,6 @@ int init_lower_nd(struct nameidata *nd, 
 		nd->intent.open.file = file;
 #endif /* ALLOC_LOWER_ND_FILE */
 		break;
-	case LOOKUP_ACCESS:
-		nd->flags = flags;
-		break;
 	default:
 		/*
 		 * We should never get here, for now.
diff -puN fs/unionfs/sioq.c~unionfs-build-fixes fs/unionfs/sioq.c
--- a/fs/unionfs/sioq.c~unionfs-build-fixes
+++ a/fs/unionfs/sioq.c
@@ -87,7 +87,7 @@ void __unionfs_symlink(struct work_struc
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
-	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf);
 	complete(&args->comp);
 }
 
diff -puN fs/unionfs/super.c~unionfs-build-fixes fs/unionfs/super.c
--- a/fs/unionfs/super.c~unionfs-build-fixes
+++ a/fs/unionfs/super.c
@@ -904,7 +904,7 @@ static void unionfs_destroy_inode(struct
 }
 
 /* unionfs inode cache constructor */
-static void init_once(struct kmem_cache *cachep, void *obj)
+static void init_once(void *obj)
 {
 	struct unionfs_inode_info *i = obj;
 
_

Patches currently in -mm which might be from hugh@veritas.com are

vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
madvise-update-function-comment-of-madvise_dontneed.patch
swap-update-function-comment-of-release_pages.patch
swapfile-vmscan-update-comments-related-to-vmscan-functions.patch
do_try_to_free_page-update-comments-related-to-vmscan-functions.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
unionfs-fix-memory-leak.patch
fsstack-fsstack_copy_inode_size-locking.patch
unionfs-build-fixes.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch

