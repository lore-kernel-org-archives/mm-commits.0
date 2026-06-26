Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB9821C16A
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434878; cv=none; b=JS6Q5MTvNP4BdX1hjQbIu2OnrYfrY9SyS7JzwC3L+Rms/AtLvhj/cT/HmrYI8XSgL6neen+g1LkPNZ8Xg0cp6HloWrYGi6wWw6x0tCfxxrWsm+tAbTEdzu/hY6GuUKUgJ3NiQXbfUYGyX/aP0Y6R9EtFH6+4DxY9NYwCTwM1ups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434878; c=relaxed/simple;
	bh=pOMsaeKZuel5/PCrhDh1HQnEgNlWVjXge6/fcmD1POs=;
	h=Date:To:From:Subject:Message-Id; b=USKZmo0YvJstm4zNaUYEbkdJBm7+A6af65s3a5ia4PnmkHgOM8Fb3YlJG1YYI/bmBx1kI5wbZ2ykIM7UVC0bNGqq9tQ8HM9ULI5yDEYgA2UtXtaKOExFHnyAsg9SK5BPknFMalIIfzHFwn+1kZJNxB1iK/E9uyXKu3VTO/lOoY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xs5C5ZIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xs5C5ZIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D669F1F000E9;
	Fri, 26 Jun 2026 00:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434876;
	bh=WDGFnWhVTHKnuqIo3FsU6qVdnLkUGiR5mvLNPpLVthM=;
	h=Date:To:From:Subject;
	b=xs5C5ZIeND+93HEDEy2faJKwRorjVPrOlgpnt1fXVKlBzZVuqZulefrsVEET7YnrE
	 XAQmjlyChkTfOshXJdj/zpnxCvLxgibY/dfwoq+KTa+HBhIUmC9rZ1HN/uqPgg4NOG
	 PZsnd1lvqJtM5gRoHsBqE/zUiFDiJxk7cRu5J/8g=
Date: Thu, 25 Jun 2026 17:47:56 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-unused-bootmem-cma-field.patch added to mm-new branch
Message-Id: <20260626004756.D669F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove unused bootmem cma field
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-unused-bootmem-cma-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-unused-bootmem-cma-field.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove unused bootmem cma field
Date: Fri, 12 Jun 2026 11:59:02 +0800

struct huge_bootmem_page no longer needs to keep the CMA pointer.  The
bootmem path only needs to remember whether a huge page came from CMA,
which is already encoded in the flags field.

Set HUGE_BOOTMEM_CMA when the page is allocated, drop the unused cma field
together with the redundant assignments, and simplify the early CMA
bootmem allocation fallback path now that the cma pointer no longer has to
be stored in struct huge_bootmem_page.

Link: https://lore.kernel.org/20260612035903.2468601-19-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |    5 +----
 mm/hugetlb_cma.c |   29 +++++++++++------------------
 mm/internal.h    |    2 --
 3 files changed, 12 insertions(+), 24 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unused-bootmem-cma-field
+++ a/mm/hugetlb.c
@@ -3076,10 +3076,7 @@ static bool __init alloc_bootmem_huge_pa
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	if (!hugetlb_early_cma(h)) {
-		m->cma = NULL;
-		m->flags = 0;
-	}
+	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
--- a/mm/hugetlb_cma.c~mm-hugetlb-remove-unused-bootmem-cma-field
+++ a/mm/hugetlb_cma.c
@@ -59,31 +59,24 @@ struct folio *hugetlb_cma_alloc_frozen_f
 void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct cma *cma;
-	struct huge_bootmem_page *m;
+	void *m;
 	int node;
 
 	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
-	if (!m) {
-		if (node_exact)
-			return NULL;
+	if (m || node_exact)
+		return m;
 
-		for_each_node_mask(node, hugetlb_bootmem_nodes) {
-			cma = hugetlb_cma[node];
-			if (!cma || node == nid)
-				continue;
-			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m)
-				break;
-		}
+	for_each_node_mask(node, hugetlb_bootmem_nodes) {
+		cma = hugetlb_cma[node];
+		if (!cma || node == nid)
+			continue;
+		m = cma_reserve_early(cma, huge_page_size(h));
+		if (m)
+			return m;
 	}
 
-	if (m) {
-		m->flags = HUGE_BOOTMEM_CMA;
-		m->cma = cma;
-	}
-
-	return m;
+	return NULL;
 }
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
--- a/mm/internal.h~mm-hugetlb-remove-unused-bootmem-cma-field
+++ a/mm/internal.h
@@ -24,13 +24,11 @@
 
 struct folio_batch;
 struct hstate;
-struct cma;
 
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
 	unsigned long flags;
-	struct cma *cma;
 };
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

