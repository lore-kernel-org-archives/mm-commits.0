From: akpm@linux-foundation.org
Subject: + fs-remove-fastcall-it-is-always-empty.patch added to -mm tree
Date: Thu, 20 Dec 2007 16:46:05 -0800
Message-ID: <200712210046.lBL0k5F4021745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbXLUAqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     fs: remove fastcall, it is always empty
has been added to the -mm tree.  Its filename is
     fs-remove-fastcall-it-is-always-empty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: remove fastcall, it is always empty
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c        |   17 ++++++++---------
 fs/buffer.c     |    6 +++---
 fs/fcntl.c      |    2 +-
 fs/file_table.c |    8 ++++----
 fs/namei.c      |   16 ++++++++--------
 fs/open.c       |    4 ++--
 6 files changed, 26 insertions(+), 27 deletions(-)

diff -puN fs/aio.c~fs-remove-fastcall-it-is-always-empty fs/aio.c
--- a/fs/aio.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/aio.c
@@ -317,7 +317,7 @@ out:
 /* wait_on_sync_kiocb:
  *	Waits on the given sync kiocb to complete.
  */
-ssize_t fastcall wait_on_sync_kiocb(struct kiocb *iocb)
+ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 {
 	while (iocb->ki_users) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -336,7 +336,7 @@ ssize_t fastcall wait_on_sync_kiocb(stru
  * go away, they will call put_ioctx and release any pinned memory
  * associated with the request (held via struct page * references).
  */
-void fastcall exit_aio(struct mm_struct *mm)
+void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx *ctx = mm->ioctx_list;
 	mm->ioctx_list = NULL;
@@ -365,7 +365,7 @@ void fastcall exit_aio(struct mm_struct 
  *	Called when the last user of an aio context has gone away,
  *	and the struct needs to be freed.
  */
-void fastcall __put_ioctx(struct kioctx *ctx)
+void __put_ioctx(struct kioctx *ctx)
 {
 	unsigned nr_events = ctx->max_reqs;
 
@@ -397,8 +397,7 @@ void fastcall __put_ioctx(struct kioctx 
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx);
-static struct kiocb fastcall *__aio_get_req(struct kioctx *ctx)
+static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
 	struct aio_ring *ring;
@@ -533,7 +532,7 @@ static int __aio_put_req(struct kioctx *
  *	Returns true if this put was the last user of the kiocb,
  *	false if the request is still in use.
  */
-int fastcall aio_put_req(struct kiocb *req)
+int aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
 	int ret;
@@ -893,7 +892,7 @@ static void try_queue_kicked_iocb(struct
  *      The retry is usually executed by aio workqueue
  *      threads (See aio_kick_handler).
  */
-void fastcall kick_iocb(struct kiocb *iocb)
+void kick_iocb(struct kiocb *iocb)
 {
 	/* sync iocbs are easy: they can only ever be executing from a 
 	 * single context. */
@@ -912,7 +911,7 @@ EXPORT_SYMBOL(kick_iocb);
  *	Returns true if this is the last user of the request.  The 
  *	only other user of the request can be the cancellation code.
  */
-int fastcall aio_complete(struct kiocb *iocb, long res, long res2)
+int aio_complete(struct kiocb *iocb, long res, long res2)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
@@ -1523,7 +1522,7 @@ static int aio_wake_function(wait_queue_
 	return 1;
 }
 
-int fastcall io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
 	struct kiocb *req;
diff -puN fs/buffer.c~fs-remove-fastcall-it-is-always-empty fs/buffer.c
--- a/fs/buffer.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/buffer.c
@@ -67,14 +67,14 @@ static int sync_buffer(void *word)
 	return 0;
 }
 
-void fastcall __lock_buffer(struct buffer_head *bh)
+void __lock_buffer(struct buffer_head *bh)
 {
 	wait_on_bit_lock(&bh->b_state, BH_Lock, sync_buffer,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_buffer);
 
-void fastcall unlock_buffer(struct buffer_head *bh)
+void unlock_buffer(struct buffer_head *bh)
 {
 	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
@@ -1164,7 +1164,7 @@ __getblk_slow(struct block_device *bdev,
  * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
  * mapping->tree_lock and the global inode_lock.
  */
-void fastcall mark_buffer_dirty(struct buffer_head *bh)
+void mark_buffer_dirty(struct buffer_head *bh)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
diff -puN fs/fcntl.c~fs-remove-fastcall-it-is-always-empty fs/fcntl.c
--- a/fs/fcntl.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/fcntl.c
@@ -24,7 +24,7 @@
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-void fastcall set_close_on_exec(unsigned int fd, int flag)
+void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
diff -puN fs/file_table.c~fs-remove-fastcall-it-is-always-empty fs/file_table.c
--- a/fs/file_table.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/file_table.c
@@ -197,7 +197,7 @@ int init_file(struct file *file, struct 
 }
 EXPORT_SYMBOL(init_file);
 
-void fastcall fput(struct file *file)
+void fput(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count))
 		__fput(file);
@@ -208,7 +208,7 @@ EXPORT_SYMBOL(fput);
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
-void fastcall __fput(struct file *file)
+void __fput(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
@@ -241,7 +241,7 @@ void fastcall __fput(struct file *file)
 	mntput(mnt);
 }
 
-struct file fastcall *fget(unsigned int fd)
+struct file *fget(unsigned int fd)
 {
 	struct file *file;
 	struct files_struct *files = current->files;
@@ -269,7 +269,7 @@ EXPORT_SYMBOL(fget);
  * and a flag is returned to be passed to the corresponding fput_light().
  * There must not be a cloning between an fget_light/fput_light pair.
  */
-struct file fastcall *fget_light(unsigned int fd, int *fput_needed)
+struct file *fget_light(unsigned int fd, int *fput_needed)
 {
 	struct file *file;
 	struct files_struct *files = current->files;
diff -puN fs/namei.c~fs-remove-fastcall-it-is-always-empty fs/namei.c
--- a/fs/namei.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/namei.c
@@ -106,7 +106,7 @@
  * any extra contention...
  */
 
-static int fastcall link_path_walk(const char *name, struct nameidata *nd);
+static int link_path_walk(const char *name, struct nameidata *nd);
 
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
@@ -824,7 +824,7 @@ fail:
  * Returns 0 and nd will have valid dentry and mnt on success.
  * Returns error and drops reference to input namei data on failure.
  */
-static fastcall int __link_path_walk(const char * name, struct nameidata *nd)
+static int __link_path_walk(const char * name, struct nameidata *nd)
 {
 	struct path next;
 	struct inode *inode;
@@ -1016,7 +1016,7 @@ return_err:
  * Retry the whole path once, forcing real lookup requests
  * instead of relying on the dcache.
  */
-static int fastcall link_path_walk(const char *name, struct nameidata *nd)
+static int link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct nameidata save = *nd;
 	int result;
@@ -1040,7 +1040,7 @@ static int fastcall link_path_walk(const
 	return result;
 }
 
-static int fastcall path_walk(const char * name, struct nameidata *nd)
+static int path_walk(const char * name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
@@ -1117,7 +1117,7 @@ set_it:
 }
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
-static int fastcall do_path_lookup(int dfd, const char *name,
+static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1184,7 +1184,7 @@ fput_fail:
 	goto out_fail;
 }
 
-int fastcall path_lookup(const char *name, unsigned int flags,
+int path_lookup(const char *name, unsigned int flags,
 			struct nameidata *nd)
 {
 	return do_path_lookup(AT_FDCWD, name, flags, nd);
@@ -1410,7 +1410,7 @@ struct dentry *lookup_one_noperm(const c
 	return __lookup_hash(&this, base, NULL);
 }
 
-int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
+int __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 			    struct nameidata *nd)
 {
 	char *tmp = getname(name);
@@ -1423,7 +1423,7 @@ int fastcall __user_walk_fd(int dfd, con
 	return err;
 }
 
-int fastcall __user_walk(const char __user *name, unsigned flags, struct nameidata *nd)
+int __user_walk(const char __user *name, unsigned flags, struct nameidata *nd)
 {
 	return __user_walk_fd(AT_FDCWD, name, flags, nd);
 }
diff -puN fs/open.c~fs-remove-fastcall-it-is-always-empty fs/open.c
--- a/fs/open.c~fs-remove-fastcall-it-is-always-empty
+++ a/fs/open.c
@@ -991,7 +991,7 @@ static void __put_unused_fd(struct files
 		files->next_fd = fd;
 }
 
-void fastcall put_unused_fd(unsigned int fd)
+void put_unused_fd(unsigned int fd)
 {
 	struct files_struct *files = current->files;
 	spin_lock(&files->file_lock);
@@ -1014,7 +1014,7 @@ EXPORT_SYMBOL(put_unused_fd);
  * will follow.
  */
 
-void fastcall fd_install(unsigned int fd, struct file * file)
+void fd_install(unsigned int fd, struct file * file)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-net.patch
git-sh.patch
git-x86.patch
mm-remove-fastcall-from-mm.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
fs-remove-fastcall-it-is-always-empty.patch
