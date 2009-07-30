From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-fix-i_blocks-accounting.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:35:15 -0700
Message-ID: <200907302035.n6UKZFQV007760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbZG3UlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@sandeen.net, andi@firstfloor.org, sandeen@redhat.com, stable@kernel.org, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: fix i_blocks accounting
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-i_blocks-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: fix i_blocks accounting
From: Eric Sandeen <sandeen@sandeen.net>

As reported in Red Hat bz #509671, i_blocks for files on hugetlbfs get
accounting wrong when doing something like:

   $ > foo
   $ date  > foo
   date: write error: Invalid argument
   $ /usr/bin/stat foo
     File: `foo'
     Size: 0          Blocks: 18446744073709547520 IO Block: 2097152 regular
...

This is because hugetlb_unreserve_pages() is unconditionally removing
blocks_per_huge_page(h) on each call rather than using the freed amount. 
If there were 0 blocks, it goes negative, resulting in the above.

This is a regression from commit a5516438959d90b071ff0a484ce4f3f523dc3152
("hugetlb: modular state for hugetlb page size")

which did:

-	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
+	inode->i_blocks -= blocks_per_huge_page(h);

so just put back the freed multiplier, and it's all happy again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Andi Kleen <andi@firstfloor.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlbfs-fix-i_blocks-accounting mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-fix-i_blocks-accounting
+++ a/mm/hugetlb.c
@@ -2370,7 +2370,7 @@ void hugetlb_unreserve_pages(struct inod
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
 
 	spin_lock(&inode->i_lock);
-	inode->i_blocks -= blocks_per_huge_page(h);
+	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));
_

Patches currently in -mm which might be from sandeen@sandeen.net are

origin.patch
linux-next.patch

