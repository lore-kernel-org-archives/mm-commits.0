Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA37E2417E2
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 23:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738884026; cv=none; b=CvMtiMqZDTQsCfYUa6qwHMTA0UKcy75fGha34UOWvhR/0YmIsL/7Ozx390R/3z3pHpaMzY8ISO8oP9YboGhXGDSXjJphFDI9U04rcVL27ojJ/deTnHvvq5k00SEesiSmsJ3JbIzDqARXA5AMXbZgu73tgnthrDXf7/GmY4y0uF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738884026; c=relaxed/simple;
	bh=0k0DqXcPUX8jWZNnuY1fWWXkIkBMZXdrS2rRnCTzeOg=;
	h=Date:To:From:Subject:Message-Id; b=Qs5wPXXjeWENKLd2pobiBRYuK3T3ghdgkE4lwWIKweZm38xbAv3wysRmUAzDvHZBNaL0+mvCy2yzW2VkIGlqT+v870X5elpZCzDd0Vl2NXfLGiZjJ3vw/Nv4ZujjKQxMKwN6tZwIX65M0jUDl1vO+O2eXAj4z2xyA86Pn9ltBV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GaISMUDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GaISMUDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFCFC4CEDD;
	Thu,  6 Feb 2025 23:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738884026;
	bh=0k0DqXcPUX8jWZNnuY1fWWXkIkBMZXdrS2rRnCTzeOg=;
	h=Date:To:From:Subject:From;
	b=GaISMUDvcialLvBZGlrA8om0BARFBBP9htGpnRD5rPVOCFv6du2fZIWc09wMHF4RP
	 HTqEZlyTcrY5CeizMlU1xO6dA4tlSNuLggfxQVkLwxYBjOzELM00ejvUmhmOPluv2Y
	 VOdh1nAUG3H+3ASas3gzrQbNFm8sVc7U3vQjkUbQ=
Date: Thu, 06 Feb 2025 15:20:25 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch added to mm-unstable branch
Message-Id: <20250206232026.9EFCFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: move hugetlb CMA code in to its own file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: move hugetlb CMA code in to its own file
Date: Thu, 6 Feb 2025 18:51:08 +0000

hugetlb.c contained a number of CONFIG_CMA ifdefs, and the code inside
them was large enough to merit being in its own file, so move it, cleaning
up things a bit.

Hide some direct variable access behind functions to accommodate the move.

No functional change intended.

Link: https://lkml.kernel.org/r/20250206185109.1210657-29-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS      |    2 
 mm/Makefile      |    3 
 mm/hugetlb.c     |  252 ++-----------------------------------------
 mm/hugetlb_cma.c |  258 +++++++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb_cma.h |   55 +++++++++
 5 files changed, 334 insertions(+), 236 deletions(-)

--- a/MAINTAINERS~mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file
+++ a/MAINTAINERS
@@ -10700,6 +10700,8 @@ F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
+F:	mm/hugetlb_cma.c
+F:	mm/hugetlb_cma.h
 F:	mm/hugetlb_vmemmap.c
 F:	mm/hugetlb_vmemmap.h
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
--- a/mm/hugetlb.c~mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file
+++ a/mm/hugetlb.c
@@ -49,19 +49,13 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include "hugetlb_cma.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
-#ifdef CONFIG_CMA
-static struct cma *hugetlb_cma[MAX_NUMNODES];
-static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-#endif
-static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
-
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
@@ -128,14 +122,11 @@ static struct resv_map *vma_resv_map(str
 
 static void hugetlb_free_folio(struct folio *folio)
 {
-#ifdef CONFIG_CMA
-	int nid = folio_nid(folio);
-
 	if (folio_test_hugetlb_cma(folio)) {
-		WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+		hugetlb_cma_free_folio(folio);
 		return;
 	}
-#endif
+
 	folio_put(folio);
 }
 
@@ -1492,31 +1483,9 @@ static struct folio *alloc_gigantic_foli
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	folio = NULL;
-#ifdef CONFIG_CMA
-	{
-		int node;
-
-		if (hugetlb_cma[nid])
-			folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
-
-		if (!folio && !(gfp_mask & __GFP_THISNODE)) {
-			for_each_node_mask(node, *nodemask) {
-				if (node == nid || !hugetlb_cma[node])
-					continue;
-
-				folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
-				if (folio)
-					break;
-			}
-		}
-
-		if (folio)
-			folio_set_hugetlb_cma(folio);
-	}
-#endif
+	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
 	if (!folio) {
-		if (hugetlb_cma_only)
+		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
 
 		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
@@ -3179,32 +3148,19 @@ out_end_reservation:
 	return ERR_PTR(-ENOSPC);
 }
 
-static bool __init hugetlb_early_cma(struct hstate *h)
-{
-	if (arch_has_huge_bootmem_alloc())
-		return false;
-
-	return (hstate_is_gigantic(h) && hugetlb_cma_only);
-}
-
 static __init void *alloc_bootmem(struct hstate *h, int nid)
 {
 	struct huge_bootmem_page *m;
-	unsigned long flags;
-	struct cma *cma;
 
-#ifdef CONFIG_CMA
-	if (hugetlb_early_cma(h)) {
-		flags = HUGE_BOOTMEM_CMA;
-		cma = hugetlb_cma[nid];
-		m = cma_reserve_early(cma, huge_page_size(h));
-	} else
-#endif
-	{
-		flags = 0;
-		cma = NULL;
+	if (hugetlb_early_cma(h))
+		m = hugetlb_cma_alloc_bootmem(h, nid);
+	else {
 		m = memblock_alloc_try_nid_raw(huge_page_size(h),
 			huge_page_size(h), 0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		if (m) {
+			m->flags = 0;
+			m->cma = NULL;
+		}
 	}
 
 	if (m) {
@@ -3219,8 +3175,6 @@ static __init void *alloc_bootmem(struct
 		INIT_LIST_HEAD(&m->list);
 		list_add(&m->list, &huge_boot_pages[nid]);
 		m->hstate = h;
-		m->flags = flags;
-		m->cma = cma;
 	}
 
 	return m;
@@ -3665,7 +3619,8 @@ static void __init hugetlb_hstate_alloc_
 	 * Skip gigantic hugepages allocation if early CMA
 	 * reservations are not available.
 	 */
-	if (hstate_is_gigantic(h) && hugetlb_cma_size && !hugetlb_early_cma(h)) {
+	if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
+	    !hugetlb_early_cma(h)) {
 		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
 	}
@@ -3702,7 +3657,7 @@ static void __init hugetlb_init_hstates(
 		 */
 		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 			continue;
-		if (hugetlb_cma_size && h->order <= HUGETLB_PAGE_ORDER)
+		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
 			continue;
 		for_each_hstate(h2) {
 			if (h2 == h)
@@ -4604,14 +4559,6 @@ static void hugetlb_register_all_nodes(v
 
 #endif
 
-#ifdef CONFIG_CMA
-static void __init hugetlb_cma_check(void);
-#else
-static inline __init void hugetlb_cma_check(void)
-{
-}
-#endif
-
 static void __init hugetlb_sysfs_init(void)
 {
 	struct hstate *h;
@@ -4795,8 +4742,7 @@ static __init void hugetlb_parse_params(
 		hcp->setup(hcp->val);
 	}
 
-	if (!hugetlb_cma_size)
-		hugetlb_cma_only = false;
+	hugetlb_cma_validate_params();
 }
 
 /*
@@ -7866,169 +7812,3 @@ void hugetlb_unshare_all_pmds(struct vm_
 	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
 			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
 }
-
-#ifdef CONFIG_CMA
-static bool cma_reserve_called __initdata;
-
-static int __init cmdline_parse_hugetlb_cma(char *p)
-{
-	int nid, count = 0;
-	unsigned long tmp;
-	char *s = p;
-
-	while (*s) {
-		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
-			break;
-
-		if (s[count] == ':') {
-			if (tmp >= MAX_NUMNODES)
-				break;
-			nid = array_index_nospec(tmp, MAX_NUMNODES);
-
-			s += count + 1;
-			tmp = memparse(s, &s);
-			hugetlb_cma_size_in_node[nid] = tmp;
-			hugetlb_cma_size += tmp;
-
-			/*
-			 * Skip the separator if have one, otherwise
-			 * break the parsing.
-			 */
-			if (*s == ',')
-				s++;
-			else
-				break;
-		} else {
-			hugetlb_cma_size = memparse(p, &p);
-			break;
-		}
-	}
-
-	return 0;
-}
-
-early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
-
-static int __init cmdline_parse_hugetlb_cma_only(char *p)
-{
-	return kstrtobool(p, &hugetlb_cma_only);
-}
-
-early_param("hugetlb_cma_only", cmdline_parse_hugetlb_cma_only);
-
-void __init hugetlb_cma_reserve(int order)
-{
-	unsigned long size, reserved, per_node;
-	bool node_specific_cma_alloc = false;
-	int nid;
-
-	/*
-	 * HugeTLB CMA reservation is required for gigantic
-	 * huge pages which could not be allocated via the
-	 * page allocator. Just warn if there is any change
-	 * breaking this assumption.
-	 */
-	VM_WARN_ON(order <= MAX_PAGE_ORDER);
-	cma_reserve_called = true;
-
-	if (!hugetlb_cma_size)
-		return;
-
-	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-		if (hugetlb_cma_size_in_node[nid] == 0)
-			continue;
-
-		if (!node_online(nid)) {
-			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
-			continue;
-		}
-
-		if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
-			pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
-				nid, (PAGE_SIZE << order) / SZ_1M);
-			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
-			hugetlb_cma_size_in_node[nid] = 0;
-		} else {
-			node_specific_cma_alloc = true;
-		}
-	}
-
-	/* Validate the CMA size again in case some invalid nodes specified. */
-	if (!hugetlb_cma_size)
-		return;
-
-	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
-		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
-			(PAGE_SIZE << order) / SZ_1M);
-		hugetlb_cma_size = 0;
-		return;
-	}
-
-	if (!node_specific_cma_alloc) {
-		/*
-		 * If 3 GB area is requested on a machine with 4 numa nodes,
-		 * let's allocate 1 GB on first three nodes and ignore the last one.
-		 */
-		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
-		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
-			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
-	}
-
-	reserved = 0;
-	for_each_online_node(nid) {
-		int res;
-		char name[CMA_MAX_NAME];
-
-		if (node_specific_cma_alloc) {
-			if (hugetlb_cma_size_in_node[nid] == 0)
-				continue;
-
-			size = hugetlb_cma_size_in_node[nid];
-		} else {
-			size = min(per_node, hugetlb_cma_size - reserved);
-		}
-
-		size = round_up(size, PAGE_SIZE << order);
-
-		snprintf(name, sizeof(name), "hugetlb%d", nid);
-		/*
-		 * Note that 'order per bit' is based on smallest size that
-		 * may be returned to CMA allocator in the case of
-		 * huge page demotion.
-		 */
-		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
-					HUGETLB_PAGE_ORDER, name,
-					&hugetlb_cma[nid], nid);
-		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
-				res, nid);
-			continue;
-		}
-
-		reserved += size;
-		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
-			size / SZ_1M, nid);
-
-		if (reserved >= hugetlb_cma_size)
-			break;
-	}
-
-	if (!reserved)
-		/*
-		 * hugetlb_cma_size is used to determine if allocations from
-		 * cma are possible.  Set to zero if no cma regions are set up.
-		 */
-		hugetlb_cma_size = 0;
-}
-
-static void __init hugetlb_cma_check(void)
-{
-	if (!hugetlb_cma_size || cma_reserve_called)
-		return;
-
-	pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
-}
-
-#endif /* CONFIG_CMA */
diff --git a/mm/hugetlb_cma.c a/mm/hugetlb_cma.c
new file mode 100644
--- /dev/null
+++ a/mm/hugetlb_cma.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/mm.h>
+#include <linux/cma.h>
+#include <linux/compiler.h>
+#include <linux/mm_inline.h>
+
+#include <asm/page.h>
+#include <asm/setup.h>
+
+#include <linux/hugetlb.h>
+#include "internal.h"
+#include "hugetlb_cma.h"
+
+
+static struct cma *hugetlb_cma[MAX_NUMNODES];
+static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
+static bool hugetlb_cma_only;
+static unsigned long hugetlb_cma_size __initdata;
+
+void hugetlb_cma_free_folio(struct folio *folio)
+{
+	int nid = folio_nid(folio);
+
+	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+}
+
+
+struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+				      int nid, nodemask_t *nodemask)
+{
+	int node;
+	int order = huge_page_order(h);
+	struct folio *folio = NULL;
+
+	if (hugetlb_cma[nid])
+		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+
+	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
+		for_each_node_mask(node, *nodemask) {
+			if (node == nid || !hugetlb_cma[node])
+				continue;
+
+			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
+			if (folio)
+				break;
+		}
+	}
+
+	if (folio)
+		folio_set_hugetlb_cma(folio);
+
+	return folio;
+}
+
+struct huge_bootmem_page * __init
+hugetlb_cma_alloc_bootmem(struct hstate *h, int nid)
+{
+	struct cma *cma;
+	struct huge_bootmem_page *m;
+
+	cma = hugetlb_cma[nid];
+	m = cma_reserve_early(cma, huge_page_size(h));
+	if (m) {
+		m->flags = HUGE_BOOTMEM_CMA;
+		m->cma = cma;
+	}
+
+	return m;
+}
+
+
+static bool cma_reserve_called __initdata;
+
+static int __init cmdline_parse_hugetlb_cma(char *p)
+{
+	int nid, count = 0;
+	unsigned long tmp;
+	char *s = p;
+
+	while (*s) {
+		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
+			break;
+
+		if (s[count] == ':') {
+			if (tmp >= MAX_NUMNODES)
+				break;
+			nid = array_index_nospec(tmp, MAX_NUMNODES);
+
+			s += count + 1;
+			tmp = memparse(s, &s);
+			hugetlb_cma_size_in_node[nid] = tmp;
+			hugetlb_cma_size += tmp;
+
+			/*
+			 * Skip the separator if have one, otherwise
+			 * break the parsing.
+			 */
+			if (*s == ',')
+				s++;
+			else
+				break;
+		} else {
+			hugetlb_cma_size = memparse(p, &p);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
+
+static int __init cmdline_parse_hugetlb_cma_only(char *p)
+{
+	return kstrtobool(p, &hugetlb_cma_only);
+}
+
+early_param("hugetlb_cma_only", cmdline_parse_hugetlb_cma_only);
+
+void __init hugetlb_cma_reserve(int order)
+{
+	unsigned long size, reserved, per_node;
+	bool node_specific_cma_alloc = false;
+	int nid;
+
+	/*
+	 * HugeTLB CMA reservation is required for gigantic
+	 * huge pages which could not be allocated via the
+	 * page allocator. Just warn if there is any change
+	 * breaking this assumption.
+	 */
+	VM_WARN_ON(order <= MAX_PAGE_ORDER);
+	cma_reserve_called = true;
+
+	if (!hugetlb_cma_size)
+		return;
+
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		if (hugetlb_cma_size_in_node[nid] == 0)
+			continue;
+
+		if (!node_online(nid)) {
+			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
+			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
+			hugetlb_cma_size_in_node[nid] = 0;
+			continue;
+		}
+
+		if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
+			pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
+				nid, (PAGE_SIZE << order) / SZ_1M);
+			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
+			hugetlb_cma_size_in_node[nid] = 0;
+		} else {
+			node_specific_cma_alloc = true;
+		}
+	}
+
+	/* Validate the CMA size again in case some invalid nodes specified. */
+	if (!hugetlb_cma_size)
+		return;
+
+	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
+		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
+			(PAGE_SIZE << order) / SZ_1M);
+		hugetlb_cma_size = 0;
+		return;
+	}
+
+	if (!node_specific_cma_alloc) {
+		/*
+		 * If 3 GB area is requested on a machine with 4 numa nodes,
+		 * let's allocate 1 GB on first three nodes and ignore the last one.
+		 */
+		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
+			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+	}
+
+	reserved = 0;
+	for_each_online_node(nid) {
+		int res;
+		char name[CMA_MAX_NAME];
+
+		if (node_specific_cma_alloc) {
+			if (hugetlb_cma_size_in_node[nid] == 0)
+				continue;
+
+			size = hugetlb_cma_size_in_node[nid];
+		} else {
+			size = min(per_node, hugetlb_cma_size - reserved);
+		}
+
+		size = round_up(size, PAGE_SIZE << order);
+
+		snprintf(name, sizeof(name), "hugetlb%d", nid);
+		/*
+		 * Note that 'order per bit' is based on smallest size that
+		 * may be returned to CMA allocator in the case of
+		 * huge page demotion.
+		 */
+		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
+					HUGETLB_PAGE_ORDER, name,
+					&hugetlb_cma[nid], nid);
+		if (res) {
+			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+				res, nid);
+			continue;
+		}
+
+		reserved += size;
+		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
+			size / SZ_1M, nid);
+
+		if (reserved >= hugetlb_cma_size)
+			break;
+	}
+
+	if (!reserved)
+		/*
+		 * hugetlb_cma_size is used to determine if allocations from
+		 * cma are possible.  Set to zero if no cma regions are set up.
+		 */
+		hugetlb_cma_size = 0;
+}
+
+void __init hugetlb_cma_check(void)
+{
+	if (!hugetlb_cma_size || cma_reserve_called)
+		return;
+
+	pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
+}
+
+bool hugetlb_cma_exclusive_alloc(void)
+{
+	return hugetlb_cma_only;
+}
+
+unsigned long __init hugetlb_cma_total_size(void)
+{
+	return hugetlb_cma_size;
+}
+
+void __init hugetlb_cma_validate_params(void)
+{
+	if (!hugetlb_cma_size)
+		hugetlb_cma_only = false;
+}
+
+bool __init hugetlb_early_cma(struct hstate *h)
+{
+	if (arch_has_huge_bootmem_alloc())
+		return false;
+
+	return hstate_is_gigantic(h) && hugetlb_cma_only;
+}
diff --git a/mm/hugetlb_cma.h a/mm/hugetlb_cma.h
new file mode 100644
--- /dev/null
+++ a/mm/hugetlb_cma.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_HUGETLB_CMA_H
+#define _LINUX_HUGETLB_CMA_H
+
+#ifdef CONFIG_CMA
+void hugetlb_cma_free_folio(struct folio *folio);
+struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+				      int nid, nodemask_t *nodemask);
+struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid);
+void hugetlb_cma_check(void);
+bool hugetlb_cma_exclusive_alloc(void);
+unsigned long hugetlb_cma_total_size(void);
+void hugetlb_cma_validate_params(void);
+bool hugetlb_early_cma(struct hstate *h);
+#else
+static inline void hugetlb_cma_free_folio(struct folio *folio)
+{
+}
+
+static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
+	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	return NULL;
+}
+
+static inline
+struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid)
+{
+	return NULL;
+}
+
+static inline void hugetlb_cma_check(void)
+{
+}
+
+static inline bool hugetlb_cma_exclusive_alloc(void)
+{
+	return false;
+}
+
+static inline unsigned long hugetlb_cma_total_size(void)
+{
+	return 0;
+}
+
+static inline void hugetlb_cma_validate_params(void)
+{
+}
+
+static inline bool hugetlb_early_cma(struct hstate *h)
+{
+	return false;
+}
+#endif
+#endif
--- a/mm/Makefile~mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file
+++ a/mm/Makefile
@@ -79,6 +79,9 @@ obj-$(CONFIG_SWAP)	+= page_io.o swap_sta
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
+ifdef CONFIG_CMA
+obj-$(CONFIG_HUGETLBFS)	+= hugetlb_cma.o
+endif
 obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

