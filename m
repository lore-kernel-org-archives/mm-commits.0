Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0498878F5E
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976905; cv=none; b=ItIOy4edfjk+075iAMSCZRCPm2CvqLibSW37WN3B1bIvgkoByKGG075w0EoTPzaWVhEaK5SJ2uF1ySgDsU/zwOfaV7zNl5Ac+xhgkxGCCjCj+AnDVyKbDYigYFszeKZZnR8eAiSz95/UAIkUy0tWsds+Jwl4d/+Ig2UXMAguK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976905; c=relaxed/simple;
	bh=ApN0FS+M9/+GNn7sV0+LWvwc445SCSFy2Hf8sr/vzFE=;
	h=Date:To:From:Subject:Message-Id; b=GMLx96/h2LRtmGJNM2lESVUqjcSMyIzW6ZfVk/RsJz9fEjFsVkfOzLVWM5HO/6veA0/gXV7YPH356+OjSI42yiFOKrr3wvUa/mJWNq5t3UiH4H/enIZq9mIfwQ2TRVNIx9ay04pz33UizG6y86nrL4P3RTpdxLrwATvbjYTVZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xD6izXyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xD6izXyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3322C4CEE3;
	Sun, 20 Jul 2025 02:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976904;
	bh=ApN0FS+M9/+GNn7sV0+LWvwc445SCSFy2Hf8sr/vzFE=;
	h=Date:To:From:Subject:From;
	b=xD6izXyiV6mZsvbUza87RCib+rXGjZamBY5VExhgI/GbnnAnf2Vmm/S2sz1ExwmKg
	 AkSv7xBRaQm0s6pKb9M8fxYe1/Z+C2TeU2F7R/kKXzYjYesrsWHodrx+TPosbr/tld
	 Y0XjCC844U080MJXxfpuyBeHw9AvqhLgKGQxB0PM=
Date: Sat, 19 Jul 2025 19:01:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch removed from -mm tree
Message-Id: <20250720020144.C3322C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: add vaddr versions of migrate_{hot,cold}
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/vaddr: add vaddr versions of migrate_{hot,cold}
Date: Tue, 8 Jul 2025 19:59:39 -0500

migrate_{hot,cold} are paddr schemes that are used to migrate hot/cold
data to a specified node.  However, these schemes are only available when
doing physical address monitoring.  This patch adds an implementation for
them virtual address monitoring as well.

Link: https://lkml.kernel.org/r/20250709005952.17776-10-bijan311@gmail.com
Co-developed-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   98 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold
+++ a/mm/damon/vaddr.c
@@ -15,6 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 
+#include "../internal.h"
 #include "ops-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
@@ -610,6 +611,68 @@ static unsigned int damon_va_check_acces
 	return max_nr_accesses;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct list_head *migration_list = walk->private;
+	struct folio *folio;
+	spinlock_t *ptl;
+	pmd_t pmde;
+
+	ptl = pmd_lock(walk->mm, pmd);
+	pmde = pmdp_get(pmd);
+
+	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
+		goto unlock;
+
+	/* Tell page walk code to not split the PMD */
+	walk->action = ACTION_CONTINUE;
+
+	folio = damon_get_folio(pmd_pfn(pmde));
+	if (!folio)
+		goto unlock;
+
+	if (!folio_isolate_lru(folio))
+		goto put_folio;
+
+	list_add(&folio->lru, migration_list);
+
+put_folio:
+	folio_put(folio);
+unlock:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damos_va_migrate_pmd_entry NULL
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static int damos_va_migrate_pte_entry(pte_t *pte, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct list_head *migration_list = walk->private;
+	struct folio *folio;
+	pte_t ptent;
+
+	ptent = ptep_get(pte);
+	if (pte_none(ptent) || !pte_present(ptent))
+		return 0;
+
+	folio = damon_get_folio(pte_pfn(ptent));
+	if (!folio)
+		return 0;
+
+	if (!folio_isolate_lru(folio))
+		goto out;
+
+	list_add(&folio->lru, migration_list);
+
+out:
+	folio_put(folio);
+	return 0;
+}
+
 /*
  * Functions for the target validity check and cleanup
  */
@@ -653,6 +716,34 @@ static unsigned long damos_madvise(struc
 }
 #endif	/* CONFIG_ADVISE_SYSCALLS */
 
+static unsigned long damos_va_migrate(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	LIST_HEAD(folio_list);
+	struct mm_struct *mm;
+	unsigned long applied = 0;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = damos_va_migrate_pmd_entry,
+		.pte_entry = damos_va_migrate_pte_entry,
+		.walk_lock = PGWALK_RDLOCK,
+	};
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &folio_list);
+	mmap_read_unlock(mm);
+	mmput(mm);
+
+	applied = damon_migrate_pages(&folio_list, s->target_nid);
+	cond_resched();
+
+	return applied * PAGE_SIZE;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -675,6 +766,9 @@ static unsigned long damon_va_apply_sche
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_MIGRATE_HOT:
+	case DAMOS_MIGRATE_COLD:
+		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return 0;
 	default:
@@ -695,6 +789,10 @@ static int damon_va_scheme_score(struct
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
 		return damon_cold_score(context, r, scheme);
+	case DAMOS_MIGRATE_HOT:
+		return damon_hot_score(context, r, scheme);
+	case DAMOS_MIGRATE_COLD:
+		return damon_cold_score(context, r, scheme);
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from bijantabatab@micron.com are


