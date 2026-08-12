Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89672BD587;
	Wed, 12 Aug 2026 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786502444; cv=none; b=MQsBrxBadS0lGQPJ6Cp2Upb5oNu3yfGyKd5Qea12miFymyDdlP0pFGpwOSDQPFvZXQ7kdr7CtvWm6WvNgfJruRpgZVhs69/lurikxs2l9syRn3CINTIzWm/NB7u28LcEwiVpQGzYsLcu1cYfhdhgBi7n/DRHnJYD/iJVMPLPgJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786502444; c=relaxed/simple;
	bh=9BIyMNT0dlqXSX98F9Cc+goJK1Rc7gMmtlCkuKSY6jA=;
	h=Date:To:From:Subject:Message-Id; b=bY1E2IQMfa1Ys8szgjiVHtS+6agD6E45uMyQJ77ljgOHvziVOE/MvGxX73JfzrDzwLpRB+NhTGdinXzFxscBerguJf82jKG7FNFyIGJ24IhqYl1Sw1+AxDh21D805hQ9ABihwHekmxChdN+uk/a7w3CcFwibzen5W0RrIWyYRzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZJRhcec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZJRhcec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1043A1F00A3A;
	Wed, 12 Aug 2026 02:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786502442;
	bh=07pSwwRODL1e7A74ekI9ZHfVQwJBIEjz9aYMJQ+gUG0=;
	h=Date:To:From:Subject;
	b=1ZJRhcecmkVmKH1VxQuVisXEAEdysqLSujeqhABwnwbOKmYbrs+4md4uz4AO22qc0
	 AE3LUu4Cvfu5iAS4Crz3K+0WmTnm0QmtVMJ7QkHL/PL9mXlZ04G6dzcJxvClm4dywz
	 PeUqDfgpQO658zT7F5PUDUymDEqduLp4gcbRaxmQ=
Date: Tue, 11 Aug 2026 19:40:41 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,gthelen@google.com,fvdl@google.com,david@kernel.org,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260812024042.1043A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch

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
Subject: mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
Date: Tue, 11 Aug 2026 05:29:09 +0000

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
cpuset_current_mems_allowed.  Enclose the allocation attempts within the
cpuset seqcount retry loop so that if the cpuset changes concurrently
during allocation, the attempts are retried using the updated nodemask. 
This ensures that the initial node check and fallback loop safely honor
the task's cpuset without violating cpuset constraints or causing NULL
pointer dereferences or unexpected allocation failures.

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

Link: https://lore.kernel.org/20260811052909.475635-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio
+++ a/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,15 +31,25 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	const nodemask_t *nmask;
+	unsigned int cpuset_mems_cookie;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+retry_cpuset:
+	if (!nodemask) {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nmask = &cpuset_current_mems_allowed;
+	} else {
+		nmask = nodemask;
+	}
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-		for_each_node_mask(node, *nodemask) {
+		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
@@ -48,8 +59,12 @@ struct folio *hugetlb_cma_alloc_frozen_f
 		}
 	}
 
-	if (!page)
+	if (!page) {
+		if (!nodemask &&
+		    unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+			goto retry_cpuset;
 		return NULL;
+	}
 
 	folio = page_folio(page);
 	folio_set_hugetlb_cma(folio);
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

