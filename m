From: akpm@linux-foundation.org
Subject: + hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch
 added to -mm tree
Date: Thu, 22 May 2014 12:25:14 -0700
Message-ID: <537e4f1a.eIogvsLUCteLXHDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVTZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 15:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, htl10@users.sourceforge.net, saproj@gmail.com

Subject: + hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch added to -mm tree
To: saproj@gmail.com,htl10@users.sourceforge.net,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 12:25:14 -0700


The patch titled
     Subject: hfsplus: coding style fix for declarations in hfsplus_fs.h
has been added to the -mm tree.  Its filename is
     hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: coding style fix for declarations in hfsplus_fs.h

Some function declarations in hfsplus_fs.h were with argument names, some
without, and some were mixed.  This patch adds argument names everywhere,
sorts function in order they go in .c files, and moves hfs_part_find() to
a proper section.

Auto-formatting and sorting was done with:
cfunctions *.c | indent -linux | sed "s| \* | \*|"

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |  205 ++++++++++++++++++++------------------
 1 file changed, 109 insertions(+), 96 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -369,112 +369,121 @@ typedef int (*search_strategy_t)(struct
 /* attributes.c */
 int __init hfsplus_create_attr_tree_cache(void);
 void hfsplus_destroy_attr_tree_cache(void);
+int hfsplus_attr_bin_cmp_key(const hfsplus_btree_key *k1,
+			     const hfsplus_btree_key *k2);
+int hfsplus_attr_build_key(struct super_block *sb, hfsplus_btree_key *key,
+			   u32 cnid, const char *name);
 hfsplus_attr_entry *hfsplus_alloc_attr_entry(void);
-void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry_p);
-int hfsplus_attr_bin_cmp_key(const hfsplus_btree_key *,
-		const hfsplus_btree_key *);
-int hfsplus_attr_build_key(struct super_block *, hfsplus_btree_key *,
-			u32, const char *);
-int hfsplus_find_attr(struct super_block *, u32,
-			const char *, struct hfs_find_data *);
+void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry);
+int hfsplus_find_attr(struct super_block *sb, u32 cnid, const char *name,
+		      struct hfs_find_data *fd);
 int hfsplus_attr_exists(struct inode *inode, const char *name);
-int hfsplus_create_attr(struct inode *, const char *, const void *, size_t);
-int hfsplus_delete_attr(struct inode *, const char *);
+int hfsplus_create_attr(struct inode *inode, const char *name,
+			const void *value, size_t size);
+int hfsplus_delete_attr(struct inode *inode, const char *name);
 int hfsplus_delete_all_attrs(struct inode *dir, u32 cnid);
 
 /* bitmap.c */
-int hfsplus_block_allocate(struct super_block *, u32, u32, u32 *);
-int hfsplus_block_free(struct super_block *, u32, u32);
+int hfsplus_block_allocate(struct super_block *sb, u32 size, u32 offset,
+			   u32 *max);
+int hfsplus_block_free(struct super_block *sb, u32 offset, u32 count);
 
 /* btree.c */
-u32 hfsplus_calc_btree_clump_size(u32, u32, u64, int);
-struct hfs_btree *hfs_btree_open(struct super_block *, u32);
-void hfs_btree_close(struct hfs_btree *);
-int hfs_btree_write(struct hfs_btree *);
-struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *);
-void hfs_bmap_free(struct hfs_bnode *);
+u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u64 sectors,
+				  int file_id);
+struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
+void hfs_btree_close(struct hfs_btree *tree);
+int hfs_btree_write(struct hfs_btree *tree);
+struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree);
+void hfs_bmap_free(struct hfs_bnode *node);
 
 /* bnode.c */
-void hfs_bnode_read(struct hfs_bnode *, void *, int, int);
-u16 hfs_bnode_read_u16(struct hfs_bnode *, int);
-u8 hfs_bnode_read_u8(struct hfs_bnode *, int);
-void hfs_bnode_read_key(struct hfs_bnode *, void *, int);
-void hfs_bnode_write(struct hfs_bnode *, void *, int, int);
-void hfs_bnode_write_u16(struct hfs_bnode *, int, u16);
-void hfs_bnode_clear(struct hfs_bnode *, int, int);
-void hfs_bnode_copy(struct hfs_bnode *, int,
-		    struct hfs_bnode *, int, int);
-void hfs_bnode_move(struct hfs_bnode *, int, int, int);
-void hfs_bnode_dump(struct hfs_bnode *);
-void hfs_bnode_unlink(struct hfs_bnode *);
-struct hfs_bnode *hfs_bnode_findhash(struct hfs_btree *, u32);
-struct hfs_bnode *hfs_bnode_find(struct hfs_btree *, u32);
-void hfs_bnode_unhash(struct hfs_bnode *);
-void hfs_bnode_free(struct hfs_bnode *);
-struct hfs_bnode *hfs_bnode_create(struct hfs_btree *, u32);
-void hfs_bnode_get(struct hfs_bnode *);
-void hfs_bnode_put(struct hfs_bnode *);
-bool hfs_bnode_need_zeroout(struct hfs_btree *);
+void hfs_bnode_read(struct hfs_bnode *node, void *buf, int off, int len);
+u16 hfs_bnode_read_u16(struct hfs_bnode *node, int off);
+u8 hfs_bnode_read_u8(struct hfs_bnode *node, int off);
+void hfs_bnode_read_key(struct hfs_bnode *node, void *key, int off);
+void hfs_bnode_write(struct hfs_bnode *node, void *buf, int off, int len);
+void hfs_bnode_write_u16(struct hfs_bnode *node, int off, u16 data);
+void hfs_bnode_clear(struct hfs_bnode *node, int off, int len);
+void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
+		    struct hfs_bnode *src_node, int src, int len);
+void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len);
+void hfs_bnode_dump(struct hfs_bnode *node);
+void hfs_bnode_unlink(struct hfs_bnode *node);
+struct hfs_bnode *hfs_bnode_findhash(struct hfs_btree *tree, u32 cnid);
+void hfs_bnode_unhash(struct hfs_bnode *node);
+struct hfs_bnode *hfs_bnode_find(struct hfs_btree *tree, u32 num);
+void hfs_bnode_free(struct hfs_bnode *node);
+struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num);
+void hfs_bnode_get(struct hfs_bnode *node);
+void hfs_bnode_put(struct hfs_bnode *node);
+bool hfs_bnode_need_zeroout(struct hfs_btree *tree);
 
 /* brec.c */
-u16 hfs_brec_lenoff(struct hfs_bnode *, u16, u16 *);
-u16 hfs_brec_keylen(struct hfs_bnode *, u16);
-int hfs_brec_insert(struct hfs_find_data *, void *, int);
-int hfs_brec_remove(struct hfs_find_data *);
+u16 hfs_brec_lenoff(struct hfs_bnode *node, u16 rec, u16 *off);
+u16 hfs_brec_keylen(struct hfs_bnode *node, u16 rec);
+int hfs_brec_insert(struct hfs_find_data *fd, void *entry, int entry_len);
+int hfs_brec_remove(struct hfs_find_data *fd);
 
 /* bfind.c */
-int hfs_find_init(struct hfs_btree *, struct hfs_find_data *);
-void hfs_find_exit(struct hfs_find_data *);
-int hfs_find_1st_rec_by_cnid(struct hfs_bnode *,
-				struct hfs_find_data *,
-				int *, int *, int *);
-int hfs_find_rec_by_key(struct hfs_bnode *,
-				struct hfs_find_data *,
-				int *, int *, int *);
-int __hfs_brec_find(struct hfs_bnode *, struct hfs_find_data *,
-				search_strategy_t);
-int hfs_brec_find(struct hfs_find_data *, search_strategy_t);
-int hfs_brec_read(struct hfs_find_data *, void *, int);
-int hfs_brec_goto(struct hfs_find_data *, int);
+int hfs_find_init(struct hfs_btree *tree, struct hfs_find_data *fd);
+void hfs_find_exit(struct hfs_find_data *fd);
+int hfs_find_1st_rec_by_cnid(struct hfs_bnode *bnode, struct hfs_find_data *fd,
+			     int *begin, int *end, int *cur_rec);
+int hfs_find_rec_by_key(struct hfs_bnode *bnode, struct hfs_find_data *fd,
+			int *begin, int *end, int *cur_rec);
+int __hfs_brec_find(struct hfs_bnode *bnode, struct hfs_find_data *fd,
+		    search_strategy_t rec_found);
+int hfs_brec_find(struct hfs_find_data *fd, search_strategy_t do_key_compare);
+int hfs_brec_read(struct hfs_find_data *fd, void *rec, int rec_len);
+int hfs_brec_goto(struct hfs_find_data *fd, int cnt);
 
 /* catalog.c */
-int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *,
-		const hfsplus_btree_key *);
-int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
-		const hfsplus_btree_key *);
-void hfsplus_cat_build_key(struct super_block *sb,
-		hfsplus_btree_key *, u32, struct qstr *);
-int hfsplus_find_cat(struct super_block *, u32, struct hfs_find_data *);
-int hfsplus_create_cat(u32, struct inode *, struct qstr *, struct inode *);
-int hfsplus_delete_cat(u32, struct inode *, struct qstr *);
-int hfsplus_rename_cat(u32, struct inode *, struct qstr *,
-		       struct inode *, struct qstr *);
+int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *k1,
+			     const hfsplus_btree_key *k2);
+int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *k1,
+			    const hfsplus_btree_key *k2);
+void hfsplus_cat_build_key(struct super_block *sb, hfsplus_btree_key *key,
+			   u32 parent, struct qstr *str);
+void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
+				     hfsplus_btree_key *key, u32 parent);
 void hfsplus_cat_set_perms(struct inode *inode, struct hfsplus_perm *perms);
+int hfsplus_find_cat(struct super_block *sb, u32 cnid,
+		     struct hfs_find_data *fd);
+int hfsplus_create_cat(u32 cnid, struct inode *dir, struct qstr *str,
+		       struct inode *inode);
+int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str);
+int hfsplus_rename_cat(u32 cnid, struct inode *src_dir, struct qstr *src_name,
+		       struct inode *dst_dir, struct qstr *dst_name);
 
 /* dir.c */
 extern const struct inode_operations hfsplus_dir_inode_operations;
 extern const struct file_operations hfsplus_dir_operations;
 
 /* extents.c */
-int hfsplus_ext_cmp_key(const hfsplus_btree_key *, const hfsplus_btree_key *);
-int hfsplus_ext_write_extent(struct inode *);
-int hfsplus_get_block(struct inode *, sector_t, struct buffer_head *, int);
-int hfsplus_free_fork(struct super_block *, u32,
-		struct hfsplus_fork_raw *, int);
-int hfsplus_file_extend(struct inode *, bool zeroout);
-void hfsplus_file_truncate(struct inode *);
+int hfsplus_ext_cmp_key(const hfsplus_btree_key *k1,
+			const hfsplus_btree_key *k2);
+int hfsplus_ext_write_extent(struct inode *inode);
+int hfsplus_get_block(struct inode *inode, sector_t iblock,
+		      struct buffer_head *bh_result, int create);
+int hfsplus_free_fork(struct super_block *sb, u32 cnid,
+		      struct hfsplus_fork_raw *fork, int type);
+int hfsplus_file_extend(struct inode *inode, bool zeroout);
+void hfsplus_file_truncate(struct inode *inode);
 
 /* inode.c */
 extern const struct address_space_operations hfsplus_aops;
 extern const struct address_space_operations hfsplus_btree_aops;
 extern const struct dentry_operations hfsplus_dentry_operations;
 
-void hfsplus_inode_read_fork(struct inode *, struct hfsplus_fork_raw *);
-void hfsplus_inode_write_fork(struct inode *, struct hfsplus_fork_raw *);
-int hfsplus_cat_read_inode(struct inode *, struct hfs_find_data *);
-int hfsplus_cat_write_inode(struct inode *);
-struct inode *hfsplus_new_inode(struct super_block *, umode_t);
-void hfsplus_delete_inode(struct inode *);
+struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode);
+void hfsplus_delete_inode(struct inode *inode);
+void hfsplus_inode_read_fork(struct inode *inode,
+			     struct hfsplus_fork_raw *fork);
+void hfsplus_inode_write_fork(struct inode *inode,
+			      struct hfsplus_fork_raw *fork);
+int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd);
+int hfsplus_cat_write_inode(struct inode *inode);
 int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 		       int datasync);
 
@@ -482,13 +491,17 @@ int hfsplus_file_fsync(struct file *file
 long hfsplus_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 
 /* options.c */
-int hfsplus_parse_options(char *, struct hfsplus_sb_info *);
+void hfsplus_fill_defaults(struct hfsplus_sb_info *opts);
 int hfsplus_parse_options_remount(char *input, int *force);
-void hfsplus_fill_defaults(struct hfsplus_sb_info *);
-int hfsplus_show_options(struct seq_file *, struct dentry *);
+int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi);
+int hfsplus_show_options(struct seq_file *seq, struct dentry *root);
+
+/* part_tbl.c */
+int hfs_part_find(struct super_block *sb, sector_t *part_start,
+		  sector_t *part_size);
 
 /* super.c */
-struct inode *hfsplus_iget(struct super_block *, unsigned long);
+struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino);
 void hfsplus_mark_mdb_dirty(struct super_block *sb);
 
 /* tables.c */
@@ -497,23 +510,23 @@ extern u16 hfsplus_decompose_table[];
 extern u16 hfsplus_compose_table[];
 
 /* unicode.c */
-int hfsplus_strcasecmp(const struct hfsplus_unistr *,
-		const struct hfsplus_unistr *);
-int hfsplus_strcmp(const struct hfsplus_unistr *,
-		const struct hfsplus_unistr *);
-int hfsplus_uni2asc(struct super_block *,
-		const struct hfsplus_unistr *, char *, int *);
-int hfsplus_asc2uni(struct super_block *,
-		struct hfsplus_unistr *, int, const char *, int);
+int hfsplus_strcasecmp(const struct hfsplus_unistr *s1,
+		       const struct hfsplus_unistr *s2);
+int hfsplus_strcmp(const struct hfsplus_unistr *s1,
+		   const struct hfsplus_unistr *s2);
+int hfsplus_uni2asc(struct super_block *sb, const struct hfsplus_unistr *ustr,
+		    char *astr, int *len_p);
+int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
+		    int max_unistr_len, const char *astr, int len);
 int hfsplus_hash_dentry(const struct dentry *dentry, struct qstr *str);
-int hfsplus_compare_dentry(const struct dentry *parent, const struct dentry *dentry,
-		unsigned int len, const char *str, const struct qstr *name);
+int hfsplus_compare_dentry(const struct dentry *parent,
+			   const struct dentry *dentry, unsigned int len,
+			   const char *str, const struct qstr *name);
 
 /* wrapper.c */
-int hfsplus_read_wrapper(struct super_block *);
-int hfs_part_find(struct super_block *, sector_t *, sector_t *);
-int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
-		void *buf, void **data, int rw);
+int hfsplus_submit_bio(struct super_block *sb, sector_t sector, void *buf,
+		       void **data, int rw);
+int hfsplus_read_wrapper(struct super_block *sb);
 
 /* time macros */
 #define __hfsp_mt2ut(t)		(be32_to_cpu(t) - 2082844800U)
_

Patches currently in -mm which might be from saproj@gmail.com are

hfsplus-emit-proper-file-type-from-readdir.patch
hfsplus-fix-unused-node-is-not-erased-error.patch
hfsplus-coding-style-fix-for-declarations-in-hfsplus_fsh.patch

