From: akpm@linux-foundation.org
Subject: [merged] nilfs2-integrated-block-mapping.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:17 -0700
Message-ID: <200904071908.n37J8H3k011727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbZDGTpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sato.koji@lab.ntt.co.jp, konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nilfs2: integrated block mapping
has been removed from the -mm tree.  Its filename was
     nilfs2-integrated-block-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: integrated block mapping
From: Koji Sato <sato.koji@lab.ntt.co.jp>

This adds structures and operations for the block mapping (bmap for
short).  NILFS2 uses direct mappings for short files or B-tree based
mappings for longer files.

Every on-disk data block is held with inodes and managed through this
block mapping.  The nilfs_bmap structure and a set of functions here
provide this capability to the NILFS2 inode.

[penberg@cs.helsinki.fi: remove a bunch of bmap wrapper macros]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Koji Sato <sato.koji@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c       |  783 +++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/bmap.h       |  244 ++++++++++++
 fs/nilfs2/bmap_union.h |   42 ++
 3 files changed, 1069 insertions(+)

diff -puN /dev/null fs/nilfs2/bmap.c
--- /dev/null
+++ a/fs/nilfs2/bmap.c
@@ -0,0 +1,783 @@
+/*
+ * bmap.c - NILFS block mapping.
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
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include "nilfs.h"
+#include "bmap.h"
+#include "sb.h"
+#include "btnode.h"
+#include "mdt.h"
+#include "dat.h"
+#include "alloc.h"
+
+int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
+			       __u64 *ptrp)
+{
+	__u64 ptr;
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_lookup)(bmap, key, level, ptrp);
+	if (ret < 0)
+		goto out;
+	if (bmap->b_pops->bpop_translate != NULL) {
+		ret = (*bmap->b_pops->bpop_translate)(bmap, *ptrp, &ptr);
+		if (ret < 0)
+			goto out;
+		*ptrp = ptr;
+	}
+
+ out:
+	up_read(&bmap->b_sem);
+	return ret;
+}
+
+
+/**
+ * nilfs_bmap_lookup - find a record
+ * @bmap: bmap
+ * @key: key
+ * @recp: pointer to record
+ *
+ * Description: nilfs_bmap_lookup() finds a record whose key matches @key in
+ * @bmap.
+ *
+ * Return Value: On success, 0 is returned and the record associated with @key
+ * is stored in the place pointed by @recp. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A record associated with @key does not exist.
+ */
+int nilfs_bmap_lookup(struct nilfs_bmap *bmap,
+		      unsigned long key,
+		      unsigned long *recp)
+{
+	__u64 ptr;
+	int ret;
+
+	/* XXX: use macro for level 1 */
+	ret = nilfs_bmap_lookup_at_level(bmap, key, 1, &ptr);
+	if (recp != NULL)
+		*recp = ptr;
+	return ret;
+}
+
+static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
+{
+	__u64 keys[NILFS_BMAP_SMALL_HIGH + 1];
+	__u64 ptrs[NILFS_BMAP_SMALL_HIGH + 1];
+	int ret, n;
+
+	if (bmap->b_ops->bop_check_insert != NULL) {
+		ret = (*bmap->b_ops->bop_check_insert)(bmap, key);
+		if (ret > 0) {
+			n = (*bmap->b_ops->bop_gather_data)(
+				bmap, keys, ptrs, NILFS_BMAP_SMALL_HIGH + 1);
+			if (n < 0)
+				return n;
+			ret = nilfs_btree_convert_and_insert(
+				bmap, key, ptr, keys, ptrs, n,
+				NILFS_BMAP_LARGE_LOW, NILFS_BMAP_LARGE_HIGH);
+			if (ret == 0)
+				bmap->b_u.u_flags |= NILFS_BMAP_LARGE;
+
+			return ret;
+		} else if (ret < 0)
+			return ret;
+	}
+
+	return (*bmap->b_ops->bop_insert)(bmap, key, ptr);
+}
+
+/**
+ * nilfs_bmap_insert - insert a new key-record pair into a bmap
+ * @bmap: bmap
+ * @key: key
+ * @rec: record
+ *
+ * Description: nilfs_bmap_insert() inserts the new key-record pair specified
+ * by @key and @rec into @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EEXIST - A record associated with @key already exist.
+ */
+int nilfs_bmap_insert(struct nilfs_bmap *bmap,
+		      unsigned long key,
+		      unsigned long rec)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_insert(bmap, key, rec);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
+{
+	__u64 keys[NILFS_BMAP_LARGE_LOW + 1];
+	__u64 ptrs[NILFS_BMAP_LARGE_LOW + 1];
+	int ret, n;
+
+	if (bmap->b_ops->bop_check_delete != NULL) {
+		ret = (*bmap->b_ops->bop_check_delete)(bmap, key);
+		if (ret > 0) {
+			n = (*bmap->b_ops->bop_gather_data)(
+				bmap, keys, ptrs, NILFS_BMAP_LARGE_LOW + 1);
+			if (n < 0)
+				return n;
+			ret = nilfs_direct_delete_and_convert(
+				bmap, key, keys, ptrs, n,
+				NILFS_BMAP_SMALL_LOW, NILFS_BMAP_SMALL_HIGH);
+			if (ret == 0)
+				bmap->b_u.u_flags &= ~NILFS_BMAP_LARGE;
+
+			return ret;
+		} else if (ret < 0)
+			return ret;
+	}
+
+	return (*bmap->b_ops->bop_delete)(bmap, key);
+}
+
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
+{
+	__u64 lastkey;
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	if (!ret)
+		*key = lastkey;
+	up_read(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_delete - delete a key-record pair from a bmap
+ * @bmap: bmap
+ * @key: key
+ *
+ * Description: nilfs_bmap_delete() deletes the key-record pair specified by
+ * @key from @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A record associated with @key does not exist.
+ */
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_delete(bmap, key);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
+{
+	__u64 lastkey;
+	int ret;
+
+	ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			ret = 0;
+		return ret;
+	}
+
+	while (key <= lastkey) {
+		ret = nilfs_bmap_do_delete(bmap, lastkey);
+		if (ret < 0)
+			return ret;
+		ret = (*bmap->b_ops->bop_last_key)(bmap, &lastkey);
+		if (ret < 0) {
+			if (ret == -ENOENT)
+				ret = 0;
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * nilfs_bmap_truncate - truncate a bmap to a specified key
+ * @bmap: bmap
+ * @key: key
+ *
+ * Description: nilfs_bmap_truncate() removes key-record pairs whose keys are
+ * greater than or equal to @key from @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_do_truncate(bmap, key);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_clear - free resources a bmap holds
+ * @bmap: bmap
+ *
+ * Description: nilfs_bmap_clear() frees resources associated with @bmap.
+ */
+void nilfs_bmap_clear(struct nilfs_bmap *bmap)
+{
+	down_write(&bmap->b_sem);
+	if (bmap->b_ops->bop_clear != NULL)
+		(*bmap->b_ops->bop_clear)(bmap);
+	up_write(&bmap->b_sem);
+}
+
+/**
+ * nilfs_bmap_propagate - propagate dirty state
+ * @bmap: bmap
+ * @bh: buffer head
+ *
+ * Description: nilfs_bmap_propagate() marks the buffers that directly or
+ * indirectly refer to the block specified by @bh dirty.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_propagate)(bmap, bh);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_lookup_dirty_buffers -
+ * @bmap: bmap
+ * @listp: pointer to buffer head list
+ */
+void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *bmap,
+				     struct list_head *listp)
+{
+	if (bmap->b_ops->bop_lookup_dirty_buffers != NULL)
+		(*bmap->b_ops->bop_lookup_dirty_buffers)(bmap, listp);
+}
+
+/**
+ * nilfs_bmap_assign - assign a new block number to a block
+ * @bmap: bmap
+ * @bhp: pointer to buffer head
+ * @blocknr: block number
+ * @binfo: block information
+ *
+ * Description: nilfs_bmap_assign() assigns the block number @blocknr to the
+ * buffer specified by @bh.
+ *
+ * Return Value: On success, 0 is returned and the buffer head of a newly
+ * create buffer and the block information associated with the buffer are
+ * stored in the place pointed by @bh and @binfo, respectively. On error, one
+ * of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_assign(struct nilfs_bmap *bmap,
+		      struct buffer_head **bh,
+		      unsigned long blocknr,
+		      union nilfs_binfo *binfo)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_assign)(bmap, bh, blocknr, binfo);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_mark - mark block dirty
+ * @bmap: bmap
+ * @key: key
+ * @level: level
+ *
+ * Description: nilfs_bmap_mark() marks the block specified by @key and @level
+ * as dirty.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
+{
+	int ret;
+
+	if (bmap->b_ops->bop_mark == NULL)
+		return 0;
+
+	down_write(&bmap->b_sem);
+	ret = (*bmap->b_ops->bop_mark)(bmap, key, level);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+/**
+ * nilfs_bmap_test_and_clear_dirty - test and clear a bmap dirty state
+ * @bmap: bmap
+ *
+ * Description: nilfs_test_and_clear() is the atomic operation to test and
+ * clear the dirty state of @bmap.
+ *
+ * Return Value: 1 is returned if @bmap is dirty, or 0 if clear.
+ */
+int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
+{
+	int ret;
+
+	down_write(&bmap->b_sem);
+	ret = nilfs_bmap_dirty(bmap);
+	nilfs_bmap_clear_dirty(bmap);
+	up_write(&bmap->b_sem);
+	return ret;
+}
+
+
+/*
+ * Internal use only
+ */
+
+void nilfs_bmap_add_blocks(const struct nilfs_bmap *bmap, int n)
+{
+	inode_add_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
+	if (NILFS_MDT(bmap->b_inode))
+		nilfs_mdt_mark_dirty(bmap->b_inode);
+	else
+		mark_inode_dirty(bmap->b_inode);
+}
+
+void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
+{
+	inode_sub_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
+	if (NILFS_MDT(bmap->b_inode))
+		nilfs_mdt_mark_dirty(bmap->b_inode);
+	else
+		mark_inode_dirty(bmap->b_inode);
+}
+
+int nilfs_bmap_get_block(const struct nilfs_bmap *bmap, __u64 ptr,
+			 struct buffer_head **bhp)
+{
+	return nilfs_btnode_get(&NILFS_BMAP_I(bmap)->i_btnode_cache,
+				ptr, 0, bhp, 0);
+}
+
+void nilfs_bmap_put_block(const struct nilfs_bmap *bmap,
+			  struct buffer_head *bh)
+{
+	brelse(bh);
+}
+
+int nilfs_bmap_get_new_block(const struct nilfs_bmap *bmap, __u64 ptr,
+			     struct buffer_head **bhp)
+{
+	int ret;
+
+	ret = nilfs_btnode_get(&NILFS_BMAP_I(bmap)->i_btnode_cache,
+			       ptr, 0, bhp, 1);
+	if (ret < 0)
+		return ret;
+	set_buffer_nilfs_volatile(*bhp);
+	return 0;
+}
+
+void nilfs_bmap_delete_block(const struct nilfs_bmap *bmap,
+			     struct buffer_head *bh)
+{
+	nilfs_btnode_delete(bh);
+}
+
+__u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
+			      const struct buffer_head *bh)
+{
+	struct buffer_head *pbh;
+	__u64 key;
+
+	key = page_index(bh->b_page) << (PAGE_CACHE_SHIFT -
+					 bmap->b_inode->i_blkbits);
+	for (pbh = page_buffers(bh->b_page); pbh != bh;
+	     pbh = pbh->b_this_page, key++);
+
+	return key;
+}
+
+__u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *bmap, __u64 key)
+{
+	__s64 diff;
+
+	diff = key - bmap->b_last_allocated_key;
+	if ((nilfs_bmap_keydiff_abs(diff) < NILFS_INODE_BMAP_SIZE) &&
+	    (bmap->b_last_allocated_ptr != NILFS_BMAP_INVALID_PTR) &&
+	    (bmap->b_last_allocated_ptr + diff > 0))
+		return bmap->b_last_allocated_ptr + diff;
+	else
+		return NILFS_BMAP_INVALID_PTR;
+}
+
+static struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
+{
+	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
+}
+
+#define NILFS_BMAP_GROUP_DIV	8
+__u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *bmap)
+{
+	struct inode *dat = nilfs_bmap_get_dat(bmap);
+	unsigned long entries_per_group = nilfs_palloc_entries_per_group(dat);
+	unsigned long group = bmap->b_inode->i_ino / entries_per_group;
+
+	return group * entries_per_group +
+		(bmap->b_inode->i_ino % NILFS_BMAP_GROUP_DIV) *
+		(entries_per_group / NILFS_BMAP_GROUP_DIV);
+}
+
+static int nilfs_bmap_prepare_alloc_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_alloc_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_abort_alloc_v(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_alloc(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static int nilfs_bmap_prepare_start_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_start_v(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req,
+				      sector_t blocknr)
+{
+	nilfs_dat_commit_start(nilfs_bmap_get_dat(bmap), &req->bpr_req,
+			       blocknr);
+}
+
+static void nilfs_bmap_abort_start_v(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_start(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static int nilfs_bmap_prepare_end_v(struct nilfs_bmap *bmap,
+				    union nilfs_bmap_ptr_req *req)
+{
+	return nilfs_dat_prepare_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+static void nilfs_bmap_commit_end_v(struct nilfs_bmap *bmap,
+				    union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 0);
+}
+
+static void nilfs_bmap_commit_end_vmdt(struct nilfs_bmap *bmap,
+				       union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_commit_end(nilfs_bmap_get_dat(bmap), &req->bpr_req, 1);
+}
+
+static void nilfs_bmap_abort_end_v(struct nilfs_bmap *bmap,
+				   union nilfs_bmap_ptr_req *req)
+{
+	nilfs_dat_abort_end(nilfs_bmap_get_dat(bmap), &req->bpr_req);
+}
+
+int nilfs_bmap_move_v(const struct nilfs_bmap *bmap, __u64 vblocknr,
+		      sector_t blocknr)
+{
+	return nilfs_dat_move(nilfs_bmap_get_dat(bmap), vblocknr, blocknr);
+}
+
+int nilfs_bmap_mark_dirty(const struct nilfs_bmap *bmap, __u64 vblocknr)
+{
+	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), vblocknr);
+}
+
+int nilfs_bmap_prepare_update(struct nilfs_bmap *bmap,
+			      union nilfs_bmap_ptr_req *oldreq,
+			      union nilfs_bmap_ptr_req *newreq)
+{
+	int ret;
+
+	ret = (*bmap->b_pops->bpop_prepare_end_ptr)(bmap, oldreq);
+	if (ret < 0)
+		return ret;
+	ret = (*bmap->b_pops->bpop_prepare_alloc_ptr)(bmap, newreq);
+	if (ret < 0)
+		(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
+
+	return ret;
+}
+
+void nilfs_bmap_commit_update(struct nilfs_bmap *bmap,
+			      union nilfs_bmap_ptr_req *oldreq,
+			      union nilfs_bmap_ptr_req *newreq)
+{
+	(*bmap->b_pops->bpop_commit_end_ptr)(bmap, oldreq);
+	(*bmap->b_pops->bpop_commit_alloc_ptr)(bmap, newreq);
+}
+
+void nilfs_bmap_abort_update(struct nilfs_bmap *bmap,
+			     union nilfs_bmap_ptr_req *oldreq,
+			     union nilfs_bmap_ptr_req *newreq)
+{
+	(*bmap->b_pops->bpop_abort_end_ptr)(bmap, oldreq);
+	(*bmap->b_pops->bpop_abort_alloc_ptr)(bmap, newreq);
+}
+
+static int nilfs_bmap_translate_v(const struct nilfs_bmap *bmap, __u64 ptr,
+				  __u64 *ptrp)
+{
+	sector_t blocknr;
+	int ret;
+
+	ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), ptr, &blocknr);
+	if (ret < 0)
+		return ret;
+	if (ptrp != NULL)
+		*ptrp = blocknr;
+	return 0;
+}
+
+static int nilfs_bmap_prepare_alloc_p(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	/* ignore target ptr */
+	req->bpr_ptr = bmap->b_last_allocated_ptr++;
+	return 0;
+}
+
+static void nilfs_bmap_commit_alloc_p(struct nilfs_bmap *bmap,
+				      union nilfs_bmap_ptr_req *req)
+{
+	/* do nothing */
+}
+
+static void nilfs_bmap_abort_alloc_p(struct nilfs_bmap *bmap,
+				     union nilfs_bmap_ptr_req *req)
+{
+	bmap->b_last_allocated_ptr--;
+}
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_v = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
+	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
+	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
+	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
+	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
+	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_v,
+	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
+
+	.bpop_translate		=	nilfs_bmap_translate_v,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_vmdt = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_v,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_v,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_v,
+	.bpop_prepare_start_ptr	=	nilfs_bmap_prepare_start_v,
+	.bpop_commit_start_ptr	=	nilfs_bmap_commit_start_v,
+	.bpop_abort_start_ptr	=	nilfs_bmap_abort_start_v,
+	.bpop_prepare_end_ptr	=	nilfs_bmap_prepare_end_v,
+	.bpop_commit_end_ptr	=	nilfs_bmap_commit_end_vmdt,
+	.bpop_abort_end_ptr	=	nilfs_bmap_abort_end_v,
+
+	.bpop_translate		=	nilfs_bmap_translate_v,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_p = {
+	.bpop_prepare_alloc_ptr	=	nilfs_bmap_prepare_alloc_p,
+	.bpop_commit_alloc_ptr	=	nilfs_bmap_commit_alloc_p,
+	.bpop_abort_alloc_ptr	=	nilfs_bmap_abort_alloc_p,
+	.bpop_prepare_start_ptr	=	NULL,
+	.bpop_commit_start_ptr	=	NULL,
+	.bpop_abort_start_ptr	=	NULL,
+	.bpop_prepare_end_ptr	=	NULL,
+	.bpop_commit_end_ptr	=	NULL,
+	.bpop_abort_end_ptr	=	NULL,
+
+	.bpop_translate		=	NULL,
+};
+
+static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_gc = {
+	.bpop_prepare_alloc_ptr	=	NULL,
+	.bpop_commit_alloc_ptr	=	NULL,
+	.bpop_abort_alloc_ptr	=	NULL,
+	.bpop_prepare_start_ptr	=	NULL,
+	.bpop_commit_start_ptr	=	NULL,
+	.bpop_abort_start_ptr	=	NULL,
+	.bpop_prepare_end_ptr	=	NULL,
+	.bpop_commit_end_ptr	=	NULL,
+	.bpop_abort_end_ptr	=	NULL,
+
+	.bpop_translate		=	NULL,
+};
+
+/**
+ * nilfs_bmap_read - read a bmap from an inode
+ * @bmap: bmap
+ * @raw_inode: on-disk inode
+ *
+ * Description: nilfs_bmap_read() initializes the bmap @bmap.
+ *
+ * Return Value: On success, 0 is returned. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
+{
+	if (raw_inode == NULL)
+		memset(bmap->b_u.u_data, 0, NILFS_BMAP_SIZE);
+	else
+		memcpy(bmap->b_u.u_data, raw_inode->i_bmap, NILFS_BMAP_SIZE);
+
+	init_rwsem(&bmap->b_sem);
+	bmap->b_state = 0;
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+	switch (bmap->b_inode->i_ino) {
+	case NILFS_DAT_INO:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_p;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
+		break;
+	case NILFS_CPFILE_INO:
+	case NILFS_SUFILE_INO:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_vmdt;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		break;
+	default:
+		bmap->b_pops = &nilfs_bmap_ptr_ops_v;
+		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
+		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+		break;
+	}
+
+	return (bmap->b_u.u_flags & NILFS_BMAP_LARGE) ?
+		nilfs_btree_init(bmap,
+				 NILFS_BMAP_LARGE_LOW,
+				 NILFS_BMAP_LARGE_HIGH) :
+		nilfs_direct_init(bmap,
+				  NILFS_BMAP_SMALL_LOW,
+				  NILFS_BMAP_SMALL_HIGH);
+}
+
+/**
+ * nilfs_bmap_write - write back a bmap to an inode
+ * @bmap: bmap
+ * @raw_inode: on-disk inode
+ *
+ * Description: nilfs_bmap_write() stores @bmap in @raw_inode.
+ */
+void nilfs_bmap_write(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
+{
+	down_write(&bmap->b_sem);
+	memcpy(raw_inode->i_bmap, bmap->b_u.u_data,
+	       NILFS_INODE_BMAP_SIZE * sizeof(__le64));
+	if (bmap->b_inode->i_ino == NILFS_DAT_INO)
+		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
+
+	up_write(&bmap->b_sem);
+}
+
+void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
+{
+	memset(&bmap->b_u, 0, NILFS_BMAP_SIZE);
+	init_rwsem(&bmap->b_sem);
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+	bmap->b_pops = &nilfs_bmap_ptr_ops_gc;
+	bmap->b_last_allocated_key = 0;
+	bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
+	bmap->b_state = 0;
+	nilfs_btree_init_gc(bmap);
+}
+
+void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
+{
+	memcpy(gcbmap, bmap, sizeof(union nilfs_bmap_union));
+	init_rwsem(&gcbmap->b_sem);
+	gcbmap->b_inode = &NILFS_BMAP_I(gcbmap)->vfs_inode;
+}
+
+void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
+{
+	memcpy(bmap, gcbmap, sizeof(union nilfs_bmap_union));
+	init_rwsem(&bmap->b_sem);
+	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+}
diff -puN /dev/null fs/nilfs2/bmap.h
--- /dev/null
+++ a/fs/nilfs2/bmap.h
@@ -0,0 +1,244 @@
+/*
+ * bmap.h - NILFS block mapping.
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
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_BMAP_H
+#define _NILFS_BMAP_H
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "alloc.h"
+
+#define NILFS_BMAP_INVALID_PTR	0
+
+#define nilfs_bmap_dkey_to_key(dkey)	le64_to_cpu(dkey)
+#define nilfs_bmap_key_to_dkey(key)	cpu_to_le64(key)
+#define nilfs_bmap_dptr_to_ptr(dptr)	le64_to_cpu(dptr)
+#define nilfs_bmap_ptr_to_dptr(ptr)	cpu_to_le64(ptr)
+
+#define nilfs_bmap_keydiff_abs(diff)	((diff) < 0 ? -(diff) : (diff))
+
+
+struct nilfs_bmap;
+
+/**
+ * union nilfs_bmap_ptr_req - request for bmap ptr
+ * @bpr_ptr: bmap pointer
+ * @bpr_req: request for persistent allocator
+ */
+union nilfs_bmap_ptr_req {
+	__u64 bpr_ptr;
+	struct nilfs_palloc_req bpr_req;
+};
+
+/**
+ * struct nilfs_bmap_stats - bmap statistics
+ * @bs_nblocks: number of blocks created or deleted
+ */
+struct nilfs_bmap_stats {
+	unsigned int bs_nblocks;
+};
+
+/**
+ * struct nilfs_bmap_operations - bmap operation table
+ */
+struct nilfs_bmap_operations {
+	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
+	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
+	int (*bop_delete)(struct nilfs_bmap *, __u64);
+	void (*bop_clear)(struct nilfs_bmap *);
+
+	int (*bop_propagate)(const struct nilfs_bmap *, struct buffer_head *);
+	void (*bop_lookup_dirty_buffers)(struct nilfs_bmap *,
+					 struct list_head *);
+
+	int (*bop_assign)(struct nilfs_bmap *,
+			  struct buffer_head **,
+			  sector_t,
+			  union nilfs_binfo *);
+	int (*bop_mark)(struct nilfs_bmap *, __u64, int);
+
+	/* The following functions are internal use only. */
+	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
+	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
+	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
+	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
+};
+
+
+/**
+ * struct nilfs_bmap_ptr_operations - bmap ptr operation table
+ */
+struct nilfs_bmap_ptr_operations {
+	int (*bpop_prepare_alloc_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_alloc_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_abort_alloc_ptr)(struct nilfs_bmap *,
+				     union nilfs_bmap_ptr_req *);
+	int (*bpop_prepare_start_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_start_ptr)(struct nilfs_bmap *,
+				      union nilfs_bmap_ptr_req *,
+				      sector_t);
+	void (*bpop_abort_start_ptr)(struct nilfs_bmap *,
+				     union nilfs_bmap_ptr_req *);
+	int (*bpop_prepare_end_ptr)(struct nilfs_bmap *,
+				    union nilfs_bmap_ptr_req *);
+	void (*bpop_commit_end_ptr)(struct nilfs_bmap *,
+				    union nilfs_bmap_ptr_req *);
+	void (*bpop_abort_end_ptr)(struct nilfs_bmap *,
+				   union nilfs_bmap_ptr_req *);
+
+	int (*bpop_translate)(const struct nilfs_bmap *, __u64, __u64 *);
+};
+
+
+#define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
+#define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * 8 /* CHAR_BIT */)
+#define NILFS_BMAP_NEW_PTR_INIT	\
+	(1UL << (sizeof(unsigned long) * 8 /* CHAR_BIT */ - 1))
+
+static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
+{
+	return !!(ptr & NILFS_BMAP_NEW_PTR_INIT);
+}
+
+
+/**
+ * struct nilfs_bmap - bmap structure
+ * @b_u: raw data
+ * @b_sem: semaphore
+ * @b_inode: owner of bmap
+ * @b_ops: bmap operation table
+ * @b_pops: bmap ptr operation table
+ * @b_low: low watermark of conversion
+ * @b_high: high watermark of conversion
+ * @b_last_allocated_key: last allocated key for data block
+ * @b_last_allocated_ptr: last allocated ptr for data block
+ * @b_state: state
+ */
+struct nilfs_bmap {
+	union {
+		__u8 u_flags;
+		__le64 u_data[NILFS_BMAP_SIZE / sizeof(__le64)];
+	} b_u;
+	struct rw_semaphore b_sem;
+	struct inode *b_inode;
+	const struct nilfs_bmap_operations *b_ops;
+	const struct nilfs_bmap_ptr_operations *b_pops;
+	__u64 b_low;
+	__u64 b_high;
+	__u64 b_last_allocated_key;
+	__u64 b_last_allocated_ptr;
+	int b_state;
+};
+
+/* state */
+#define NILFS_BMAP_DIRTY	0x00000001
+
+
+int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
+int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
+void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
+int nilfs_bmap_lookup(struct nilfs_bmap *, unsigned long, unsigned long *);
+int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
+int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
+int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
+int nilfs_bmap_truncate(struct nilfs_bmap *, unsigned long);
+void nilfs_bmap_clear(struct nilfs_bmap *);
+int nilfs_bmap_propagate(struct nilfs_bmap *, struct buffer_head *);
+void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *, struct list_head *);
+int nilfs_bmap_assign(struct nilfs_bmap *, struct buffer_head **,
+		      unsigned long, union nilfs_binfo *);
+int nilfs_bmap_lookup_at_level(struct nilfs_bmap *, __u64, int, __u64 *);
+int nilfs_bmap_mark(struct nilfs_bmap *, __u64, int);
+
+void nilfs_bmap_init_gc(struct nilfs_bmap *);
+void nilfs_bmap_init_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
+void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
+
+
+/*
+ * Internal use only
+ */
+
+int nilfs_bmap_move_v(const struct nilfs_bmap *, __u64, sector_t);
+int nilfs_bmap_mark_dirty(const struct nilfs_bmap *, __u64);
+
+
+__u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
+			      const struct buffer_head *);
+
+__u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *, __u64);
+__u64 nilfs_bmap_find_target_in_group(const struct nilfs_bmap *);
+
+int nilfs_bmap_prepare_update(struct nilfs_bmap *,
+			      union nilfs_bmap_ptr_req *,
+			      union nilfs_bmap_ptr_req *);
+void nilfs_bmap_commit_update(struct nilfs_bmap *,
+			      union nilfs_bmap_ptr_req *,
+			      union nilfs_bmap_ptr_req *);
+void nilfs_bmap_abort_update(struct nilfs_bmap *,
+			     union nilfs_bmap_ptr_req *,
+			     union nilfs_bmap_ptr_req *);
+
+void nilfs_bmap_add_blocks(const struct nilfs_bmap *, int);
+void nilfs_bmap_sub_blocks(const struct nilfs_bmap *, int);
+
+
+int nilfs_bmap_get_block(const struct nilfs_bmap *, __u64,
+			 struct buffer_head **);
+void nilfs_bmap_put_block(const struct nilfs_bmap *, struct buffer_head *);
+int nilfs_bmap_get_new_block(const struct nilfs_bmap *, __u64,
+			     struct buffer_head **);
+void nilfs_bmap_delete_block(const struct nilfs_bmap *, struct buffer_head *);
+
+
+/* Assume that bmap semaphore is locked. */
+static inline int nilfs_bmap_dirty(const struct nilfs_bmap *bmap)
+{
+	return !!(bmap->b_state & NILFS_BMAP_DIRTY);
+}
+
+/* Assume that bmap semaphore is locked. */
+static inline void nilfs_bmap_set_dirty(struct nilfs_bmap *bmap)
+{
+	bmap->b_state |= NILFS_BMAP_DIRTY;
+}
+
+/* Assume that bmap semaphore is locked. */
+static inline void nilfs_bmap_clear_dirty(struct nilfs_bmap *bmap)
+{
+	bmap->b_state &= ~NILFS_BMAP_DIRTY;
+}
+
+
+#define NILFS_BMAP_LARGE	0x1
+
+#define NILFS_BMAP_SMALL_LOW	NILFS_DIRECT_KEY_MIN
+#define NILFS_BMAP_SMALL_HIGH	NILFS_DIRECT_KEY_MAX
+#define NILFS_BMAP_LARGE_LOW	NILFS_BTREE_ROOT_NCHILDREN_MAX
+#define NILFS_BMAP_LARGE_HIGH	NILFS_BTREE_KEY_MAX
+
+#endif	/* _NILFS_BMAP_H */
diff -puN /dev/null fs/nilfs2/bmap_union.h
--- /dev/null
+++ a/fs/nilfs2/bmap_union.h
@@ -0,0 +1,42 @@
+/*
+ * bmap_union.h - NILFS block mapping.
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
+ * Written by Koji Sato <koji@osrg.net>.
+ */
+
+#ifndef _NILFS_BMAP_UNION_H
+#define _NILFS_BMAP_UNION_H
+
+#include "bmap.h"
+#include "direct.h"
+#include "btree.h"
+
+/**
+ * nilfs_bmap_union -
+ * @bi_bmap: bmap structure
+ * @bi_btree: direct map structure
+ * @bi_direct: B-tree structure
+ */
+union nilfs_bmap_union {
+	struct nilfs_bmap bi_bmap;
+	struct nilfs_direct bi_direct;
+	struct nilfs_btree bi_btree;
+};
+
+#endif	/* _NILFS_BMAP_UNION_H */
_

Patches currently in -mm which might be from sato.koji@lab.ntt.co.jp are

origin.patch

