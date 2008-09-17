From: akpm@linux-foundation.org
Subject: + nilfs2-another-dat-for-garbage-collection.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:28:26 -0700
Message-ID: <200809172028.m8HKSQaL029033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093AbYIQU2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:28:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, amagai.yoshiji@lab.ntt.co.jp, kihara.seiji@lab.ntt.co.jp


The patch titled
     nilfs2: another dat for garbage collection
has been added to the -mm tree.  Its filename is
     nilfs2-another-dat-for-garbage-collection.patch

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
Subject: nilfs2: another dat for garbage collection
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

NILFS2 uses another DAT inode during garbage collection to ensure
atomicity and consistency of the DAT in the transient state.  This
twin inode is called GCDAT.

This adds functions to initialize the GCDAT and to switch page caches
and B-tree node caches between these two inodes.

Signed-off-by: Seiji Kihara <kihara.seiji@lab.ntt.co.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcdat.c |   84 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff -puN /dev/null fs/nilfs2/gcdat.c
--- /dev/null
+++ a/fs/nilfs2/gcdat.c
@@ -0,0 +1,84 @@
+/*
+ * gcdat.c - NILFS shadow DAT inode for GC
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
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
+ * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
+ *            and Ryusuke Konishi <ryusuke@osrg.net>.
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include "nilfs.h"
+#include "page.h"
+#include "mdt.h"
+
+int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
+	int err;
+
+	gcdat->i_state = 0;
+	gcdat->i_blocks = dat->i_blocks;
+	gii->i_flags = dii->i_flags;
+	gii->i_state = dii->i_state | (1 << NILFS_I_GCDAT);
+	gii->i_cno = 0;
+	nilfs_bmap_init_gcdat(gii->i_bmap, dii->i_bmap);
+	err = nilfs_copy_dirty_pages(gcdat->i_mapping, dat->i_mapping);
+	if (unlikely(err))
+		return err;
+
+	return nilfs_copy_dirty_pages(&gii->i_btnode_cache,
+				      &dii->i_btnode_cache);
+}
+
+void nilfs_commit_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
+	struct address_space *mapping = dat->i_mapping;
+	struct address_space *gmapping = gcdat->i_mapping;
+
+	down_write(&NILFS_MDT(dat)->mi_sem);
+	dat->i_blocks = gcdat->i_blocks;
+	dii->i_flags = gii->i_flags;
+	dii->i_state = gii->i_state & ~(1 << NILFS_I_GCDAT);
+
+	nilfs_bmap_commit_gcdat(gii->i_bmap, dii->i_bmap);
+
+	nilfs_clear_dirty_pages(mapping);
+	nilfs_copy_back_pages(mapping, gmapping);
+	/* note: mdt dirty flags should be cleared by segctor. */
+
+	nilfs_clear_dirty_pages(&dii->i_btnode_cache);
+	nilfs_copy_back_pages(&dii->i_btnode_cache, &gii->i_btnode_cache);
+
+	up_write(&NILFS_MDT(dat)->mi_sem);
+}
+
+void nilfs_clear_gcdat_inode(struct the_nilfs *nilfs)
+{
+	struct inode *gcdat = nilfs->ns_gc_dat;
+	struct nilfs_inode_info *gii = NILFS_I(gcdat);
+
+	gcdat->i_state = I_CLEAR;
+	gii->i_flags = 0;
+
+	truncate_inode_pages(gcdat->i_mapping, 0);
+	truncate_inode_pages(&gii->i_btnode_cache, 0);
+}
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

