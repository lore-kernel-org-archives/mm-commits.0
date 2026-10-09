Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F208C403AEA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525446; cv=none; b=fihuqxpvI1aWO9MWO96kzVbLZIHEJ+JFVlLYyUozlW853ftTpzcUcIuwNXWFSnWHHspT5wzspktp6exRhPIT4/tByVik2q/n4Lh8lA7TJ3jlJOMX7u6hC3FRX0VM16ldUwAnhdR93o/kmAOCkL9AnesFcYPra/jvHvhIBQAZZA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525446; c=relaxed/simple;
	bh=uMb2Ry/ttakkWapoev6zJ8jX8pOuVJTukIP2aRPonJw=;
	h=Date:To:From:Subject:Message-Id; b=XakRugqpAMZlQNbGKxZF5nz0Q/GMaH2mTNFhr0zXM0Rqy4vReLQZL/VBBL7FJj9AgLEtiSruKlkmVWbSFFCvuWzi9RB33a4Of4KFkUX97tQbdUEbKV/TqY6gib7AkuQL7o2T9302gxqrkxmkU1V6qTxz3Q23wjsF6y6i3gHEXb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FgSMaT9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FgSMaT9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65BB1F00898;
	Fri,  9 Oct 2026 05:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525444;
	bh=ecg8qebman+mgyX6T5wzAzxqaXj8/JaOVLoAlFudKo0=;
	h=Date:To:From:Subject;
	b=FgSMaT9t2Sxc+YMYpFAyo6fDz54/5rb0X4Zx9DCD+llaweOeoT8p7qvcsQmMm4ScB
	 VV8tofF2ctgp+Rsj7fix+KPKiGXmu4Z3mzMznjiA7o1tMXSMz1Cq7s3P9qtZTsjS+g
	 yTCSLEbGxh8lhwADKUDhDu645J+cfmydzommJ53w=
Date: Thu, 08 Oct 2026 22:57:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch removed from -mm tree
Message-Id: <20261009055724.C65BB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
has been removed from the -mm tree.  Its filename was
     mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Krishna Iyer <kiyer@crusoe.ai>
Subject: mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
Date: Tue, 8 Sep 2026 06:51:53 -0700

Patch series "mm/damon: support access monitoring of hugetlb-backed
memory", v3.

On virtualization hosts, most system memory is often backed by hugetlbfs. 
On our production hosts, for example, ~95% of RAM is 1 GiB hugetlb pages
backing guest memory.  DAMON's physical address space monitoring is blind
to such memory: every access check starts at damon_get_folio(), which
rejects folios that are not on the LRU lists, and hugetlb folios are
managed outside of the LRU by design.  As a result, all hugetlb-backed
memory is silently reported as never accessed.  In testing on a 1 TiB
host, an hour of 4-thread random access over 842 GiB inside a guest was
statistically indistinguishable from an idle host.

The first patch moves damon_hugetlb_mkold() from vaddr to ops-common as a
preparation.  The second patch teaches the folio mkold/young rmap walkers
to handle hugetlb folios, aging the huge PTE and notifying secondary MMUs
across the whole huge page size; the secondary MMU notification is what
surfaces guest-side (e.g., KVM/EPT) accessed bits.  The third patch adds
damon_get_monitor_folio() and uses it from the paddr monitoring primitives
only.  DAMOS action appliers such as DAMON_RECLAIM and DAMON_LRU_SORT keep
the LRU-only lookup and are behaviorally unchanged.

This series is the first half of an earlier six-patch series [1], split
out as SJ suggested [2].  The second half (the 'aging_flush'
TLB-flush-assisted aging) is deferred: we will gather more quantitative
data on the gap it addresses, including the workload-side impact of the
flushes and the working set measurement details SJ asked about, and post
it separately once the data is in hand, aligned with the ongoing
monitoring preparation actions work.

Per Documentation/process/generated-content.rst, this series was developed
with the assistance of an AI coding assistant (Anthropic Claude, via
Claude Code).  The assistant helped draft the code and changelogs, and
applied the v1 review feedback.  All changes were reviewed by the human
submitter, who takes full responsibility for the contribution.

The series as posted here was regression-tested on its base commit with a
full x86_64 kernel build (no W=1 warnings in mm/damon), the DAMON kunit
suite (41/41 passing) and the DAMON selftests (15/15 passing) on a kernel
booted with virtme-ng.


This patch (of 3):

damon_hugetlb_mkold() clears the accessed bit of a hugetlb-mapping huge
PTE and propagates the aging to secondary MMUs via
mmu_notifier_clear_young(), spanning the whole huge page size.  It
currently lives in vaddr.c, and is thus usable only by the virtual address
space monitoring operations set.

The physical address space monitoring operations set will need the same
logic, to support access monitoring of hugetlb-backed memory.  Move the
function to ops-common as-is, with no behavioral change.  A follow-up
change will use it from the folio-granular rmap walkers.

Link: https://lore.kernel.org/20260908135156.97481-1-sj@kernel.org
Link: https://lore.kernel.org/20260902025700.17975-2-kiyer@crusoe.ai
Link: https://lore.kernel.org/20260908135156.97481-2-sj@kernel.org
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
---

 mm/damon/ops-common.c |   37 +++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |    9 +++++++++
 mm/damon/vaddr.c      |   34 ----------------------------------
 3 files changed, 46 insertions(+), 34 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common
+++ a/mm/damon/ops-common.c
@@ -3,6 +3,7 @@
  * Common Code for Data Access Monitoring
  */
 
+#include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
@@ -103,6 +104,42 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
+{
+	unsigned long psize = huge_page_size(hstate_vma(vma));
+
+	if (!pte_young(*entry))
+		return false;
+	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
+	*entry = pte_mkold(*entry);
+	set_huge_pte_at(mm, addr, pte, *entry, psize);
+	return true;
+}
+
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	bool referenced = false;
+	pte_t entry = huge_ptep_get(mm, addr, pte);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
+
+	folio_get(folio);
+
+	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
+	if (mmu_notifier_clear_young(mm, addr,
+				     addr + huge_page_size(hstate_vma(vma))))
+		referenced = true;
+
+	if (referenced)
+		folio_set_young(folio);
+
+	folio_set_idle(folio);
+	folio_put(folio);
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
 #define DAMON_MAX_SUBSCORE	(100)
 #define DAMON_MAX_AGE_IN_LOG	(32)
 
--- a/mm/damon/ops-common.h~mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common
+++ a/mm/damon/ops-common.h
@@ -9,6 +9,15 @@ struct folio *damon_get_folio(unsigned l
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
+#ifdef CONFIG_HUGETLB_PAGE
+void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr);
+#else
+static inline void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
 void damon_folio_mkold(struct folio *folio);
 bool damon_folio_young(struct folio *folio);
 
--- a/mm/damon/vaddr.c~mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common
+++ a/mm/damon/vaddr.c
@@ -283,40 +283,6 @@ out:
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
-{
-	unsigned long psize = huge_page_size(hstate_vma(vma));
-
-	if (!pte_young(*entry))
-		return false;
-	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
-	*entry = pte_mkold(*entry);
-	set_huge_pte_at(mm, addr, pte, *entry, psize);
-	return true;
-}
-
-static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
-				struct vm_area_struct *vma, unsigned long addr)
-{
-	bool referenced = false;
-	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
-
-	folio_get(folio);
-
-	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
-	if (mmu_notifier_clear_young(mm, addr,
-				     addr + huge_page_size(hstate_vma(vma))))
-		referenced = true;
-
-	if (referenced)
-		folio_set_young(folio);
-
-	folio_set_idle(folio);
-	folio_put(folio);
-}
-
 static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				     unsigned long addr, unsigned long end,
 				     struct mm_walk *walk)
_

Patches currently in -mm which might be from kiyer@crusoe.ai are


