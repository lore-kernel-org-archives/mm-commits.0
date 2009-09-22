From: akpm@linux-foundation.org
Subject: [merged] mm-fix-anonymous-dirtying.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:55 -0700
Message-ID: <200909222042.n8MKgtu4010592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZIVUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, stable@kernel.org


The patch titled
     mm: fix anonymous dirtying
has been removed from the -mm tree.  Its filename was
     mm-fix-anonymous-dirtying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix anonymous dirtying
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

do_anonymous_page() has been wrong to dirty the pte regardless.
If it's not going to mark the pte writable, then it won't help
to mark it dirty here, and clogs up memory with pages which will
need swap instead of being thrown away.  Especially wrong if no
overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
we could exceed the limit and OOM despite no overcommit.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-fix-anonymous-dirtying mm/memory.c
--- a/mm/memory.c~mm-fix-anonymous-dirtying
+++ a/mm/memory.c
@@ -2653,7 +2653,8 @@ static int do_anonymous_page(struct mm_s
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (vma->vm_flags & VM_WRITE)
+		entry = pte_mkwrite(pte_mkdirty(entry));
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!pte_none(*page_table))
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

