From: akpm@linux-foundation.org
Subject: - knfsd-exportfs-add-exportfsh-header.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:04 -0700
Message-ID: <200707172304.l6HN44Io011772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936391AbXGQXRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, neilb@suse.de, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     knfsd: exportfs: add exportfs.h header
has been removed from the -mm tree.  Its filename was
     knfsd-exportfs-add-exportfsh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: exportfs: add exportfs.h header
From: Christoph Hellwig <hch@infradead.org>

currently the export_operation structure and helpers related to it are in
fs.h.  fs.h is already far too large and there are very few places needing the
export bits, so split them off into a separate header.

[akpm@linux-foundation.org: fix cifs build]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/export.c             |    1 
 fs/efs/super.c               |    1 
 fs/exportfs/expfs.c          |    1 
 fs/ext2/super.c              |    1 
 fs/ext3/super.c              |    1 
 fs/ext4/super.c              |    1 
 fs/fat/inode.c               |    1 
 fs/gfs2/ops_export.c         |    1 
 fs/isofs/isofs.h             |    1 
 fs/jfs/super.c               |    1 
 fs/nfsd/export.c             |    1 
 fs/nfsd/nfsfh.c              |    1 
 fs/ntfs/namei.c              |    1 
 fs/ocfs2/export.h            |    2 
 fs/reiserfs/inode.c          |    1 
 fs/reiserfs/super.c          |    1 
 fs/xfs/linux-2.6/xfs_super.h |    2 
 include/linux/exportfs.h     |  119 +++++++++++++++++++++++++++++++++
 include/linux/fs.h           |  114 -------------------------------
 mm/shmem.c                   |    1 
 20 files changed, 140 insertions(+), 113 deletions(-)

diff -puN fs/cifs/export.c~knfsd-exportfs-add-exportfsh-header fs/cifs/export.c
--- a/fs/cifs/export.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/cifs/export.c
@@ -29,6 +29,7 @@
   */
 
 #include <linux/fs.h>
+#include <linux/exportfs.h>
  
 #ifdef CONFIG_CIFS_EXPERIMENTAL
  
diff -puN fs/efs/super.c~knfsd-exportfs-add-exportfsh-header fs/efs/super.c
--- a/fs/efs/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/efs/super.c
@@ -11,6 +11,7 @@
 #include <linux/efs_fs.h>
 #include <linux/efs_vh.h>
 #include <linux/efs_fs_sb.h>
+#include <linux/exportfs.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
diff -puN fs/exportfs/expfs.c~knfsd-exportfs-add-exportfsh-header fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/exportfs/expfs.c
@@ -1,4 +1,5 @@
 
+#include <linux/exportfs.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/module.h>
diff -puN fs/ext2/super.c~knfsd-exportfs-add-exportfsh-header fs/ext2/super.c
--- a/fs/ext2/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/ext2/super.c
@@ -25,6 +25,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
diff -puN fs/ext3/super.c~knfsd-exportfs-add-exportfsh-header fs/ext3/super.c
--- a/fs/ext3/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/ext3/super.c
@@ -29,6 +29,7 @@
 #include <linux/parser.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/vfs.h>
 #include <linux/random.h>
 #include <linux/mount.h>
diff -puN fs/ext4/super.c~knfsd-exportfs-add-exportfsh-header fs/ext4/super.c
--- a/fs/ext4/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/ext4/super.c
@@ -29,6 +29,7 @@
 #include <linux/parser.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/vfs.h>
 #include <linux/random.h>
 #include <linux/mount.h>
diff -puN fs/fat/inode.c~knfsd-exportfs-add-exportfsh-header fs/fat/inode.c
--- a/fs/fat/inode.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/fat/inode.c
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
diff -puN fs/gfs2/ops_export.c~knfsd-exportfs-add-exportfsh-header fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/gfs2/ops_export.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
diff -puN fs/isofs/isofs.h~knfsd-exportfs-add-exportfsh-header fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~knfsd-exportfs-add-exportfsh-header
+++ a/fs/isofs/isofs.h
@@ -1,5 +1,6 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/iso_fs.h>
 #include <asm/unaligned.h>
 
diff -puN fs/jfs/super.c~knfsd-exportfs-add-exportfsh-header fs/jfs/super.c
--- a/fs/jfs/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/jfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/posix_acl.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 
diff -puN fs/nfsd/export.c~knfsd-exportfs-add-exportfsh-header fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/nfsd/export.c
@@ -26,6 +26,7 @@
 #include <linux/mount.h>
 #include <linux/hash.h>
 #include <linux/module.h>
+#include <linux/exportfs.h>
 
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
diff -puN fs/nfsd/nfsfh.c~knfsd-exportfs-add-exportfsh-header fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/nfsd/nfsfh.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/dcache.h>
+#include <linux/exportfs.h>
 #include <linux/mount.h>
 
 #include <linux/sunrpc/clnt.h>
diff -puN fs/ntfs/namei.c~knfsd-exportfs-add-exportfsh-header fs/ntfs/namei.c
--- a/fs/ntfs/namei.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/ntfs/namei.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/dcache.h>
+#include <linux/exportfs.h>
 #include <linux/security.h>
 
 #include "attrib.h"
diff -puN fs/ocfs2/export.h~knfsd-exportfs-add-exportfsh-header fs/ocfs2/export.h
--- a/fs/ocfs2/export.h~knfsd-exportfs-add-exportfsh-header
+++ a/fs/ocfs2/export.h
@@ -26,6 +26,8 @@
 #ifndef OCFS2_EXPORT_H
 #define OCFS2_EXPORT_H
 
+#include <linux/exportfs.h>
+
 extern struct export_operations ocfs2_export_ops;
 
 #endif /* OCFS2_EXPORT_H */
diff -puN fs/reiserfs/inode.c~knfsd-exportfs-add-exportfsh-header fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/reiserfs/inode.c
@@ -7,6 +7,7 @@
 #include <linux/reiserfs_fs.h>
 #include <linux/reiserfs_acl.h>
 #include <linux/reiserfs_xattr.h>
+#include <linux/exportfs.h>
 #include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
diff -puN fs/reiserfs/super.c~knfsd-exportfs-add-exportfsh-header fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~knfsd-exportfs-add-exportfsh-header
+++ a/fs/reiserfs/super.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/exportfs.h>
 #include <linux/vfs.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
diff -puN fs/xfs/linux-2.6/xfs_super.h~knfsd-exportfs-add-exportfsh-header fs/xfs/linux-2.6/xfs_super.h
--- a/fs/xfs/linux-2.6/xfs_super.h~knfsd-exportfs-add-exportfsh-header
+++ a/fs/xfs/linux-2.6/xfs_super.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_SUPER_H__
 #define __XFS_SUPER_H__
 
+#include <linux/exportfs.h>
+
 #ifdef CONFIG_XFS_DMAPI
 # define vfs_insertdmapi(vfs)	vfs_insertops(vfsp, &xfs_dmops)
 # define vfs_initdmapi()	dmapi_init()
diff -puN include/linux/exportfs.h~knfsd-exportfs-add-exportfsh-header include/linux/exportfs.h
--- a/include/linux/exportfs.h~knfsd-exportfs-add-exportfsh-header
+++ a/include/linux/exportfs.h
@@ -0,0 +1,119 @@
+#ifndef LINUX_EXPORTFS_H
+#define LINUX_EXPORTFS_H 1
+
+#include <linux/types.h>
+
+struct dentry;
+struct super_block;
+
+
+/**
+ * struct export_operations - for nfsd to communicate with file systems
+ * @decode_fh:      decode a file handle fragment and return a &struct dentry
+ * @encode_fh:      encode a file handle fragment from a dentry
+ * @get_name:       find the name for a given inode in a given directory
+ * @get_parent:     find the parent of a given directory
+ * @get_dentry:     find a dentry for the inode given a file handle sub-fragment
+ * @find_exported_dentry:
+ *	set by the exporting module to a standard helper function.
+ *
+ * Description:
+ *    The export_operations structure provides a means for nfsd to communicate
+ *    with a particular exported file system  - particularly enabling nfsd and
+ *    the filesystem to co-operate when dealing with file handles.
+ *
+ *    export_operations contains two basic operation for dealing with file
+ *    handles, decode_fh() and encode_fh(), and allows for some other
+ *    operations to be defined which standard helper routines use to get
+ *    specific information from the filesystem.
+ *
+ *    nfsd encodes information use to determine which filesystem a filehandle
+ *    applies to in the initial part of the file handle.  The remainder, termed
+ *    a file handle fragment, is controlled completely by the filesystem.  The
+ *    standard helper routines assume that this fragment will contain one or
+ *    two sub-fragments, one which identifies the file, and one which may be
+ *    used to identify the (a) directory containing the file.
+ *
+ *    In some situations, nfsd needs to get a dentry which is connected into a
+ *    specific part of the file tree.  To allow for this, it passes the
+ *    function acceptable() together with a @context which can be used to see
+ *    if the dentry is acceptable.  As there can be multiple dentrys for a
+ *    given file, the filesystem should check each one for acceptability before
+ *    looking for the next.  As soon as an acceptable one is found, it should
+ *    be returned.
+ *
+ * decode_fh:
+ *    @decode_fh is given a &struct super_block (@sb), a file handle fragment
+ *    (@fh, @fh_len) and an acceptability testing function (@acceptable,
+ *    @context).  It should return a &struct dentry which refers to the same
+ *    file that the file handle fragment refers to,  and which passes the
+ *    acceptability test.  If it cannot, it should return a %NULL pointer if
+ *    the file was found but no acceptable &dentries were available, or a
+ *    %ERR_PTR error code indicating why it couldn't be found (e.g. %ENOENT or
+ *    %ENOMEM).
+ *
+ * encode_fh:
+ *    @encode_fh should store in the file handle fragment @fh (using at most
+ *    @max_len bytes) information that can be used by @decode_fh to recover the
+ *    file refered to by the &struct dentry @de.  If the @connectable flag is
+ *    set, the encode_fh() should store sufficient information so that a good
+ *    attempt can be made to find not only the file but also it's place in the
+ *    filesystem.   This typically means storing a reference to de->d_parent in
+ *    the filehandle fragment.  encode_fh() should return the number of bytes
+ *    stored or a negative error code such as %-ENOSPC
+ *
+ * get_name:
+ *    @get_name should find a name for the given @child in the given @parent
+ *    directory.  The name should be stored in the @name (with the
+ *    understanding that it is already pointing to a a %NAME_MAX+1 sized
+ *    buffer.   get_name() should return %0 on success, a negative error code
+ *    or error.  @get_name will be called without @parent->i_mutex held.
+ *
+ * get_parent:
+ *    @get_parent should find the parent directory for the given @child which
+ *    is also a directory.  In the event that it cannot be found, or storage
+ *    space cannot be allocated, a %ERR_PTR should be returned.
+ *
+ * get_dentry:
+ *    Given a &super_block (@sb) and a pointer to a file-system specific inode
+ *    identifier, possibly an inode number, (@inump) get_dentry() should find
+ *    the identified inode and return a dentry for that inode.  Any suitable
+ *    dentry can be returned including, if necessary, a new dentry created with
+ *    d_alloc_root.  The caller can then find any other extant dentrys by
+ *    following the d_alias links.  If a new dentry was created using
+ *    d_alloc_root, DCACHE_NFSD_DISCONNECTED should be set, and the dentry
+ *    should be d_rehash()ed.
+ *
+ *    If the inode cannot be found, either a %NULL pointer or an %ERR_PTR code
+ *    can be returned.  The @inump will be whatever was passed to
+ *    nfsd_find_fh_dentry() in either the @obj or @parent parameters.
+ *
+ * Locking rules:
+ *    get_parent is called with child->d_inode->i_mutex down
+ *    get_name is not (which is possibly inconsistent)
+ */
+
+struct export_operations {
+	struct dentry *(*decode_fh)(struct super_block *sb, __u32 *fh,
+			int fh_len, int fh_type,
+			int (*acceptable)(void *context, struct dentry *de),
+			void *context);
+	int (*encode_fh)(struct dentry *de, __u32 *fh, int *max_len,
+			int connectable);
+	int (*get_name)(struct dentry *parent, char *name,
+			struct dentry *child);
+	struct dentry * (*get_parent)(struct dentry *child);
+	struct dentry * (*get_dentry)(struct super_block *sb, void *inump);
+
+	/* This is set by the exporting module to a standard helper */
+	struct dentry * (*find_exported_dentry)(
+			struct super_block *sb, void *obj, void *parent,
+			int (*acceptable)(void *context, struct dentry *de),
+			void *context);
+};
+
+extern struct dentry *find_exported_dentry(struct super_block *sb, void *obj,
+	void *parent, int (*acceptable)(void *context, struct dentry *de),
+	void *context);
+
+#endif /* LINUX_EXPORTFS_H */
diff -puN include/linux/fs.h~knfsd-exportfs-add-exportfsh-header include/linux/fs.h
--- a/include/linux/fs.h~knfsd-exportfs-add-exportfsh-header
+++ a/include/linux/fs.h
@@ -289,6 +289,7 @@ extern int dir_notify_enable;
 #include <asm/semaphore.h>
 #include <asm/byteorder.h>
 
+struct export_operations;
 struct hd_geometry;
 struct iovec;
 struct nameidata;
@@ -1278,119 +1279,6 @@ static inline void file_accessed(struct 
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 
-/**
- * struct export_operations - for nfsd to communicate with file systems
- * @decode_fh:      decode a file handle fragment and return a &struct dentry
- * @encode_fh:      encode a file handle fragment from a dentry
- * @get_name:       find the name for a given inode in a given directory
- * @get_parent:     find the parent of a given directory
- * @get_dentry:     find a dentry for the inode given a file handle sub-fragment
- * @find_exported_dentry:
- *	set by the exporting module to a standard helper function.
- *
- * Description:
- *    The export_operations structure provides a means for nfsd to communicate
- *    with a particular exported file system  - particularly enabling nfsd and
- *    the filesystem to co-operate when dealing with file handles.
- *
- *    export_operations contains two basic operation for dealing with file
- *    handles, decode_fh() and encode_fh(), and allows for some other
- *    operations to be defined which standard helper routines use to get
- *    specific information from the filesystem.
- *
- *    nfsd encodes information use to determine which filesystem a filehandle
- *    applies to in the initial part of the file handle.  The remainder, termed
- *    a file handle fragment, is controlled completely by the filesystem.  The
- *    standard helper routines assume that this fragment will contain one or
- *    two sub-fragments, one which identifies the file, and one which may be
- *    used to identify the (a) directory containing the file.
- *
- *    In some situations, nfsd needs to get a dentry which is connected into a
- *    specific part of the file tree.  To allow for this, it passes the
- *    function acceptable() together with a @context which can be used to see
- *    if the dentry is acceptable.  As there can be multiple dentrys for a
- *    given file, the filesystem should check each one for acceptability before
- *    looking for the next.  As soon as an acceptable one is found, it should
- *    be returned.
- *
- * decode_fh:
- *    @decode_fh is given a &struct super_block (@sb), a file handle fragment
- *    (@fh, @fh_len) and an acceptability testing function (@acceptable,
- *    @context).  It should return a &struct dentry which refers to the same
- *    file that the file handle fragment refers to,  and which passes the
- *    acceptability test.  If it cannot, it should return a %NULL pointer if
- *    the file was found but no acceptable &dentries were available, or a
- *    %ERR_PTR error code indicating why it couldn't be found (e.g. %ENOENT or
- *    %ENOMEM).
- *
- * encode_fh:
- *    @encode_fh should store in the file handle fragment @fh (using at most
- *    @max_len bytes) information that can be used by @decode_fh to recover the
- *    file refered to by the &struct dentry @de.  If the @connectable flag is
- *    set, the encode_fh() should store sufficient information so that a good
- *    attempt can be made to find not only the file but also it's place in the
- *    filesystem.   This typically means storing a reference to de->d_parent in
- *    the filehandle fragment.  encode_fh() should return the number of bytes
- *    stored or a negative error code such as %-ENOSPC
- *
- * get_name:
- *    @get_name should find a name for the given @child in the given @parent
- *    directory.  The name should be stored in the @name (with the
- *    understanding that it is already pointing to a a %NAME_MAX+1 sized
- *    buffer.   get_name() should return %0 on success, a negative error code
- *    or error.  @get_name will be called without @parent->i_mutex held.
- *
- * get_parent:
- *    @get_parent should find the parent directory for the given @child which
- *    is also a directory.  In the event that it cannot be found, or storage
- *    space cannot be allocated, a %ERR_PTR should be returned.
- *
- * get_dentry:
- *    Given a &super_block (@sb) and a pointer to a file-system specific inode
- *    identifier, possibly an inode number, (@inump) get_dentry() should find
- *    the identified inode and return a dentry for that inode.  Any suitable
- *    dentry can be returned including, if necessary, a new dentry created with
- *    d_alloc_root.  The caller can then find any other extant dentrys by
- *    following the d_alias links.  If a new dentry was created using
- *    d_alloc_root, DCACHE_NFSD_DISCONNECTED should be set, and the dentry
- *    should be d_rehash()ed.
- *
- *    If the inode cannot be found, either a %NULL pointer or an %ERR_PTR code
- *    can be returned.  The @inump will be whatever was passed to
- *    nfsd_find_fh_dentry() in either the @obj or @parent parameters.
- *
- * Locking rules:
- *    get_parent is called with child->d_inode->i_mutex down
- *    get_name is not (which is possibly inconsistent)
- */
-
-struct export_operations {
-	struct dentry *(*decode_fh)(struct super_block *sb, __u32 *fh, int fh_len, int fh_type,
-			 int (*acceptable)(void *context, struct dentry *de),
-			 void *context);
-	int (*encode_fh)(struct dentry *de, __u32 *fh, int *max_len,
-			 int connectable);
-
-	/* the following are only called from the filesystem itself */
-	int (*get_name)(struct dentry *parent, char *name,
-			struct dentry *child);
-	struct dentry * (*get_parent)(struct dentry *child);
-	struct dentry * (*get_dentry)(struct super_block *sb, void *inump);
-
-	/* This is set by the exporting module to a standard helper */
-	struct dentry * (*find_exported_dentry)(
-		struct super_block *sb, void *obj, void *parent,
-		int (*acceptable)(void *context, struct dentry *de),
-		void *context);
-
-
-};
-
-extern struct dentry *
-find_exported_dentry(struct super_block *sb, void *obj, void *parent,
-		     int (*acceptable)(void *context, struct dentry *de),
-		     void *context);
-
 struct file_system_type {
 	const char *name;
 	int fs_flags;
diff -puN mm/shmem.c~knfsd-exportfs-add-exportfsh-header mm/shmem.c
--- a/mm/shmem.c~knfsd-exportfs-add-exportfsh-header
+++ a/mm/shmem.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/xattr.h>
+#include <linux/exportfs.h>
 #include <linux/generic_acl.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-vfs-lease-api.patch
git-xfs.patch
introduce-i_sync.patch
