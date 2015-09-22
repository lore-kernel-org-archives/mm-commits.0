From: akpm@linux-foundation.org
Subject: + nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch added to -mm
 tree
Date: Tue, 22 Sep 2015 13:25:16 -0700
Message-ID: <5601b92c.ApwaJ2TweyfFqp7C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934337AbbIVUZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 16:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: get rid of nilfs_palloc_group_is_in()
has been added to the -mm tree.  Its filename is
     nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch

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

nilfs2-use-nilfs_warning-in-allocator-implementation.patch
nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
nilfs2-refactor-nilfs_palloc_find_available_slot.patch
nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch
nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch

