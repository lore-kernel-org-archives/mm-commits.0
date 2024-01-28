Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A7D536
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430491; cv=none; b=Kj0R8F4p+TIsrR7R1fXnCepQQWzA45N3OOjathTVhUOLUG7zl+Wn7hKVH4JF5srAERkYFKbn5qIqQcTfEjZxYl0ta30chNEy6H5XViTK/YTgBXd1VACbCW1dOsoIQ87QI7cm8sjgX+mr0EZ7HgLEwDbdrlOtjHA3ELsiCbNwGE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430491; c=relaxed/simple;
	bh=PfsxHM2Fuyv0268gsEAgeVdyg4uZZZ5ZgUh0SE2UDuM=;
	h=Date:To:From:Subject:Message-Id; b=AJ3P3aen8stDcE9N97GF6pSCGWUgstVK5DkyQ0FvdUN60ilWendO8DoLQk4Yl4wYyySuXNwCKpe9X57Sy8mmat0RT5WurPjnxJXwgdALu31RM7/liKA1tswdzAaLrAxJQ3qWyl+/rx6TUbibrdgn6Sx5NML+9raOSJAn/hxei8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8kUBPx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8kUBPx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2ACC433C7;
	Sun, 28 Jan 2024 08:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430491;
	bh=PfsxHM2Fuyv0268gsEAgeVdyg4uZZZ5ZgUh0SE2UDuM=;
	h=Date:To:From:Subject:From;
	b=t8kUBPx57+x9HxUStLja4nlvbDMJt6ALgG4yo/7aICRHOMBRMclmHMGdLSPwlPDrM
	 Wi3Rq7nJu2BXpMuC107+xc7rt0DVtHGtuz8Swr8K1U+ZWg4uPeuoVhtF9ffA8rzjv4
	 P7Oz1kIj0jL74KGv/o5kFQ3TCWbCQJyvxUYj6Bdc=
Date: Sun, 28 Jan 2024 00:28:07 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch added to mm-unstable branch
Message-Id: <20240128082810.BB2ACC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: pass *next_nid_to_alloc directly to for_each_node_mask_to_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: pass *next_nid_to_alloc directly to for_each_node_mask_to_alloc
Date: Fri, 26 Jan 2024 23:24:08 +0800

With parallelization of hugetlb allocation across different threads, each
thread works on a differnet node to allocate pages from, instead of all
allocating from a common node h->next_nid_to_alloc.  To address this, it's
necessary to assign a separate next_nid_to_alloc for each thread.

Consequently, the hstate_next_node_to_alloc and
for_each_node_mask_to_alloc have been modified to directly accept a
*next_nid_to_alloc parameter, ensuring thread-specific allocation and
avoiding concurrent access issues.

Link: https://lkml.kernel.org/r/20240126152411.1238072-5-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc
+++ a/mm/hugetlb.c
@@ -1464,15 +1464,15 @@ static int get_valid_node_allowed(int ni
  * next node from which to allocate, handling wrap at end of node
  * mask.
  */
-static int hstate_next_node_to_alloc(struct hstate *h,
+static int hstate_next_node_to_alloc(int *next_node,
 					nodemask_t *nodes_allowed)
 {
 	int nid;
 
 	VM_BUG_ON(!nodes_allowed);
 
-	nid = get_valid_node_allowed(h->next_nid_to_alloc, nodes_allowed);
-	h->next_nid_to_alloc = next_node_allowed(nid, nodes_allowed);
+	nid = get_valid_node_allowed(*next_node, nodes_allowed);
+	*next_node = next_node_allowed(nid, nodes_allowed);
 
 	return nid;
 }
@@ -1495,10 +1495,10 @@ static int hstate_next_node_to_free(stru
 	return nid;
 }
 
-#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
+#define for_each_node_mask_to_alloc(next_node, nr_nodes, node, mask)		\
 	for (nr_nodes = nodes_weight(*mask);				\
 		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
+		((node = hstate_next_node_to_alloc(next_node, mask)) || 1);	\
 		nr_nodes--)
 
 #define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
@@ -2350,12 +2350,13 @@ static void prep_and_add_allocated_folio
  */
 static struct folio *alloc_pool_huge_folio(struct hstate *h,
 					nodemask_t *nodes_allowed,
-					nodemask_t *node_alloc_noretry)
+					nodemask_t *node_alloc_noretry,
+					int *next_node)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nr_nodes, node;
 
-	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
+	for_each_node_mask_to_alloc(next_node, nr_nodes, node, nodes_allowed) {
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
@@ -3310,7 +3311,7 @@ int __alloc_bootmem_huge_page(struct hst
 		goto found;
 	}
 	/* allocate from next node when distributing huge pages */
-	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
+	for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, &node_states[N_MEMORY]) {
 		m = memblock_alloc_try_nid_raw(
 				huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
@@ -3679,7 +3680,7 @@ static int adjust_pool_surplus(struct hs
 	VM_BUG_ON(delta != -1 && delta != 1);
 
 	if (delta < 0) {
-		for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
+		for_each_node_mask_to_alloc(&h->next_nid_to_alloc, nr_nodes, node, nodes_allowed) {
 			if (h->surplus_huge_pages_node[node])
 				goto found;
 		}
@@ -3794,7 +3795,8 @@ static int set_max_huge_pages(struct hst
 		cond_resched();
 
 		folio = alloc_pool_huge_folio(h, nodes_allowed,
-						node_alloc_noretry);
+						node_alloc_noretry,
+						&h->next_nid_to_alloc);
 		if (!folio) {
 			prep_and_add_allocated_folios(h, &page_list);
 			spin_lock_irq(&hugetlb_lock);
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

