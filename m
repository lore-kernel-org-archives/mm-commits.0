From: akpm@linux-foundation.org
Subject: - hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:57 -0700
Message-ID: <200710162035.l9GKZvUx015097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965970AbXJPVoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, agl@us.ibm.com, david@gibson.dropbear.id.au, nacc@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: allow extending ftruncate on hugetlbfs
has been removed from the -mm tree.  Its filename was
     hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: allow extending ftruncate on hugetlbfs
From: "Ken Chen" <kenchen@google.com>

For historical reason, expanding ftruncate that increases file size on
hugetlbfs is not allowed due to pages were pre-faulted and lack of fault
handler.  Now that we have demand faulting on hugetlb since 2.6.15, there
is no reason to hold back that limitation.

This will make hugetlbfs behave more like a normal fs.  I'm writing a user
level code that uses hugetlbfs but will fall back to tmpfs if there are no
hugetlb page available in the system.  Having hugetlbfs specific ftruncate
behavior is a bit quirky and I would like to remove that artificial
limitation.

Signed-off-by: <kenchen@google.com>
Acked-by: Wiliam Irwin <wli@holomorphy.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-allow-extending-ftruncate-on-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-allow-extending-ftruncate-on-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -322,21 +322,15 @@ hugetlb_vmtruncate_list(struct prio_tree
 	}
 }
 
-/*
- * Expanding truncates are not allowed.
- */
 static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 {
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
 
-	if (offset > inode->i_size)
-		return -EINVAL;
-
 	BUG_ON(offset & ~HPAGE_MASK);
 	pgoff = offset >> PAGE_SHIFT;
 
-	inode->i_size = offset;
+	i_size_write(inode, offset);
 	spin_lock(&mapping->i_mmap_lock);
 	if (!prio_tree_empty(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
