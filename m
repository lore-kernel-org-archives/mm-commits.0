From: akpm@linux-foundation.org
Subject: [merged] mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:15 -0700
Message-ID: <20121009181416.9F44F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33158 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab2JISOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:19 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365351wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, cl@linux.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, segooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: revert 0def08e3 ("mm/mempolicy.c: check return code of check_range")
has been removed from the -mm tree.  Its filename was
     mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: revert 0def08e3 ("mm/mempolicy.c: check return code of check_range")

Revert 0def08e3 because check_range can't fail in migrate_to_node with
considering current usecases.

Quote from Johannes

: I think it makes sense to revert.  Not because of the semantics, but I
: just don't see how check_range() could even fail for this callsite:
: 
: 1. we pass mm->mmap->vm_start in there, so we should not fail due to
:    find_vma()
: 
: 2. we pass MPOL_MF_DISCONTIG_OK, so the discontig checks do not apply
:    and so can not fail
: 
: 3. we pass MPOL_MF_MOVE | MPOL_MF_MOVE_ALL, the page table loops will
:    continue until addr == end, so we never fail with -EIO


And I added a new VM_BUG_ON for checking migrate_to_node's future usecase
which might pass to MPOL_MF_STRICT.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range mm/mempolicy.c
--- a/mm/mempolicy.c~mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range
+++ a/mm/mempolicy.c
@@ -946,15 +946,18 @@ static int migrate_to_node(struct mm_str
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
-	struct vm_area_struct *vma;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	/*
+	 * This does not "check" the range but isolates all pages that
+	 * need migration.  Between passing in the full user address
+	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
+	 */
+	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
+	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

