From: akpm@linux-foundation.org
Subject: [merged] nilfs2-insert-explanations-in-gcinode-file.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:17 -0700
Message-ID: <200904071909.n37J9HAr012273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbZDGTNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, 20080917144146.GD8750@logfs.org, 20080917224953.GB14644@logfs.org, joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     nilfs2: insert explanations in gcinode file
has been removed from the -mm tree.  Its filename was
     nilfs2-insert-explanations-in-gcinode-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

