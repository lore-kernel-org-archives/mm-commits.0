From: akpm@linux-foundation.org
Subject: [patch 28/84] nilfs2: avoid bare use of 'unsigned'
Date: Mon, 23 May 2016 16:23:39 -0700
Message-ID: <574390fb.nuE8rvpgePuaDRW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: avoid bare use of 'unsigned'

This fixes checkpatch.pl warning "WARNING: Prefer 'unsigned int' to
bare use of 'unsigned'".

Link: http://lkml.kernel.org/r/1462886671-3521-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c         |    8 +++---
 fs/nilfs2/alloc.h         |    2 -
 fs/nilfs2/bmap.c          |    2 -
 fs/nilfs2/bmap.h          |    4 +--
 fs/nilfs2/btree.c         |    3 +-
 fs/nilfs2/cpfile.c        |    8 +++---
 fs/nilfs2/cpfile.h        |    4 +--
 fs/nilfs2/dat.c           |    2 -
 fs/nilfs2/dat.h           |    2 -
 fs/nilfs2/dir.c           |   47 ++++++++++++++++++------------------
 fs/nilfs2/direct.c        |    5 ++-
 fs/nilfs2/inode.c         |   14 +++++-----
 fs/nilfs2/mdt.c           |    4 +--
 fs/nilfs2/mdt.h           |    6 ++--
 fs/nilfs2/namei.c         |    2 -
 fs/nilfs2/nilfs.h         |    2 -
 fs/nilfs2/page.c          |    8 +++---
 fs/nilfs2/page.h          |    3 +-
 fs/nilfs2/recovery.c      |    4 +--
 fs/nilfs2/segbuf.c        |    4 +--
 fs/nilfs2/segbuf.h        |    5 ++-
 fs/nilfs2/segment.c       |   18 ++++++-------
 fs/nilfs2/segment.h       |    4 +--
 fs/nilfs2/sysfs.c         |    6 ++--
 fs/nilfs2/the_nilfs.c     |    4 +--
 fs/nilfs2/the_nilfs.h     |   10 +++----
 include/linux/nilfs2_fs.h |    6 ++--
 27 files changed, 97 insertions(+), 90 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/alloc.c
@@ -53,7 +53,7 @@ nilfs_palloc_groups_count(const struct i
  * @inode: inode of metadata file using this allocator
  * @entry_size: size of the persistent object
  */
-int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
+int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned int entry_size)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 
@@ -384,7 +384,7 @@ void *nilfs_palloc_block_get_entry(const
  */
 static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
-					    unsigned bsize,
+					    unsigned int bsize,
 					    spinlock_t *lock)
 {
 	int pos, end = bsize;
@@ -735,8 +735,8 @@ int nilfs_palloc_freev(struct inode *ino
 	unsigned long group, group_offset;
 	__u64 group_min_nr, last_nrs[8];
 	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
-	const unsigned epb = NILFS_MDT(inode)->mi_entries_per_block;
-	unsigned entry_start, end, pos;
+	const unsigned int epb = NILFS_MDT(inode)->mi_entries_per_block;
+	unsigned int entry_start, end, pos;
 	spinlock_t *lock;
 	int i, j, k, ret;
 	u32 nfree;
diff -puN fs/nilfs2/alloc.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/alloc.h
@@ -37,7 +37,7 @@ nilfs_palloc_entries_per_group(const str
 	return 1UL << (inode->i_blkbits + 3 /* log2(8 = CHAR_BITS) */);
 }
 
-int nilfs_palloc_init_blockgroup(struct inode *, unsigned);
+int nilfs_palloc_init_blockgroup(struct inode *, unsigned int);
 int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
diff -puN fs/nilfs2/bmap.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/bmap.c
@@ -93,7 +93,7 @@ int nilfs_bmap_lookup_at_level(struct ni
 }
 
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
-			     unsigned maxblocks)
+			     unsigned int maxblocks)
 {
 	int ret;
 
diff -puN fs/nilfs2/bmap.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/bmap.h
--- a/fs/nilfs2/bmap.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/bmap.h
@@ -57,7 +57,7 @@ struct nilfs_bmap_stats {
 struct nilfs_bmap_operations {
 	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
 	int (*bop_lookup_contig)(const struct nilfs_bmap *, __u64, __u64 *,
-				 unsigned);
+				 unsigned int);
 	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
 	int (*bop_delete)(struct nilfs_bmap *, __u64);
 	void (*bop_clear)(struct nilfs_bmap *);
@@ -150,7 +150,7 @@ struct nilfs_bmap_store {
 int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
 void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
-int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
+int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned int);
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec);
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key);
 int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp);
diff -puN fs/nilfs2/btree.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/btree.c
@@ -685,7 +685,8 @@ static int nilfs_btree_lookup(const stru
 }
 
 static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
-				     __u64 key, __u64 *ptrp, unsigned maxblocks)
+				     __u64 key, __u64 *ptrp,
+				     unsigned int maxblocks)
 {
 	struct nilfs_btree_path *path;
 	struct nilfs_btree_node *node;
diff -puN fs/nilfs2/cpfile.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/cpfile.c
@@ -431,7 +431,8 @@ static void nilfs_cpfile_checkpoint_to_c
 }
 
 static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
-					  void *buf, unsigned cisz, size_t nci)
+					  void *buf, unsigned int cisz,
+					  size_t nci)
 {
 	struct nilfs_checkpoint *cp;
 	struct nilfs_cpinfo *ci = buf;
@@ -482,7 +483,8 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 }
 
 static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
-					  void *buf, unsigned cisz, size_t nci)
+					  void *buf, unsigned int cisz,
+					  size_t nci)
 {
 	struct buffer_head *bh;
 	struct nilfs_cpfile_header *header;
@@ -568,7 +570,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
  */
 
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
-				void *buf, unsigned cisz, size_t nci)
+				void *buf, unsigned int cisz, size_t nci)
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
diff -puN fs/nilfs2/cpfile.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/cpfile.h
--- a/fs/nilfs2/cpfile.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/cpfile.h
@@ -33,8 +33,8 @@ int nilfs_cpfile_delete_checkpoint(struc
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
 int nilfs_cpfile_is_snapshot(struct inode *, __u64);
 int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *, unsigned,
-				size_t);
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *,
+				unsigned int, size_t);
 
 int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
diff -puN fs/nilfs2/dat.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/dat.c
@@ -424,7 +424,7 @@ int nilfs_dat_translate(struct inode *da
 	return ret;
 }
 
-ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
+ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned int visz,
 			    size_t nvi)
 {
 	struct buffer_head *entry_bh;
diff -puN fs/nilfs2/dat.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/dat.h
--- a/fs/nilfs2/dat.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/dat.h
@@ -47,7 +47,7 @@ void nilfs_dat_abort_update(struct inode
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
-ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
+ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned int, size_t);
 
 int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 		   struct nilfs_inode *raw_inode, struct inode **inodep);
diff -puN fs/nilfs2/dir.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/dir.c
@@ -46,7 +46,7 @@
  * nilfs uses block-sized chunks. Arguably, sector-sized ones would be
  * more robust, but we have what we have
  */
-static inline unsigned nilfs_chunk_size(struct inode *inode)
+static inline unsigned int nilfs_chunk_size(struct inode *inode)
 {
 	return inode->i_sb->s_blocksize;
 }
@@ -61,9 +61,9 @@ static inline void nilfs_put_page(struct
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
  */
-static unsigned nilfs_last_byte(struct inode *inode, unsigned long page_nr)
+static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned last_byte = inode->i_size;
+	unsigned int last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
@@ -71,7 +71,8 @@ static unsigned nilfs_last_byte(struct i
 	return last_byte;
 }
 
-static int nilfs_prepare_chunk(struct page *page, unsigned from, unsigned to)
+static int nilfs_prepare_chunk(struct page *page, unsigned int from,
+			       unsigned int to)
 {
 	loff_t pos = page_offset(page) + from;
 
@@ -80,12 +81,12 @@ static int nilfs_prepare_chunk(struct pa
 
 static void nilfs_commit_chunk(struct page *page,
 			       struct address_space *mapping,
-			       unsigned from, unsigned to)
+			       unsigned int from, unsigned int to)
 {
 	struct inode *dir = mapping->host;
 	loff_t pos = page_offset(page) + from;
-	unsigned len = to - from;
-	unsigned nr_dirty, copied;
+	unsigned int len = to - from;
+	unsigned int nr_dirty, copied;
 	int err;
 
 	nr_dirty = nilfs_page_count_clean_buffers(page, from, to);
@@ -103,10 +104,10 @@ static bool nilfs_check_page(struct page
 {
 	struct inode *dir = page->mapping->host;
 	struct super_block *sb = dir->i_sb;
-	unsigned chunk_size = nilfs_chunk_size(dir);
+	unsigned int chunk_size = nilfs_chunk_size(dir);
 	char *kaddr = page_address(page);
-	unsigned offs, rec_len;
-	unsigned limit = PAGE_SIZE;
+	unsigned int offs, rec_len;
+	unsigned int limit = PAGE_SIZE;
 	struct nilfs_dir_entry *p;
 	char *error;
 
@@ -256,7 +257,6 @@ static int nilfs_readdir(struct file *fi
 	unsigned int offset = pos & ~PAGE_MASK;
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
-/*	unsigned chunk_mask = ~(nilfs_chunk_size(inode)-1); */
 
 	if (pos > inode->i_size - NILFS_DIR_REC_LEN(1))
 		return 0;
@@ -318,7 +318,7 @@ nilfs_find_entry(struct inode *dir, cons
 {
 	const unsigned char *name = qstr->name;
 	int namelen = qstr->len;
-	unsigned reclen = NILFS_DIR_REC_LEN(namelen);
+	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = dir_pages(dir);
 	struct page *page = NULL;
@@ -408,8 +408,8 @@ ino_t nilfs_inode_by_name(struct inode *
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
-	unsigned from = (char *) de - (char *) page_address(page);
-	unsigned to = from + nilfs_rec_len_from_disk(de->rec_len);
+	unsigned int from = (char *)de - (char *)page_address(page);
+	unsigned int to = from + nilfs_rec_len_from_disk(de->rec_len);
 	struct address_space *mapping = page->mapping;
 	int err;
 
@@ -431,15 +431,15 @@ int nilfs_add_link(struct dentry *dentry
 	struct inode *dir = d_inode(dentry->d_parent);
 	const unsigned char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
-	unsigned chunk_size = nilfs_chunk_size(dir);
-	unsigned reclen = NILFS_DIR_REC_LEN(namelen);
+	unsigned int chunk_size = nilfs_chunk_size(dir);
+	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
 	struct page *page = NULL;
 	struct nilfs_dir_entry *de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
 	char *kaddr;
-	unsigned from, to;
+	unsigned int from, to;
 	int err;
 
 	/*
@@ -531,13 +531,14 @@ int nilfs_delete_entry(struct nilfs_dir_
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 	char *kaddr = page_address(page);
-	unsigned from = ((char *)dir - kaddr) & ~(nilfs_chunk_size(inode) - 1);
-	unsigned to = ((char *)dir - kaddr) +
-		nilfs_rec_len_from_disk(dir->rec_len);
-	struct nilfs_dir_entry *pde = NULL;
-	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(kaddr + from);
+	unsigned int from, to;
+	struct nilfs_dir_entry *de, *pde = NULL;
 	int err;
 
+	from = ((char *)dir - kaddr) & ~(nilfs_chunk_size(inode) - 1);
+	to = ((char *)dir - kaddr) + nilfs_rec_len_from_disk(dir->rec_len);
+	de = (struct nilfs_dir_entry *)(kaddr + from);
+
 	while ((char *)de < (char *)dir) {
 		if (de->rec_len == 0) {
 			nilfs_error(inode->i_sb, __func__,
@@ -570,7 +571,7 @@ int nilfs_make_empty(struct inode *inode
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page = grab_cache_page(mapping, 0);
-	unsigned chunk_size = nilfs_chunk_size(inode);
+	unsigned int chunk_size = nilfs_chunk_size(inode);
 	struct nilfs_dir_entry *de;
 	int err;
 	void *kaddr;
diff -puN fs/nilfs2/direct.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/direct.c
@@ -58,7 +58,7 @@ static int nilfs_direct_lookup(const str
 
 static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 				      __u64 key, __u64 *ptrp,
-				      unsigned maxblocks)
+				      unsigned int maxblocks)
 {
 	struct inode *dat = NULL;
 	__u64 ptr, ptr2;
@@ -79,7 +79,8 @@ static int nilfs_direct_lookup_contig(co
 		ptr = blocknr;
 	}
 
-	maxblocks = min_t(unsigned, maxblocks, NILFS_DIRECT_KEY_MAX - key + 1);
+	maxblocks = min_t(unsigned int, maxblocks,
+			  NILFS_DIRECT_KEY_MAX - key + 1);
 	for (cnt = 1; cnt < maxblocks &&
 		     (ptr2 = nilfs_direct_get_ptr(direct, key + cnt)) !=
 		     NILFS_BMAP_INVALID_PTR;
diff -puN fs/nilfs2/inode.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/inode.c
@@ -83,7 +83,7 @@ int nilfs_get_block(struct inode *inode,
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	__u64 blknum = 0;
 	int err = 0, ret;
-	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
+	unsigned int maxblocks = bh_result->b_size >> inode->i_blkbits;
 
 	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
@@ -163,7 +163,7 @@ static int nilfs_readpage(struct file *f
  * @nr_pages - number of pages to be read
  */
 static int nilfs_readpages(struct file *file, struct address_space *mapping,
-			   struct list_head *pages, unsigned nr_pages)
+			   struct list_head *pages, unsigned int nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, nilfs_get_block);
 }
@@ -222,7 +222,7 @@ static int nilfs_set_page_dirty(struct p
 	int ret = __set_page_dirty_nobuffers(page);
 
 	if (page_has_buffers(page)) {
-		unsigned nr_dirty = 0;
+		unsigned int nr_dirty = 0;
 		struct buffer_head *bh, *head;
 
 		/*
@@ -245,7 +245,7 @@ static int nilfs_set_page_dirty(struct p
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
 	} else if (ret) {
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned int nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
 
 		nilfs_set_file_dirty(inode, nr_dirty);
 	}
@@ -287,8 +287,8 @@ static int nilfs_write_end(struct file *
 			   struct page *page, void *fsdata)
 {
 	struct inode *inode = mapping->host;
-	unsigned start = pos & (PAGE_SIZE - 1);
-	unsigned nr_dirty;
+	unsigned int start = pos & (PAGE_SIZE - 1);
+	unsigned int nr_dirty;
 	int err;
 
 	nr_dirty = nilfs_page_count_clean_buffers(page, start,
@@ -902,7 +902,7 @@ int nilfs_inode_dirty(struct inode *inod
 	return ret;
 }
 
-int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
+int nilfs_set_file_dirty(struct inode *inode, unsigned int nr_dirty)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
diff -puN fs/nilfs2/mdt.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/mdt.c
@@ -490,8 +490,8 @@ void nilfs_mdt_destroy(struct inode *ino
 	kfree(mdi);
 }
 
-void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
-			      unsigned header_size)
+void nilfs_mdt_set_entry_size(struct inode *inode, unsigned int entry_size,
+			      unsigned int header_size)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 
diff -puN fs/nilfs2/mdt.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/mdt.h
@@ -53,8 +53,8 @@ struct nilfs_shadow_map {
 struct nilfs_mdt_info {
 	struct rw_semaphore	mi_sem;
 	struct blockgroup_lock *mi_bgl;
-	unsigned		mi_entry_size;
-	unsigned		mi_first_entry_offset;
+	unsigned int		mi_entry_size;
+	unsigned int		mi_first_entry_offset;
 	unsigned long		mi_entries_per_block;
 	struct nilfs_palloc_cache *mi_palloc_cache;
 	struct nilfs_shadow_map *mi_shadow;
@@ -90,7 +90,7 @@ int nilfs_mdt_init(struct inode *inode,
 void nilfs_mdt_clear(struct inode *inode);
 void nilfs_mdt_destroy(struct inode *inode);
 
-void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
+void nilfs_mdt_set_entry_size(struct inode *, unsigned int, unsigned int);
 
 int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow);
diff -puN fs/nilfs2/namei.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/namei.c
@@ -139,7 +139,7 @@ static int nilfs_symlink(struct inode *d
 {
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = dir->i_sb;
-	unsigned l = strlen(symname)+1;
+	unsigned int l = strlen(symname) + 1;
 	struct inode *inode;
 	int err;
 
diff -puN fs/nilfs2/nilfs.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/nilfs.h
@@ -274,7 +274,7 @@ extern void nilfs_write_failed(struct ad
 int nilfs_permission(struct inode *inode, int mask);
 int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
 extern int nilfs_inode_dirty(struct inode *);
-int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty);
+int nilfs_set_file_dirty(struct inode *inode, unsigned int nr_dirty);
 extern int __nilfs_mark_inode_dirty(struct inode *, int);
 extern void nilfs_dirty_inode(struct inode *, int flags);
 int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff -puN fs/nilfs2/page.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/page.c
@@ -435,12 +435,12 @@ void nilfs_clear_dirty_page(struct page
 	__nilfs_clear_page_dirty(page);
 }
 
-unsigned nilfs_page_count_clean_buffers(struct page *page,
-					unsigned from, unsigned to)
+unsigned int nilfs_page_count_clean_buffers(struct page *page,
+					    unsigned int from, unsigned int to)
 {
-	unsigned block_start, block_end;
+	unsigned int block_start, block_end;
 	struct buffer_head *bh, *head;
-	unsigned nc = 0;
+	unsigned int nc = 0;
 
 	for (bh = head = page_buffers(page), block_start = 0;
 	     bh != head || !block_start;
diff -puN fs/nilfs2/page.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/page.h
--- a/fs/nilfs2/page.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/page.h
@@ -53,7 +53,8 @@ void nilfs_copy_back_pages(struct addres
 void nilfs_clear_dirty_page(struct page *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
 void nilfs_mapping_init(struct address_space *mapping, struct inode *inode);
-unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
+unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
+					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff);
diff -puN fs/nilfs2/recovery.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/recovery.c
@@ -152,7 +152,7 @@ int nilfs_read_super_root_block(struct t
 
 	sr = (struct nilfs_super_root *)bh_sr->b_data;
 	if (check) {
-		unsigned bytes = le16_to_cpu(sr->sr_bytes);
+		unsigned int bytes = le16_to_cpu(sr->sr_bytes);
 
 		if (bytes == 0 || bytes > nilfs->ns_blocksize) {
 			ret = NILFS_SEG_FAIL_CHECKSUM_SUPER_ROOT;
@@ -504,7 +504,7 @@ static int nilfs_recover_dsync_blocks(st
 {
 	struct inode *inode;
 	struct nilfs_recovery_block *rb, *n;
-	unsigned blocksize = nilfs->ns_blocksize;
+	unsigned int blocksize = nilfs->ns_blocksize;
 	struct page *page;
 	loff_t pos;
 	int err = 0, err2 = 0;
diff -puN fs/nilfs2/segbuf.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/segbuf.c
@@ -129,7 +129,7 @@ int nilfs_segbuf_extend_payload(struct n
 	return 0;
 }
 
-int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned int flags,
 		       time_t ctime, __u64 cno)
 {
 	int err;
@@ -236,7 +236,7 @@ nilfs_segbuf_fill_in_super_root_crc(stru
 {
 	struct nilfs_super_root *raw_sr;
 	struct the_nilfs *nilfs = segbuf->sb_super->s_fs_info;
-	unsigned srsize;
+	unsigned int srsize;
 	u32 crc;
 
 	raw_sr = (struct nilfs_super_root *)segbuf->sb_super_root->b_data;
diff -puN fs/nilfs2/segbuf.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/segbuf.h
--- a/fs/nilfs2/segbuf.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/segbuf.h
@@ -78,7 +78,7 @@ struct nilfs_segment_buffer {
 	__u64			sb_nextnum;
 	sector_t		sb_fseg_start, sb_fseg_end;
 	sector_t		sb_pseg_start;
-	unsigned		sb_rest_blocks;
+	unsigned int		sb_rest_blocks;
 
 	/* Buffers */
 	struct list_head	sb_segsum_buffers;
@@ -120,7 +120,8 @@ void nilfs_segbuf_map_cont(struct nilfs_
 			   struct nilfs_segment_buffer *prev);
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
 				  struct the_nilfs *);
-int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t, __u64);
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned int, time_t,
+		       __u64);
 int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
 int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
 				struct buffer_head **);
diff -puN fs/nilfs2/segment.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/segment.c
@@ -393,10 +393,10 @@ static void nilfs_transaction_unlock(str
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
 					    struct nilfs_segsum_pointer *ssp,
-					    unsigned bytes)
+					    unsigned int bytes)
 {
 	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
-	unsigned blocksize = sci->sc_super->s_blocksize;
+	unsigned int blocksize = sci->sc_super->s_blocksize;
 	void *p;
 
 	if (unlikely(ssp->offset + bytes > blocksize)) {
@@ -418,8 +418,8 @@ static int nilfs_segctor_reset_segment_b
 {
 	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	struct buffer_head *sumbh;
-	unsigned sumbytes;
-	unsigned flags = 0;
+	unsigned int sumbytes;
+	unsigned int flags = 0;
 	int err;
 
 	if (nilfs_doing_gc())
@@ -468,9 +468,9 @@ static int nilfs_segctor_add_super_root(
  */
 static int nilfs_segctor_segsum_block_required(
 	struct nilfs_sc_info *sci, const struct nilfs_segsum_pointer *ssp,
-	unsigned binfo_size)
+	unsigned int binfo_size)
 {
-	unsigned blocksize = sci->sc_super->s_blocksize;
+	unsigned int blocksize = sci->sc_super->s_blocksize;
 	/* Size of finfo and binfo is enough small against blocksize */
 
 	return ssp->offset + binfo_size +
@@ -529,7 +529,7 @@ static void nilfs_segctor_end_finfo(stru
 static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 					struct buffer_head *bh,
 					struct inode *inode,
-					unsigned binfo_size)
+					unsigned int binfo_size)
 {
 	struct nilfs_segment_buffer *segbuf;
 	int required, err = 0;
@@ -773,7 +773,7 @@ static void nilfs_dispose_list(struct th
 {
 	struct nilfs_inode_info *ii, *n;
 	struct nilfs_inode_info *ivec[SC_N_INODEVEC], **pii;
-	unsigned nv = 0;
+	unsigned int nv = 0;
 
 	while (!list_empty(head)) {
 		spin_lock(&nilfs->ns_inode_lock);
@@ -954,7 +954,7 @@ static void nilfs_segctor_fill_in_super_
 {
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
-	unsigned isz, srsz;
+	unsigned int isz, srsz;
 
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
diff -puN fs/nilfs2/segment.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/segment.h
@@ -71,7 +71,7 @@ struct nilfs_recovery_info {
  */
 struct nilfs_cstage {
 	int			scnt;
-	unsigned		flags;
+	unsigned int		flags;
 	struct nilfs_inode_info *dirty_file_ptr;
 	struct nilfs_inode_info *gc_inode_ptr;
 };
@@ -80,7 +80,7 @@ struct nilfs_segment_buffer;
 
 struct nilfs_segsum_pointer {
 	struct buffer_head     *bh;
-	unsigned		offset; /* offset in bytes */
+	unsigned int		offset; /* offset in bytes */
 };
 
 /**
diff -puN fs/nilfs2/sysfs.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/sysfs.c
@@ -756,7 +756,7 @@ nilfs_superblock_sb_write_count_show(str
 				      struct the_nilfs *nilfs,
 				      char *buf)
 {
-	unsigned sbwcount;
+	unsigned int sbwcount;
 
 	down_read(&nilfs->ns_sem);
 	sbwcount = nilfs->ns_sbwcount;
@@ -770,7 +770,7 @@ nilfs_superblock_sb_update_frequency_sho
 					    struct the_nilfs *nilfs,
 					    char *buf)
 {
-	unsigned sb_update_freq;
+	unsigned int sb_update_freq;
 
 	down_read(&nilfs->ns_sem);
 	sb_update_freq = nilfs->ns_sb_update_freq;
@@ -784,7 +784,7 @@ nilfs_superblock_sb_update_frequency_sto
 					    struct the_nilfs *nilfs,
 					    const char *buf, size_t count)
 {
-	unsigned val;
+	unsigned int val;
 	int err;
 
 	err = kstrtouint(skip_spaces(buf), 0, &val);
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/the_nilfs.c
@@ -108,8 +108,8 @@ static int nilfs_load_super_root(struct
 	struct nilfs_super_root *raw_sr;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct nilfs_inode *rawi;
-	unsigned dat_entry_size, segment_usage_size, checkpoint_size;
-	unsigned inode_size;
+	unsigned int dat_entry_size, segment_usage_size, checkpoint_size;
+	unsigned int inode_size;
 	int err;
 
 	err = nilfs_read_super_root_block(nilfs, sr_block, &bh_sr, 1);
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-avoid-bare-use-of-unsigned fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/fs/nilfs2/the_nilfs.h
@@ -114,10 +114,10 @@ struct the_nilfs {
 	struct buffer_head     *ns_sbh[2];
 	struct nilfs_super_block *ns_sbp[2];
 	time_t			ns_sbwtime;
-	unsigned		ns_sbwcount;
-	unsigned		ns_sbsize;
-	unsigned		ns_mount_state;
-	unsigned		ns_sb_update_freq;
+	unsigned int		ns_sbwcount;
+	unsigned int		ns_sbsize;
+	unsigned int		ns_mount_state;
+	unsigned int		ns_sb_update_freq;
 
 	/*
 	 * Following fields are dedicated to a writable FS-instance.
@@ -306,7 +306,7 @@ static inline void nilfs_get_root(struct
 
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
 {
-	unsigned valid_fs;
+	unsigned int valid_fs;
 
 	down_read(&nilfs->ns_sem);
 	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
diff -puN include/linux/nilfs2_fs.h~nilfs2-avoid-bare-use-of-unsigned include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-avoid-bare-use-of-unsigned
+++ a/include/linux/nilfs2_fs.h
@@ -322,9 +322,9 @@ enum {
 					~NILFS_DIR_ROUND)
 #define NILFS_MAX_REC_LEN		((1<<16)-1)
 
-static inline unsigned nilfs_rec_len_from_disk(__le16 dlen)
+static inline unsigned int nilfs_rec_len_from_disk(__le16 dlen)
 {
-	unsigned len = le16_to_cpu(dlen);
+	unsigned int len = le16_to_cpu(dlen);
 
 #if !defined(__KERNEL__) || (PAGE_SIZE >= 65536)
 	if (len == NILFS_MAX_REC_LEN)
@@ -333,7 +333,7 @@ static inline unsigned nilfs_rec_len_fro
 	return len;
 }
 
-static inline __le16 nilfs_rec_len_to_disk(unsigned len)
+static inline __le16 nilfs_rec_len_to_disk(unsigned int len)
 {
 #if !defined(__KERNEL__) || (PAGE_SIZE >= 65536)
 	if (len == (1 << 16))
_
