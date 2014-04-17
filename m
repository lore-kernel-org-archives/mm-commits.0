From: akpm@linux-foundation.org
Subject: + hugetlb-move-helpers-up-in-the-file.patch added to -mm tree
Date: Thu, 17 Apr 2014 16:01:26 -0700
Message-ID: <53505d46.RmYaNJo+uV4Nqlcx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaDQXB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 19:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidlohr@hp.com, aarcange@redhat.com, lcapitulino@redhat.com

Subject: + hugetlb-move-helpers-up-in-the-file.patch added to -mm tree
To: lcapitulino@redhat.com,aarcange@redhat.com,davidlohr@hp.com,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 16:01:26 -0700


The patch titled
     Subject: hugetlb: move helpers up in the file
has been added to the -mm tree.  Its filename is
     hugetlb-move-helpers-up-in-the-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-move-helpers-up-in-the-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-move-helpers-up-in-the-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: move helpers up in the file

Next commit will add new code which will want to call
for_each_node_mask_to_alloc() macro.  Move it, its buddy
for_each_node_mask_to_free() and their dependencies up in the file so the
new code can use them.  This is just code movement, no logic change.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  146 ++++++++++++++++++++++++-------------------------
 1 file changed, 73 insertions(+), 73 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-move-helpers-up-in-the-file mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-helpers-up-in-the-file
+++ a/mm/hugetlb.c
@@ -608,6 +608,79 @@ err:
 	return NULL;
 }
 
+/*
+ * common helper functions for hstate_next_node_to_{alloc|free}.
+ * We may have allocated or freed a huge page based on a different
+ * nodes_allowed previously, so h->next_node_to_{alloc|free} might
+ * be outside of *nodes_allowed.  Ensure that we use an allowed
+ * node for alloc or free.
+ */
+static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	nid = next_node(nid, *nodes_allowed);
+	if (nid == MAX_NUMNODES)
+		nid = first_node(*nodes_allowed);
+	VM_BUG_ON(nid >= MAX_NUMNODES);
+
+	return nid;
+}
+
+static int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	if (!node_isset(nid, *nodes_allowed))
+		nid = next_node_allowed(nid, nodes_allowed);
+	return nid;
+}
+
+/*
+ * returns the previously saved node ["this node"] from which to
+ * allocate a persistent huge page for the pool and advance the
+ * next node from which to allocate, handling wrap at end of node
+ * mask.
+ */
+static int hstate_next_node_to_alloc(struct hstate *h,
+					nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(h->next_nid_to_alloc, nodes_allowed);
+	h->next_nid_to_alloc = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+/*
+ * helper for free_pool_huge_page() - return the previously saved
+ * node ["this node"] from which to free a huge page.  Advance the
+ * next node id whether or not we find a free huge page to free so
+ * that the next attempt to free addresses the next node.
+ */
+static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
+	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
+		nr_nodes--)
+
+#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
+		nr_nodes--)
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
@@ -787,79 +860,6 @@ static struct page *alloc_fresh_huge_pag
 	return page;
 }
 
-/*
- * common helper functions for hstate_next_node_to_{alloc|free}.
- * We may have allocated or freed a huge page based on a different
- * nodes_allowed previously, so h->next_node_to_{alloc|free} might
- * be outside of *nodes_allowed.  Ensure that we use an allowed
- * node for alloc or free.
- */
-static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	nid = next_node(nid, *nodes_allowed);
-	if (nid == MAX_NUMNODES)
-		nid = first_node(*nodes_allowed);
-	VM_BUG_ON(nid >= MAX_NUMNODES);
-
-	return nid;
-}
-
-static int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	if (!node_isset(nid, *nodes_allowed))
-		nid = next_node_allowed(nid, nodes_allowed);
-	return nid;
-}
-
-/*
- * returns the previously saved node ["this node"] from which to
- * allocate a persistent huge page for the pool and advance the
- * next node from which to allocate, handling wrap at end of node
- * mask.
- */
-static int hstate_next_node_to_alloc(struct hstate *h,
-					nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(h->next_nid_to_alloc, nodes_allowed);
-	h->next_nid_to_alloc = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-/*
- * helper for free_pool_huge_page() - return the previously saved
- * node ["this node"] from which to free a huge page.  Advance the
- * next node id whether or not we find a free huge page to free so
- * that the next attempt to free addresses the next node.
- */
-static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
-	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
-		nr_nodes--)
-
-#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
-		nr_nodes--)
