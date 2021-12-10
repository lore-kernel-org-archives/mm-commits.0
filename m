Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16826C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244162AbhLJQyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:54:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59928 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbhLJQyB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:54:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C86CCE2C1E
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73AFC341C6;
        Fri, 10 Dec 2021 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639155022;
        bh=g+6T5OOumwr9fEmmOFxmNDvATSokm+t4dcz/+9Naoqw=;
        h=Date:From:To:Subject:From;
        b=PnchjW88f9jGGKpLyQJok8GnJ575MnVS8TbmqN/HKTMUXqQ3Hc7SoWjX6EZXfddia
         +xTS1o4k2iiM4DzEg26VrgxzkqIMmBLg6OZieUoovoPA9GfS/9ItUuw+74tOQYQopq
         n6LD3eGB4/OlmxrUsmgKZOaowBh6miE+c7pkGBBM=
Date:   Fri, 10 Dec 2021 08:50:22 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
 added to -mm tree
Message-ID: <20211210165022.YTVF0m1Da%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: account how many times quota limit has exceeded
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch

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
Subject: mm/damon/schemes: account how many times quota limit has exceeded

If the time/space quotas of a given DAMON-based operation scheme is too
small, the scheme could show unexpectedly slow progress.  However, there
is no good way to notice the case in runtime.  This commit extends the
DAMOS stat to provide how many times the quota limits exceeded so that the
users can easily notice the case and tune the scheme.

Link: https://lkml.kernel.org/r/20211210150016.35349-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/damon.h~mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded
+++ a/include/linux/damon.h
@@ -198,12 +198,14 @@ struct damos_watermarks {
  * @sz_tried:	Total size of regions that the scheme is tried to be applied.
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
+ * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  */
 struct damos_stat {
 	unsigned long nr_tried;
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long qt_exceeds;
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded
+++ a/mm/damon/core.c
@@ -693,6 +693,8 @@ static void kdamond_apply_schemes(struct
 		if (time_after_eq(jiffies, quota->charged_from +
 					msecs_to_jiffies(
 						quota->reset_interval))) {
+			if (quota->esz && quota->charged_sz >= quota->esz)
+				s->stat.qt_exceeds++;
 			quota->total_charged_sz += quota->charged_sz;
 			quota->charged_from = jiffies;
 			quota->charged_sz = 0;
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

