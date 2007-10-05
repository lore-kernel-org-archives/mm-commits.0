From: akpm@linux-foundation.org
Subject: + reiser4-do-not-allocate-struct-file-on-stack.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:47:22 -0700
Message-ID: <200710052347.l95NlM5h031184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764219AbXJEXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, vs@namesys.com, zlynx@acm.org


The patch titled
     reiser4: do not allocate struct file on stack
has been added to the -mm tree.  Its filename is
     reiser4-do-not-allocate-struct-file-on-stack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: do not allocate struct file on stack
From: Edward Shishkin <edward@namesys.com>

Do not allocate struct file on stack, pass the persistent one instead.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Tested-by: Zan Lynx <zlynx@acm.org>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/reiser4/plugin/file/file.c~reiser4-do-not-allocate-struct-file-on-stack fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-do-not-allocate-struct-file-on-stack
+++ a/fs/reiser4/plugin/file/file.c
@@ -565,23 +565,18 @@ static int should_have_notail(const stru
  * items or add them to represent a hole at the end of file. The caller has to
  * obtain exclusive access to the file.
  */
-static int truncate_file_body(struct inode *inode, loff_t new_size)
+static int truncate_file_body(struct inode *inode, struct iattr *attr)
 {
 	int result;
+	loff_t new_size = attr->ia_size;
 
 	if (inode->i_size < new_size) {
 		/* expanding truncate */
-		struct dentry dentry;
-		struct file file;
-		struct unix_file_info *uf_info;
+		struct file * file = attr->ia_file;
+		struct unix_file_info *uf_info = unix_file_inode_data(inode);
+
+		assert("edward-1532", attr->ia_valid & ATTR_FILE);
 
-		dentry.d_inode = inode;
-		file.f_dentry = &dentry;
-		file.private_data = NULL;
-		file.f_pos = new_size;
-		file.private_data = NULL;
-		file.f_vfsmnt = NULL;
-		uf_info = unix_file_inode_data(inode);
 		result = find_file_state(inode, uf_info);
 		if (result)
 			return result;
@@ -614,19 +609,19 @@ static int truncate_file_body(struct ino
 						return result;
 				}
 			}
-			result = reiser4_write_extent(&file, NULL, 0,
+			result = reiser4_write_extent(file, NULL, 0,
 						      &new_size);
 			if (result)
 				return result;
 			uf_info->container = UF_CONTAINER_EXTENTS;
 		} else {
 			if (uf_info->container ==  UF_CONTAINER_EXTENTS) {
-				result = reiser4_write_extent(&file, NULL, 0,
+				result = reiser4_write_extent(file, NULL, 0,
 							      &new_size);
 				if (result)
 					return result;
 			} else {
-				result = reiser4_write_tail(&file, NULL, 0,
+				result = reiser4_write_tail(file, NULL, 0,
 							    &new_size);
 				if (result)
 					return result;
@@ -635,10 +630,10 @@ static int truncate_file_body(struct ino
 		}
 		BUG_ON(result > 0);
 		INODE_SET_FIELD(inode, i_size, new_size);
-		file_update_time(&file);
+		file_update_time(file);
 		result = reiser4_update_sd(inode);
 		BUG_ON(result != 0);
-		reiser4_free_file_fsdata(&file);
+		reiser4_free_file_fsdata(file);
 	} else
 		result = shorten_file(inode, new_size);
 	return result;
@@ -2091,7 +2086,7 @@ int open_unix_file(struct inode *inode, 
 		 * first item is formatting item, therefore there was
 		 * incomplete extent2tail conversion. Complete it
 		 */
-		result = extent2tail(unix_file_inode_data(inode));
+		result = extent2tail(file, unix_file_inode_data(inode));
 	else
 		result = -EIO;
 
@@ -2371,7 +2366,7 @@ int release_unix_file(struct inode *inod
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
 		    !should_have_notail(uf_info, inode->i_size) &&
 		    !rofs_inode(inode)) {
-			result = extent2tail(uf_info);
+			result = extent2tail(file, uf_info);
 			if (result != 0) {
 				warning("nikita-3233",
 					"Failed (%d) to convert in %s (%llu)",
@@ -2637,7 +2632,7 @@ static int setattr_truncate(struct inode
 	if (result == 0)
 		result = safe_link_add(inode, SAFE_TRUNCATE);
 	if (result == 0)
-		result = truncate_file_body(inode, attr->ia_size);
+		result = truncate_file_body(inode, attr);
 	if (result)
 		warning("vs-1588", "truncate_file failed: oid %lli, "
 			"old size %lld, new size %lld, retval %d",
@@ -2723,7 +2718,7 @@ int delete_object_unix_file(struct inode
 	/* truncate file bogy first */
 	uf_info = unix_file_inode_data(inode);
 	get_exclusive_access(uf_info);
-	result = truncate_file_body(inode, 0 /* size */ );
+	result = shorten_file(inode, 0 /* size */ );
 	drop_exclusive_access(uf_info);
 
 	if (result)
diff -puN fs/reiser4/plugin/file/file.h~reiser4-do-not-allocate-struct-file-on-stack fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-do-not-allocate-struct-file-on-stack
+++ a/fs/reiser4/plugin/file/file.h
@@ -243,7 +243,7 @@ extern reiser4_plugin_ops cryptcompress_
 #define WRITE_GRANULARITY 32
 
 int tail2extent(struct unix_file_info *);
-int extent2tail(struct unix_file_info *);
+int extent2tail(struct file *, struct unix_file_info *);
 
 int goto_right_neighbor(coord_t *, lock_handle *);
 int find_or_create_extent(struct page *);
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-do-not-allocate-struct-file-on-stack fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-do-not-allocate-struct-file-on-stack
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -546,7 +546,7 @@ static int reserve_extent2tail_iteration
 
 /* for every page of file: read page, cut part of extent pointing to this page,
    put data of page tree by tail item */
-int extent2tail(struct unix_file_info *uf_info)
+int extent2tail(struct file * file, struct unix_file_info *uf_info)
 {
 	int result;
 	struct inode *inode;
@@ -644,20 +644,17 @@ int extent2tail(struct unix_file_info *u
 			/* last page can be incompleted */
 			count = (inode->i_size & ~PAGE_CACHE_MASK);
 		while (count) {
-			struct dentry dentry;
-			struct file file;
-			loff_t pos;
-
-			dentry.d_inode = inode;
-			file.f_dentry = &dentry;
-			file.private_data = NULL;
-			file.f_pos = start_byte;
-			file.private_data = NULL;
-			pos = start_byte;
-			result = reiser4_write_tail(&file,
+			loff_t pos = start_byte;
+
+			assert("edward-1533",
+			       file != NULL && file->f_dentry != NULL);
+			assert("edward-1534",
+			       file->f_dentry->d_inode == inode);
+
+			result = reiser4_write_tail(file,
 						    (char __user *)kmap(page),
 						    count, &pos);
-			reiser4_free_file_fsdata(&file);
+			reiser4_free_file_fsdata(file);
 			if (result <= 0) {
 				warning("", "reiser4_write_tail failed");
 				page_cache_release(page);
_

Patches currently in -mm which might be from edward@namesys.com are

reiserfs-do-not-repair-wrong-journal-params.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
