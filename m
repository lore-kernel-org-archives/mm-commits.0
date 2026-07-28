Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182301DF74F;
	Tue, 28 Jul 2026 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200012; cv=none; b=kxy4j53HlDzNzxj5aZBfr1RDkj5aodmEFc1KqWzLqr9NOC3Qvs/JNuNYbDD49ZxcPri3cINMJo99oEiJD4MJNWJbImMiJw9Awq0bKc1EQt0F5r7zSGWxP2kLqT5rwPjQ+YQLR6Q5ls248k6MPW5S8ZLcwGFB0puIiyh1Aa5su9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200012; c=relaxed/simple;
	bh=Hj79tQc6y1YTBCRFvNtnJpmTatDliqU0CyLVPju/bhU=;
	h=Date:To:From:Subject:Message-Id; b=ZnzusmVQNbGNB4nkQ8JY2FuM+cQVT7ifcGYhXMO6khCvJ59+cf2StAXo+2d6LIjGf6nfZ/OqzqDfi4oBMH/zbqffJ1IfrmKUPcowgfR1lXB4pOcyX5WuZXLbkP8v6qXg6o0fJDCNDHcI4AT67NfnnkJGc/WhSUiRs6Veo3VjqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RpiAYYm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RpiAYYm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5121F00A3A;
	Tue, 28 Jul 2026 00:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785200010;
	bh=k9JJWkDt87qDdv8jF7zcJAWc2Bn1EUmBrVE4L54J/Ag=;
	h=Date:To:From:Subject;
	b=RpiAYYm7zhsTrJQxNSef+VTCtuE7U4n1mJG8k6CH2pOQgDZVbR3hhx7Oc7B3SQdj+
	 imPOHNwmn3XT6c9Slkmpx8vWC30qNubA3BKIOzpDoedjj40VqCqYp3tpvJu8LhSilQ
	 GF6oM7XMTnRLHMzXfmV4tdg51+mZ2yyJfbIAwfVI=
Date: Mon, 27 Jul 2026 17:53:30 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch removed from -mm tree
Message-Id: <20260728005330.7D5121F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix null nodemask in alloc_fresh_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm/hugetlb: fix null nodemask in alloc_fresh_hugetlb_folio
Date: Sun, 5 Jul 2026 17:51:19 +0000

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
alloc_fresh_hugetlb_folio() as a fallback to allocate from all nodes.  If
order is gigantic, alloc_fresh_hugetlb_folio() propagates the NULL
nodemask down to hugetlb_cma_alloc_frozen_folio() which blindly
dereferences it in for_each_node_mask(), leading to a null pointer
dereference.

Similarly, if the CMA allocation fails, the fallback
alloc_contig_frozen_pages() is also called with a NULL nodemask, which may
cause issues.

Fix this by explicitly checking if nodemask is NULL in
alloc_fresh_hugetlb_folio() and defaulting to cpuset_current_mems_allowed.
This ensures that both the CMA and contiguous allocators receive a valid
nodemask safely using a seqcount loop to prevent torn reads.

From a userspace perspective, this bug allows an unprivileged user to
crash the kernel (trigger a panic) by requesting a gigantic hugepage
allocation with MPOL_PREFERRED_MANY on a system where CMA is only
configured on a subset of NUMA nodes.

This can be reproduced by booting a VM with two NUMA nodes, restricting
CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G hugepagesz=1G
hugepages=0), and running a program that allocates a 1GB hugepage area
without reserving, restricts allocation to Node 0 using mbind() with
MPOL_PREFERRED_MANY, and triggers a page fault:

  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
  unsigned long nodemask = 1; /* Node 0 */
  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
        sizeof(nodemask) * 8, 0);
  memset(ptr, 0, 1UL << 30); /* Trigger fault */

This results in a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
  Call Trace:
   <TASK>
   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
   alloc_surplus_hugetlb_folio+0x6d/0x100
   alloc_hugetlb_folio+0x3c5/0x660
   hugetlb_no_page+0x3d9/0x650

Additionally, this patch adds a missing node_isset(nid, *nodemask) check
in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocation
attempt respects the memory policy.

Link: https://lore.kernel.org/20260705175119.440599-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |   12 ++++++++++++
 mm/hugetlb_cma.c |    2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1864,6 +1864,18 @@ static struct folio *alloc_fresh_hugetlb
 		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
+	nodemask_t local_node_mask;
+
+	if (!nmask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nmask = &local_node_mask;
+	}
 
 	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (folio)
--- a/mm/hugetlb_cma.c~mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb_cma.c
@@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

