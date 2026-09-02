Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87565416CFA;
	Wed,  2 Sep 2026 21:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788385955; cv=none; b=LnDOo0MUf2wH9Uv90Eb0MpT8fXEEUv0/1GNWgVk+XFJWDbb0n1GxPNqKjdLm6CkOmKJn8QrvK0L/Aq5ozrw7Iid8ynvGhWC1AIN+lQM97vxxpH1n41x6zzY0Pwk9M03Mti35zFunTpDhEuLQ30vqDZcwq5tuekmoAsNZ6ejevdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788385955; c=relaxed/simple;
	bh=znPBXvsOLxULY1B/j5jqI+7hnMcaeVYEJ512f7XqRHA=;
	h=Date:To:From:Subject:Message-Id; b=iqxeJgJnlLcWGR6BlrMLsvwatPrlYZHRv2pPHWB2wQ+RRtmKXaRb5STlI4r6FVkSv3TwWfEWCFUOpoj6xovctxODXPLt6iyGPfxKtThFwc5txIUCocnIqA9G8wGczT4/CPl6QNuKS443p6NzE+PWTw7zFuJFo4U/CBgtQINH/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YlOZpQDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YlOZpQDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678551F000E9;
	Wed,  2 Sep 2026 21:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788385947;
	bh=3pvqbuW3FvISi2MN7+lFjJL28D368u8EdmQgmeN/q9M=;
	h=Date:To:From:Subject;
	b=YlOZpQDqDpGqjhME46YjNXsa6e0b/6DPv6IKMnrT707EUqk7kDpnxpTg0nRYu0hjo
	 fT6NCnm+qJ7OEDstNEs8D//x5fwihleeAoSaKv+81D+Q+SsNx6klHqUxRB5oq2cp2O
	 gjA0C9iLB5hufH36QBbKVavPVfDFTigg5lnF1wyw=
Date: Wed, 02 Sep 2026 14:52:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,vannapurve@google.com,surenb@google.com,stable@vger.kernel.org,si.yanteng@linux.dev,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,mawupeng1@huawei.com,louhongxiang@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jthoughton@google.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,fvdl@google.com,dzm91@hust.edu.cn,david@kernel.org,corbet@lwn.net,alexs@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-return-enospc-on-memcg-charge-failure.patch added to mm-new branch
Message-Id: <20260902215227.678551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: return -ENOSPC on memcg charge failure
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-return-enospc-on-memcg-charge-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-return-enospc-on-memcg-charge-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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

mm-hugetlb-return-enospc-on-memcg-charge-failure.patch
mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

