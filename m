Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A881991D2
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 22:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751668566; cv=none; b=YPkNZNRf+ywU5SGXc7YcvKkD2csYf/Zs4vcD3YvbxbdA+Fus4HyJW1D1TFExT0Pb9Fqss7nyIvjp/HLDdirktryU+rD44UwXlrwNmCHWDB/WGPzGtVQpFCFN0PONQUFlB44gsi7+JcIE8pEyQvCZ6YxVoKY1j7QW4AUuFJcbSOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751668566; c=relaxed/simple;
	bh=Rkv83vE3mrtzSR41Lg5Hzn0qNeaaSG1H/1c5PrcaRXo=;
	h=Date:To:From:Subject:Message-Id; b=tvw0TJ4uvurNcbGVpOgZZTN3Ekr0s7Bo2cjcNPsRF6wbzEp359h6LGNoeND7zBv/6yeRZ/zO5Si1okAXskbiI8ATf7j04WGNprDP1ueGEKHybfp7ESFKUQMIP+NxOHJs6FRdZ2pzFzN7RdCFtz+srSLVZZ5KY0B5b37aEG+Fi0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dn7UXCvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dn7UXCvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAB2C4CEE3;
	Fri,  4 Jul 2025 22:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751668566;
	bh=Rkv83vE3mrtzSR41Lg5Hzn0qNeaaSG1H/1c5PrcaRXo=;
	h=Date:To:From:Subject:From;
	b=dn7UXCvG+RKldK0CYecg/aVPJrpWndAulzCMBGDjX8HpUy8MuOhHTPZe9k7MljmIX
	 ZirKwb3qewiZ/8NmA4Ry9HweTpUa2QCejgrwEfFxcNTSbiW8zBn4ggpVAyOyh1hy/S
	 Fs1fpYEV5j0HeLe4mLKlcD6vXW8+m3b+CQdV/5ew=
Date: Fri, 04 Jul 2025 15:36:05 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch added to mm-new branch
Message-Id: <20250704223606.2AAB2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add trace event for auto-tuned monitoring intervals
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch

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

