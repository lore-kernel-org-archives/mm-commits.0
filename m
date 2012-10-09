From: akpm@linux-foundation.org
Subject: [merged] hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:01 -0700
Message-ID: <20121009181402.016DE200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33221 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab2JISOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:04 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so285733wib.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

0c176d5 ("mm: hugetlb: fix pgoff computation when unmapping page from
vma") fixed pgoff calculation but it has replaced it by
vma_hugecache_offset() which is not approapriate for offsets used for
vma_prio_tree_foreach() because that one expects index in page units
rather than in huge_page_shift.

Johannes said:

: The resulting index may not be too big, but it can be too small: assume
: hpage size of 2M and the address to unmap to be 0x200000.  This is regular
: page index 512 and hpage index 1.  If you have a VMA that maps the file
: only starting at the second huge page, that VMAs vm_pgoff will be 512 but
: you ask for offset 1 and miss it even though it does map the page of
: interest.  hugetlb_cow() will try to unmap, miss the vma, and retry the
: cow until the allocation succeeds or the skipped vma(s) go away.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach
+++ a/mm/hugetlb.c
@@ -2480,7 +2480,8 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = vma_hugecache_offset(h, vma, address);
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
 	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-memblock-reduce-overhead-in-binary-search.patch

