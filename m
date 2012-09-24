From: akpm@linux-foundation.org
Subject: + hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:49:24 -0700
Message-ID: <20120924224925.409D51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38684 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2IXWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:49:26 -0400
Received: by mail-yx0-f202.google.com with SMTP id r11so438826yen.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:49:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: rework functionality of getting, setting and deleting of extended attributes
has been added to the -mm tree.  Its filename is
     hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: rework functionality of getting, setting and deleting of extended attributes

Rework functionality of getting, setting and deleting of extended
attributes.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/ioctl.c |  542 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 473 insertions(+), 69 deletions(-)

diff -puN fs/hfsplus/ioctl.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes
+++ a/fs/hfsplus/ioctl.c
@@ -152,47 +152,205 @@ long hfsplus_ioctl(struct file *file, un
 	}
 }
 
+static int strcmp_xattr_finder_info(const char *name)
+{
+	if (name) {
+		return strncmp(name, HFSPLUS_XATTR_FINDER_INFO_NAME,
+				sizeof(HFSPLUS_XATTR_FINDER_INFO_NAME));
+	}
+	return -1;
+}
+
+static int strcmp_xattr_acl(const char *name)
+{
+	if (name) {
+		return strncmp(name, HFSPLUS_XATTR_ACL_NAME,
+				sizeof(HFSPLUS_XATTR_ACL_NAME));
+	}
+	return -1;
+}
+
 int hfsplus_setxattr(struct dentry *dentry, const char *name,
-		     const void *value, size_t size, int flags)
+			const void *value, size_t size, int flags)
 {
+	int err = 0;
 	struct inode *inode = dentry->d_inode;
-	struct hfs_find_data fd;
+	struct hfs_find_data cat_fd;
 	hfsplus_cat_entry entry;
-	struct hfsplus_cat_file *file;
-	int res;
-
-	if (!S_ISREG(inode->i_mode) || HFSPLUS_IS_RSRC(inode))
+	u16 cat_entry_flags, cat_entry_type;
+	u16 folder_finderinfo_len = sizeof(struct DInfo) +
+					sizeof(struct DXInfo);
+	u16 file_finderinfo_len = sizeof(struct FInfo) +
+					sizeof(struct FXInfo);
+
+	if ((!S_ISREG(inode->i_mode) &&
+			!S_ISDIR(inode->i_mode)) ||
+				HFSPLUS_IS_RSRC(inode))
 		return -EOPNOTSUPP;
 
-	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
-	if (res)
-		return res;
-	res = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
-	if (res)
-		goto out;
-	hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
-			sizeof(struct hfsplus_cat_file));
-	file = &entry.file;
-
-	if (!strcmp(name, "hfs.type")) {
-		if (size == 4)
-			memcpy(&file->user_info.fdType, value, 4);
-		else
-			res = -ERANGE;
-	} else if (!strcmp(name, "hfs.creator")) {
-		if (size == 4)
-			memcpy(&file->user_info.fdCreator, value, 4);
-		else
-			res = -ERANGE;
-	} else
-		res = -EOPNOTSUPP;
-	if (!res) {
-		hfs_bnode_write(fd.bnode, &entry, fd.entryoffset,
-				sizeof(struct hfsplus_cat_file));
+	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
+	if (err) {
+		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		return err;
+	}
+
+	err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &cat_fd);
+	if (err) {
+		printk(KERN_ERR "hfs: catalog searching failed\n");
+		goto end_setxattr;
+	}
+
+	if (!strcmp_xattr_finder_info(name)) {
+		if (flags & XATTR_CREATE) {
+			printk(KERN_ERR "hfs: xattr exists yet\n");
+			err = -EOPNOTSUPP;
+			goto end_setxattr;
+		}
+		hfs_bnode_read(cat_fd.bnode, &entry, cat_fd.entryoffset,
+					sizeof(hfsplus_cat_entry));
+		if (be16_to_cpu(entry.type) == HFSPLUS_FOLDER) {
+			if (size == folder_finderinfo_len) {
+				memcpy(&entry.folder.user_info, value,
+						folder_finderinfo_len);
+				hfs_bnode_write(cat_fd.bnode, &entry,
+					cat_fd.entryoffset,
+					sizeof(struct hfsplus_cat_folder));
+				hfsplus_mark_inode_dirty(inode,
+						HFSPLUS_I_CAT_DIRTY);
+			} else {
+				err = -ERANGE;
+				goto end_setxattr;
+			}
+		} else if (be16_to_cpu(entry.type) == HFSPLUS_FILE) {
+			if (size == file_finderinfo_len) {
+				memcpy(&entry.file.user_info, value,
+						file_finderinfo_len);
+				hfs_bnode_write(cat_fd.bnode, &entry,
+					cat_fd.entryoffset,
+					sizeof(struct hfsplus_cat_file));
+				hfsplus_mark_inode_dirty(inode,
+						HFSPLUS_I_CAT_DIRTY);
+			} else {
+				err = -ERANGE;
+				goto end_setxattr;
+			}
+		} else {
+			err = -EOPNOTSUPP;
+			goto end_setxattr;
+		}
+		goto end_setxattr;
+	}
+
+	if (!HFSPLUS_SB(inode->i_sb)->attr_tree) {
+		err = -EOPNOTSUPP;
+		goto end_setxattr;
+	}
+
+	if (hfsplus_attr_exists(inode, name)) {
+		if (flags & XATTR_CREATE) {
+			printk(KERN_ERR "hfs: xattr exists yet\n");
+			err = -EOPNOTSUPP;
+			goto end_setxattr;
+		}
+		err = hfsplus_delete_attr(inode, name);
+		if (err)
+			goto end_setxattr;
+		err = hfsplus_create_attr(inode, name, value, size);
+		if (err)
+			goto end_setxattr;
+	} else {
+		if (flags & XATTR_REPLACE) {
+			printk(KERN_ERR "hfs: cannot replace xattr\n");
+			err = -EOPNOTSUPP;
+			goto end_setxattr;
+		}
+		err = hfsplus_create_attr(inode, name, value, size);
+		if (err)
+			goto end_setxattr;
+	}
+
+	cat_entry_type = hfs_bnode_read_u16(cat_fd.bnode, cat_fd.entryoffset);
+	if (cat_entry_type == HFSPLUS_FOLDER) {
+		cat_entry_flags = hfs_bnode_read_u16(cat_fd.bnode,
+				    cat_fd.entryoffset +
+				    offsetof(struct hfsplus_cat_folder, flags));
+		cat_entry_flags |= HFSPLUS_XATTR_EXISTS;
+		if (!strcmp_xattr_acl(name))
+			cat_entry_flags |= HFSPLUS_ACL_EXISTS;
+		hfs_bnode_write_u16(cat_fd.bnode, cat_fd.entryoffset +
+				offsetof(struct hfsplus_cat_folder, flags),
+				cat_entry_flags);
+		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
+	} else if (cat_entry_type == HFSPLUS_FILE) {
+		cat_entry_flags = hfs_bnode_read_u16(cat_fd.bnode,
+				    cat_fd.entryoffset +
+				    offsetof(struct hfsplus_cat_file, flags));
+		cat_entry_flags |= HFSPLUS_XATTR_EXISTS;
+		if (!strcmp_xattr_acl(name))
+			cat_entry_flags |= HFSPLUS_ACL_EXISTS;
+		hfs_bnode_write_u16(cat_fd.bnode, cat_fd.entryoffset +
+				    offsetof(struct hfsplus_cat_file, flags),
+				    cat_entry_flags);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
+	} else {
+		printk(KERN_ERR "hfs: invalid catalog entry type\n");
+		err = -EIO;
+		goto end_setxattr;
 	}
-out:
-	hfs_find_exit(&fd);
+
+end_setxattr:
+	hfs_find_exit(&cat_fd);
+	return err;
+}
+
+static ssize_t hfsplus_getxattr_finder_info(struct dentry *dentry,
+						void *value, size_t size)
+{
+	ssize_t res = 0;
+	struct inode *inode = dentry->d_inode;
+	struct hfs_find_data fd;
+	u16 entry_type;
+	u16 folder_rec_len = sizeof(struct DInfo) + sizeof(struct DXInfo);
+	u16 file_rec_len = sizeof(struct FInfo) + sizeof(struct FXInfo);
+	u16 record_len = max(folder_rec_len, file_rec_len);
+	u8 folder_finder_info[sizeof(struct DInfo) + sizeof(struct DXInfo)];
+	u8 file_finder_info[sizeof(struct FInfo) + sizeof(struct FXInfo)];
+
+	if (size >= record_len) {
+		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
+		if (res) {
+			printk(KERN_ERR "hfs: can't init xattr find struct\n");
+			return res;
+		}
+		res = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
+		if (res)
+			goto end_getxattr_finder_info;
+		entry_type = hfs_bnode_read_u16(fd.bnode, fd.entryoffset);
+
+		if (entry_type == HFSPLUS_FOLDER) {
+			hfs_bnode_read(fd.bnode, folder_finder_info,
+				fd.entryoffset +
+				offsetof(struct hfsplus_cat_folder, user_info),
+				folder_rec_len);
+			memcpy(value, folder_finder_info, folder_rec_len);
+			res = folder_rec_len;
+		} else if (entry_type == HFSPLUS_FILE) {
+			hfs_bnode_read(fd.bnode, file_finder_info,
+				fd.entryoffset +
+				offsetof(struct hfsplus_cat_file, user_info),
+				file_rec_len);
+			memcpy(value, file_finder_info, file_rec_len);
+			res = file_rec_len;
+		} else {
+			res = -EOPNOTSUPP;
+			goto end_getxattr_finder_info;
+		}
+	} else
+		res = size ? -ERANGE : record_len;
+
+end_getxattr_finder_info:
+	if (size >= record_len)
+		hfs_find_exit(&fd);
 	return res;
 }
 
@@ -201,60 +359,306 @@ ssize_t hfsplus_getxattr(struct dentry *
 {
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
-	hfsplus_cat_entry entry;
-	struct hfsplus_cat_file *file;
+	hfsplus_attr_entry *entry;
+	u32 record_type;
+	u16 record_length = 0;
 	ssize_t res = 0;
 
-	if (!S_ISREG(inode->i_mode) || HFSPLUS_IS_RSRC(inode))
+	if ((!S_ISREG(inode->i_mode) &&
+			!S_ISDIR(inode->i_mode)) ||
+				HFSPLUS_IS_RSRC(inode))
 		return -EOPNOTSUPP;
 
-	if (size) {
-		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
-		if (res)
-			return res;
-		res = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
-		if (res)
+	if (!strcmp_xattr_finder_info(name))
+		return hfsplus_getxattr_finder_info(dentry, value, size);
+
+	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
+		return -EOPNOTSUPP;
+
+	entry = hfsplus_alloc_attr_entry();
+	if (!entry) {
+		printk(KERN_ERR "hfs: can't allocate xattr entry\n");
+		return -ENOMEM;
+	}
+
+	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->attr_tree, &fd);
+	if (res) {
+		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		goto failed_getxattr_init;
+	}
+
+	res = hfsplus_find_attr(inode->i_sb, inode->i_ino, name, &fd);
+	if (res) {
+		if (res == -ENOENT)
+			res = -ENODATA;
+		else
+			printk(KERN_ERR "hfs: xattr searching failed\n");
+		goto out;
+	}
+
+	hfs_bnode_read(fd.bnode, &record_type,
+			fd.entryoffset, sizeof(record_type));
+	record_type = be32_to_cpu(record_type);
+	if (record_type == HFSPLUS_ATTR_INLINE_DATA) {
+		record_length = hfs_bnode_read_u16(fd.bnode,
+				fd.entryoffset +
+				offsetof(struct hfsplus_attr_inline_data,
+				length));
+		if (record_length > HFSPLUS_MAX_INLINE_DATA_SIZE) {
+			printk(KERN_ERR "hfs: invalid xattr record size\n");
+			res = -EIO;
 			goto out;
-		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
-				sizeof(struct hfsplus_cat_file));
+		}
+	} else if (record_type == HFSPLUS_ATTR_FORK_DATA ||
+			record_type == HFSPLUS_ATTR_EXTENTS) {
+		printk(KERN_ERR "hfs: only inline data xattr are supported\n");
+		res = -EOPNOTSUPP;
+		goto out;
+	} else {
+		printk(KERN_ERR "hfs: invalid xattr record\n");
+		res = -EIO;
+		goto out;
+	}
+
+	if (size) {
+		hfs_bnode_read(fd.bnode, entry, fd.entryoffset,
+				offsetof(struct hfsplus_attr_inline_data,
+					raw_bytes) + record_length);
 	}
-	file = &entry.file;
 
-	if (!strcmp(name, "hfs.type")) {
-		if (size >= 4) {
-			memcpy(value, &file->user_info.fdType, 4);
-			res = 4;
-		} else
-			res = size ? -ERANGE : 4;
-	} else if (!strcmp(name, "hfs.creator")) {
-		if (size >= 4) {
-			memcpy(value, &file->user_info.fdCreator, 4);
-			res = 4;
-		} else
-			res = size ? -ERANGE : 4;
+	if (size >= record_length) {
+		memcpy(value, entry->inline_data.raw_bytes, record_length);
+		res = record_length;
 	} else
-		res = -EOPNOTSUPP;
+		res = size ? -ERANGE : record_length;
+
 out:
-	if (size)
-		hfs_find_exit(&fd);
+	hfs_find_exit(&fd);
+
+failed_getxattr_init:
+	hfsplus_destroy_attr_entry(entry);
 	return res;
 }
 
-#define HFSPLUS_ATTRLIST_SIZE (sizeof("hfs.creator")+sizeof("hfs.type"))
+static ssize_t hfsplus_listxattr_finder_info(struct dentry *dentry,
+						char *buffer, size_t size)
+{
+	ssize_t res = 0;
+	struct inode *inode = dentry->d_inode;
+	struct hfs_find_data fd;
+	u16 entry_type;
+	u8 folder_finder_info[sizeof(struct DInfo) + sizeof(struct DXInfo)];
+	u8 file_finder_info[sizeof(struct FInfo) + sizeof(struct FXInfo)];
+	unsigned long len, found_bit;
+
+	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
+	if (res) {
+		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		return res;
+	}
+
+	res = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
+	if (res)
+		goto end_listxattr_finder_info;
+
+	entry_type = hfs_bnode_read_u16(fd.bnode, fd.entryoffset);
+	if (entry_type == HFSPLUS_FOLDER) {
+		len = sizeof(struct DInfo) + sizeof(struct DXInfo);
+		hfs_bnode_read(fd.bnode, folder_finder_info,
+				fd.entryoffset +
+				offsetof(struct hfsplus_cat_folder, user_info),
+				len);
+		found_bit = find_first_bit((void *)folder_finder_info, len*8);
+	} else if (entry_type == HFSPLUS_FILE) {
+		len = sizeof(struct FInfo) + sizeof(struct FXInfo);
+		hfs_bnode_read(fd.bnode, file_finder_info,
+				fd.entryoffset +
+				offsetof(struct hfsplus_cat_file, user_info),
+				len);
+		found_bit = find_first_bit((void *)file_finder_info, len*8);
+	} else {
+		res = -EOPNOTSUPP;
+		goto end_listxattr_finder_info;
+	}
+
+	if (found_bit >= (len*8))
+		res = 0;
+	else {
+		if (!buffer || !size) {
+			res = sizeof(HFSPLUS_XATTR_FINDER_INFO_NAME);
+		} else if (size < sizeof(HFSPLUS_XATTR_FINDER_INFO_NAME)) {
+			res = -ERANGE;
+		} else {
+			strncpy(buffer, HFSPLUS_XATTR_FINDER_INFO_NAME,
+				    sizeof(HFSPLUS_XATTR_FINDER_INFO_NAME));
+			res = sizeof(HFSPLUS_XATTR_FINDER_INFO_NAME);
+		}
+	}
+
+end_listxattr_finder_info:
+	hfs_find_exit(&fd);
+
+	return res;
+}
 
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
+	ssize_t err;
+	ssize_t res = 0;
 	struct inode *inode = dentry->d_inode;
+	struct hfs_find_data fd;
+	u16 key_len = 0;
+	struct hfsplus_attr_key attr_key;
+	char strbuf[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
+	int name_len;
+
+	if ((!S_ISREG(inode->i_mode) &&
+			!S_ISDIR(inode->i_mode)) ||
+				HFSPLUS_IS_RSRC(inode))
+		return -EOPNOTSUPP;
+
+	res = hfsplus_listxattr_finder_info(dentry, buffer, size);
+	if (res < 0)
+		return res;
+	else if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
+		return (res == 0) ? -EOPNOTSUPP : res;
 
-	if (!S_ISREG(inode->i_mode) || HFSPLUS_IS_RSRC(inode))
+	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->attr_tree, &fd);
+	if (err) {
+		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		return err;
+	}
+
+	err = hfsplus_find_attr(inode->i_sb, inode->i_ino, NULL, &fd);
+	if (err) {
+		if (err == -ENOENT) {
+			if (res == 0)
+				res = -ENODATA;
+			goto end_listxattr;
+		} else {
+			res = err;
+			goto end_listxattr;
+		}
+	}
+
+	for (;;) {
+		key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
+		if (key_len == 0 || key_len > fd.tree->max_key_len) {
+			printk(KERN_ERR "hfs: invalid xattr key length: %d\n",
+							key_len);
+			res = -EIO;
+			goto end_listxattr;
+		}
+
+		hfs_bnode_read(fd.bnode, &attr_key,
+				fd.keyoffset, key_len + sizeof(key_len));
+
+		if (be32_to_cpu(attr_key.cnid) != inode->i_ino)
+			goto end_listxattr;
+
+		name_len = HFSPLUS_ATTR_MAX_STRLEN;
+		if (hfsplus_uni2asc(inode->i_sb,
+			(const struct hfsplus_unistr *)&fd.key->attr.key_name,
+					strbuf, &name_len)) {
+			printk(KERN_ERR "hfs: unicode conversion failed\n");
+			res = -EIO;
+			goto end_listxattr;
+		}
+
+		if (!buffer || !size)
+			res += name_len + 1;
+		else if (size < (res + name_len + 1)) {
+			res = -ERANGE;
+			goto end_listxattr;
+		} else {
+			strncpy(buffer + res, strbuf, name_len);
+			memset(buffer + res + name_len, 0, 1);
+			res += name_len + 1;
+		}
+
+		if (hfs_brec_goto(&fd, 1))
+			goto end_listxattr;
+	}
+
+end_listxattr:
+	hfs_find_exit(&fd);
+	return res;
+}
+
+int hfsplus_removexattr(struct dentry *dentry, const char *name)
+{
+	int err = 0;
+	struct inode *inode = dentry->d_inode;
+	struct hfs_find_data cat_fd;
+	u16 flags;
+	u16 cat_entry_type;
+	int is_xattr_acl_deleted = 0;
+	int is_all_xattrs_deleted = 0;
+
+	if ((!S_ISREG(inode->i_mode) &&
+			!S_ISDIR(inode->i_mode)) ||
+				HFSPLUS_IS_RSRC(inode))
+		return -EOPNOTSUPP;
+
+	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
+		return -EOPNOTSUPP;
+
+	if (!strcmp_xattr_finder_info(name))
 		return -EOPNOTSUPP;
 
-	if (!buffer || !size)
-		return HFSPLUS_ATTRLIST_SIZE;
-	if (size < HFSPLUS_ATTRLIST_SIZE)
-		return -ERANGE;
-	strcpy(buffer, "hfs.type");
-	strcpy(buffer + sizeof("hfs.type"), "hfs.creator");
+	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
+	if (err) {
+		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		return err;
+	}
+
+	err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &cat_fd);
+	if (err) {
+		printk(KERN_ERR "hfs: catalog searching failed\n");
+		goto end_removexattr;
+	}
+
+	err = hfsplus_delete_attr(inode, name);
+	if (err)
+		goto end_removexattr;
+
+	is_xattr_acl_deleted = !strcmp_xattr_acl(name);
+	is_all_xattrs_deleted = !hfsplus_attr_exists(inode, NULL);
+
+	if (!is_xattr_acl_deleted && !is_all_xattrs_deleted)
+		goto end_removexattr;
+
+	cat_entry_type = hfs_bnode_read_u16(cat_fd.bnode, cat_fd.entryoffset);
+
+	if (cat_entry_type == HFSPLUS_FOLDER) {
+		flags = hfs_bnode_read_u16(cat_fd.bnode, cat_fd.entryoffset +
+				offsetof(struct hfsplus_cat_folder, flags));
+		if (is_xattr_acl_deleted)
+			flags &= ~HFSPLUS_ACL_EXISTS;
+		if (is_all_xattrs_deleted)
+			flags &= ~HFSPLUS_XATTR_EXISTS;
+		hfs_bnode_write_u16(cat_fd.bnode, cat_fd.entryoffset +
+				offsetof(struct hfsplus_cat_folder, flags),
+				flags);
+		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
+	} else if (cat_entry_type == HFSPLUS_FILE) {
+		flags = hfs_bnode_read_u16(cat_fd.bnode, cat_fd.entryoffset +
+				offsetof(struct hfsplus_cat_file, flags));
+		if (is_xattr_acl_deleted)
+			flags &= ~HFSPLUS_ACL_EXISTS;
+		if (is_all_xattrs_deleted)
+			flags &= ~HFSPLUS_XATTR_EXISTS;
+		hfs_bnode_write_u16(cat_fd.bnode, cat_fd.entryoffset +
+				offsetof(struct hfsplus_cat_file, flags),
+				flags);
+		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
+	} else {
+		printk(KERN_ERR "hfs: invalid catalog entry type\n");
+		err = -EIO;
+		goto end_removexattr;
+	}
 
-	return HFSPLUS_ATTRLIST_SIZE;
+end_removexattr:
+	hfs_find_exit(&cat_fd);
+	return err;
 }
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

