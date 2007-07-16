From: akpm@linux-foundation.org
Subject: - ext3-ext4-orphan-list-check-on-destroy_inode.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:59 -0700
Message-ID: <200707162055.l6GKtx6x001984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760677AbXGPVP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     ext3/ext4: orphan list check on destroy_inode
has been removed from the -mm tree.  Its filename was
     ext3-ext4-orphan-list-check-on-destroy_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3/ext4: orphan list check on destroy_inode
From: Vasily Averin <vvs@sw.ru>

Customers claims to ext3-related errors, investigation showed that ext3
orphan list has been corrupted and have the reference to non-ext3 inode. 
The following debug helps to understand the reasons of this issue.

[akpm@linux-foundation.org: update for print_hex_dump() changes]
Signed-off-by: Vasily Averin <vvs@sw.ru>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    8 ++++++++
 fs/ext4/super.c |    8 ++++++++
 2 files changed, 16 insertions(+)

diff -puN fs/ext3/super.c~ext3-ext4-orphan-list-check-on-destroy_inode fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-ext4-orphan-list-check-on-destroy_inode
+++ a/fs/ext3/super.c
@@ -459,6 +459,14 @@ static struct inode *ext3_alloc_inode(st
 
 static void ext3_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
+		printk("EXT3 Inode %p: orphan list check failed!\n",
+			EXT3_I(inode));
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 16, 4,
+				EXT3_I(inode), sizeof(struct ext3_inode_info),
+				false);
+		dump_stack();
+	}
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
diff -puN fs/ext4/super.c~ext3-ext4-orphan-list-check-on-destroy_inode fs/ext4/super.c
--- a/fs/ext4/super.c~ext3-ext4-orphan-list-check-on-destroy_inode
+++ a/fs/ext4/super.c
@@ -510,6 +510,14 @@ static struct inode *ext4_alloc_inode(st
 
 static void ext4_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+		printk("EXT4 Inode %p: orphan list check failed!\n",
+			EXT4_I(inode));
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 16, 4,
+				EXT4_I(inode), sizeof(struct ext4_inode_info),
+				true);
+		dump_stack();
+	}
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
