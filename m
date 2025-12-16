Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363C333E360
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911508; cv=none; b=j10bO23KHL3kHVRvehfrLz9CRVmRxLnlL80UVuYT0H9REgWknJJyJX0GgiQGlx2Z2dF8Qce4v2UTyfffCs23AyvvVCCAfkUg0CIwR0zFCQ/kD8K0D756FikNuSnN2zbyGVL3fKn3nDeznYfAqYUz/UMV4dbLUL4O7Hhzavn/bBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911508; c=relaxed/simple;
	bh=17Y0XT4rn56l/CSrtRFpuCgfIQ6mkHig+JSTSUgZNRs=;
	h=Date:To:From:Subject:Message-Id; b=INPOgdfTvv4fuPoqdyPlSKgTTYr9/59Lv92mRB7NHM8R1MwErcPUn2OzRdoHnc519N+cb8sU5hR7BTgdeN6sTOeRtQBJGByD+u/DTJrUXkJbOwLwAidExR56wnacz+UsfSJcanqn5KIGwT9dsd6vMXWXGRoRA0xFC7IZlp6fMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGd9fxDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGd9fxDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F57C4CEF1;
	Tue, 16 Dec 2025 18:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911508;
	bh=17Y0XT4rn56l/CSrtRFpuCgfIQ6mkHig+JSTSUgZNRs=;
	h=Date:To:From:Subject:From;
	b=yGd9fxDpsCANJ5eND3CK04VW3QZkt4pyGK7Wix5PcHodpOhSvBpjEpd9A/nMONLHe
	 p6u1emgT94dmN3CNFXMZJ/Zx8WePaMnpm4/P4Y//0AyoEYzxPEOUCTT/ol+Fur7jhB
	 dcUB7Je9DMhwxNH8zYKG+oQT1Uai3/O9782k7agE=
Date: Tue, 16 Dec 2025 10:58:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch added to mm-new branch
Message-Id: <20251216185828.07F57C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add trace point for damos stat per apply interval
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
@@ -2256,6 +2256,22 @@ static void damos_adjust_quota(struct da
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
@@ -2297,6 +2313,7 @@ static void kdamond_apply_schemes(struct
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
+		damos_trace_stat(c, s);
 	}
 	mutex_unlock(&c->walk_control_lock);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

