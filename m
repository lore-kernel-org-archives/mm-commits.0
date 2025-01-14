Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A0D23C6EE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836994; cv=none; b=nyF4LlZIMO/t7F1O0onkpU2bfSievqqO66YXzTBpZ/2SarjhLkLw0irEHWBmtOYy6gsjUmgAufiBS38xKsuXB9urIE2UYAckLgTanT5/aBoHZnqid9vA81GsjNCqDo2629baOC5PAyRZAugqvUVIddUa3WAdc82ri3UplZ/eJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836994; c=relaxed/simple;
	bh=TNedEMeFwa9yCSfB8n7LoeotssBtn4K2dIIXIbgSa0U=;
	h=Date:To:From:Subject:Message-Id; b=Qj4JENFnXjcRGAHrurOpVLxYMAil1vVq8r0mFDuTDs2M1eJFv8qnPCJaojyDaeqip7c9mHr0np4ddC4BVAPBTEorNI6OhVSSBJYYSzQHnSwnqhZdvlI2H+qx9WOEawhtYCaseGDmkiGOzxrq1CDQEHADBp6+saQu7CqLpKReEqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAqY48lW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAqY48lW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8735C4CEDD;
	Tue, 14 Jan 2025 06:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836993;
	bh=TNedEMeFwa9yCSfB8n7LoeotssBtn4K2dIIXIbgSa0U=;
	h=Date:To:From:Subject:From;
	b=HAqY48lW7P9X66pU0Vx2i6J4qQiFGdxJD0pZzJAOoW5yiMusjC3zuLWmRN+uChFnX
	 3nohYDpQlPEt3VJW5UgEL2fx3p8aPiqR/55K/fEK2NBgRCP3LiMnA8cW0B/db9q8Be
	 F5f7K3Ibw+BOakm2E+TmNsBYW7yS371vcAjIXuh8=
Date: Mon, 13 Jan 2025 22:43:13 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,muchun.song@linux.dev,david@redhat.com,aris@ruivo.org,aris@redhat.com,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-prioritize-surplus-allocation-from-current-node.patch removed from -mm tree
Message-Id: <20250114064313.A8735C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: prioritize surplus allocation from current node
has been removed from the -mm tree.  Its filename was
     hugetlb-prioritize-surplus-allocation-from-current-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Koichiro Den <koichiro.den@canonical.com>
Subject: hugetlb: prioritize surplus allocation from current node
Date: Thu, 5 Dec 2024 01:55:03 +0900

Previously, surplus allocations triggered by mmap were typically made from
the node where the process was running.  On a page fault, the area was
reliably dequeued from the hugepage_freelists for that node.  However,
since commit 003af997c8a9 ("hugetlb: force allocating surplus hugepages on
mempolicy allowed nodes"), dequeue_hugetlb_folio_vma() may fall back to
other nodes unnecessarily even if there is no MPOL_BIND policy, causing
folios to be dequeued from nodes other than the current one.

Also, allocating from the node where the current process is running is
likely to result in a performance win, as mmap-ing processes often touch
the area not so long after allocation.  This change minimizes surprises
for users relying on the previous behavior while maintaining the benefit
introduced by the commit.

So, prioritize the node the current process is running on when possible.

Link: https://lkml.kernel.org/r/20241204165503.628784-1-koichiro.den@canonical.com
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Acked-by: Aristeu Rozanski <aris@ruivo.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-prioritize-surplus-allocation-from-current-node
+++ a/mm/hugetlb.c
@@ -2463,7 +2463,13 @@ static int gather_surplus_pages(struct h
 	long needed, allocated;
 	bool alloc_ok = true;
 	int node;
-	nodemask_t *mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
+	nodemask_t *mbind_nodemask, alloc_nodemask;
+
+	mbind_nodemask = policy_mbind_nodemask(htlb_alloc_mask(h));
+	if (mbind_nodemask)
+		nodes_and(alloc_nodemask, *mbind_nodemask, cpuset_current_mems_allowed);
+	else
+		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
@@ -2479,8 +2485,16 @@ retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		folio = NULL;
-		for_each_node_mask(node, cpuset_current_mems_allowed) {
-			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
+
+		/* Prioritize current node */
+		if (node_isset(numa_mem_id(), alloc_nodemask))
+			folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+					numa_mem_id(), NULL);
+
+		if (!folio) {
+			for_each_node_mask(node, alloc_nodemask) {
+				if (node == numa_mem_id())
+					continue;
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
 						node, NULL);
 				if (folio)
_

Patches currently in -mm which might be from koichiro.den@canonical.com are


