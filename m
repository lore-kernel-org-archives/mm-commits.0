From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-use-nilfs_warning-in-allocator-implementation.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:58 -0800
Message-ID: <5640fe4a.wYRngiODSH4LtsyA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use nilfs_warning() in allocator implementation
has been removed from the -mm tree.  Its filename was
     nilfs2-use-nilfs_warning-in-allocator-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use nilfs_warning() in allocator implementation

This uses nilfs_warning() to replace "printk(KERN_WARNING ...);" in the
bitmap based allocator implementation of nilfs2.  The warning messages are
modified to include the device name and the inode number in each message. 
This makes it clear which metadata file of which device has output
warnings such as "entry number xxxx already freed".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-use-nilfs_warning-in-allocator-implementation fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-use-nilfs_warning-in-allocator-implementation
+++ a/fs/nilfs2/alloc.c
@@ -583,8 +583,10 @@ void nilfs_palloc_commit_free_entry(stru
 
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
+		nilfs_warning(inode->i_sb, __func__,
+			      "entry number %llu already freed: ino=%lu\n",
+			      (unsigned long long)req->pr_entry_nr,
+			      (unsigned long)inode->i_ino);
 	else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
@@ -620,8 +622,10 @@ void nilfs_palloc_abort_alloc_entry(stru
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap))
-		printk(KERN_WARNING "%s: entry number %llu already freed\n",
-		       __func__, (unsigned long long)req->pr_entry_nr);
+		nilfs_warning(inode->i_sb, __func__,
+			      "entry number %llu already freed: ino=%lu\n",
+			      (unsigned long long)req->pr_entry_nr,
+			      (unsigned long)inode->i_ino);
 	else
 		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
 
@@ -734,10 +738,10 @@ int nilfs_palloc_freev(struct inode *ino
 			if (!nilfs_clear_bit_atomic(
 				    nilfs_mdt_bgl_lock(inode, group),
 				    group_offset, bitmap)) {
-				printk(KERN_WARNING
-				       "%s: entry number %llu already freed\n",
-				       __func__,
-				       (unsigned long long)entry_nrs[j]);
+				nilfs_warning(inode->i_sb, __func__,
+					      "entry number %llu already freed: ino=%lu\n",
+					      (unsigned long long)entry_nrs[j],
+					      (unsigned long)inode->i_ino);
 			} else {
 				n++;
 			}
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


