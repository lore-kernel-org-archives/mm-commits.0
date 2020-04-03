From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-replace-open-codings-to-numa_no_node.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:39:48 -0700
Message-ID: <20200403203948.zm8n-uZE1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUjs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, minchan@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmscan: replace open codings to NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     mm-vmscan-replace-open-codings-to-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmscan: replace open codings to NUMA_NO_NODE

The commit 98fa15f34cb3 ("mm: replace all open encodings for
NUMA_NO_NODE") did the replacement across the kernel tree, but we got
some more in vmscan.c since then.

Link: http://lkml.kernel.org/r/1581568298-45317-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-replace-open-codings-to-numa_no_node
+++ a/mm/vmscan.c
@@ -2096,7 +2096,7 @@ static void shrink_active_list(unsigned
 
 unsigned long reclaim_pages(struct list_head *page_list)
 {
-	int nid = -1;
+	int nid = NUMA_NO_NODE;
 	unsigned long nr_reclaimed = 0;
 	LIST_HEAD(node_page_list);
 	struct reclaim_stat dummy_stat;
@@ -2111,7 +2111,7 @@ unsigned long reclaim_pages(struct list_
 
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
-		if (nid == -1) {
+		if (nid == NUMA_NO_NODE) {
 			nid = page_to_nid(page);
 			INIT_LIST_HEAD(&node_page_list);
 		}
@@ -2132,7 +2132,7 @@ unsigned long reclaim_pages(struct list_
 			putback_lru_page(page);
 		}
 
-		nid = -1;
+		nid = NUMA_NO_NODE;
 	}
 
 	if (!list_empty(&node_page_list)) {
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-migratec-migrate-pg_readahead-flag.patch
