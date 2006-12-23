From: akpm@osdl.org
Subject: - ext3-fix-kmalloc-flags-used-with-an-active-journal-handle.patch removed from -mm tree
Date: Fri, 22 Dec 2006 20:17:53 -0800
Message-ID: <200612230417.kBN4HroU007199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbWLWESG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 23:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext3: fix kmalloc flags used with an active journal handle
has been removed from the -mm tree.  Its filename was
     ext3-fix-kmalloc-flags-used-with-an-active-journal-handle.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ext3: fix kmalloc flags used with an active journal handle


Fix the kmalloc flags used from within ext3, when we have an active journal
handle

If we do a kmalloc with GFP_KERNEL on system running low on memory, with an
active journal handle, we might end up in cleaning up the fs cache flushing
dirty inodes for some other filesystem.  This would cause hitting a
J_ASSERT() in :

handle_t *journal_start(journal_t *journal, int nblocks)
{
	handle_t *handle = journal_current_handle();
	int err;
[...]

	if (handle) {
		J_ASSERT(handle->h_transaction->t_journal == journal);

Here are the places where we do kmalloc or may end up doing kmalloc, with __GFP_FS (through GFP_KERNEL) from ext3, while holding a journal handle.

1) fs/ext3/xattr.c :: ext3_xattr_block_set() : 2 occurences

2) fs/ext3/resize.c :: reserve_backup_gdb()
3) fs/ext3/resize.c :: add_new_gdb()

4) fs/ext3/acl.c :: ext3_init_acl() :
    There are quite a few points where we may endup calling the kmalloc() from ext3_init_acl() which is called with a handle() from ext3_new_inode():

 a)   Called direclty within ext3_init_acl() as:
          clone = posix_acl_clone(acl, GFP_KERNEL);
 b) With the following code path:
    ext3_init_acl()-> ext3_get_acl()-> ext3_acl_from_disk() -> posix_acl_alloc(GFP_KERNEL)

 c) Also  ext3_init_acl()-> ext3_get_acl()-> kmalloc() also might call kmalloc() directly.

5) fs/ext3/acl.c :: ext3_acl_to_disk() which is called from ext3_set_acl().

Among these 4.b & 4.c may be called from a with or without handle case.

There was a similar issue reported sometime back, early this year.

http://lkml.org/lkml/2006/1/31/54

Attached patch fixes all the above invokations to make use of GFP_NOFS
instead of GFP_KERNEL.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/acl.c    |    8 ++++----
 fs/ext3/resize.c |    4 ++--
 fs/ext3/xattr.c  |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext3/acl.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle fs/ext3/acl.c
--- a/fs/ext3/acl.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle
+++ a/fs/ext3/acl.c
@@ -37,7 +37,7 @@ ext3_acl_from_disk(const void *value, si
 		return ERR_PTR(-EINVAL);
 	if (count == 0)
 		return NULL;
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	for (n=0; n < count; n++) {
@@ -91,7 +91,7 @@ ext3_acl_to_disk(const struct posix_acl 
 
 	*size = ext3_acl_size(acl->a_count);
 	ext_acl = kmalloc(sizeof(ext3_acl_header) + acl->a_count *
-			sizeof(ext3_acl_entry), GFP_KERNEL);
+			sizeof(ext3_acl_entry), GFP_NOFS);
 	if (!ext_acl)
 		return ERR_PTR(-ENOMEM);
 	ext_acl->a_version = cpu_to_le32(EXT3_ACL_VERSION);
@@ -187,7 +187,7 @@ ext3_get_acl(struct inode *inode, int ty
 	}
 	retval = ext3_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
-		value = kmalloc(retval, GFP_KERNEL);
+		value = kmalloc(retval, GFP_NOFS);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		retval = ext3_xattr_get(inode, name_index, "", value, retval);
@@ -335,7 +335,7 @@ ext3_init_acl(handle_t *handle, struct i
 			if (error)
 				goto cleanup;
 		}
-		clone = posix_acl_clone(acl, GFP_KERNEL);
+		clone = posix_acl_clone(acl, GFP_NOFS);
 		error = -ENOMEM;
 		if (!clone)
 			goto cleanup;
diff -puN fs/ext3/resize.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle
+++ a/fs/ext3/resize.c
@@ -440,7 +440,7 @@ static int add_new_gdb(handle_t *handle,
 		goto exit_dindj;
 
 	n_group_desc = kmalloc((gdb_num + 1) * sizeof(struct buffer_head *),
-			GFP_KERNEL);
+			GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
 		ext3_warning (sb, __FUNCTION__,
@@ -524,7 +524,7 @@ static int reserve_backup_gdb(handle_t *
 	int res, i;
 	int err;
 
-	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_KERNEL);
+	primary = kmalloc(reserved_gdb * sizeof(*primary), GFP_NOFS);
 	if (!primary)
 		return -ENOMEM;
 
diff -puN fs/ext3/xattr.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-fix-kmalloc-flags-used-with-an-active-journal-handle
+++ a/fs/ext3/xattr.c
@@ -718,7 +718,7 @@ ext3_xattr_block_set(handle_t *handle, s
 				ce = NULL;
 			}
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_KERNEL);
+			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
@@ -730,7 +730,7 @@ ext3_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kmalloc(sb->s_blocksize, GFP_NOFS);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
_

Patches currently in -mm which might be from suzuki@in.ibm.com are


