From: akpm@linux-foundation.org
Subject: + mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
 added to -mm tree
Date: Tue, 01 Dec 2015 15:13:25 -0800
Message-ID: <565e2995.Aa+8g21diJmH78SZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbbLAXN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix

- remove 'j'


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -4148,7 +4148,7 @@ static void set_zonelist_order(void)
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int i, j, node, load;
+	int i, node, load;
 	nodemask_t used_mask;
 	int local_node, prev_node;
 	struct zonelist *zonelist;
@@ -4168,7 +4168,7 @@ static void build_zonelists(pg_data_t *p
 	nodes_clear(used_mask);
 
 	memset(node_order, 0, sizeof(node_order));
-	j = 0;
+	i = 0;
 
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
 		/*
@@ -4185,12 +4185,12 @@ static void build_zonelists(pg_data_t *p
 		if (order == ZONELIST_ORDER_NODE)
 			build_zonelists_in_node_order(pgdat, node);
 		else
-			node_order[j++] = node;	/* remember order */
+			node_order[i++] = node;	/* remember order */
 	}
 
 	if (order == ZONELIST_ORDER_ZONE) {
 		/* calculate node order -- i.e., DMA last! */
-		build_zonelists_in_zone_order(pgdat, j);
+		build_zonelists_in_zone_order(pgdat, i);
 	}
 
 	build_thisnode_zonelists(pgdat);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch
mm-hugetlb-call-huge_pte_alloc-only-if-ptep-is-null.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

