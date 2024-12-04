Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3F8191F92
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349156; cv=none; b=Jx/14+Su+XgTNz2P7TSJq3Xnt0CcrMsN4LfQsJEKKqHwvQq23S1jFMuyIdDbhhkRCto1gex/ZQd6/glRRVU8Yi02x919YXMGY8p125Lg5DxN7ZkF0ZlcnJh8eFVANYJpouJ2/aTR08QEeyp/acIDZdIZBM5sfIfJzcqZuwY5yO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349156; c=relaxed/simple;
	bh=txExFiMwlQDZnu9zbVlWXDpJc8WmJ2TxitebTnwjdFE=;
	h=Date:To:From:Subject:Message-Id; b=Q4fo0LN9/dFhtHKGXg+Uv8/y0HPsdyPej4R6p6UkVjaaX2zEePABKXtkHuIv6RVyCb7Nxb1qLAJkbelZkfiJsl3gP/fXhsTanj2F+UNmMriU1+FAYTV1UTQUVtgPtGf1DW8vacYr0lU8bX0Z0kYod/2/MwcXnZ+TbpntbjvN3FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bl0BL4Ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bl0BL4Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B2DC4CECD;
	Wed,  4 Dec 2024 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733349156;
	bh=txExFiMwlQDZnu9zbVlWXDpJc8WmJ2TxitebTnwjdFE=;
	h=Date:To:From:Subject:From;
	b=Bl0BL4Efjfak4bDB7I7d4E/vfV5IdWjbxBBs/DG8c+bVIY0eA4zV0U2iA0ZmTWgux
	 cs4QMRydXl3xZOconM/ijabmrXAyeCVA62Y+jGifdbbcW0qKkBOJ3RiAg7yaZhVyyZ
	 ewGIkjbVSq8cZzs+pTV2R/ESJM+Ye+hlHgqPVZT4=
Date: Wed, 04 Dec 2024 13:52:35 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,muchun.song@linux.dev,david@redhat.com,aris@ruivo.org,aris@redhat.com,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-prioritize-surplus-allocation-from-current-node.patch added to mm-unstable branch
Message-Id: <20241204215236.17B2DC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: prioritize surplus allocation from current node
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-prioritize-surplus-allocation-from-current-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-prioritize-surplus-allocation-from-current-node.patch

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
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
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

hugetlb-prioritize-surplus-allocation-from-current-node.patch

