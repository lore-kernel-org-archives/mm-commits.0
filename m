From: akpm@linux-foundation.org
Subject: + cramfs-make-cramfs-little-endian-only.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:11:29 -0800
Message-ID: <200712042011.lB4KBTe0002751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbXLDULl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lists-receive@programmierforen.de, andi@programmierforen.de


The patch titled
     cramfs: make cramfs little endian only
has been added to the -mm tree.  Its filename is
     cramfs-make-cramfs-little-endian-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cramfs: make cramfs little endian only
From: Andi Drebes <lists-receive@programmierforen.de>

Make cramfs little endian only.  When trying to mount a big endian image, an
error message is produced.

The changes were tested on the following types of machines: An i386 compatible
box (little endian) UltraSparc IIi (big endian)

Signed-off-by: Andi Drebes <andi@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |  163 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 136 insertions(+), 27 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-make-cramfs-little-endian-only fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-make-cramfs-little-endian-only
+++ a/fs/cramfs/inode.c
@@ -4,6 +4,10 @@
  * Copyright (C) 1999 Linus Torvalds.
  *
  * This file is released under the GPL.
+ *
+ * Changelog:
+ *	11/07 - Andi Drebes <andi@programmierforen.de>
+ *	Made cramfs little endian only.
  */
 
 /*
@@ -40,6 +44,95 @@ static DEFINE_MUTEX(read_mutex);
 #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
 #define OFFSET(x)	((x)->i_ino)
 
+#ifdef __BIG_ENDIAN
+/* Converts a cramfs_info from little endian to big endian. */
+static inline void cramfs_convert_info_letobe(struct cramfs_info* info)
+{
+	 info->crc = swab32(info->crc);
+	 info->edition = swab32(info->edition);
+	 info->blocks = swab32(info->blocks);
+	 info->files = swab32(info->files);
+}
+
+/* Converts a cramfs_info from little endian to big endian. */
+static inline void cramfs_convert_inode_letobe(struct cramfs_inode* inode)
+{
+	u8* inode_bytes = (u8*)inode;
+	u8 old_nloffs[4];
+
+	inode->mode = swab16(inode->mode);
+	inode->uid = swab16(inode->uid);
+	inode->size = (inode_bytes[6] << 16) | (inode_bytes[5] << 8) | (inode_bytes[4]);
+
+	/* Save the old values of the namelength and the offset */
+	memcpy(old_nloffs, inode_bytes+8, 4);
+
+	/* Convert the namelength and the offset */
+	inode_bytes[8] = ((old_nloffs[0] & 0x3f) << 2) | ((old_nloffs[3] & 0xc0) >> 6);
+	inode_bytes[9] = ((old_nloffs[3] & 0x3f) << 2) | ((old_nloffs[2] & 0xc0) >> 6);
+	inode_bytes[10] = ((old_nloffs[2] & 0x3f) << 2) | ((old_nloffs[1] & 0xc0) >> 6);
+	inode_bytes[11] = ((old_nloffs[1] & 0x3f) << 2) | ((old_nloffs[0] & 0xc0) >> 6);
+}
+
+/* Converts a cramfs superblock from little endian to big endian. */
+static inline void cramfs_convert_super_letobe(struct cramfs_super* super)
+{
+	super->magic = swab32(super->magic);
+	super->size = swab32(super->size);
+	super->flags = swab32(super->flags);
+	super->future = swab32(super->future);
+	cramfs_convert_info_letobe(&super->fsid);
+	cramfs_convert_inode_letobe(&super->root);
+}
+
+/* Converts a 32 bit integer from little endian to big endian */
+static inline u32 cramfs_convert_u32_letobe(u32 val)
+{
+	return swab32(val);
+}
+
+static inline void cramfs_info_to_host(struct cramfs_info *info)
+{
+	cramfs_convert_info_letobe(info);
+}
+
+static inline void cramfs_inode_to_host(struct cramfs_inode *inode)
+{
+	cramfs_convert_inode_letobe(inode);
+}
+
+static inline void cramfs_super_to_host(struct cramfs_super *super)
+{
+	cramfs_convert_super_letobe(super);
+}
+
+static inline u32 cramfs_u32_to_host(u32 val)
+{
+	return cramfs_convert_u32_letobe(val);
+}
+
+#elif defined(__LITTLE_ENDIAN)
+
+static inline void cramfs_info_to_host(struct cramfs_info *info)
+{
+}
+
+static inline void cramfs_inode_to_host(struct cramfs_inode *inode)
+{
+}
+
+static inline void cramfs_super_to_host(struct cramfs_super *super)
+{
+}
+
+static inline u32 cramfs_u32_to_host(u32 val)
+{
+	return val;
+}
+
+#else
+#error "Neither __BIG_ENDIAN nor __LITTLE_ENDIAN defined."
+#endif
 
 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
@@ -253,29 +346,35 @@ static int cramfs_fill_super(struct supe
 
 	/* Read the first block and get the superblock from it */
 	memcpy(&super, cramfs_read(sb, 0, sizeof(super)), sizeof(super));
+	cramfs_super_to_host(&super);
 	mutex_unlock(&read_mutex);
 
 	/* Do sanity checks on the superblock */
-	if (super.magic != CRAMFS_MAGIC) {
-		/* check for wrong endianess */
-		if (super.magic == CRAMFS_MAGIC_WEND) {
-			if (!silent)
-				printk(KERN_ERR "cramfs: wrong endianess\n");
-			goto out;
-		}
-
+	if (super.magic != CRAMFS_MAGIC && super.magic != CRAMFS_MAGIC_WEND) {
 		/* check at 512 byte offset */
 		mutex_lock(&read_mutex);
 		memcpy(&super, cramfs_read(sb, 512, sizeof(super)), sizeof(super));
+		cramfs_super_to_host(&super);
 		mutex_unlock(&read_mutex);
-		if (super.magic != CRAMFS_MAGIC) {
-			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				printk(KERN_ERR "cramfs: wrong endianess\n");
-			else if (!silent)
+
+		if (super.magic == CRAMFS_MAGIC_WEND) {
+			goto other_endian;
+		}
+		else if (super.magic != CRAMFS_MAGIC) {
+			if (!silent)
 				printk(KERN_ERR "cramfs: wrong magic\n");
+
 			goto out;
 		}
 	}
+	/* check for wrong endianess */
+	else if (super.magic == CRAMFS_MAGIC_WEND) {
+other_endian:
+		if (!silent)
+			printk(KERN_ERR "cramfs: filesystems in big endian format are not supported any longer.\n");
+
+		goto out;
+	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
@@ -367,7 +466,8 @@ static int cramfs_readdir(struct file *f
 
 	copied = 0;
 	while (offset < inode->i_size) {
-		struct cramfs_inode *de;
+		void *inode_data;
+		struct cramfs_inode de;
 		unsigned long nextoffset;
 		char *name;
 		ino_t ino;
@@ -375,20 +475,22 @@ static int cramfs_readdir(struct file *f
 		int namelen, error;
 
 		mutex_lock(&read_mutex);
-		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
-		name = (char *)(de+1);
+		inode_data = cramfs_read(sb, OFFSET(inode) + offset, sizeof(de)+CRAMFS_MAXPATHLEN);
+		memcpy(&de, inode_data, sizeof(de));
+		name = inode_data+sizeof(de);
+		cramfs_inode_to_host(&de);
 
 		/*
 		 * Namelengths on disk are shifted by two
 		 * and the name padded out to 4-byte boundaries
 		 * with zeroes.
 		 */
-		namelen = de->namelen << 2;
+		namelen = de.namelen << 2;
 		memcpy(buf, name, namelen);
-		ino = CRAMINO(de);
-		mode = de->mode;
+		ino = CRAMINO(&de);
+		mode = de.mode;
 		mutex_unlock(&read_mutex);
-		nextoffset = offset + sizeof(*de) + namelen;
+		nextoffset = offset + sizeof(de) + namelen;
 		for (;;) {
 			if (!namelen) {
 				kfree(buf);
@@ -421,19 +523,22 @@ static struct dentry * cramfs_lookup(str
 	mutex_lock(&read_mutex);
 	sorted = CRAMFS_SB(dir->i_sb)->flags & CRAMFS_FLAG_SORTED_DIRS;
 	while (offset < dir->i_size) {
-		struct cramfs_inode *de;
+		void* inode_data;
+		struct cramfs_inode de;
 		char *name;
 		int namelen, retval;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
-		name = (char *)(de+1);
+		inode_data = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(de)+CRAMFS_MAXPATHLEN);
+		memcpy(&de, inode_data, sizeof(de));
+		name = (char *)(inode_data+sizeof(de));
+		cramfs_inode_to_host(&de);
 
 		/* Try to take advantage of sorted directories */
 		if (sorted && (dentry->d_name.name[0] < name[0]))
 			break;
 
-		namelen = de->namelen << 2;
-		offset += sizeof(*de) + namelen;
+		namelen = de.namelen << 2;
+		offset += sizeof(de) + namelen;
 
 		/* Quick check that the name is roughly the right length */
 		if (((dentry->d_name.len + 3) & ~3) != namelen)
@@ -454,7 +559,7 @@ static struct dentry * cramfs_lookup(str
 		if (retval > 0)
 			continue;
 		if (!retval) {
-			struct cramfs_inode entry = *de;
+			struct cramfs_inode entry = de;
 			mutex_unlock(&read_mutex);
 			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry));
 			return NULL;
@@ -483,9 +588,13 @@ static int cramfs_readpage(struct file *
 
 		start_offset = OFFSET(inode) + maxblock*4;
 		mutex_lock(&read_mutex);
-		if (page->index)
+		if (page->index) {
 			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
-		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
+			start_offset = cramfs_u32_to_host(start_offset);
+		}
+
+		compr_len = cramfs_u32_to_host(*(u32 *) cramfs_read(sb, blkptr_offset, 4)) - start_offset;
+
 		mutex_unlock(&read_mutex);
 		pgdata = kmap(page);
 		if (compr_len == 0)
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

cramfs-make-cramfs-little-endian-only.patch
cramfs-make-cramfs-little-endian-only-fix.patch
cramfs-update-documentation.patch
