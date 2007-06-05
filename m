From: akpm@linux-foundation.org
Subject: + ext3-ext4-orphan-list-check-on-destroy_inode.patch added to -mm tree
Date: Tue, 05 Jun 2007 10:53:20 -0700
Message-ID: <200706051753.l55HrKIx031952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbXFERyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 13:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru


The patch titled
     ext3/ext4: orphan list check on destroy_inode
has been added to the -mm tree.  Its filename is
     ext3-ext4-orphan-list-check-on-destroy_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3/ext4: orphan list check on destroy_inode
From: Vasily Averin <vvs@sw.ru>

Customers claims to ext3-related errors, investigation showed that ext3
orphan list has been corrupted and have the reference to non-ext3 inode. 
The following debug helps to understand the reasons of this issue.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    7 +++++++
 fs/ext4/super.c |    7 +++++++
 2 files changed, 14 insertions(+)

diff -puN fs/ext3/super.c~ext3-ext4-orphan-list-check-on-destroy_inode fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-ext4-orphan-list-check-on-destroy_inode
+++ a/fs/ext3/super.c
@@ -459,6 +459,13 @@ static struct inode *ext3_alloc_inode(st
 
 static void ext3_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
+		printk("EXT3 Inode %p: orphan list check failed!\n",
+			EXT3_I(inode));
+		print_hex_dump(KERN_INFO, DUMP_PREFIX_ADDRESS,
+				EXT3_I(inode), sizeof(struct ext3_inode_info));
+		dump_stack();
+	}
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
diff -puN fs/ext4/super.c~ext3-ext4-orphan-list-check-on-destroy_inode fs/ext4/super.c
--- a/fs/ext4/super.c~ext3-ext4-orphan-list-check-on-destroy_inode
+++ a/fs/ext4/super.c
@@ -510,6 +510,13 @@ static struct inode *ext4_alloc_inode(st
 
 static void ext4_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+		printk("EXT4 Inode %p: orphan list check failed!\n",
+			EXT4_I(inode));
+		print_hex_dump(KERN_INFO, DUMP_PREFIX_ADDRESS,
+				EXT4_I(inode), sizeof(struct ext4_inode_info));
+		dump_stack();
+	}
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
_

Patches currently in -mm which might be from vvs@sw.ru are

wrong-timeout-value-in-sk_wait_data-v2-fix.patch
ext3-lost-brelse-in-ext3_read_inode.patch
ext4-lost-brelse-in-ext4_read_inode.patch
ext3-ext4-orphan-list-check-on-destroy_inode.patch
ext3-ext4-orphan-list-corruption-due-bad-inode.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
