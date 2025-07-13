Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164621CC51
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450112; cv=none; b=Dt1oO9WFaZkoZ5cwTIjwlx0pL1hf+MUXyIdVgf5ZLBC6Jzif20rrDYem9DQHb2gHQ767kWETA2OaEYlX3s35QB4JnCjLedDYnRQ1eas6wNo8SvfIJhlj2DexTKmGiYTJBy9ji6VFxTrd3umQ9cDXMf88T4PAwVf6CeiPyDVu7Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450112; c=relaxed/simple;
	bh=bT6ODPX+lj/g6DcpoJywOFpLEBGxT4Llp1VKr9kygs4=;
	h=Date:To:From:Subject:Message-Id; b=OwOAyD3J4LWNJb6brtdeAEPIx88Ht1x58URnfPHGxGfzKQ530WnAHIQhiqSvCjmgsSrH1fDAtoPKjbe+r/9q0vvM8x1IKnkYf7Nu6K2AmsHo+V36MITWm9VXZaw1SMhCV0Hz5aDF38mP5/j4iaBGTC3B55lFFBPAlH0noq37oCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W2t+MWxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W2t+MWxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8651EC4CEE3;
	Sun, 13 Jul 2025 23:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450112;
	bh=bT6ODPX+lj/g6DcpoJywOFpLEBGxT4Llp1VKr9kygs4=;
	h=Date:To:From:Subject:From;
	b=W2t+MWxDIzBwfA7d5/RZTe2wCs4MR6nQoWMnie/oKoIjGMWNABp3PbgunReqOzDYF
	 R9b7L8VeQxOv+93b9w4K/zL/ZXUzvoxC0evJRKh28NG6UxW/55b8hcI2fSZHcvsaGp
	 exGxYnRHmcg1PJ+Gp48CJjjLe2nCZb+IjUhVbZZs=
Date: Sun, 13 Jul 2025 16:41:52 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-trace-event-for-effective-size-quota.patch removed from -mm tree
Message-Id: <20250713234152.8651EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add trace event for effective size quota
has been removed from the -mm tree.  Its filename was
     mm-damon-add-trace-event-for-effective-size-quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add trace event for effective size quota
Date: Fri, 4 Jul 2025 15:14:08 -0700

Aim-oriented DAMOS quota auto-tuning is an important and recommended
feature for DAMOS users.  Add a trace event for the observability of the
tuned quota and tuning itself.

[sj@kernel.org: initialize sidx in damos_trace_esz()]
  Link: https://lkml.kernel.org/r/20250705172003.52324-1-sj@kernel.org
[sj@kernel.org: make damos_esz unconditional trace event]
  Link: https://lkml.kernel.org/r/20250709182843.35812-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250704221408.38510-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   24 ++++++++++++++++++++++++
 mm/damon/core.c              |   20 +++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-add-trace-event-for-effective-size-quota
+++ a/include/trace/events/damon.h
@@ -9,6 +9,30 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(damos_esz,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		unsigned long esz),
+
+	TP_ARGS(context_idx, scheme_idx, esz),
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
+	unsigned int cidx = 0, sidx = 0;
+	struct damos *siter;
+
+	damon_for_each_scheme(siter, c) {
+		if (siter == s)
+			break;
+		sidx++;
+	}
+	trace_damos_esz(cidx, sidx, quota->esz);
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

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

