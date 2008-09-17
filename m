From: akpm@linux-foundation.org
Subject: + nilfs2-inode-map-file.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:27:42 -0700
Message-ID: <200809172027.m8HKRgq2028983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbYIQU1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, amagai.yoshiji@lab.ntt.co.jp


The patch titled
     nilfs2: inode map file
has been added to the -mm tree.  Its filename is
     nilfs2-inode-map-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: inode map file
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds a meta data file which stores on-disk inodes in its data blocks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ifile.c |  150 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/ifile.h |   53 +++++++++++++++
 2 files changed, 203 insertions(+)

diff -puN /dev/null fs/nilfs2/ifile.c
--- /dev/null
+++ a/fs/nilfs2/ifile.c
@@ -0,0 +1,150 @@
+/*
+ * ifile.c - NILFS inode file
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
+ * Written by Amagai Yoshiji <amagai@osrg.net>.
+ * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include "nilfs.h"
+#include "mdt.h"
+#include "alloc.h"
+#include "ifile.h"
+
+/**
+ * nilfs_ifile_create_inode - create a new disk inode
+ * @ifile: ifile inode
+ * @out_ino: pointer to a variable to store inode number
+ * @out_bh: buffer_head contains newly allocated disk inode
+ *
+ * Return Value: On success, 0 is returned and the newly allocated inode
+ * number is stored in the place pointed by @ino, and buffer_head pointer
+ * that contains newly allocated disk inode structure is stored in the
+ * place pointed by @out_bh
+ * On error, one of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No inode left.
+ */
+int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
+			     struct buffer_head **out_bh)
+{
+	struct nilfs_palloc_req req;
+	int ret;
+
+	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
+				 a group. dull code!! */
+	req.pr_entry_bh = NULL;
+
+	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	if (!ret) {
+		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 1,
+						   &req.pr_entry_bh);
+		if (ret < 0)
+			nilfs_palloc_abort_alloc_entry(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+	nilfs_palloc_commit_alloc_entry(ifile, &req);
+	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	nilfs_mdt_mark_dirty(ifile);
+	*out_ino = (ino_t)req.pr_entry_nr;
+	*out_bh = req.pr_entry_bh;
+	return 0;
+}
+
+/**
+ * nilfs_ifile_delete_inode - delete a disk inode
+ * @ifile: ifile inode
+ * @ino: inode number
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - The inode number @ino have not been allocated.
+ */
+int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
+{
+	struct nilfs_palloc_req req = {
+		.pr_entry_nr = ino, .pr_entry_bh = NULL
+	};
+	struct nilfs_inode *raw_inode;
+	void *kaddr;
+	int ret;
+
+	ret = nilfs_palloc_prepare_free_entry(ifile, &req);
+	if (!ret) {
+		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 0,
+						   &req.pr_entry_bh);
+		if (ret < 0)
+			nilfs_palloc_abort_free_entry(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+
+	kaddr = kmap_atomic(req.pr_entry_bh->b_page, KM_USER0);
+	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
+						 req.pr_entry_bh, kaddr);
+	raw_inode->i_flags = 0;
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	brelse(req.pr_entry_bh);
+
+	nilfs_palloc_commit_free_entry(ifile, &req);
+
+	return 0;
+}
+
+int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
+				struct buffer_head **out_bh)
+{
+	struct super_block *sb = ifile->i_sb;
+	int err;
+
+	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
+		nilfs_error(sb, __func__, "bad inode number: %lu",
+			    (unsigned long) ino);
+		return -EINVAL;
+	}
+
+	err = nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
+	if (unlikely(err)) {
+		if (err == -EINVAL)
+			nilfs_error(sb, __func__, "ifile is broken");
+		else
+			nilfs_warning(sb, __func__,
+				      "unable to read inode: %lu",
+				      (unsigned long) ino);
+	}
+	return err;
+}
diff -puN /dev/null fs/nilfs2/ifile.h
--- /dev/null
+++ a/fs/nilfs2/ifile.h
@@ -0,0 +1,53 @@
+/*
+ * ifile.h - NILFS inode file
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
+ * Written by Amagai Yoshiji <amagai@osrg.net>
+ * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _NILFS_IFILE_H
+#define _NILFS_IFILE_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+#include "alloc.h"
+
+#define NILFS_IFILE_GFP  NILFS_MDT_GFP
+
+static inline struct nilfs_inode *
+nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
+{
+	void *kaddr = kmap(ibh->b_page);
+	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
+}
+
+static inline void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
+					   struct buffer_head *ibh)
+{
+	kunmap(ibh->b_page);
+}
+
+int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
+int nilfs_ifile_delete_inode(struct inode *, ino_t);
+int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
+
+#endif	/* _NILFS_IFILE_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch

