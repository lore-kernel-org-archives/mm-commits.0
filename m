From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-replace-open-codings-to-numa_no_node.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 21:16:48 -0800
Message-ID: <20200214051648.aFv7bnp3S%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgBNFQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:16:49 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, minchan@kernel.org, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmscan: replace open codings to NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     mm-vmscan-replace-open-codings-to-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-replace-open-codings-to-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-replace-open-codings-to-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmscan: replace open codings to NUMA_NO_NODE

The commit 98fa15f34cb3 ("mm: replace all open encodings for
NUMA_NO_NODE") did the replacement across the kernel tree, but we got
some more in vmscan.c since then.

Link: http://lkml.kernel.org/r/1581568298-45317-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
mm-vmpressure-use-mem_cgroup_is_root-api.patch
mm-vmscan-replace-open-codings-to-numa_no_node.patch
mm-migratec-migrate-pg_readahead-flag.patch
