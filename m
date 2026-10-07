Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954E937FF76
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401762; cv=none; b=e/H1jvOMX+fvqD+adinU5vyFOESezN0tFHEWJILPLrRRJLcYn0Q75mFYH9NMBRiqqSFrDzCwKogBAWOYzVi0FOCvGXqYWmipd3xzI/sJuIQVB900s19qUiSkB34cuQ6AeUTBjJHin/YN83tS3oSIjYG570KSIJAVzbNgVj1PBhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401762; c=relaxed/simple;
	bh=3KFtGVQnsSookqhdIerDWDZF3if9nfXzJQeCaGy20uU=;
	h=Date:To:From:Subject:Message-Id; b=sEPCn/3qgFbg0BZoa9dfwe1OlxTdIB6hqvOe6P65znpn7DYivQW1UXckIIAOPnTmYnbiEJjNfC35YEsJdQHa4OmZvqN93x6hgDidFrmDFCWL14eBb+Kw26dJ6OZIFMXOiU0ltaX379ZMh9AkWR+m0qf0YMOv1Dd5fFVTlAQaYvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t9b3Rr05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t9b3Rr05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065861F000FF;
	Wed,  7 Oct 2026 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791401761;
	bh=wde+LGWOtE7n0Gk4RwubeLeojuBiOIvVvId9HMYkHOM=;
	h=Date:To:From:Subject;
	b=t9b3Rr05gYyz8eKn54jZ1WEWnYJAi3+8zFvIXF1T5dBgIrKxlzHljQlEyg0rNngaG
	 PSdZXLPr9yy4gBlaIL2gxnf0IXehSKR9IHgcVdPN20ig5GclTV31p+HHrmZrLfIC69
	 WYa3j2SFg6XIkJ33xrjtOOf4P5yg03ElfGq5ZJGw=
Date: Wed, 07 Oct 2026 12:36:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch added to mm-unstable branch
Message-Id: <20261007193601.065861F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: use damon_get_monitor_folio() for hugetlb entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

This patch will later appear in the mm-unstable branch at
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
From: Gregory Price <gourry@gourry.net>
Subject: mm/damon: use damon_get_monitor_folio() for hugetlb entries
Date: Mon,  5 Oct 2026 23:52:06 -0700

Hugetlb folio acquisition is open-coded in three places:
  - damon_hugetlb_mkold()
  - damon_young_hugetlb_entry()
  - damon_va_probe_hugetlb_entry()

DAMON already has damon_get_monitor_folio(), which paddr uses to get
monitored LRU and hugetlb folios and to filter them through
damon_folio_acceptable().  These paths bypass that check.

Use that helper in these paths too, so that DAMON acquires hugetlb folios
and applies its acceptance policy in one place.

No functional change intended.  All callers reach these paths with a
present hugetlb PTE under the page table lock, so the folio is always a
mapped hugetlb folio and the helper always returns it.

Link: https://lore.kernel.org/20261006065209.41507-3-sj@kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 mm/damon/ops-common.c |    6 ++++--
 mm/damon/vaddr.c      |   10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries
+++ a/mm/damon/ops-common.c
@@ -140,9 +140,11 @@ void damon_hugetlb_mkold(pte_t *pte, str
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
+	struct folio *folio;
 
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		return;
 
 	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 	if (mmu_notifier_clear_young(mm, addr,
--- a/mm/damon/vaddr.c~mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries
+++ a/mm/damon/vaddr.c
@@ -411,8 +411,9 @@ static int damon_young_hugetlb_entry(pte
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
@@ -660,8 +661,9 @@ static int damon_va_probe_hugetlb_entry(
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
 			walk->vma->vm_mm);
 	folio_put(folio);
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch
mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

