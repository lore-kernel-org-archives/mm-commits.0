Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25B02765D7;
	Wed, 12 Aug 2026 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786499134; cv=none; b=Nst3zXAfkuPqAB7Yf0JPv9VxMpkZn8x6RBnBWyHTZbx0WvWzay8wOt08/Fvmp0K1AGRORqa7sTBDO1/IxTU9WITukBxpMyr07K7hqvUeqYRnuM2OyNT0xBvs9CeyW/3N9bgYrpT0ROU9hn1xMbXqrqDj5KQKFewvCUcyn62n9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786499134; c=relaxed/simple;
	bh=obAGY9gsWNVOli/1LFL94m/t2nqUeluBSOcsrnkxQJw=;
	h=Date:To:From:Subject:Message-Id; b=bw+dtp4ovzOEsRpNY38zZZoRvS7xdXQHkSb9gY+8MPr9JrF9zIHJXjY90hpznvcBFnUqWPaF259J4tp/+UtIcFwFhGMp75VQ6HAqupsz6hyNiIUDoqVuNVaiRiT6Z8pu3W95CUcKU/dNGCX2bYaLNiretPyjTfg3D1ZJP89hslY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wyFP/z6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wyFP/z6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391C61F000E9;
	Wed, 12 Aug 2026 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786499132;
	bh=Y8GfhmhWvkGeHqt870xpRXaasoUG/5uOvKBMWN4EJvM=;
	h=Date:To:From:Subject;
	b=wyFP/z6RMFWD55u06xyM2JLdqXZffMwc8OsKFa+xoA7ViGUEmEgyAv4oYmJpFB2ns
	 ud6WOspM3oyrUFrWSH8ILxG3vo/QRRvEVN3nWPZtSa0aPRzhZKMVal1a5n967aDtYP
	 YzD2OEEbAQE1gjif6Q2AfGptbp701J4dx6/6ZQIo=
Date: Tue, 11 Aug 2026 18:45:31 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch removed from -mm tree
Message-Id: <20260812014532.391C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
Date: Sun, 26 Jul 2026 07:29:34 +0000

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
alloc_fresh_hugetlb_folio() as a fallback to allocate from all nodes.  If
order is gigantic, alloc_fresh_hugetlb_folio() propagates the NULL
nodemask down to hugetlb_cma_alloc_frozen_folio() via
alloc_gigantic_frozen_folio().

Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
allocation on hugetlb_cma[nid] without verifying if nid is included in the
caller's nodemask.  Adding a node_isset(nid, *nodemask) check ensures the
initial preferred node allocation honors the memory policy / nodemask.

However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
leading to a null pointer dereference kernel panic when nodemask is NULL.

Fix this by checking if nodemask is NULL in
hugetlb_cma_alloc_frozen_folio() and defaulting it to
cpuset_current_mems_allowed (safely read using a seqcount retry loop). 
This ensures that the initial node check and fallback loop safely honor
the task's cpuset without violating cpuset constraints or causing NULL
pointer dereferences.

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

[souravpanda@google.com: v5]
  Link: https://lore.kernel.org/20260809043250.2917406-1-souravpanda@google.com
Link: https://lore.kernel.org/20260726072935.3513996-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio
+++ a/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	nodemask_t local_node_mask;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+	if (!nodemask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nodemask = &local_node_mask;
+	}
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

