Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8974D3EA66;
	Sun,  5 Jul 2026 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783278259; cv=none; b=aEhD2zWY3rPNjnLETgtizv5yPHkJnj4vy6qzq0+t1EldV08e2Sbh6xYeFbHUhshQPOJGntE/abcQYVmYcVebWgDyfVSgcSV2X5sgnnZ04f1GbHBH9+piAdKa0i24EXOgaDyLWL2tdxJGFxif9z4XOEb4m5qtanzLukCp721ZLS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783278259; c=relaxed/simple;
	bh=/lvtglFdxG7A6SK3fGYpTgcc7MwYUSmGA2CQLV68yyw=;
	h=Date:To:From:Subject:Message-Id; b=EYbig7JYBVdIIF2+0Kk2PlK0LQ1uaqsA8lGB6cYAUEd4mvfUj9TL/krS4M3Livy4LiMt6LsNP24CBsYZUDkn9stV62wrEUZHR83WNHfDCaOu+jg+mWknAtC4+OxiL4DpGGIC+rF6bW09LcC1Ioc/oFKSciJDzDaMMStVFToEoNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JO7xZ3Sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JO7xZ3Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8C1F00A3A;
	Sun,  5 Jul 2026 19:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783278258;
	bh=m9jF/0MMQ80L7Ic7+haoJ7HfJI38w0hF9EPOFBOvPVU=;
	h=Date:To:From:Subject;
	b=JO7xZ3SjQyVsf3o1/jDKDW7QHy1NZChpJrsKheGDu1af2j8aiPnEOiFWojT84lNmC
	 TiIw0Q/qlRA8kAAYhnOUQMw+KQQnmxuSrP/kmh89IU2A+xvxa9eNELbfKXSRIWawG+
	 ginzrRTO5VlDnWhKvpswaQ7Nb8e17VWsHunnQxkg=
Date: Sun, 05 Jul 2026 12:04:17 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260705190418.10A8C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix null nodemask in alloc_fresh_hugetlb_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-fix-null-nodemask-in-alloc_fresh_hugetlb_folio.patch
mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

