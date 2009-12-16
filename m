From: akpm@linux-foundation.org
Subject: [merged] gru-initial-gru-based-on-blade-topology.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:09 -0800
Message-ID: <200912162040.nBGKe9Lu013587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965004AbZLPUkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: initial GRU based on blade topology
has been removed from the -mm tree.  Its filename was
     gru-initial-gru-based-on-blade-topology.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: initial GRU based on blade topology
From: Jack Steiner <steiner@sgi.com>

Change the GRU initialization code to initialize based on blade topology
instead of node topology.  The result is the same but blade-based
initialization is cleaner.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-initial-gru-based-on-blade-topology drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-initial-gru-based-on-blade-topology
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -264,11 +264,9 @@ static int gru_init_tables(unsigned long
 
 	max_user_cbrs = GRU_NUM_CB;
 	max_user_dsr_bytes = GRU_NUM_DSR_BYTES;
-	for_each_online_node(nid) {
-		bid = uv_node_to_blade_id(nid);
-		pnode = uv_node_to_pnode(nid);
-		if (bid < 0 || gru_base[bid])
-			continue;
+	for_each_possible_blade(bid) {
+		pnode = uv_blade_to_pnode(bid);
+		nid = uv_blade_to_memory_nid(bid);
 		page = alloc_pages_exact_node(nid, GFP_KERNEL, order);
 		if (!page)
 			goto fail;
@@ -298,8 +296,8 @@ static int gru_init_tables(unsigned long
 	return 0;
 
 fail:
-	for (nid--; nid >= 0; nid--)
-		free_pages((unsigned long)gru_base[nid], order);
+	for (bid--; bid >= 0; bid--)
+		free_pages((unsigned long)gru_base[bid], order);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

