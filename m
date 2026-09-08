Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF052E04D
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893960; cv=none; b=cPU1qd9spJmFR8Gnfis6jc6wdjhks2NUMrdexWT9z60SObBpb+vAzp7RrbuNEVukQUrYf9eEybSShxt4OP2tlkq6jj9YUgF5Rz7ccmwGQMaCnoQD9NAPt7r4Lr8pa5PfufKjWhHC97bpySbV/gj7S3ehUAMgx+PUqy/h/Bi+j/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893960; c=relaxed/simple;
	bh=Cz7lyW4jbXUFnu2brgQVw2A+xBqhdyZHGjAS1kkRsRg=;
	h=Date:To:From:Subject:Message-Id; b=Lccz+cUJo6kK9qoKmYe8i+JIUrOlr+JykoVIzei0lZrwUfi77qONZJRnpJE/Kaq/ou39RVI9iEj/maxgtjV9rh8w8Q8xSmo+j5aGldaU4UEeYXlfkzkVl7v7bNuzDP/nWHi3c9PT7Oo4JDU1DS5KFjO3MBRi6AoZjp9IlYE8Uwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhHsxxj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhHsxxj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F21F00A3A;
	Tue,  8 Sep 2026 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788893958;
	bh=RuE/qmDj6MH3oHOpUrqt4SBwzfzt9ymNbkPodYPTjXM=;
	h=Date:To:From:Subject;
	b=XhHsxxj1BeKdcKstMkwx6ml7aCPGsqxj+Ovd14a6sYN/4vAYZUEf8tQAwcIFPb21S
	 t3XSEVlHXscoGYV8PRc9x+zBglWUllaORHsPdqI+xULsCnfs34cNujdcG16gfZ5Mh3
	 jiWgG466ckIwepxnGbTi0WYk4XP7rIHpdVJdbySs=
Date: Tue, 08 Sep 2026 11:59:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch added to mm-new branch
Message-Id: <20260908185918.774F21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch

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
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch
mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch
mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

