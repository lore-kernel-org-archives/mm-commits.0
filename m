From: akpm@linux-foundation.org
Subject: + nilfs2-insert-explanations-in-gcinode-file.patch added to -mm tree
Date: Mon, 15 Dec 2008 15:27:25 -0800
Message-ID: <200812152327.mBFNRPOj005008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYLOX2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 18:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, 20080917144146.GD8750@logfs.org, 20080917224953.GB14644@logfs.org, joern@logfs.org


The patch titled
     nilfs2: insert explanations in gcinode file
has been added to the -mm tree.  Its filename is
     nilfs2-insert-explanations-in-gcinode-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: insert explanations in gcinode file
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The file gcinode.c gives buffer cache functions for on-disk blocks
moved in garbage collection.  Joern Engel has suggested inserting its
explanations in the source file (Message-ID:
<20080917144146.GD8750@logfs.org> and
<20080917224953.GB14644@logfs.org>).

This follows the comment.

Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/gcinode.c~nilfs2-insert-explanations-in-gcinode-file fs/nilfs2/gcinode.c
--- a/fs/nilfs2/gcinode.c~nilfs2-insert-explanations-in-gcinode-file
+++ a/fs/nilfs2/gcinode.c
@@ -1,5 +1,5 @@
 /*
- * gcinode.c - NILFS memory inode for GC
+ * gcinode.c - dummy inodes to buffer blocks for garbage collection
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
@@ -22,6 +22,25 @@
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  *
  */
+/*
+ * This file adds the cache of on-disk blocks to be moved in garbage
+ * collection.  The disk blocks are held with dummy inodes (called
+ * gcinodes), and this file provides lookup function of the dummy
+ * inodes and their buffer read function.
+ *
+ * Since NILFS2 keeps up multiple checkpoints/snapshots accross GC, it
+ * has to treat blocks that belong to a same file but have different
+ * checkpoint numbers.  To avoid interference among generations, dummy
+ * inodes are managed separatly from actual inodes, and their lookup
+ * function (nilfs_gc_iget) is designed to be specified with a
+ * checkpoint number argument as well as an inode number.
+ *
+ * Buffers and pages held by the dummy inodes will be released each
+ * time after they are copied to a new log.  Dirty blocks made on the
+ * current generation and the blocks to be moved by GC never overlap
+ * because the dirty blocks make a new generation; they rather must be
+ * written individually.
+ */
 
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
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
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch

