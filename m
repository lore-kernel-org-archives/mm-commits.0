Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B138A733
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 23:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997068; cv=none; b=O8nbooW8jOjtsp63Wgk5kqUbIyOxva+z3lZuFf5vMinfux0fDGxOulxHC0K5lUlb7/QKIjucUYBdwPr8FCkvX068hP1M9Ijgbs1bmnMu+uEe2x0EdY/5ifr2YNXugRnqWYImK64f9pn2D3j87k3LlSWaVeYotxJbGS88zbHsyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997068; c=relaxed/simple;
	bh=UCaBHwpzqnKxGM3WnnDefSzlrzRMu0jOK3akNp4Q+6k=;
	h=Date:To:From:Subject:Message-Id; b=YypXEjdDM0Qsf8km2E7o9F29cabnVNq/OUjhdY3B1LUB1kIC1g+eJi7Y6yfFRGF5Al8u4Eod1AzE5oRzIcqF6sj8Ikn9/QYGi+7SGAs72f9I9pvH2vLAjWLBdBSoNqrpBbyowgkdc8G8X9St3vYVPIWiX8u4Jps/JMOP1K6OOSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XAk6oYou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XAk6oYou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21ED1F000FF;
	Wed,  9 Sep 2026 23:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997067;
	bh=/Rg+C2Kj5sk0PzC0mBZ8ws4nu4jub6krUUBLIO+B6eI=;
	h=Date:To:From:Subject;
	b=XAk6oYouxRyJzSafEvXD2R0ZINICvptymZybKZGYMYrzMt+a8tITULQ8wZx5Cy9fY
	 C6ObtHPVEBd47q3Q2f+FrAj+fRMr0ZjPqP96Wilvl1pVhTW1fsTDhj1h505rzHBeMu
	 mHseP1J08ucX4dfb6bbwPI7HptA8m7SrcMne76h8=
Date: Wed, 09 Sep 2026 16:37:46 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-return-enospc-on-memcg-charge-failure.patch removed from -mm tree
Message-Id: <20260909233746.E21ED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: return -ENOSPC on memcg charge failure
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-return-enospc-on-memcg-charge-failure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: return -ENOSPC on memcg charge failure
Date: Wed, 02 Sep 2026 01:22:56 -0700

Patch series "Fix bugs in HugeTLB allocation when
mem_cgroup_charge_hugetlb() fails".

In hugetlb_alloc_folio(), when mem_cgroup_charge_hugetlb() fails, there are
2 issues:

1. free_huge_folio() expects a non-refcounted folio and will
   VM_BUG_ON_FOLIO().

2. -ENOMEM is returned, causing an infinite loop retrying the fault.

This patch series is a subset of patches in [1].

Note: [1] was applied on an earlier version of HugeTLB allocation.  In
that earlier version, VMA reservations were not undone on
mem_cgroup_charge_hugetlb() failure.

5737df3826dee: ("mm: hugetlb: refactor out hugetlb_alloc_folio()") fixed
that, since returning an error from hugetlb_alloc_folio() causes
alloc_hugetlb_folio() to execute vma_end_reservation().

At the Link: there is a reproducer to trigger mem_cgroup_charge_hugetlb()
failure.


This patch (of 2):

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error.  This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer.  Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to an
infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error
handling path, the same handling used for
hugetlb_cgroup_uncharge_cgroup{,_rsvd}(), which also don't trigger the OOM
killer and hence opt to terminate the process with a SIGBUS.

Link: https://lore.kernel.org/20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com
Link: https://lore.kernel.org/20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-1-e3e8942c141b@google.com
Fixes: 991135774c0e ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-return-enospc-on-memcg-charge-failure
+++ a/mm/hugetlb.c
@@ -2851,7 +2851,6 @@ void wait_for_freed_hugetlb_folios(void)
  *
  * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
  *         -ENOSPC if cgroup charging fails or no folio is available.
- *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
 		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
@@ -2924,7 +2923,18 @@ struct folio *hugetlb_alloc_folio(struct
 		 * were committed to the folio and freeing the folio
 		 * would have cleared those up.
 		 */
-		return ERR_PTR(ret);
+		/*
+		 * Return -ENOSPC when this function fails to allocate
+		 * or charge a huge page. If a standard (PAGE_SIZE)
+		 * page allocation fails, the OOM killer is given a
+		 * chance to run, which may resolve the failure on
+		 * retry. However, for HugeTLB allocations, the OOM
+		 * killer is not triggered.  Returning -ENOMEM (or
+		 * anything resulting in VM_FAULT_OOM) would leak to
+		 * the #PF handler, causing it to loop indefinitely
+		 * retrying the fault.
+		 */
+		return ERR_PTR(-ENOSPC);
 	}
 
 	return folio;
_

Patches currently in -mm which might be from ackerleytng@google.com are

mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

