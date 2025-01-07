Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15E333EA
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215466; cv=none; b=BBiGO2B7v4P8q2JtGgjq8kN/m099aA8A57gILfLab41ZBY3BFSbT16n+0DHGy8wN0kWVMHyoACoZlPY8zs/qwYWIlKD03OcoyR7zrk3LGhnnfU9hYJTkXyPTcnmwN8A4AjKETVVLTJ2cTGd6fSkoFgra76Vsq9FXs3VF6OgkvE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215466; c=relaxed/simple;
	bh=xKHL1D/F/doj+B4byhx6ReQ7r+QMdF5c/YQ5h+yftjk=;
	h=Date:To:From:Subject:Message-Id; b=rKp35hOAl12rsM97+7o1RXKWyATFVWXI+DJWjjtVxshdv0C9voe2gDnRfejRy2SG8d8k/lLsoZmRPamxdSNxBAql2irgu0qxQhWuwiOF3EBhrHSrjKfVJJmpZNHOOyOB8ak4q1ZIIK1K8O4IZYWlA+IdN0lnVooG3NhNDh7G9L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d1AKXmnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d1AKXmnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968FAC4CED2;
	Tue,  7 Jan 2025 02:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215466;
	bh=xKHL1D/F/doj+B4byhx6ReQ7r+QMdF5c/YQ5h+yftjk=;
	h=Date:To:From:Subject:From;
	b=d1AKXmnEjGa/nXTQNRHptIjOu1RQwrCmXah+u7M3juCjDIjsD+4Y4DtesFMOSfDlw
	 eaDNlRjoSV7PB/7Ik6Gw8fcQHXaRKzhKxRxNrIkTsBRh1t02aR1XBzs6da9MWKnNA5
	 Ng3mpWuOwRDAo2gtJn2SJUld2CU/IhCzeH8JAKY4=
Date: Mon, 06 Jan 2025 18:04:26 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch added to mm-unstable branch
Message-Id: <20250107020426.968FAC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: ask apply_scheme() to report filter-passed region-internal bytes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch

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
Subject: mm/damon: ask apply_scheme() to report filter-passed region-internal bytes
Date: Mon, 6 Jan 2025 11:33:49 -0800

Some DAMOS filter types including those for young page, anon page, and
belonging memcg are handled by underlying DAMON operations set
implementation, via damon_operations->apply_scheme() interface.  How many
bytes of the region have passed the filter can be useful for DAMOS scheme
tuning and access pattern monitoring.  Modify the interface to let the
callback implementation reports back the number if possible.

Link: https://lkml.kernel.org/r/20250106193401.109161-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++--
 mm/damon/core.c       |    4 +++-
 mm/damon/paddr.c      |    2 +-
 mm/damon/vaddr.c      |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/include/linux/damon.h
@@ -529,7 +529,8 @@ enum damon_ops_id {
  * @apply_scheme is called from @kdamond when a region for user provided
  * DAMON-based operation scheme is found.  It should apply the scheme's action
  * to the region and return bytes of the region that the action is successfully
- * applied.
+ * applied.  It should also report how many bytes of the region has passed
+ * filters (&struct damos_filter) that handled by itself.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup is called from @kdamond just before its termination.
@@ -546,7 +547,7 @@ struct damon_operations {
 			struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
-			struct damos *scheme);
+			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
--- a/mm/damon/core.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/core.c
@@ -1523,6 +1523,7 @@ static void damos_apply_scheme(struct da
 	unsigned long sz = damon_sz_region(r);
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
+	unsigned long sz_ops_filter_passed = 0;
 	int err = 0;
 	/*
 	 * We plan to support multiple context per kdamond, as DAMON sysfs
@@ -1568,7 +1569,8 @@ static void damos_apply_scheme(struct da
 		if (!err) {
 			trace_damos_before_apply(cidx, sidx, tidx, r,
 					damon_nr_regions(t), do_trace);
-			sz_applied = c->ops.apply_scheme(c, t, r, s);
+			sz_applied = c->ops.apply_scheme(c, t, r, s,
+					&sz_ops_filter_passed);
 		}
 		damos_walk_call_walk(c, t, r, s);
 		ktime_get_coarse_ts64(&end);
--- a/mm/damon/paddr.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/paddr.c
@@ -477,7 +477,7 @@ put_folio:
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damos *scheme, unsigned long *sz_filter_passed)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes
+++ a/mm/damon/vaddr.c
@@ -655,7 +655,7 @@ static unsigned long damos_madvise(struc
 
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damos *scheme, unsigned long *sz_filter_passed)
 {
 	int madv_action;
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

