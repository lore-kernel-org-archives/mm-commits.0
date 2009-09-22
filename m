From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbfs_pagecache_present.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:07 -0700
Message-ID: <200909222043.n8MKh7mP010989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbZIVUnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: hugetlbfs_pagecache_present
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs_pagecache_present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlbfs_pagecache_present
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Rename hugetlbfs_backed() to hugetlbfs_pagecache_present()
and add more comments, as suggested by Mel Gorman.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbfs_pagecache_present mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs_pagecache_present
+++ a/mm/hugetlb.c
@@ -2016,8 +2016,11 @@ static struct page *hugetlbfs_pagecache_
 	return find_lock_page(mapping, idx);
 }
 
-/* Return whether there is a pagecache page to back given address within VMA */
-static bool hugetlbfs_backed(struct hstate *h,
+/*
+ * Return whether there is a pagecache page to back given address within VMA.
+ * Caller follow_hugetlb_page() holds page_table_lock so we cannot lock_page.
+ */
+static bool hugetlbfs_pagecache_present(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	struct address_space *mapping;
@@ -2254,10 +2257,13 @@ int follow_hugetlb_page(struct mm_struct
 
 		/*
 		 * When coredumping, it suits get_dump_page if we just return
-		 * an error if there's a hole and no huge pagecache to back it.
+		 * an error where there's an empty slot with no huge pagecache
+		 * to back it.  This way, we avoid allocating a hugepage, and
+		 * the sparse dumpfile avoids allocating disk blocks, but its
+		 * huge holes still show up with zeroes where they need to be.
 		 */
-		if (absent &&
-		    ((flags & FOLL_DUMP) && !hugetlbfs_backed(h, vma, vaddr))) {
+		if (absent && (flags & FOLL_DUMP) &&
+		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
 			remainder = 0;
 			break;
 		}
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

