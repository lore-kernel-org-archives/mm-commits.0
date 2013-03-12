From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-make-hugetlb_register_node-static.patch removed from -mm tree
Date: Tue, 12 Mar 2013 12:10:01 -0700
Message-ID: <20130312191001.7128631C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53680 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab3CLTKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 15:10:02 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so14766vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 12:10:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: claudiughioc@gmail.com, claudiu.ghioc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make hugetlb_[un]register_node() static
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-make-hugetlb_register_node-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Claudiu Ghioc <claudiughioc@gmail.com>
Subject: mm/hugetlb.c: make hugetlb_[un]register_node() static

Fixes sparse warnings:

mm/hugetlb.c:1764:6: warning: symbol 'hugetlb_unregister_node' was not declared. Should it be static?

mm/hugetlb.c:1808:6: warning: symbol 'hugetlb_register_node' was not declared. Should it be static?

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-make-hugetlb_register_node-static mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-make-hugetlb_register_node-static
+++ a/mm/hugetlb.c
@@ -1761,7 +1761,7 @@ static struct hstate *kobj_to_node_hstat
  * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
-void hugetlb_unregister_node(struct node *node)
+static void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
@@ -1805,7 +1805,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+static void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
_

Patches currently in -mm which might be from claudiughioc@gmail.com are

linux-next.patch

