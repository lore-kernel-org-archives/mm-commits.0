From: akpm@linux-foundation.org
Subject: + nilfs2-use-nilfs_warning-in-allocator-implementation.patch
 added to -mm tree
Date: Tue, 22 Sep 2015 13:25:10 -0700
Message-ID: <5601b926.tdXZtsetDW7bsuFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934337AbbIVUZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 16:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use nilfs_warning() in allocator implementation
has been added to the -mm tree.  Its filename is
     nilfs2-use-nilfs_warning-in-allocator-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-nilfs_warning-in-allocator-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-nilfs_warning-in-allocator-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-use-nilfs_warning-in-allocator-implementation.patch
nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
nilfs2-refactor-nilfs_palloc_find_available_slot.patch
nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch
nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch

