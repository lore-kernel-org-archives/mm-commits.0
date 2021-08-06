Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F48C4338F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF4A611C3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbhHFAmT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 20:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243003AbhHFAmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 20:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF6761186;
        Fri,  6 Aug 2021 00:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628210522;
        bh=8uaJP9wfmn4wbTvDVLpskDRSJODW9WDRHv68mquIMTM=;
        h=Date:From:To:Subject:From;
        b=NQVCP7Pfxh91P+RAbFksPkqNt/u/eaMxPNxr5L0E7i9xfIqOGErQb+WRqAiIFwsVq
         8Bupf+W2QW/fC5PLePyUsKUnIU5jdKd+2hYOsWDQTVWPVSGgUmii8yis0Tkg72yYMC
         sxzGswlqF/TiuZ/latsePlzAw2sKUOxRR+J9/q3k=
Date:   Thu, 05 Aug 2021 17:42:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        sieberf@amazon.com, shuah@kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, rientjes@google.com, riel@surriel.com,
        peterz@infradead.org, namhyung@kernel.org, mingo@redhat.com,
        minchan@kernel.org, mheyne@amazon.de, mgorman@suse.de,
        markubo@amazon.de, Jonathan.Cameron@huawei.com, joe@perches.com,
        gthelen@google.com, greg@kroah.com, foersleo@amazon.de,
        fan.du@intel.com, elver@google.com, dwmw@amazon.com,
        david@redhat.com, corbet@lwn.net, brendanhiggins@google.com,
        benh@kernel.crashing.org, amit@kernel.org,
        alexander.shishkin@linux.intel.com, sjpark@amazon.de
Subject:  + mm-damon-add-a-tracepoint.patch added to -mm tree
Message-ID: <20210806004201.4VACX%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: add a tracepoint
has been added to the -mm tree.  Its filename is
     mm-damon-add-a-tracepoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-a-tracepoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-a-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon: add a tracepoint

This commit adds a tracepoint for DAMON.  It traces the monitoring results
of each region for each aggregation interval.  Using this, DAMON can
easily integrated with tracepoints supporting tools such as perf.

Link: https://lkml.kernel.org/r/20210716081449.22187-7-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Leonard Foerster <foersleo@amazon.de>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Fernand Sieber <sieberf@amazon.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |   43 +++++++++++++++++++++++++++++++++
 mm/damon/core.c              |    7 ++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/include/trace/events/damon.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM damon
+
+#if !defined(_TRACE_DAMON_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_DAMON_H
+
+#include <linux/damon.h>
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(damon_aggregated,
+
+	TP_PROTO(struct damon_target *t, struct damon_region *r,
+		unsigned int nr_regions),
+
+	TP_ARGS(t, r, nr_regions),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, target_id)
+		__field(unsigned int, nr_regions)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, nr_accesses)
+	),
+
+	TP_fast_assign(
+		__entry->target_id = t->id;
+		__entry->nr_regions = nr_regions;
+		__entry->start = r->ar.start;
+		__entry->end = r->ar.end;
+		__entry->nr_accesses = r->nr_accesses;
+	),
+
+	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u",
+			__entry->target_id, __entry->nr_regions,
+			__entry->start, __entry->end, __entry->nr_accesses)
+);
+
+#endif /* _TRACE_DAMON_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/mm/damon/core.c~mm-damon-add-a-tracepoint
+++ a/mm/damon/core.c
@@ -13,6 +13,9 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/damon.h>
+
 /* Get a random number in [l, r) */
 #define damon_rand(l, r) (l + prandom_u32_max(r - l))
 
@@ -387,8 +390,10 @@ static void kdamond_reset_aggregated(str
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
 
-		damon_for_each_region(r, t)
+		damon_for_each_region(r, t) {
+			trace_damon_aggregated(t, r, damon_nr_regions(t));
 			r->nr_accesses = 0;
+		}
 	}
 }
 
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

