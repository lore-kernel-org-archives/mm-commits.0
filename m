Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27F1E7C4F6
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjJDUWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244869AbjJDUW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEA41717
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59AFC433C9;
        Wed,  4 Oct 2023 20:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450880;
        bh=7WZX6lS2FKOzen6APo0aVaqzIZZa4FLthY4BvKRMz7w=;
        h=Date:To:From:Subject:From;
        b=y0w0Zarj2MQ5A9IC5k2bb+MOGMdBI6M/p/6Pu9/QoxzXMs/TZtZB+tixaJG79T9RA
         Z5Axx8ihigIoVDRXjcGVkmJCn86fW6nEgEwyCt8rujHPsje4SOFdErxIlhEvRp2306
         /aKWMcYCtDnr+ZQFv5olPLvcEKRbpuLmG5X5xrjo=
Date:   Wed, 04 Oct 2023 13:21:18 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch removed from -mm tree
Message-Id: <20231004202119.D59AFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: add a tracepoint for damos apply target regions
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add a tracepoint for damos apply target regions
Date: Wed, 13 Sep 2023 02:20:49 +0000

Patch series "mm/damon: add a tracepoint for damos apply target regions",
v2.

DAMON provides damon_aggregated tracepoint to let users record full
monitoring results.  Sometimes, users need to record monitoring results of
specific pattern.  DAMOS tried regions directory of DAMON sysfs interface
allows it, but the interface is mainly designed for snapshots and
therefore would be inefficient for such recording.  Implement yet another
tracepoint for efficient support of the usecase.


This patch (of 2):

DAMON provides damon_aggregated tracepoint, which exposes details of each
region and its access monitoring results.  It is useful for getting whole
monitoring results, e.g., for recording purposes.

For investigations of DAMOS, DAMON Sysfs interface provides DAMOS
statistics and tried_regions directory.  But, those provides only
statistics and snapshots.  If the scheme is frequently applied and if the
user needs to know every detail of DAMOS behavior, the snapshot-based
interface could be insufficient and expensive.

As a last resort, userspace users need to record the all monitoring
results via damon_aggregated tracepoint and simulate how DAMOS would
worked.  It is unnecessarily complicated.  DAMON kernel API users,
meanwhile, can do that easily via before_damos_apply() callback field of
'struct damon_callback', though.

Add a tracepoint that will be called just after before_damos_apply()
callback for more convenient investigations of DAMOS.  The tracepoint
exposes all details about each regions, similar to damon_aggregated
tracepoint.

Please note that DAMOS is currently not only for memory management but
also for query-like efficient monitoring results retrievals (when 'stat'
action is used).  Until now, only statistics or snapshots were supported. 
Addition of this tracepoint allows efficient full recording of DAMOS-based
filtered monitoring results.

Link: https://lkml.kernel.org/r/20230913022050.2109-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230913022050.2109-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>	[tracing]
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   39 +++++++++++++++++++++++++++++++++
 mm/damon/core.c              |   32 ++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions
+++ a/include/trace/events/damon.h
@@ -9,6 +9,45 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT_CONDITION(damos_before_apply,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		unsigned int target_idx, struct damon_region *r,
+		unsigned int nr_regions, bool do_trace),
+
+	TP_ARGS(context_idx, target_idx, scheme_idx, r, nr_regions, do_trace),
+
+	TP_CONDITION(do_trace),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(unsigned long, target_idx)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, nr_accesses)
+		__field(unsigned int, age)
+		__field(unsigned int, nr_regions)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->target_idx = target_idx;
+		__entry->start = r->ar.start;
+		__entry->end = r->ar.end;
+		__entry->nr_accesses = r->nr_accesses;
+		__entry->age = r->age;
+		__entry->nr_regions = nr_regions;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u target_idx=%lu nr_regions=%u %lu-%lu: %u %u",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->target_idx, __entry->nr_regions,
+			__entry->start, __entry->end,
+			__entry->nr_accesses, __entry->age)
+);
+
 TRACE_EVENT(damon_aggregated,
 
 	TP_PROTO(unsigned int target_id, struct damon_region *r,
--- a/mm/damon/core.c~mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions
+++ a/mm/damon/core.c
@@ -950,6 +950,33 @@ static void damos_apply_scheme(struct da
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
 	int err = 0;
+	/*
+	 * We plan to support multiple context per kdamond, as DAMON sysfs
+	 * implies with 'nr_contexts' file.  Nevertheless, only single context
+	 * per kdamond is supported for now.  So, we can simply use '0' context
+	 * index here.
+	 */
+	unsigned int cidx = 0;
+	struct damos *siter;		/* schemes iterator */
+	unsigned int sidx = 0;
+	struct damon_target *titer;	/* targets iterator */
+	unsigned int tidx = 0;
+	bool do_trace = false;
+
+	/* get indices for trace_damos_before_apply() */
+	if (trace_damos_before_apply_enabled()) {
+		damon_for_each_scheme(siter, c) {
+			if (siter == s)
+				break;
+			sidx++;
+		}
+		damon_for_each_target(titer, c) {
+			if (titer == t)
+				break;
+			tidx++;
+		}
+		do_trace = true;
+	}
 
 	if (c->ops.apply_scheme) {
 		if (quota->esz && quota->charged_sz + sz > quota->esz) {
@@ -964,8 +991,11 @@ static void damos_apply_scheme(struct da
 		ktime_get_coarse_ts64(&begin);
 		if (c->callback.before_damos_apply)
 			err = c->callback.before_damos_apply(c, t, r, s);
-		if (!err)
+		if (!err) {
+			trace_damos_before_apply(cidx, sidx, tidx, r,
+					damon_nr_regions(t), do_trace);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
+		}
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
_

Patches currently in -mm which might be from sj@kernel.org are


