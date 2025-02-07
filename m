Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C501CD205;
	Fri,  7 Feb 2025 23:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738971952; cv=none; b=SjISLpPryjb6Khd7cENyKY3alBE/SiuwbI/huyKFXarQZ6+0TVuZ6CqawHQUMrToisX9IF8dsMPBZeNlNZ1oIlOPziqGe5uB4VJGTf3HVE6LmxkYtvUF5AZqw1g3EK7mMMCmJwVUOn41Et6gnQS2nrDUwi8O8DQ0qL/Hy0maGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738971952; c=relaxed/simple;
	bh=uP6+4r7ii2HvcZBOLKWBVvyKrbzXwnMW1I8lMq95Obw=;
	h=Date:To:From:Subject:Message-Id; b=J65VJXTSnKZQkU9GiR+PHn931svKiWo9sTXHDgwTDDD/kW8oaPAmNMqxqQeWeMO9Q2xKsQe48bJqaEWs4aZIa3egsxtUP1BdHTjkmO9JiYugnyipWnAxR4fc4DVwp1u6evHFqUAr3teFW/3LjXzXp0kQEAOcSJI2WgPA/RCMg00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xxl83R8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xxl83R8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7FCC4CED1;
	Fri,  7 Feb 2025 23:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738971951;
	bh=uP6+4r7ii2HvcZBOLKWBVvyKrbzXwnMW1I8lMq95Obw=;
	h=Date:To:From:Subject:From;
	b=Xxl83R8ff0eTi33QU8EIevpDngIacrGZ6m4T78w52+3NoVNfRJbwwxoGNgcci61w1
	 2LfQRb3s999ys5cyJkSpZOMbej6ZFPyB3ASQL0f9b2CNL1SlskE14u0B/FEz2H0hma
	 utxkaSo9P1Cg9h7Bl4+XGpwUokuJxH5OV+cWL3vA=
Date: Fri, 07 Feb 2025 15:45:51 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch added to mm-unstable branch
Message-Id: <20250207234551.BF7FCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: avoid applying DAMOS action to same entity multiple times
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: avoid applying DAMOS action to same entity multiple times
Date: Fri, 7 Feb 2025 13:20:33 -0800

'paddr' DAMON operations set can apply a DAMOS scheme's action to a large
folio multiple times in single DAMOS-regions-walk if the folio is laid on
multiple DAMON regions.  Add a field for DAMOS scheme object that can be
used by the underlying ops to know what was the last entity that the
scheme's action has applied.  The core layer unsets the field when each
DAMOS-regions-walk is done for the given scheme.  And update 'paddr' ops
to use the infrastructure to avoid the problem.

Link: https://lkml.kernel.org/r/20250207212033.45269-3-sj@kernel.org
Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Usama Arif <usamaarif642@gmail.com>
Closes: https://lore.kernel.org/20250203225604.44742-3-usamaarif642@gmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 +++++++++++
 mm/damon/core.c       |    1 +
 mm/damon/paddr.c      |   39 +++++++++++++++++++++++++++------------
 3 files changed, 39 insertions(+), 12 deletions(-)

--- a/include/linux/damon.h~mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times
+++ a/include/linux/damon.h
@@ -432,6 +432,7 @@ struct damos_access_pattern {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
  * @filters:		Additional set of &struct damos_filter for &action.
+ * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
  *
@@ -454,6 +455,15 @@ struct damos_access_pattern {
  * implementation could check pages of the region and skip &action to respect
  * &filters
  *
+ * The minimum entity that @action can be applied depends on the underlying
+ * &struct damon_operations.  Since it may not be aligned with the core layer
+ * abstract, namely &struct damon_region, &struct damon_operations could apply
+ * @action to same entity multiple times.  Large folios that underlying on
+ * multiple &struct damon region objects could be such examples.  The &struct
+ * damon_operations can use @last_applied to avoid that.  DAMOS core logic
+ * unsets @last_applied when each regions walking for applying the scheme is
+ * finished.
+ *
  * After applying the &action to each region, &stat_count and &stat_sz is
  * updated to reflect the number of regions and total size of regions that the
  * &action is applied.
@@ -477,6 +487,7 @@ struct damos {
 		int target_nid;
 	};
 	struct list_head filters;
+	void *last_applied;
 	struct damos_stat stat;
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times
+++ a/mm/damon/core.c
@@ -1851,6 +1851,7 @@ static void kdamond_apply_schemes(struct
 		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
+		s->last_applied = NULL;
 	}
 }
 
--- a/mm/damon/paddr.c~mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times
+++ a/mm/damon/paddr.c
@@ -243,6 +243,17 @@ static bool damos_pa_filter_out(struct d
 	return false;
 }
 
+static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
+{
+	if (!folio)
+		return true;
+	if (folio == s->last_applied) {
+		folio_put(folio);
+		return true;
+	}
+	return false;
+}
+
 static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
@@ -250,6 +261,7 @@ static unsigned long damon_pa_pageout(st
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
+	struct folio *folio;
 
 	/* check access in page level again by default */
 	damos_for_each_filter(filter, s) {
@@ -268,9 +280,8 @@ static unsigned long damon_pa_pageout(st
 
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
-		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
-
-		if (!folio) {
+		folio = damon_get_folio(PHYS_PFN(addr));
+		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -296,6 +307,7 @@ put_folio:
 		damos_destroy_filter(filter);
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -304,12 +316,12 @@ static inline unsigned long damon_pa_mar
 		unsigned long *sz_filter_passed)
 {
 	unsigned long addr, applied = 0;
+	struct folio *folio;
 
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
-		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
-
-		if (!folio) {
+		folio = damon_get_folio(PHYS_PFN(addr));
+		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -328,6 +340,7 @@ put_folio:
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -471,12 +484,12 @@ static unsigned long damon_pa_migrate(st
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
+	struct folio *folio;
 
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
-		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
-
-		if (!folio) {
+		folio = damon_get_folio(PHYS_PFN(addr));
+		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -495,6 +508,7 @@ put_folio:
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -512,15 +526,15 @@ static unsigned long damon_pa_stat(struc
 {
 	unsigned long addr;
 	LIST_HEAD(folio_list);
+	struct folio *folio;
 
 	if (!damon_pa_scheme_has_filter(s))
 		return 0;
 
 	addr = r->ar.start;
 	while (addr < r->ar.end) {
-		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
-
-		if (!folio) {
+		folio = damon_get_folio(PHYS_PFN(addr));
+		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
 		}
@@ -530,6 +544,7 @@ static unsigned long damon_pa_stat(struc
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
+	s->last_applied = folio;
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch

