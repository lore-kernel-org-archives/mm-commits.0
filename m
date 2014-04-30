From: akpm@linux-foundation.org
Subject: + fs-9p-kerneldoc-fixes.patch added to -mm tree
Date: Wed, 30 Apr 2014 13:07:49 -0700
Message-ID: <53615815.PVZGv4itU3HPX4d8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaD3UHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 16:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, ericvh@gmail.com, fabf@skynet.be

Subject: + fs-9p-kerneldoc-fixes.patch added to -mm tree
To: fabf@skynet.be,ericvh@gmail.com,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:07:49 -0700


The patch titled
     Subject: fs/9p: kerneldoc fixes
has been added to the -mm tree.  Its filename is
     fs-9p-kerneldoc-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-9p-kerneldoc-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-9p-kerneldoc-fixes.patch

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
@@ -684,7 +684,7 @@ v9fs_direct_read(struct file *filp, char
 /**
  * v9fs_cached_file_read - read from a file
  * @filp: file pointer to read
- * @udata: user data buffer to read data into
+ * @data: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
@@ -701,7 +701,7 @@ v9fs_cached_file_read(struct file *filp,
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

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

