Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29DB79E5;
	Fri,  5 Jul 2024 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141593; cv=none; b=Yf2viFObsbs6hpv3B9FSK4OW3PqOPxJcpHusPEbmdDap5jFKXPurDXGQxSl+++u3L9WxpTrTqEsbIFLYfazSGcr8k/N6zvjXk6wF8v6UM9sFkWEFpMrcg8sjlKwTi6bdnP4SkgsSKbkZs76oj2txNQ5UTRvaTE3mhZLuE73bOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141593; c=relaxed/simple;
	bh=OdJ679Bx1sEPlfIJn+iB35/+gRosyYIvMAbXamA018U=;
	h=Date:To:From:Subject:Message-Id; b=t7TQj1uenCh5BlQm6m1SBdPDqAFfER1LZ+8/wS+MiHNOrs9GXzAIDkfuE8S8ri4DhWDWpXalp15Cr+SDz3JAyzJGUX1IAHF7bJdCwy901AEtp3VSje2f14GWaySJCbbON/ehrn94UkQYap0oLz196aNFS233LlKsl2vLaOEVYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S2iQea8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S2iQea8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBFFC3277B;
	Fri,  5 Jul 2024 01:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141592;
	bh=OdJ679Bx1sEPlfIJn+iB35/+gRosyYIvMAbXamA018U=;
	h=Date:To:From:Subject:From;
	b=S2iQea8qOO6W7dph4PmBAPZg/J0bpU0RlHBuY3rJ+AUn1iCjccoGeLAmjnHosfCTU
	 jKYLZ+INUym3uSYULQF/IXLCU/cGg0gZM/DEexBenIhm9tQZfaOYSBqMdba4z/+dXL
	 hPpvw4TtPk0soMEj3qk52R+PiDe+eGhtqHqWBaco=
Date: Thu, 04 Jul 2024 18:06:31 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,stable@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,aris@ruivo.org,aris@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch removed from -mm tree
Message-Id: <20240705010632.5EBFFC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
has been removed from the -mm tree.  Its filename was
     hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
Date: Fri, 21 Jun 2024 15:00:50 -0400

When trying to allocate a hugepage with no reserved ones free, it may be
allowed in case a number of overcommit hugepages was configured (using
/proc/sys/vm/nr_overcommit_hugepages) and that number wasn't reached. 
This allows for a behavior of having extra hugepages allocated
dynamically, if there're resources for it.  Some sysadmins even prefer not
reserving any hugepages and setting a big number of overcommit hugepages.

But while attempting to allocate overcommit hugepages in a multi node
system (either NUMA or mempolicy/cpuset) said allocations might randomly
fail even when there're resources available for the allocation.

This happens due to allowed_mems_nr() only accounting for the number of
free hugepages in the nodes the current process belongs to and the surplus
hugepage allocation is done so it can be allocated in any node.  In case
one or more of the requested surplus hugepages are allocated in a
different node, the whole allocation will fail due allowed_mems_nr()
returning a lower value.

So allocate surplus hugepages in one of the nodes the current process
belongs to.

Easy way to reproduce this issue is to use a 2+ NUMA nodes system:

	# echo 0 >/proc/sys/vm/nr_hugepages
	# echo 1 >/proc/sys/vm/nr_overcommit_hugepages
	# numactl -m0 ./tools/testing/selftests/mm/map_hugetlb 2

Repeating the execution of map_hugetlb test application will eventually
fail when the hugepage ends up allocated in a different node.

[aris@ruivo.org: v2]
  Link: https://lkml.kernel.org/r/20240701212343.GG844599@cathedrallabs.org
Link: https://lkml.kernel.org/r/20240621190050.mhxwb65zn37doegp@redhat.com
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

--- a/mm/hugetlb.c~hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes
+++ a/mm/hugetlb.c
@@ -2620,6 +2620,23 @@ struct folio *alloc_hugetlb_folio_nodema
 	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
 }
 
+static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
+{
+#ifdef CONFIG_NUMA
+	struct mempolicy *mpol = get_task_policy(current);
+
+	/*
+	 * Only enforce MPOL_BIND policy which overlaps with cpuset policy
+	 * (from policy_nodemask) specifically for hugetlb case
+	 */
+	if (mpol->mode == MPOL_BIND &&
+		(apply_policy_zone(mpol, gfp_zone(gfp)) &&
+		 cpuset_nodemask_valid_mems_allowed(&mpol->nodes)))
+		return &mpol->nodes;
+#endif
+	return NULL;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2633,6 +2650,8 @@ static int gather_surplus_pages(struct h
 	long i;
 	long needed, allocated;
 	bool alloc_ok = true;
+	int node;
+	nodemask_t *mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
 
 	lockdep_assert_held(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
@@ -2647,8 +2666,15 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-				NUMA_NO_NODE, NULL);
+		folio = NULL;
+		for_each_node_mask(node, cpuset_current_mems_allowed) {
+			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
+				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+						node, NULL);
+				if (folio)
+					break;
+			}
+		}
 		if (!folio) {
 			alloc_ok = false;
 			break;
@@ -4878,23 +4904,6 @@ static int __init default_hugepagesz_set
 }
 __setup("default_hugepagesz=", default_hugepagesz_setup);
 
-static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
-{
-#ifdef CONFIG_NUMA
-	struct mempolicy *mpol = get_task_policy(current);
-
-	/*
-	 * Only enforce MPOL_BIND policy which overlaps with cpuset policy
-	 * (from policy_nodemask) specifically for hugetlb case
-	 */
-	if (mpol->mode == MPOL_BIND &&
-		(apply_policy_zone(mpol, gfp_zone(gfp)) &&
-		 cpuset_nodemask_valid_mems_allowed(&mpol->nodes)))
-		return &mpol->nodes;
-#endif
-	return NULL;
-}
-
 static unsigned int allowed_mems_nr(struct hstate *h)
 {
 	int node;
_

Patches currently in -mm which might be from aris@redhat.com are


