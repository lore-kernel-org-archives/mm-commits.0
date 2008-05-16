From: akpm@linux-foundation.org
Subject: + fuse-add-export-operations.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:13 -0700
Message-ID: <200805160016.m4G0GEe3017771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbYEPAQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de


The patch titled
     fuse: add export operations
has been added to the -mm tree.  Its filename is
     fuse-add-export-operations.patch

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
Subject: fuse: add export operations
From: Miklos Szeredi <mszeredi@suse.cz>

Implement export_operations, to allow fuse filesystems to be exported to
NFS.  This feature has been in the out-of-tree fuse module, and is widely
used and tested.

It has not been originally merged into mainline, because doing the NFS
export in userspace was thought to be a cleaner and more efficient way of
doing it, than through the kernel.

While that is true, it would also have involved a lot of duplicated effort
at reimplementing NFS exporting (all the different versions of the
protocol).  This effort was unfortunately not undertaken by anyone, so we
are left with doing it the easy but less efficient way.

If this feature goes in, the out-of-tree fuse module can go away,
which would have several advantages:

  - not having to maintain two versions
  - less confusion for users
  - no bugs due to kernel API changes

Comment from hch:
 - Use the same fh_type values as XFS, since we use the same fh encoding.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    4 -
 fs/fuse/fuse_i.h |    4 +
 fs/fuse/inode.c  |  115 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dir.c~fuse-add-export-operations fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-add-export-operations
+++ a/fs/fuse/dir.c
@@ -97,7 +97,7 @@ void fuse_invalidate_attr(struct inode *
  * timeout is unknown (unlink, rmdir, rename and in some cases
  * lookup)
  */
-static void fuse_invalidate_entry_cache(struct dentry *entry)
+void fuse_invalidate_entry_cache(struct dentry *entry)
 {
 	fuse_dentry_settime(entry, 0);
 }
@@ -225,7 +225,7 @@ static int invalid_nodeid(u64 nodeid)
 	return !nodeid || nodeid == FUSE_ROOT_ID;
 }
 
-static struct dentry_operations fuse_dentry_operations = {
+struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
 };
 
diff -puN fs/fuse/fuse_i.h~fuse-add-export-operations fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-export-operations
+++ a/fs/fuse/fuse_i.h
@@ -464,6 +464,8 @@ static inline u64 get_node_id(struct ino
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
+extern struct dentry_operations fuse_dentry_operations;
+
 /**
  * Get a filled in inode
  */
@@ -604,6 +606,8 @@ void fuse_abort_conn(struct fuse_conn *f
  */
 void fuse_invalidate_attr(struct inode *inode);
 
+void fuse_invalidate_entry_cache(struct dentry *entry);
+
 /**
  * Acquire reference to fuse_conn
  */
diff -puN fs/fuse/inode.c~fuse-add-export-operations fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-export-operations
+++ a/fs/fuse/inode.c
@@ -18,6 +18,7 @@
 #include <linux/statfs.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/exportfs.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -564,6 +565,119 @@ static struct inode *get_root_inode(stru
 	return fuse_iget(sb, 1, 0, &attr, 0, 0);
 }
 
+struct fuse_inode_handle
+{
+	u64 nodeid;
+	u32 generation;
+};
+
+static struct dentry *fuse_get_dentry(struct super_block *sb,
+				      struct fuse_inode_handle *handle)
+{
+	struct inode *inode;
+	struct dentry *entry;
+	int err = -ESTALE;
+
+	if (handle->nodeid == 0)
+		goto out_err;
+
+	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
+	if (!inode)
+		goto out_err;
+	err = -ESTALE;
+	if (inode->i_generation != handle->generation)
+		goto out_iput;
+
+	entry = d_alloc_anon(inode);
+	err = -ENOMEM;
+	if (!entry)
+		goto out_iput;
+
+	if (get_node_id(inode) != FUSE_ROOT_ID) {
+		entry->d_op = &fuse_dentry_operations;
+		fuse_invalidate_entry_cache(entry);
+	}
+
+	return entry;
+
+ out_iput:
+	iput(inode);
+ out_err:
+	return ERR_PTR(err);
+}
+
+static int fuse_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
+			   int connectable)
+{
+	struct inode *inode = dentry->d_inode;
+	bool encode_parent = connectable && !S_ISDIR(inode->i_mode);
+	int len = encode_parent ? 6 : 3;
+	u64 nodeid;
+	u32 generation;
+
+	if (*max_len < len)
+		return  255;
+
+	nodeid = get_fuse_inode(inode)->nodeid;
+	generation = inode->i_generation;
+
+	fh[0] = (u32)(nodeid >> 32);
+	fh[1] = (u32)(nodeid & 0xffffffff);
+	fh[2] = generation;
+
+	if (encode_parent) {
+		struct inode *parent;
+
+		spin_lock(&dentry->d_lock);
+		parent = dentry->d_parent->d_inode;
+		nodeid = get_fuse_inode(parent)->nodeid;
+		generation = parent->i_generation;
+		spin_unlock(&dentry->d_lock);
+
+		fh[3] = (u32)(nodeid >> 32);
+		fh[4] = (u32)(nodeid & 0xffffffff);
+		fh[5] = generation;
+	}
+
+	*max_len = len;
+	return encode_parent ? 0x82 : 0x81;
+}
+
+static struct dentry *fuse_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct fuse_inode_handle handle;
+
+	if ((fh_type != 0x81 && fh_type != 0x82) || fh_len < 3)
+		return NULL;
+
+	handle.nodeid = (u64) fid->raw[0] << 32;
+	handle.nodeid |= (u64) fid->raw[1];
+	handle.generation = fid->raw[2];
+	return fuse_get_dentry(sb, &handle);
+}
+
+static struct dentry *fuse_fh_to_parent(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct fuse_inode_handle parent;
+
+	if (fh_type != 0x82 || fh_len < 6)
+		return NULL;
+
+	parent.nodeid = (u64) fid->raw[3] << 32;
+	parent.nodeid |= (u64) fid->raw[4];
+	parent.generation = fid->raw[5];
+	return fuse_get_dentry(sb, &parent);
+}
+
+
+static const struct export_operations fuse_export_operations = {
+	.fh_to_dentry	= fuse_fh_to_dentry,
+	.fh_to_parent	= fuse_fh_to_parent,
+	.encode_fh	= fuse_encode_fh,
+};
+
 static const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
@@ -668,6 +782,7 @@ static int fuse_fill_super(struct super_
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_export_op = &fuse_export_operations;
 
 	file = fget(d.fd);
 	if (!file)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-fix-infinite-loop-in-filemap_fault.patch
git-vfs-cleanups.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

