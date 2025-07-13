Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD0B21CC51
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450111; cv=none; b=jXkGPKjbDSzj8RYUcK2O/7c8b0v1iqegUkg7CKAPkmBGC0tT7611ygSlVw3OBCJ4KCZFzQcnK6EZVn4bzsTlUrNuh0SDZgPIBcI4AvVW39oOwyuu1kRhoZNmp39q4VnkuOAIWT4LnH8D55hnaZ8L3FwXYnxOipT9zP0kerTwIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450111; c=relaxed/simple;
	bh=5zBS35V7OKwSYEWj9o3WFcYfkjIgDnDNCsLAWXfac+w=;
	h=Date:To:From:Subject:Message-Id; b=Jq6hxSbxEdkbj6MevNvlzIUJ2MmZ3cVdKVKkwtyhBcLKJNwB5EZWkPqS8cKRAnkew05eV8ECZyVHKi7eE8Y2Pnsvm4Io3lz3gfteUS6ESIgRoRQJY0P9oBE7wlr64YPhHSxYs4oEX8zukgnnbO76JUQXswrM+PSbqKQD2/Ma778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzPUnN6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzPUnN6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595E2C4CEE3;
	Sun, 13 Jul 2025 23:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450111;
	bh=5zBS35V7OKwSYEWj9o3WFcYfkjIgDnDNCsLAWXfac+w=;
	h=Date:To:From:Subject:From;
	b=RzPUnN6hOXbBrOtndlLMlFEyAIRRYa0kVAsXviH+dA0DpxzvlnD+qFbhpqjwhG6nc
	 r2kQrnOLsgU0JZ76hKkJcsF0Z5x/vwa+oIydqSZmTAyyh+9BF7RMxR1as5MWqSKcmN
	 q2RKARXzWy/wyhHKfohoTfggM29wn55ZCjRkXeHY=
Date: Sun, 13 Jul 2025 16:41:50 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch removed from -mm tree
Message-Id: <20250713234151.595E2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add trace event for auto-tuned monitoring intervals
has been removed from the -mm tree.  Its filename was
     mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add trace event for auto-tuned monitoring intervals
Date: Fri, 4 Jul 2025 15:14:07 -0700

Patch series "mm/damon: add trace events for auto-tuned monitoring
intervals and DAMOS quota".

The aim-oriented auto-tuning features for monitoring intervals and DAMOS
quota are important and recommended.  Add tracepoints for observabilities
of those tuned values and the tuning itself.


This patch (of 2):

Aim-oriented monitoring intervals auto-tuning is an important and
recommended feature for DAMON users.  Add a trace event for the
observability of the tuned intervals and tuning itself.

Link: https://lkml.kernel.org/r/20250704221408.38510-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250704221408.38510-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   17 +++++++++++++++++
 mm/damon/core.c              |    1 +
 2 files changed, 18 insertions(+)

--- a/include/trace/events/damon.h~mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals
+++ a/include/trace/events/damon.h
@@ -48,6 +48,23 @@ TRACE_EVENT_CONDITION(damos_before_apply
 			__entry->nr_accesses, __entry->age)
 );
 
+TRACE_EVENT(damon_monitor_intervals_tune,
+
+	TP_PROTO(unsigned long sample_us),
+
+	TP_ARGS(sample_us),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, sample_us)
+	),
+
+	TP_fast_assign(
+		__entry->sample_us = sample_us;
+	),
+
+	TP_printk("sample_us=%lu", __entry->sample_us)
+);
+
 TRACE_EVENT(damon_aggregated,
 
 	TP_PROTO(unsigned int target_id, struct damon_region *r,
--- a/mm/damon/core.c~mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals
+++ a/mm/damon/core.c
@@ -1490,6 +1490,7 @@ static void kdamond_tune_intervals(struc
 			new_attrs.sample_interval);
 	new_attrs.aggr_interval = new_attrs.sample_interval *
 		c->attrs.aggr_samples;
+	trace_damon_monitor_intervals_tune(new_attrs.sample_interval);
 	damon_set_attrs(c, &new_attrs);
 }
 
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

