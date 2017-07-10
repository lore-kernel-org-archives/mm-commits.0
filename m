From: akpm@linux-foundation.org
Subject: [patch 041/115] mm, hugetlb, soft_offline: use
 new_page_nodemask for soft offline migration
Date: Mon, 10 Jul 2017 15:49:14 -0700
Message-ID: <20170710224914.9sjgqvkcq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbdGJWtZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb, soft_offline: use new_page_nodemask for soft offline migration

new_page is yet another duplication of the migration callback which has to
handle hugetlb migration specially.  We can safely use the generic
new_page_nodemask for the same purpose.

Please note that gigantic hugetlb pages do not need any special handling
because alloc_huge_page_nodemask will make sure to check pages in all per
node pools.  The reason this was done previously was that
alloc_huge_page_node treated NO_NUMA_NODE and a specific node differently
and so alloc_huge_page_node(nid) would check on this specific node.

Link: http://lkml.kernel.org/r/20170622193034.28972-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/memory-failure.c~mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration
+++ a/mm/memory-failure.c
@@ -1484,16 +1484,8 @@ EXPORT_SYMBOL(unpoison_memory);
 static struct page *new_page(struct page *p, unsigned long private, int **x)
 {
 	int nid = page_to_nid(p);
-	if (PageHuge(p)) {
-		struct hstate *hstate = page_hstate(compound_head(p));
 
-		if (hstate_is_gigantic(hstate))
-			return alloc_huge_page_node(hstate, NUMA_NO_NODE);
