Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF87FEC4
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719017750; cv=none; b=nyx+uU/uKfW6UfaAtjojbNfNRADfXTXve7G5Qqaig8SKqAByQ/um6KnNPFVyZwcAHun6HxlushNsu6IuVEOYPDpftUIgkgqdSbLXKlZMJcFVKLgz3toWkqdtApuzTWoiWAtUgAWuBwK5lGcKyxgtstQC3cPs7gGUMSyNOtwnO8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719017750; c=relaxed/simple;
	bh=pnO5MMsNDgaQlZXgiquxeT3DGHAN71IR9i6aLW5GZN4=;
	h=Date:To:From:Subject:Message-Id; b=BHtoydraqGpoWgOW1sQH6fIvWSXG1md6l2rXQScVeifl7gGGwtpBjHIhWRPCO8jbBZ+SW2LGrg1CIqV7OJekQBAuIzzzJ9RYtw44Z8w0YXaXoDk5lVDOrcTjR/jx+tDTM51sTv+d/n1o59F9cT6DCeRFhmsl/SXjvINMzcNgrh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NLPkLokz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NLPkLokz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE1C2BBFC;
	Sat, 22 Jun 2024 00:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719017750;
	bh=pnO5MMsNDgaQlZXgiquxeT3DGHAN71IR9i6aLW5GZN4=;
	h=Date:To:From:Subject:From;
	b=NLPkLokzp8305oqXVCOxXlArTTF+vQeyPiezoBWAoMHQpOnlQ23xB+jqbeNONHh1u
	 IOBZg8Pue8KGh1U8SFURiv/meL94ykHcRNKbvNYG5FzybK5F3pwM01M/FbJtQa3xc5
	 0gL4Sz3w4Q7M6J6lQKQ2qQ06FK83TRbNnw2RUqGg=
Date: Fri, 21 Jun 2024 17:55:49 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,aris@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch added to mm-unstable branch
Message-Id: <20240622005550.0ADE1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

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
From: Aristeu Rozanski <aris@redhat.com>
Subject: hugetlb: force allocating surplus hugepages on mempolicy allowed nodes
Date: Fri, 21 Jun 2024 15:00:50 -0400

allowed_mems_nr() only accounts for the number of free hugepages in the
nodes the current process belongs to.  In case one or more of the
requested surplus hugepages are allocated in a different node, the whole
allocation will fail due allowed_mems_nr() returning a lower value.

So allocate surplus hugepages in one of the nodes the current process belongs to.

Easy way to reproduce this issue is to use a 2+ NUMA nodes system:

		# echo 0 >/proc/sys/vm/nr_hugepages
		# echo 1 >/proc/sys/vm/nr_overcommit_hugepages
		# numactl -m0 ./tools/testing/selftests/mm/map_hugetlb 2

will eventually fail when the hugepage ends up allocated in a different node.

Link: https://lkml.kernel.org/r/20240621190050.mhxwb65zn37doegp@redhat.com
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

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
@@ -2647,8 +2666,14 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-				NUMA_NO_NODE, NULL);
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
@@ -4878,23 +4903,6 @@ static int __init default_hugepagesz_set
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

hugetlb-force-allocating-surplus-hugepages-on-mempolicy-allowed-nodes.patch

