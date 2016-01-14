From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch removed from
 -mm tree
Date: Thu, 14 Jan 2016 14:21:34 -0800
Message-ID: <56981f6e.3pfLOH6GMSNRr8TR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbcANWVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch

This patch was dropped because it was folded into mm-zonelist-enumerate-zonelists-array-index.patch

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

mm-zonelist-enumerate-zonelists-array-index.patch
mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

