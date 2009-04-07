From: akpm@linux-foundation.org
Subject: [merged] nilfs2-persistent-object-allocator.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:30 -0700
Message-ID: <200904071908.n37J8U1x011836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZDGTm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, amagai.yoshiji@lab.ntt.co.jp, sato.koji@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: persistent object allocator
has been removed from the -mm tree.  Its filename was
     nilfs2-persistent-object-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: persistent object allocator
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds common functions to allocate or deallocate entries with bitmaps
on a meta data file.  This feature is used by the DAT and ifile.

Signed-off-by: Koji Sato <sato.koji@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |  504 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/alloc.h |   72 ++++++
 2 files changed, 576 insertions(+)

diff -puN /dev/null fs/nilfs2/alloc.c
--- /dev/null
+++ a/fs/nilfs2/alloc.c
@@ -0,0 +1,504 @@
+/*
+ * alloc.c - NILFS dat/inode allocator
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Original code was written by Koji Sato <koji@osrg.net>.
+ * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
+ *                                Amagai Yoshiji <amagai@osrg.net>.
+ */
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include "mdt.h"
+#include "alloc.h"
+
+
+static inline unsigned long
+nilfs_palloc_groups_per_desc_block(const struct inode *inode)
+{
+	return (1UL << inode->i_blkbits) /
+		sizeof(struct nilfs_palloc_group_desc);
+}
+
+static inline unsigned long
+nilfs_palloc_groups_count(const struct inode *inode)
+{
+	return 1UL << (BITS_PER_LONG - (inode->i_blkbits + 3 /* log2(8) */));
+}
+
+int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+
+	mi->mi_bgl = kmalloc(sizeof(*mi->mi_bgl), GFP_NOFS);
+	if (!mi->mi_bgl)
+		return -ENOMEM;
+
+	bgl_lock_init(mi->mi_bgl);
+
+	nilfs_mdt_set_entry_size(inode, entry_size, 0);
+
+	mi->mi_blocks_per_group =
+		DIV_ROUND_UP(nilfs_palloc_entries_per_group(inode),
+			     mi->mi_entries_per_block) + 1;
+		/* Number of blocks in a group including entry blocks and
+		   a bitmap block */
+	mi->mi_blocks_per_desc_block =
+		nilfs_palloc_groups_per_desc_block(inode) *
+		mi->mi_blocks_per_group + 1;
+		/* Number of blocks per descriptor including the
+		   descriptor block */
+	return 0;
+}
+
+static unsigned long nilfs_palloc_group(const struct inode *inode, __u64 nr,
+					unsigned long *offset)
+{
+	__u64 group = nr;
+
+	*offset = do_div(group, nilfs_palloc_entries_per_group(inode));
+	return group;
+}
+
+static unsigned long
+nilfs_palloc_desc_blkoff(const struct inode *inode, unsigned long group)
+{
+	unsigned long desc_block =
+		group / nilfs_palloc_groups_per_desc_block(inode);
+	return desc_block * NILFS_MDT(inode)->mi_blocks_per_desc_block;
+}
+
+static unsigned long
+nilfs_palloc_bitmap_blkoff(const struct inode *inode, unsigned long group)
+{
+	unsigned long desc_offset =
+		group % nilfs_palloc_groups_per_desc_block(inode);
+	return nilfs_palloc_desc_blkoff(inode, group) + 1 +
+		desc_offset * NILFS_MDT(inode)->mi_blocks_per_group;
+}
+
+static unsigned long
+nilfs_palloc_group_desc_nfrees(struct inode *inode, unsigned long group,
+			       const struct nilfs_palloc_group_desc *desc)
+{
+	unsigned long nfree;
+
+	spin_lock(nilfs_mdt_bgl_lock(inode, group));
+	nfree = le32_to_cpu(desc->pg_nfrees);
+	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+	return nfree;
+}
+
+static void
+nilfs_palloc_group_desc_add_entries(struct inode *inode,
+				    unsigned long group,
+				    struct nilfs_palloc_group_desc *desc,
+				    u32 n)
+{
+	spin_lock(nilfs_mdt_bgl_lock(inode, group));
+	le32_add_cpu(&desc->pg_nfrees, n);
+	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+}
+
+static unsigned long
+nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
+{
+	unsigned long group, group_offset;
+
+	group = nilfs_palloc_group(inode, nr, &group_offset);
+
+	return nilfs_palloc_bitmap_blkoff(inode, group) + 1 +
+		group_offset / NILFS_MDT(inode)->mi_entries_per_block;
+}
+
+static void nilfs_palloc_desc_block_init(struct inode *inode,
+					 struct buffer_head *bh, void *kaddr)
+{
+	struct nilfs_palloc_group_desc *desc = kaddr + bh_offset(bh);
+	unsigned long n = nilfs_palloc_groups_per_desc_block(inode);
+	__le32 nfrees;
+
+	nfrees = cpu_to_le32(nilfs_palloc_entries_per_group(inode));
+	while (n-- > 0) {
+		desc->pg_nfrees = nfrees;
+		desc++;
+	}
+}
+
+static int nilfs_palloc_get_desc_block(struct inode *inode,
+				       unsigned long group,
+				       int create, struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(inode,
+				   nilfs_palloc_desc_blkoff(inode, group),
+				   create, nilfs_palloc_desc_block_init, bhp);
+}
+
+static int nilfs_palloc_get_bitmap_block(struct inode *inode,
+					 unsigned long group,
+					 int create, struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(inode,
+				   nilfs_palloc_bitmap_blkoff(inode, group),
+				   create, NULL, bhp);
+}
+
+int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
+				 int create, struct buffer_head **bhp)
+{
+	return nilfs_mdt_get_block(inode, nilfs_palloc_entry_blkoff(inode, nr),
+				   create, NULL, bhp);
+}
+
+static struct nilfs_palloc_group_desc *
+nilfs_palloc_block_get_group_desc(const struct inode *inode,
+				  unsigned long group,
+				  const struct buffer_head *bh, void *kaddr)
+{
+	return (struct nilfs_palloc_group_desc *)(kaddr + bh_offset(bh)) +
+		group % nilfs_palloc_groups_per_desc_block(inode);
+}
+
+static unsigned char *
+nilfs_palloc_block_get_bitmap(const struct inode *inode,
+			      const struct buffer_head *bh, void *kaddr)
+{
+	return (unsigned char *)(kaddr + bh_offset(bh));
+}
+
+void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
+				   const struct buffer_head *bh, void *kaddr)
+{
+	unsigned long entry_offset, group_offset;
+
+	nilfs_palloc_group(inode, nr, &group_offset);
+	entry_offset = group_offset % NILFS_MDT(inode)->mi_entries_per_block;
+
+	return kaddr + bh_offset(bh) +
+		entry_offset * NILFS_MDT(inode)->mi_entry_size;
+}
+
+static int nilfs_palloc_find_available_slot(struct inode *inode,
+					    unsigned long group,
+					    unsigned long target,
+					    unsigned char *bitmap,
+					    int bsize)  /* size in bits */
+{
+	int curr, pos, end, i;
+
+	if (target > 0) {
+		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
+		if (end > bsize)
+			end = bsize;
+		pos = nilfs_find_next_zero_bit(bitmap, end, target);
+		if (pos < end &&
+		    !nilfs_set_bit_atomic(
+			    nilfs_mdt_bgl_lock(inode, group), pos, bitmap))
+			return pos;
+	} else
+		end = 0;
+
+	for (i = 0, curr = end;
+	     i < bsize;
+	     i += BITS_PER_LONG, curr += BITS_PER_LONG) {
+		/* wrap around */
+		if (curr >= bsize)
+			curr = 0;
+		while (*((unsigned long *)bitmap + curr / BITS_PER_LONG)
+		       != ~0UL) {
+			end = curr + BITS_PER_LONG;
+			if (end > bsize)
+				end = bsize;
+			pos = nilfs_find_next_zero_bit(bitmap, end, curr);
+			if ((pos < end) &&
+			    !nilfs_set_bit_atomic(
+				    nilfs_mdt_bgl_lock(inode, group), pos,
+				    bitmap))
+				return pos;
+		}
+	}
+	return -ENOSPC;
+}
+
+static unsigned long
+nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
+				       unsigned long curr, unsigned long max)
+{
+	return min_t(unsigned long,
+		     nilfs_palloc_groups_per_desc_block(inode) -
+		     curr % nilfs_palloc_groups_per_desc_block(inode),
+		     max - curr + 1);
+}
+
+int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
+				     struct nilfs_palloc_req *req)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_palloc_group_desc *desc;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned long group, maxgroup, ngroups;
+	unsigned long group_offset, maxgroup_offset;
+	unsigned long n, entries_per_group, groups_per_desc_block;
+	unsigned long i, j;
+	int pos, ret;
+
+	ngroups = nilfs_palloc_groups_count(inode);
+	maxgroup = ngroups - 1;
+	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
+	entries_per_group = nilfs_palloc_entries_per_group(inode);
+	groups_per_desc_block = nilfs_palloc_groups_per_desc_block(inode);
+
+	for (i = 0; i < ngroups; i += n) {
+		if (group >= ngroups) {
+			/* wrap around */
+			group = 0;
+			maxgroup = nilfs_palloc_group(inode, req->pr_entry_nr,
+						      &maxgroup_offset) - 1;
+		}
+		ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
+		if (ret < 0)
+			return ret;
+		desc_kaddr = kmap(desc_bh->b_page);
+		desc = nilfs_palloc_block_get_group_desc(
+			inode, group, desc_bh, desc_kaddr);
+		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
+							   maxgroup);
+		for (j = 0; j < n; j++, desc++, group++) {
+			if (nilfs_palloc_group_desc_nfrees(inode, group, desc)
+			    > 0) {
+				ret = nilfs_palloc_get_bitmap_block(
+					inode, group, 1, &bitmap_bh);
+				if (ret < 0)
+					goto out_desc;
+				bitmap_kaddr = kmap(bitmap_bh->b_page);
+				bitmap = nilfs_palloc_block_get_bitmap(
+					inode, bitmap_bh, bitmap_kaddr);
+				pos = nilfs_palloc_find_available_slot(
+					inode, group, group_offset, bitmap,
+					entries_per_group);
+				if (pos >= 0) {
+					/* found a free entry */
+					nilfs_palloc_group_desc_add_entries(
+						inode, group, desc, -1);
+					req->pr_entry_nr =
+						entries_per_group * group + pos;
+					kunmap(desc_bh->b_page);
+					kunmap(bitmap_bh->b_page);
+
+					req->pr_desc_bh = desc_bh;
+					req->pr_bitmap_bh = bitmap_bh;
+					return 0;
+				}
+				kunmap(bitmap_bh->b_page);
+				brelse(bitmap_bh);
+			}
+
+			group_offset = 0;
+		}
+
+		kunmap(desc_bh->b_page);
+		brelse(desc_bh);
+	}
+
+	/* no entries left */
+	return -ENOSPC;
+
+ out_desc:
+	kunmap(desc_bh->b_page);
+	brelse(desc_bh);
+	return ret;
+}
+
+void nilfs_palloc_commit_alloc_entry(struct inode *inode,
+				     struct nilfs_palloc_req *req)
+{
+	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
+	nilfs_mdt_mark_buffer_dirty(req->pr_desc_bh);
+	nilfs_mdt_mark_dirty(inode);
+
+	brelse(req->pr_bitmap_bh);
+	brelse(req->pr_desc_bh);
+}
+
+void nilfs_palloc_commit_free_entry(struct inode *inode,
+				    struct nilfs_palloc_req *req)
+{
+	struct nilfs_palloc_group_desc *desc;
+	unsigned long group, group_offset;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+
+	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
+	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc = nilfs_palloc_block_get_group_desc(inode, group,
+						 req->pr_desc_bh, desc_kaddr);
+	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap = nilfs_palloc_block_get_bitmap(inode, req->pr_bitmap_bh,
+					       bitmap_kaddr);
+
+	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
+				    group_offset, bitmap))
+		printk(KERN_WARNING "%s: entry number %llu already freed\n",
+		       __func__, (unsigned long long)req->pr_entry_nr);
+
+	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+
+	kunmap(req->pr_bitmap_bh->b_page);
+	kunmap(req->pr_desc_bh->b_page);
+
+	nilfs_mdt_mark_buffer_dirty(req->pr_desc_bh);
+	nilfs_mdt_mark_buffer_dirty(req->pr_bitmap_bh);
+	nilfs_mdt_mark_dirty(inode);
+
+	brelse(req->pr_bitmap_bh);
+	brelse(req->pr_desc_bh);
+}
+
+void nilfs_palloc_abort_alloc_entry(struct inode *inode,
+				    struct nilfs_palloc_req *req)
+{
+	struct nilfs_palloc_group_desc *desc;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned char *bitmap;
+	unsigned long group, group_offset;
+
+	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
+	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc = nilfs_palloc_block_get_group_desc(inode, group,
+						 req->pr_desc_bh, desc_kaddr);
+	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap = nilfs_palloc_block_get_bitmap(inode, req->pr_bitmap_bh,
+					       bitmap_kaddr);
+	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
+				    group_offset, bitmap))
+		printk(KERN_WARNING "%s: entry numer %llu already freed\n",
+		       __func__, (unsigned long long)req->pr_entry_nr);
+
+	nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+
+	kunmap(req->pr_bitmap_bh->b_page);
+	kunmap(req->pr_desc_bh->b_page);
+
+	brelse(req->pr_bitmap_bh);
+	brelse(req->pr_desc_bh);
+
+	req->pr_entry_nr = 0;
+	req->pr_bitmap_bh = NULL;
+	req->pr_desc_bh = NULL;
+}
+
+int nilfs_palloc_prepare_free_entry(struct inode *inode,
+				    struct nilfs_palloc_req *req)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	unsigned long group, group_offset;
+	int ret;
+
+	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
+	ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
+	if (ret < 0)
+		return ret;
+	ret = nilfs_palloc_get_bitmap_block(inode, group, 1, &bitmap_bh);
+	if (ret < 0) {
+		brelse(desc_bh);
+		return ret;
+	}
+
+	req->pr_desc_bh = desc_bh;
+	req->pr_bitmap_bh = bitmap_bh;
+	return 0;
+}
+
+void nilfs_palloc_abort_free_entry(struct inode *inode,
+				   struct nilfs_palloc_req *req)
+{
+	brelse(req->pr_bitmap_bh);
+	brelse(req->pr_desc_bh);
+
+	req->pr_entry_nr = 0;
+	req->pr_bitmap_bh = NULL;
+	req->pr_desc_bh = NULL;
+}
+
+static int
+nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
+{
+	__u64 first, last;
+
+	first = group * nilfs_palloc_entries_per_group(inode);
+	last = first + nilfs_palloc_entries_per_group(inode) - 1;
+	return (nr >= first) && (nr <= last);
+}
+
+int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
+{
+	struct buffer_head *desc_bh, *bitmap_bh;
+	struct nilfs_palloc_group_desc *desc;
+	unsigned char *bitmap;
+	void *desc_kaddr, *bitmap_kaddr;
+	unsigned long group, group_offset;
+	int i, j, n, ret;
+
+	for (i = 0; i < nitems; i += n) {
+		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
+		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
+		if (ret < 0)
+			return ret;
+		ret = nilfs_palloc_get_bitmap_block(inode, group, 0,
+						    &bitmap_bh);
+		if (ret < 0) {
+			brelse(desc_bh);
+			return ret;
+		}
+		desc_kaddr = kmap(desc_bh->b_page);
+		desc = nilfs_palloc_block_get_group_desc(
+			inode, group, desc_bh, desc_kaddr);
+		bitmap_kaddr = kmap(bitmap_bh->b_page);
+		bitmap = nilfs_palloc_block_get_bitmap(
+			inode, bitmap_bh, bitmap_kaddr);
+		for (j = i, n = 0;
+		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
+							      entry_nrs[j]);
+		     j++, n++) {
+			nilfs_palloc_group(inode, entry_nrs[j], &group_offset);
+			if (!nilfs_clear_bit_atomic(
+				    nilfs_mdt_bgl_lock(inode, group),
+				    group_offset, bitmap)) {
+				printk(KERN_WARNING
+				       "%s: entry number %llu already freed\n",
+				       __func__,
+				       (unsigned long long)entry_nrs[j]);
+			}
+		}
+		nilfs_palloc_group_desc_add_entries(inode, group, desc, n);
+
+		kunmap(bitmap_bh->b_page);
+		kunmap(desc_bh->b_page);
+
+		nilfs_mdt_mark_buffer_dirty(desc_bh);
+		nilfs_mdt_mark_buffer_dirty(bitmap_bh);
+		nilfs_mdt_mark_dirty(inode);
+
+		brelse(bitmap_bh);
+		brelse(desc_bh);
+	}
+	return 0;
+}
diff -puN /dev/null fs/nilfs2/alloc.h
--- /dev/null
+++ a/fs/nilfs2/alloc.h
@@ -0,0 +1,72 @@
+/*
+ * alloc.h - persistent object (dat entry/disk inode) allocator/deallocator
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Original code was written by Koji Sato <koji@osrg.net>.
+ * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
+ *                                Amagai Yoshiji <amagai@osrg.net>.
+ */
+
+#ifndef _NILFS_ALLOC_H
+#define _NILFS_ALLOC_H
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include <linux/fs.h>
+
+static inline unsigned long
+nilfs_palloc_entries_per_group(const struct inode *inode)
+{
+	return 1UL << (inode->i_blkbits + 3 /* log2(8 = CHAR_BITS) */);
+}
+
+int nilfs_palloc_init_blockgroup(struct inode *, unsigned);
+int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
+				 struct buffer_head **);
+void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
+				   const struct buffer_head *, void *);
+
+/**
+ * nilfs_palloc_req - persistent alloctor request and reply
+ * @pr_entry_nr: entry number (vblocknr or inode number)
+ * @pr_desc_bh: buffer head of the buffer containing block group descriptors
+ * @pr_bitmap_bh: buffer head of the buffer containing a block group bitmap
+ * @pr_entry_bh: buffer head of the buffer containing translation entries
+ */
+struct nilfs_palloc_req {
+	__u64 pr_entry_nr;
+	struct buffer_head *pr_desc_bh;
+	struct buffer_head *pr_bitmap_bh;
+	struct buffer_head *pr_entry_bh;
+};
+
+int nilfs_palloc_prepare_alloc_entry(struct inode *,
+				     struct nilfs_palloc_req *);
+void nilfs_palloc_commit_alloc_entry(struct inode *,
+				     struct nilfs_palloc_req *);
+void nilfs_palloc_abort_alloc_entry(struct inode *, struct nilfs_palloc_req *);
+void nilfs_palloc_commit_free_entry(struct inode *, struct nilfs_palloc_req *);
+int nilfs_palloc_prepare_free_entry(struct inode *, struct nilfs_palloc_req *);
+void nilfs_palloc_abort_free_entry(struct inode *, struct nilfs_palloc_req *);
+int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
+
+#define nilfs_set_bit_atomic		ext2_set_bit_atomic
+#define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
+#define nilfs_find_next_zero_bit	ext2_find_next_zero_bit
+
+#endif	/* _NILFS_ALLOC_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

