Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CB27FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966081; cv=none; b=NtlknCGrD04XEdyTNK4mXNKlFtGJqhhGxO2JIbac3HYv2QypnGRz7ZM8D+EbUOq16mo0DzXwSFNYGOsxavcowBT5g+4C3RFitrStoG+6vjOioX8Mz6hY2++XgHmlvb7lcIiWFb2ukFDAozQxu8Aa878WWbyuekzwQDp5ga1VNIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966081; c=relaxed/simple;
	bh=64REs831HcHswm89gU90sdDriU7R/I6eWRBzW29fNQo=;
	h=Date:To:From:Subject:Message-Id; b=ZY2Akn0Zvxw04Aq3g2yn0OoLQcLb47zGn4R6y0rJmLglVO33tsdaygmgQO2qR5CQXO/JClVwfHsT6kD03S3Yn4aIRzQPn/+lqUrRbfydLrCnFxNP+vGie/c3w4BVKbyTYJIw/ydmJ4RWfBE02OYsrwNiD1K4WDBOCaYpscnwuxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rzchdn63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rzchdn63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225F6C16AAE;
	Wed, 21 Jan 2026 03:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966081;
	bh=64REs831HcHswm89gU90sdDriU7R/I6eWRBzW29fNQo=;
	h=Date:To:From:Subject:From;
	b=Rzchdn63ZnfjTXHGOfqb14eOTfzeL3jSBbCrENVzYC0/LoqOnKYkqULImAwwDFkb+
	 qNcszAaiz0tWNbYE81xONJVadwKqOqjsA2QhPyq7LCKGbnm51hMcDk5gT+kaP2BERx
	 MattXgfgHUkDNDdNVvFph+UCcksWLrfhPOmza0ow=
Date: Tue, 20 Jan 2026 19:28:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch removed from -mm tree
Message-Id: <20260121032801.225F6C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add trace point for damos stat per apply interval
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add trace point for damos stat per apply interval
Date: Tue, 16 Dec 2025 00:01:25 -0800

DAMON users can read DAMOS stats via DAMON sysfs interface.  It enables
efficient, simple and flexible usages of the stats.  Especially for
systems not having advanced tools like perf or bpftrace, that can be
useful.  But if the advanced tools are available, exposing the stats via
tracepoint can reduce unnecessary reimplementation of the wheels.  Add a
new tracepoint for DAMOS stats, namely damos_stat_after_apply_interval. 
The tracepoint is triggered for each scheme's apply interval and exposes
the whole stat values.  If the user needs sub-apply interval information
for any chance, damos_before_apply tracepoint could be used.

Link: https://lkml.kernel.org/r/20251216080128.42991-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   41 +++++++++++++++++++++++++++++++++
 mm/damon/core.c              |   17 +++++++++++++
 2 files changed, 58 insertions(+)

--- a/include/trace/events/damon.h~mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval
+++ a/include/trace/events/damon.h
@@ -9,6 +9,47 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(damos_stat_after_apply_interval,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		struct damos_stat *stat),
+
+	TP_ARGS(context_idx, scheme_idx, stat),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(unsigned long, nr_tried)
+		__field(unsigned long, sz_tried)
+		__field(unsigned long, nr_applied)
+		__field(unsigned long, sz_applied)
+		__field(unsigned long, sz_ops_filter_passed)
+		__field(unsigned long, qt_exceeds)
+		__field(unsigned long, nr_snapshots)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->nr_tried = stat->nr_tried;
+		__entry->sz_tried = stat->sz_tried;
+		__entry->nr_applied = stat->nr_applied;
+		__entry->sz_applied = stat->sz_applied;
+		__entry->sz_ops_filter_passed = stat->sz_ops_filter_passed;
+		__entry->qt_exceeds = stat->qt_exceeds;
+		__entry->nr_snapshots = stat->nr_snapshots;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
+			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
+			"qt_exceeds=%lu nr_snapshots=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->nr_tried, __entry->sz_tried,
+			__entry->nr_applied, __entry->sz_applied,
+			__entry->sz_ops_filter_passed, __entry->qt_exceeds,
+			__entry->nr_snapshots)
+);
+
 TRACE_EVENT(damos_esz,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
--- a/mm/damon/core.c~mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval
+++ a/mm/damon/core.c
@@ -2289,6 +2289,22 @@ static void damos_adjust_quota(struct da
 	quota->min_score = score;
 }
 
+static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
+{
+	unsigned int cidx = 0, sidx = 0;
+	struct damos *siter;
+
+	if (!trace_damos_stat_after_apply_interval_enabled())
+		return;
+
+	damon_for_each_scheme(siter, c) {
+		if (siter == s)
+			break;
+		sidx++;
+	}
+	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -2330,6 +2346,7 @@ static void kdamond_apply_schemes(struct
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
+		damos_trace_stat(c, s);
 	}
 	mutex_unlock(&c->walk_control_lock);
 }
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

