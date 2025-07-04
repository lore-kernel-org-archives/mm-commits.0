Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118611991D2
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 22:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751668569; cv=none; b=gNlJONZwECCbXrnZg/8Nq8v87N6MKMPDTgS2CBb6TVk87lO5a1cw0a4KDoyBjvgFzRr1BP6OeA7ywD88xmOf1E7TpzPGqO8FuyhVJsiexDxD6y28gmibC2c6IlRmoTvgd9s55KggacvCK5x8JAz0BjJDoKsEFG+dotT7kfJQTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751668569; c=relaxed/simple;
	bh=03eGHD+xJ7HP1naImms1Ox46NN6xpikMg4//rw6kyQQ=;
	h=Date:To:From:Subject:Message-Id; b=gmcnS4PYTjVUN4ls4LEbQeUiUAPtpF0Nq1Jg/x65sSq3a4tQMDEJHTZDncGLNWSROSQJI6i5dOT4HCOOadSIqKUEDYraXsGjqraDNE83myWcsYzPaWF9jtl8VAzEGb5qyqhstn0tmQ3XhWBgH8YL0V0I1MzKIBwS226psQHX+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jF5g3c2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jF5g3c2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81184C4CEE3;
	Fri,  4 Jul 2025 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751668568;
	bh=03eGHD+xJ7HP1naImms1Ox46NN6xpikMg4//rw6kyQQ=;
	h=Date:To:From:Subject:From;
	b=jF5g3c2RWMUqMqWn5uWWT9uAGUcFlaxc7IgpksOwD2P6maGYlJ6MBjU7cycUedrPB
	 Ln2ZCniIktsESV4MT+nUtzjeM7nWUB/WgOdTKnjabecTxGnIfxNPvH0KW3bAVxTuuq
	 QEh52F9aBb3h5AyYP/ODsvThXUo81Hw3YmlC9IHQ=
Date: Fri, 04 Jul 2025 15:36:08 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-trace-event-for-effective-size-quota.patch added to mm-new branch
Message-Id: <20250704223608.81184C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add trace event for effective size quota
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-add-trace-event-for-effective-size-quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-trace-event-for-effective-size-quota.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add trace event for effective size quota
Date: Fri, 4 Jul 2025 15:14:08 -0700

Aim-oriented DAMOS quota auto-tuning is an important and recommended
feature for DAMOS users.  Add a trace event for the observability of the
tuned quota and tuning itself.

Link: https://lkml.kernel.org/r/20250704221408.38510-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   26 ++++++++++++++++++++++++++
 mm/damon/core.c              |   20 +++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-add-trace-event-for-effective-size-quota
+++ a/include/trace/events/damon.h
@@ -9,6 +9,32 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT_CONDITION(damos_esz,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		unsigned long esz, bool do_trace),
+
+	TP_ARGS(context_idx, scheme_idx, esz, do_trace),
+
+	TP_CONDITION(do_trace),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(unsigned long, esz)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->esz = esz;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u esz=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->esz)
+);
+
 TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
--- a/mm/damon/core.c~mm-damon-add-trace-event-for-effective-size-quota
+++ a/mm/damon/core.c
@@ -2011,12 +2011,26 @@ static void damos_set_effective_quota(st
 	quota->esz = esz;
 }
 
+static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
+		struct damos_quota *quota)
+{
+	unsigned int cidx = 0, sidx;
+	struct damos *siter;
+
+	damon_for_each_scheme(siter, c) {
+		if (siter == s)
+			break;
+		sidx++;
+	}
+	trace_damos_esz(cidx, sidx, quota->esz, true);
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long cumulated_sz;
+	unsigned long cumulated_sz, cached_esz;
 	unsigned int score, max_score = 0;
 
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
@@ -2030,7 +2044,11 @@ static void damos_adjust_quota(struct da
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
 		quota->charged_sz = 0;
+		if (trace_damos_esz_enabled())
+			cached_esz = quota->esz;
 		damos_set_effective_quota(quota);
+		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
+			damos_trace_esz(c, s, quota);
 	}
 
 	if (!c->ops.get_scheme_score)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch

