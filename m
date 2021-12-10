Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52152C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbhLJQyF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbhLJQyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:54:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6834BC061746
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 08:50:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0881CE2C1F
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96BBC00446;
        Fri, 10 Dec 2021 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639155024;
        bh=kzTU6X49jD3QPJ3xmccHSZxG8SYw1OB9nZ34NKccd7M=;
        h=Date:From:To:Subject:From;
        b=yIugxaL1G+Q62pMAdtp9t4qeca2osZE/6WQGBH0Koy7nuGAn3FQ/GkX+ZIlhJgPUM
         /cms0hmHBRxXGMW6AFTihaXZkqJvwh2SGYO9zyRBZbvJR/bRTj4bWwB6BmuWci8wzz
         0K0YaKte7DLJDHk1pExp6Ns+Opx5A4CYisuMWrc0=
Date:   Fri, 10 Dec 2021 08:50:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  + mm-damon-reclaim-provide-reclamation-statistics.patch
 added to -mm tree
Message-ID: <20211210165024.LVQCjJv0j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: provide reclamation statistics
has been added to the -mm tree.  Its filename is
     mm-damon-reclaim-provide-reclamation-statistics.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-reclaim-provide-reclamation-statistics.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-reclaim-provide-reclamation-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: provide reclamation statistics

This commit implements new DAMON_RECLAIM parameters for statistics
reporting.  Those can be used for understanding how DAMON_RECLAIM is
working, and for tuning the other parameters.

Link: https://lkml.kernel.org/r/20211210150016.35349-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-provide-reclamation-statistics
+++ a/mm/damon/reclaim.c
@@ -185,6 +185,36 @@ module_param(monitor_region_end, ulong,
 static int kdamond_pid __read_mostly = -1;
 module_param(kdamond_pid, int, 0400);
 
+/*
+ * Number of memory regions that tried to be reclaimed.
+ */
+static unsigned long nr_reclaim_tried_regions __read_mostly;
+module_param(nr_reclaim_tried_regions, ulong, 0400);
+
+/*
+ * Total bytes of memory regions that tried to be reclaimed.
+ */
+static unsigned long bytes_reclaim_tried_regions __read_mostly;
+module_param(bytes_reclaim_tried_regions, ulong, 0400);
+
+/*
+ * Number of memory regions that successfully be reclaimed.
+ */
+static unsigned long nr_reclaimed_regions __read_mostly;
+module_param(nr_reclaimed_regions, ulong, 0400);
+
+/*
+ * Total bytes of memory regions that successfully be reclaimed.
+ */
+static unsigned long bytes_reclaimed_regions __read_mostly;
+module_param(bytes_reclaimed_regions, ulong, 0400);
+
+/*
+ * Number of times that the time/space quota limits have exceeded
+ */
+static unsigned long nr_quota_exceeds __read_mostly;
+module_param(nr_quota_exceeds, ulong, 0400);
+
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
@@ -333,6 +363,21 @@ static void damon_reclaim_timer_fn(struc
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
+static int damon_reclaim_after_aggregation(struct damon_ctx *c)
+{
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c) {
+		nr_reclaim_tried_regions = s->stat.nr_tried;
+		bytes_reclaim_tried_regions = s->stat.sz_tried;
+		nr_reclaimed_regions = s->stat.nr_applied;
+		bytes_reclaimed_regions = s->stat.sz_applied;
+		nr_quota_exceeds = s->stat.qt_exceeds;
+	}
+	return 0;
+}
+
 static int __init damon_reclaim_init(void)
 {
 	ctx = damon_new_ctx();
@@ -340,6 +385,7 @@ static int __init damon_reclaim_init(voi
 		return -ENOMEM;
 
 	damon_pa_set_primitives(ctx);
+	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	/* 4242 means nothing but fun */
 	target = damon_new_target(4242);
_

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch

