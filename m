Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE812BE4D
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759097; cv=none; b=Dv9eaFQ1Qwckd1RWJmmkIpe8ohPATKiIMuvvAYtvfFuvzGI6sZCZKWL5Kdb7OQP5ZxkenQy6CoD1S3qTesRj1Zm7AJUJw07QJUg4BqGjtNYmcTO7U4A8ch7f+SqhG8edGq/HXB9ilt4DnGYPCkVq6tCzPPqZK5g65PYedPOr2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759097; c=relaxed/simple;
	bh=ZGxllzOL0/SDFAM4tgP7KvYi7zf97rPjZTCKMMmKlvo=;
	h=Date:To:From:Subject:Message-Id; b=t/dg38MTw9gIhLdbdfkx8i9BqZVs6lvqbYN1CzxSA7ex6ZoiOqv6AefipGXrm2x5RCrdsNPyRgnzNLFVI5KsCM0B99bYZ5skgONcayCTYcLN4JB2uIZ0smHJvnDu5YvcYTtFg/VWNdZeugrdD+BV/X667557t6xN1+ACqDSKvr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b+fOzknA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b+fOzknA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5945AC43390;
	Wed,  6 Mar 2024 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759096;
	bh=ZGxllzOL0/SDFAM4tgP7KvYi7zf97rPjZTCKMMmKlvo=;
	h=Date:To:From:Subject:From;
	b=b+fOzknAqNNaHt2eqOMBhHnLhI16k4X3izoaaOHwAykqJ/Ct5N/1s8MBHYgN+Pf9C
	 Q4CeX43tmaivJgr6Z8PQlUvKgbVF3o3nJjWQKzYe2HhUk1JrbxdlYIvUomsKIl2cGz
	 JpDfCGz4tILKIlLUlEp7wiX82ifGbO4/U5oYyAME=
Date: Wed, 06 Mar 2024 13:04:55 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch removed from -mm tree
Message-Id: <20240306210456.5945AC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: pass *next_nid_to_alloc directly to for_each_node_mask_to_alloc
has been removed from the -mm tree.  Its filename was
     hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: pass *next_nid_to_alloc directly to for_each_node_mask_to_alloc
Date: Thu, 22 Feb 2024 22:04:16 +0800

With parallelization of hugetlb allocation across different threads, each
thread works on a differnet node to allocate pages from, instead of all
allocating from a common node h->next_nid_to_alloc.  To address this, it's
necessary to assign a separate next_nid_to_alloc for each thread.

Consequently, the hstate_next_node_to_alloc and
for_each_node_mask_to_alloc have been modified to directly accept a
*next_nid_to_alloc parameter, ensuring thread-specific allocation and
avoiding concurrent access issues.

Link: https://lkml.kernel.org/r/20240222140422.393911-4-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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


