From: akpm@linux-foundation.org
Subject: [merged] fs-9p-kerneldoc-fixes.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:02 -0700
Message-ID: <5390c846.Az6GS8sWVh9ySXL+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, ericvh@gmail.com, fabf@skynet.be

Subject: [merged] fs-9p-kerneldoc-fixes.patch removed from -mm tree
To: fabf@skynet.be,ericvh@gmail.com,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:02 -0700


The patch titled
     Subject: fs/9p: kerneldoc fixes
has been removed from the -mm tree.  Its filename was
     fs-9p-kerneldoc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/9p: kerneldoc fixes

Function parameters comment fixing.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_dir.c        |    1 -
 fs/9p/vfs_file.c       |    4 ++--
 fs/9p/vfs_inode.c      |    6 +++---
 fs/9p/vfs_inode_dotl.c |    7 +++----
 4 files changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/9p/vfs_dir.c~fs-9p-kerneldoc-fixes fs/9p/vfs_dir.c
--- a/fs/9p/vfs_dir.c~fs-9p-kerneldoc-fixes
+++ a/fs/9p/vfs_dir.c
@@ -42,7 +42,6 @@
 
 /**
  * struct p9_rdir - readdir accounting
- * @mutex: mutex protecting readdir
  * @head: start offset of current dirread buffer
  * @tail: end offset of current dirread buffer
  * @buf: dirread buffer
diff -puN fs/9p/vfs_file.c~fs-9p-kerneldoc-fixes fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~fs-9p-kerneldoc-fixes
+++ a/fs/9p/vfs_file.c
@@ -681,7 +681,7 @@ v9fs_direct_read(struct file *filp, char
 /**
  * v9fs_cached_file_read - read from a file
  * @filp: file pointer to read
- * @udata: user data buffer to read data into
+ * @data: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
@@ -698,7 +698,7 @@ v9fs_cached_file_read(struct file *filp,
 /**
  * v9fs_mmap_file_read - read from a file
  * @filp: file pointer to read
- * @udata: user data buffer to read data into
+ * @data: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
diff -puN fs/9p/vfs_inode.c~fs-9p-kerneldoc-fixes fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~fs-9p-kerneldoc-fixes
+++ a/fs/9p/vfs_inode.c
@@ -580,7 +580,7 @@ static int v9fs_at_to_dotl_flags(int fla
  * v9fs_remove - helper function to remove files and directories
  * @dir: directory inode that is being deleted
  * @dentry:  dentry that is being deleted
- * @rmdir: removing a directory
+ * @flags: removing a directory
  *
  */
 
@@ -778,7 +778,7 @@ static int v9fs_vfs_mkdir(struct inode *
  * v9fs_vfs_lookup - VFS lookup hook to "walk" to a new inode
  * @dir:  inode that is being walked from
  * @dentry: dentry that is being walked to?
- * @nameidata: path data
+ * @flags: lookup flags (unused)
  *
  */
 
@@ -1324,7 +1324,7 @@ v9fs_vfs_put_link(struct dentry *dentry,
  * v9fs_vfs_mkspecial - create a special file
  * @dir: inode to create special file in
  * @dentry: dentry to create
- * @mode: mode to create special file
+ * @perm: mode to create special file
  * @extension: 9p2000.u format extension string representing special file
  *
  */
diff -puN fs/9p/vfs_inode_dotl.c~fs-9p-kerneldoc-fixes fs/9p/vfs_inode_dotl.c
--- a/fs/9p/vfs_inode_dotl.c~fs-9p-kerneldoc-fixes
+++ a/fs/9p/vfs_inode_dotl.c
@@ -226,7 +226,7 @@ int v9fs_open_to_dotl_flags(int flags)
  * v9fs_vfs_create_dotl - VFS hook to create files for 9P2000.L protocol.
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
- * @mode: create permissions
+ * @omode: create permissions
  *
  */
 
@@ -375,7 +375,7 @@ err_clunk_old_fid:
  * v9fs_vfs_mkdir_dotl - VFS mkdir hook to create a directory
  * @dir:  inode that is being unlinked
  * @dentry: dentry that is being unlinked
- * @mode: mode for new directory
+ * @omode: mode for new directory
  *
  */
 
@@ -607,7 +607,6 @@ int v9fs_vfs_setattr_dotl(struct dentry
  * v9fs_stat2inode_dotl - populate an inode structure with stat info
  * @stat: stat structure
  * @inode: inode to populate
- * @sb: superblock of filesystem
  *
  */
 
@@ -808,7 +807,7 @@ v9fs_vfs_link_dotl(struct dentry *old_de
  * v9fs_vfs_mknod_dotl - create a special file
  * @dir: inode destination for new link
  * @dentry: dentry for file
- * @mode: mode for creation
+ * @omode: mode for creation
  * @rdev: device associated with special file
  *
  */
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

