From: akpm@linux-foundation.org
Subject: - hfs-add-custom-dentry-hash-and-comparison-operations.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:52 -0700
Message-ID: <200707162057.l6GKvqJu002233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761436AbXGPVPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     HFS+: add custom dentry hash and comparison operations
has been removed from the -mm tree.  Its filename was
     hfs-add-custom-dentry-hash-and-comparison-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HFS+: add custom dentry hash and comparison operations
From: Duane Griffin <duaneg@dghda.com>

Add custom dentry hash and comparison operations for HFS+ filesystems that are
case-insensitive and/or do automatic unicode decomposition.  The new
operations reuse the existing HFS+ ASCII to unicode conversion, unicode
decomposition and case folding functionality.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c      |    4 -
 fs/hfsplus/dir.c        |    2 
 fs/hfsplus/hfsplus_fs.h |    4 +
 fs/hfsplus/inode.c      |    5 +
 fs/hfsplus/super.c      |    1 
 fs/hfsplus/unicode.c    |  123 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 138 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/btree.c~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/btree.c
@@ -62,8 +62,10 @@ struct hfs_btree *hfs_btree_open(struct 
 		if ((HFSPLUS_SB(sb).flags & HFSPLUS_SB_HFSX) &&
 		    (head->key_type == HFSPLUS_KEY_BINARY))
 			tree->keycmp = hfsplus_cat_bin_cmp_key;
-		else
+		else {
 			tree->keycmp = hfsplus_cat_case_cmp_key;
+			HFSPLUS_SB(sb).flags |= HFSPLUS_SB_CASEFOLD;
+		}
 	} else {
 		printk(KERN_ERR "hfs: unknown B*Tree requested\n");
 		goto fail_page;
diff -puN fs/hfsplus/dir.c~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/dir.c
@@ -36,6 +36,8 @@ static struct dentry *hfsplus_lookup(str
 	u16 type;
 
 	sb = dir->i_sb;
+
+	dentry->d_op = &hfsplus_dentry_operations;
 	dentry->d_fsdata = NULL;
 	hfs_find_init(HFSPLUS_SB(sb).cat_tree, &fd);
 	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
diff -puN fs/hfsplus/hfsplus_fs.h~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -150,6 +150,7 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_NODECOMPOSE	0x0002
 #define HFSPLUS_SB_FORCE	0x0004
 #define HFSPLUS_SB_HFSX		0x0008
+#define HFSPLUS_SB_CASEFOLD	0x0010
 
 
 struct hfsplus_inode_info {
@@ -321,6 +322,7 @@ void hfsplus_file_truncate(struct inode 
 /* inode.c */
 extern const struct address_space_operations hfsplus_aops;
 extern const struct address_space_operations hfsplus_btree_aops;
+extern struct dentry_operations hfsplus_dentry_operations;
 
 void hfsplus_inode_read_fork(struct inode *, struct hfsplus_fork_raw *);
 void hfsplus_inode_write_fork(struct inode *, struct hfsplus_fork_raw *);
@@ -353,6 +355,8 @@ int hfsplus_strcasecmp(const struct hfsp
 int hfsplus_strcmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
+int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
+int hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2);
 
 /* wrapper.c */
 int hfsplus_read_wrapper(struct super_block *);
diff -puN fs/hfsplus/inode.c~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/inode.c
@@ -131,6 +131,11 @@ const struct address_space_operations hf
 	.writepages	= hfsplus_writepages,
 };
 
+struct dentry_operations hfsplus_dentry_operations = {
+	.d_hash       = hfsplus_hash_dentry,
+	.d_compare    = hfsplus_compare_dentry,
+};
+
 static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dentry,
 					  struct nameidata *nd)
 {
diff -puN fs/hfsplus/super.c~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/super.c
@@ -380,6 +380,7 @@ static int hfsplus_fill_super(struct sup
 		iput(root);
 		goto cleanup;
 	}
+	sb->s_root->d_op = &hfsplus_dentry_operations;
 
 	str.len = sizeof(HFSP_HIDDENDIR_NAME) - 1;
 	str.name = HFSP_HIDDENDIR_NAME;
diff -puN fs/hfsplus/unicode.c~hfs-add-custom-dentry-hash-and-comparison-operations fs/hfsplus/unicode.c
--- a/fs/hfsplus/unicode.c~hfs-add-custom-dentry-hash-and-comparison-operations
+++ a/fs/hfsplus/unicode.c
@@ -314,3 +314,126 @@ int hfsplus_asc2uni(struct super_block *
 		return -ENAMETOOLONG;
 	return 0;
 }
+
+/*
+ * Hash a string to an integer as appropriate for the HFS+ filesystem.
+ * Composed unicode characters are decomposed and case-folding is performed
+ * if the appropriate bits are (un)set on the superblock.
+ */
+int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str)
+{
+	struct super_block *sb = dentry->d_sb;
+	const char *astr;
+	const u16 *dstr;
+	int casefold, decompose, size, dsize, len;
+	unsigned long hash;
+	wchar_t c;
+	u16 c2;
+
+	casefold = (HFSPLUS_SB(sb).flags & HFSPLUS_SB_CASEFOLD);
+	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
+	hash = init_name_hash();
+	astr = str->name;
+	len = str->len;
+	while (len > 0) {
+		size = asc2unichar(sb, astr, len, &c);
+		astr += size;
+		len -= size;
+
+		if (decompose && (dstr = decompose_unichar(c, &dsize))) {
+			do {
+				c2 = *dstr++;
+				if (!casefold || (c2 = case_fold(c2)))
+					hash = partial_name_hash(c2, hash);
+			} while (--dsize > 0);
+		} else {
+			c2 = c;
+			if (!casefold || (c2 = case_fold(c2)))
+				hash = partial_name_hash(c2, hash);
+		}
+	}
+	str->hash = end_name_hash(hash);
+
+	return 0;
+}
+
+/*
+ * Compare strings with HFS+ filename ordering.
+ * Composed unicode characters are decomposed and case-folding is performed
+ * if the appropriate bits are (un)set on the superblock.
+ */
+int hfsplus_compare_dentry(struct dentry *dentry, struct qstr *s1, struct qstr *s2)
+{
+	struct super_block *sb = dentry->d_sb;
+	int casefold, decompose, size;
+	int dsize1, dsize2, len1, len2;
+	const u16 *dstr1, *dstr2;
+	const char *astr1, *astr2;
+	u16 c1, c2;
+	wchar_t c;
+
+	casefold = (HFSPLUS_SB(sb).flags & HFSPLUS_SB_CASEFOLD);
+	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
+	astr1 = s1->name;
+	len1 = s1->len;
+	astr2 = s2->name;
+	len2 = s2->len;
+	dsize1 = dsize2 = 0;
+	dstr1 = dstr2 = NULL;
+
+	while (len1 > 0 && len2 > 0) {
+		if (!dsize1) {
+			size = asc2unichar(sb, astr1, len1, &c);
+			astr1 += size;
+			len1 -= size;
+
+			if (!decompose || !(dstr1 = decompose_unichar(c, &dsize1))) {
+				c1 = c;
+				dstr1 = &c1;
+				dsize1 = 1;
+			}
+		}
+
+		if (!dsize2) {
+			size = asc2unichar(sb, astr2, len2, &c);
+			astr2 += size;
+			len2 -= size;
+
+			if (!decompose || !(dstr2 = decompose_unichar(c, &dsize2))) {
+				c2 = c;
+				dstr2 = &c2;
+				dsize2 = 1;
+			}
+		}
+
+		c1 = *dstr1;
+		c2 = *dstr2;
+		if (casefold) {
+			if  (!(c1 = case_fold(c1))) {
+				dstr1++;
+				dsize1--;
+				continue;
+			}
+			if (!(c2 = case_fold(c2))) {
+				dstr2++;
+				dsize2--;
+				continue;
+			}
+		}
+		if (c1 < c2)
+			return -1;
+		else if (c1 > c2)
+			return 1;
+
+		dstr1++;
+		dsize1--;
+		dstr2++;
+		dsize2--;
+	}
+
+	if (len1 < len2)
+		return -1;
+	if (len1 > len2)
+		return 1;
+	return 0;
+}
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
