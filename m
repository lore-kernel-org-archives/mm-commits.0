Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1601DF75C
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027839; cv=none; b=DJnargdy3SHLHyobpfMlsVTJ9IdRIGz62krLGWEmBNTResm5PltZDbBxUzMYc9slfoYEqJksSpIrqooFa87aZonqS2MMrteQjrHefgONFPyPnieM+3KA+o5QM1OPkKXwMTm0i8zSkTXV7JdbQrY2qIf67bydAVW8Uz/bCqglZE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027839; c=relaxed/simple;
	bh=bZ/jrOmwx/WvCsO+L8eo6X/ADy6C+5/LDpvblHTkBnI=;
	h=Date:To:From:Subject:Message-Id; b=stfAvZbzlWQZx+2CWZzy4sTHvtJhIYO30QnIF1Ui9eLc5pOfhlCpvsQ5zKBssNZr9p7MwoWPgVlCpqQPC9agJGC7pVF+2/hsY78sYyLL2fyw6Il7IPE9Hsb5H//Af/7hdO7hcPoh/gtWOVmhk/Snd3xIJJ7QVnhvB+B6n4IL9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyhwowFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyhwowFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1A1C4CEF0;
	Wed,  9 Jul 2025 02:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027838;
	bh=bZ/jrOmwx/WvCsO+L8eo6X/ADy6C+5/LDpvblHTkBnI=;
	h=Date:To:From:Subject:From;
	b=iyhwowFB0lRLcIL9DUS8uw+9AZgy/alMBbi6YRCo61dNp1FxYgud296XU/PIkUwT9
	 jQCBXOFjL0IDSiD+5oN5Yr+vWsgWm+CYDvTrhgxZMZDeQnBmpArmZsqKaM3eqtypD4
	 iFn/F5ouoLUx4kKhIngDkDBuQkPwk2oi8Qi4rVLI=
Date: Tue, 08 Jul 2025 19:23:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch added to mm-new branch
Message-Id: <20250709022358.BF1A1C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: move folio filtering from paddr to ops-common
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon: move folio filtering from paddr to ops-common
Date: Tue, 8 Jul 2025 19:59:42 -0500

This patch moves damos_pa_filter_match and the functions it calls to
ops-common, renaming it to damos_folio_filter_match.  Doing so allows us
to share the filtering logic for the vaddr version of the
migrate_{hot,cold} schemes.

Link: https://lkml.kernel.org/r/20250709005952.17776-13-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |  150 +++++++++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |    3 
 mm/damon/paddr.c      |  153 ----------------------------------------
 3 files changed, 154 insertions(+), 152 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-move-folio-filtering-from-paddr-to-ops-common
+++ a/mm/damon/ops-common.c
@@ -141,6 +141,156 @@ int damon_cold_score(struct damon_ctx *c
 	return DAMOS_MAX_SCORE - hotness;
 }
 
+static bool damon_folio_mkold_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		addr = pvmw.address;
+		if (pvmw.pte)
+			damon_ptep_mkold(pvmw.pte, vma, addr);
+		else
+			damon_pmdp_mkold(pvmw.pmd, vma, addr);
+	}
+	return true;
+}
+
+void damon_folio_mkold(struct folio *folio)
+{
+	struct rmap_walk_control rwc = {
+		.rmap_one = damon_folio_mkold_one,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+	bool need_lock;
+
+	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
+		folio_set_idle(folio);
+		return;
+	}
+
+	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
+	if (need_lock && !folio_trylock(folio))
+		return;
+
+	rmap_walk(folio, &rwc);
+
+	if (need_lock)
+		folio_unlock(folio);
+
+}
+
+static bool damon_folio_young_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	bool *accessed = arg;
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
+	pte_t pte;
+
+	*accessed = false;
+	while (page_vma_mapped_walk(&pvmw)) {
+		addr = pvmw.address;
+		if (pvmw.pte) {
+			pte = ptep_get(pvmw.pte);
+
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			*accessed = (pte_present(pte) && pte_young(pte)) ||
+				!folio_test_idle(folio) ||
+				mmu_notifier_test_young(vma->vm_mm, addr);
+		} else {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
+				!folio_test_idle(folio) ||
+				mmu_notifier_test_young(vma->vm_mm, addr);
+#else
+			WARN_ON_ONCE(1);
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+		}
+		if (*accessed) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+	}
+
+	/* If accessed, stop walking */
+	return *accessed == false;
+}
+
+bool damon_folio_young(struct folio *folio)
+{
+	bool accessed = false;
+	struct rmap_walk_control rwc = {
+		.arg = &accessed,
+		.rmap_one = damon_folio_young_one,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+	bool need_lock;
+
+	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
+		if (folio_test_idle(folio))
+			return false;
+		else
+			return true;
+	}
+
+	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
+	if (need_lock && !folio_trylock(folio))
+		return false;
+
+	rmap_walk(folio, &rwc);
+
+	if (need_lock)
+		folio_unlock(folio);
+
+	return accessed;
+}
+
+bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+	size_t folio_sz;
+
+	switch (filter->type) {
+	case DAMOS_FILTER_TYPE_ANON:
+		matched = folio_test_anon(folio);
+		break;
+	case DAMOS_FILTER_TYPE_ACTIVE:
+		matched = folio_test_active(folio);
+		break;
+	case DAMOS_FILTER_TYPE_MEMCG:
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
+	case DAMOS_FILTER_TYPE_YOUNG:
+		matched = damon_folio_young(folio);
+		if (matched)
+			damon_folio_mkold(folio);
+		break;
+	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		folio_sz = folio_size(folio);
+		matched = filter->sz_range.min <= folio_sz &&
+			  folio_sz <= filter->sz_range.max;
+		break;
+	case DAMOS_FILTER_TYPE_UNMAPPED:
+		matched = !folio_mapped(folio) || !folio_raw_mapping(folio);
+		break;
+	default:
+		break;
+	}
+
+	return matched == filter->matching;
+}
+
 static unsigned int __damon_migrate_folio_list(
 		struct list_head *migrate_folios, struct pglist_data *pgdat,
 		int target_nid)
--- a/mm/damon/ops-common.h~mm-damon-move-folio-filtering-from-paddr-to-ops-common
+++ a/mm/damon/ops-common.h
@@ -11,10 +11,13 @@ struct folio *damon_get_folio(unsigned l
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
+void damon_folio_mkold(struct folio *folio);
+bool damon_folio_young(struct folio *folio);
 
 int damon_cold_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s);
 int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s);
 
+bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
--- a/mm/damon/paddr.c~mm-damon-move-folio-filtering-from-paddr-to-ops-common
+++ a/mm/damon/paddr.c
@@ -18,45 +18,6 @@
 #include "../internal.h"
 #include "ops-common.h"
 
-static bool damon_folio_mkold_one(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr, void *arg)
-{
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
-
-	while (page_vma_mapped_walk(&pvmw)) {
-		addr = pvmw.address;
-		if (pvmw.pte)
-			damon_ptep_mkold(pvmw.pte, vma, addr);
-		else
-			damon_pmdp_mkold(pvmw.pmd, vma, addr);
-	}
-	return true;
-}
-
-static void damon_folio_mkold(struct folio *folio)
-{
-	struct rmap_walk_control rwc = {
-		.rmap_one = damon_folio_mkold_one,
-		.anon_lock = folio_lock_anon_vma_read,
-	};
-	bool need_lock;
-
-	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
-		folio_set_idle(folio);
-		return;
-	}
-
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
-		return;
-
-	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
-
-}
-
 static void damon_pa_mkold(unsigned long paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
@@ -86,75 +47,6 @@ static void damon_pa_prepare_access_chec
 	}
 }
 
-static bool damon_folio_young_one(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr, void *arg)
-{
-	bool *accessed = arg;
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
-	pte_t pte;
-
-	*accessed = false;
-	while (page_vma_mapped_walk(&pvmw)) {
-		addr = pvmw.address;
-		if (pvmw.pte) {
-			pte = ptep_get(pvmw.pte);
-
-			/*
-			 * PFN swap PTEs, such as device-exclusive ones, that
-			 * actually map pages are "old" from a CPU perspective.
-			 * The MMU notifier takes care of any device aspects.
-			 */
-			*accessed = (pte_present(pte) && pte_young(pte)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
-		} else {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
-#else
-			WARN_ON_ONCE(1);
-#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
-		}
-		if (*accessed) {
-			page_vma_mapped_walk_done(&pvmw);
-			break;
-		}
-	}
-
-	/* If accessed, stop walking */
-	return *accessed == false;
-}
-
-static bool damon_folio_young(struct folio *folio)
-{
-	bool accessed = false;
-	struct rmap_walk_control rwc = {
-		.arg = &accessed,
-		.rmap_one = damon_folio_young_one,
-		.anon_lock = folio_lock_anon_vma_read,
-	};
-	bool need_lock;
-
-	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
-		if (folio_test_idle(folio))
-			return false;
-		else
-			return true;
-	}
-
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
-		return false;
-
-	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
-
-	return accessed;
-}
-
 static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
@@ -205,49 +97,6 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-static bool damos_pa_filter_match(struct damos_filter *filter,
-		struct folio *folio)
-{
-	bool matched = false;
-	struct mem_cgroup *memcg;
-	size_t folio_sz;
-
-	switch (filter->type) {
-	case DAMOS_FILTER_TYPE_ANON:
-		matched = folio_test_anon(folio);
-		break;
-	case DAMOS_FILTER_TYPE_ACTIVE:
-		matched = folio_test_active(folio);
-		break;
-	case DAMOS_FILTER_TYPE_MEMCG:
-		rcu_read_lock();
-		memcg = folio_memcg_check(folio);
-		if (!memcg)
-			matched = false;
-		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
-		rcu_read_unlock();
-		break;
-	case DAMOS_FILTER_TYPE_YOUNG:
-		matched = damon_folio_young(folio);
-		if (matched)
-			damon_folio_mkold(folio);
-		break;
-	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
-		folio_sz = folio_size(folio);
-		matched = filter->sz_range.min <= folio_sz &&
-			  folio_sz <= filter->sz_range.max;
-		break;
-	case DAMOS_FILTER_TYPE_UNMAPPED:
-		matched = !folio_mapped(folio) || !folio_raw_mapping(folio);
-		break;
-	default:
-		break;
-	}
-
-	return matched == filter->matching;
-}
-
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
@@ -259,7 +108,7 @@ static bool damos_pa_filter_out(struct d
 		return false;
 
 	damos_for_each_ops_filter(filter, scheme) {
-		if (damos_pa_filter_match(filter, folio))
+		if (damos_folio_filter_match(filter, folio))
 			return !filter->allow;
 	}
 	return scheme->ops_filters_default_reject;
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

