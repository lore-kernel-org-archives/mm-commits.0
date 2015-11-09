From: akpm@linux-foundation.org
Subject: [merged] nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:04 -0800
Message-ID: <5640fe50.i578HO3zTGdgjYb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: get rid of nilfs_palloc_group_is_in()
has been removed from the -mm tree.  Its filename was
     nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: get rid of nilfs_palloc_group_is_in()

This unfolds nilfs_palloc_group_is_in() helper function into
nilfs_palloc_freev() function to simplify a range check and an index
calculation repeatedy performed in a loop of the function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-get-rid-of-nilfs_palloc_group_is_in fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-get-rid-of-nilfs_palloc_group_is_in
+++ a/fs/nilfs2/alloc.c
@@ -673,22 +673,6 @@ void nilfs_palloc_abort_free_entry(struc
 }
 
 /**
- * nilfs_palloc_group_is_in - judge if an entry is in a group
- * @inode: inode of metadata file using this allocator
- * @group: group number
- * @nr: serial number of the entry (e.g. inode number)
- */
-static int
-nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
-{
-	__u64 first, last;
-
-	first = group * nilfs_palloc_entries_per_group(inode);
-	last = first + nilfs_palloc_entries_per_group(inode) - 1;
-	return (nr >= first) && (nr <= last);
-}
-
-/**
  * nilfs_palloc_freev - deallocate a set of persistent objects
  * @inode: inode of metadata file using this allocator
  * @entry_nrs: array of entry numbers to be deallocated
@@ -701,6 +685,8 @@ int nilfs_palloc_freev(struct inode *ino
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, group_offset;
+	__u64 group_min_nr;
+	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
 	spinlock_t *lock;
 	int i, j, n, ret;
 
@@ -715,6 +701,10 @@ int nilfs_palloc_freev(struct inode *ino
 			brelse(desc_bh);
 			return ret;
 		}
+
+		/* Get the first entry number of the group */
+		group_min_nr = (__u64)group * epg;
+
 		desc_kaddr = kmap(desc_bh->b_page);
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
@@ -722,10 +712,10 @@ int nilfs_palloc_freev(struct inode *ino
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
 		for (j = i, n = 0;
-		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
-							      entry_nrs[j]);
+		     j < nitems && entry_nrs[j] >= group_min_nr &&
+			     entry_nrs[j] < group_min_nr + epg;
 		     j++) {
-			nilfs_palloc_group(inode, entry_nrs[j], &group_offset);
+			group_offset = entry_nrs[j] - group_min_nr;
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


