From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 121/155] mm: vmscan: replace open codings to
 NUMA_NO_NODE
Date: Wed, 01 Apr 2020 21:10:05 -0700
Message-ID: <20200402041005.F9e1YW8Vu%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:07 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.shi@linux.alibaba.com

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
