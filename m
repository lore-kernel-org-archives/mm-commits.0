Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3799B39282B
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298479; cv=none; b=j5x0fkfTjlWFfM6z5lO0XkDU7B9YpxaqdrVgZei8hptx+VdkwruiAJj8ucirq/WLvBEvYYfsaj84L1uiS7Mw21dxQU3SMygYOZ71dQteNiNblFgWDxFGWIq54W9acYDTUz1G/Nax7qEX67qG7vkrdXj+sTxVwNvsiBeBmwk/nTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298479; c=relaxed/simple;
	bh=aSTwQoIAPpWbou93hP/8y3ZYnLn4eQBqNV5UVKIoTQc=;
	h=Date:To:From:Subject:Message-Id; b=baPj8bNyT6lYsZL8Wuo2X1VQFolglHxoZuezu/yl9AY8ccIOWLhZjo8sO/wvsknplDv/InT9fCv1/0okSuECFJMnftbAaW8AKJdWUjwkvb3p/TueXzZcI1KcYKKwtI9cNvW5TIxcu9JgH2m+ehtxfynsZ8SA2EJzP0vSOkW7i0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUD8B+i3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUD8B+i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4CE1F000E9;
	Wed, 29 Jul 2026 04:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298478;
	bh=/GUzF+mVWtFblDUAmX+h0MQtg1P+Uo2rg9aJv963tAw=;
	h=Date:To:From:Subject;
	b=dUD8B+i3lubXkLuMhC+i3Fl2C5MWdqls71dDL8nmmrWtsLtMOFKPG1wQ1+9hUF8wZ
	 ukl1MtyJiVZiC1B58lXCS5VaokY4bKbQstYmWPsFMZVj6nrURnfa4xNUV8kTIp6ntX
	 yK9oVia7ovWSzBdwimJxjKRoaVL+a+8dgAJ+Nr9c=
Date: Tue, 28 Jul 2026 21:14:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-unused-bootmem-cma-field.patch removed from -mm tree
Message-Id: <20260729041438.0E4CE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove unused bootmem cma field
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-unused-bootmem-cma-field.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

