Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C6835CBBF
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966075; cv=none; b=jTrNhPCm7wgo2APhQZ7DK/Lz9XD6QSjo0Ul+46vYjiHJHxitjOfSR30/IkNPh0rzuwqjD1l6pdFeerFUuVQrxvYPk0U6ybEg1Get9Wjg8rdIfOhgNd4vSrimGW7ZigFGQqpF2UYtFiFJq4TX3jE1BJi0APyHsDeirSoiRCUTfkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966075; c=relaxed/simple;
	bh=v7z6m6Y1n3Ib/Flq/0pMp0klVpPPC9xbfO4dPLYhhlk=;
	h=Date:To:From:Subject:Message-Id; b=e8cNhlMjO9kBql4wVOmb85Lu5Fx3b/GdLgFpeop6ZwKG8+5/K5hhz3F0/GxRU/fisL4SyiXIJ3vYWK7W6o2zUOjKUfntybhTy3P3SYBsdC5X6Bzne7XvEIpxRnNBoZlC0ctTzuD2RUUUWKOvz2jQzxpkadCYO9TY6d5KjtQo+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wyUPp89+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wyUPp89+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA015C16AAE;
	Wed, 21 Jan 2026 03:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966074;
	bh=v7z6m6Y1n3Ib/Flq/0pMp0klVpPPC9xbfO4dPLYhhlk=;
	h=Date:To:From:Subject:From;
	b=wyUPp89+ht2N3dd15GqEwVod+jpEyqJiinKHBNgg2irmCYd3hGqenZ67U2mRk3BER
	 FX3iPACnIMmwPf/ZarZ4cEZI6QyScuxQJ7ziubkC4z1cr7wf4bGlX7ixKyd9LeafAi
	 MK1Oefey7aMXv1EYJt1ukctgTDLM+IAUsrmcV7ZI=
Date: Tue, 20 Jan 2026 19:27:54 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-max_nr_snapshots.patch removed from -mm tree
Message-Id: <20260121032754.DA015C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement max_nr_snapshots
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-max_nr_snapshots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:20 -0800

There are DAMOS use cases that require user-space centric control of its
activation and deactivation.  Having the control plane on the user-space,
or using DAMOS as a way for monitoring results collection are such
examples.

DAMON parameters online commit, DAMOS quotas and watermarks can be useful
for this purpose.  However, those features work only at the
sub-DAMON-snapshot level.  In some use cases, the DAMON-snapshot level
control is required.  For example, in DAMOS-based monitoring results
collection use case, the user online-installs a DAMOS scheme with
DAMOS_STAT action, wait it be applied to whole regions of a single
DAMON-snapshot, retrieves the stats and tried regions information, and
online-uninstall the scheme.  It is efficient to ensure the lifetime of
the scheme as no more no less one snapshot consumption.

To support such use cases, introduce a new DAMOS core API per-scheme
parameter, namely max_nr_snapshots.  As the name implies, it is the upper
limit of nr_snapshots, which is a DAMOS stat that represents the number of
DAMON-snapshots that the scheme has fully applied.  If the limit is set
with a non-zero value and nr_snapshots reaches or exceeds the limit, the
scheme is deactivated.

Link: https://lkml.kernel.org/r/20251216080128.42991-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |   11 ++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-implement-max_nr_snapshots
+++ a/include/linux/damon.h
@@ -499,6 +499,7 @@ struct damos_migrate_dests {
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
+ * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
  * @list:		List head for siblings.
  *
  * For each @apply_interval_us, DAMON finds regions which fit in the
@@ -533,6 +534,9 @@ struct damos_migrate_dests {
  * finished.
  *
  * After applying the &action to each region, &stat is updated.
+ *
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * greater than it, the scheme is deactivated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
@@ -567,6 +571,7 @@ struct damos {
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
+	unsigned long max_nr_snapshots;
 	struct list_head list;
 };
 
--- a/mm/damon/core.c~mm-damon-core-implement-max_nr_snapshots
+++ a/mm/damon/core.c
@@ -401,6 +401,7 @@ struct damos *damon_new_scheme(struct da
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
+	scheme->max_nr_snapshots = 0;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
@@ -1078,7 +1079,11 @@ static int damos_commit(struct damos *ds
 		return err;
 
 	err = damos_commit_filters(dst, src);
-	return err;
+	if (err)
+		return err;
+
+	dst->max_nr_snapshots = src->max_nr_snapshots;
+	return 0;
 }
 
 static int damon_commit_schemes(struct damon_ctx *dst, struct damon_ctx *src)
@@ -1984,6 +1989,10 @@ static void damon_do_apply_schemes(struc
 		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
 			continue;
 
+		if (s->max_nr_snapshots &&
+				s->max_nr_snapshots <= s->stat.nr_snapshots)
+			continue;
+
 		if (damos_valid_target(c, t, r, s))
 			damos_apply_scheme(c, t, r, s);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

