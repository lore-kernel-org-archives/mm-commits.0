Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6912153E0;
	Mon, 17 Mar 2025 05:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188254; cv=none; b=FyhWNrRVITlQjM1s87YGy1HqTJ6aYLMDiYVlPAqA9uRyz3t/9E4LMTIkfG77z3tiVagfI+Mw++mbMBUdbDeMDG9dT049bEWIbLME3GuKDeHZwHuaHJ4eWEZrTDG3EFht7gj3LtAcoM212Ni8NMWB3pNwL3btffoBXuW6saDR9Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188254; c=relaxed/simple;
	bh=KQZ124g5v4d+9yDUzkmKtBmxUCujrKREO5JhKmCLCz8=;
	h=Date:To:From:Subject:Message-Id; b=nuPj/ScipENLK9zNL3lXTTNw92gbokTTj4MSb5ZcTWhaElM9YwUQ4E3z5nr9YjAHiCvdDYgJBcnurfyqTrdDdiipPSjlgvBkcl4LWzWkjniJg4h/790GT6L4Xei009fjvRECTbv2szekWO3yQpOWJ5USZhresBv59JaqullZkHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOn5tNxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOn5tNxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5423BC4CEEC;
	Mon, 17 Mar 2025 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188254;
	bh=KQZ124g5v4d+9yDUzkmKtBmxUCujrKREO5JhKmCLCz8=;
	h=Date:To:From:Subject:From;
	b=qOn5tNxIhEMhCD1fog7Nqf5ooCVc5kkfit5uIB32SIGO+N2KOglexHpwZNviQqoOh
	 +jib5W5aQ+dV3XoRAM0FLxm0QvpPDWP0aG1U0mCPjpnq9ZuBbGim2gdUrIacKiFe8t
	 8WKPOopENBtvkwh0p9Rgb5e3+tHS0hWSkH7CLUSM=
Date: Sun, 16 Mar 2025 22:10:53 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch removed from -mm tree
Message-Id: <20250317051054.5423BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: avoid applying DAMOS action to same entity multiple times
has been removed from the -mm tree.  Its filename was
     mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -482,6 +492,7 @@ struct damos {
 		int target_nid;
 	};
 	struct list_head filters;
+	void *last_applied;
 	struct damos_stat stat;
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times
+++ a/mm/damon/core.c
@@ -1856,6 +1856,7 @@ static void kdamond_apply_schemes(struct
 		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
+		s->last_applied = NULL;
 	}
 }
 
--- a/mm/damon/paddr.c~mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times
+++ a/mm/damon/paddr.c
@@ -254,6 +254,17 @@ static bool damos_pa_filter_out(struct d
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
@@ -261,6 +272,7 @@ static unsigned long damon_pa_pageout(st
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
+	struct folio *folio;
 
 	/* check access in page level again by default */
 	damos_for_each_filter(filter, s) {
@@ -279,9 +291,8 @@ static unsigned long damon_pa_pageout(st
 
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
@@ -307,6 +318,7 @@ put_folio:
 		damos_destroy_filter(filter);
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -315,12 +327,12 @@ static inline unsigned long damon_pa_mar
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
@@ -339,6 +351,7 @@ put_folio:
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -482,12 +495,12 @@ static unsigned long damon_pa_migrate(st
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
@@ -506,6 +519,7 @@ put_folio:
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
+	s->last_applied = folio;
 	return applied * PAGE_SIZE;
 }
 
@@ -523,15 +537,15 @@ static unsigned long damon_pa_stat(struc
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
@@ -541,6 +555,7 @@ static unsigned long damon_pa_stat(struc
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
+	s->last_applied = folio;
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

