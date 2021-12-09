Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537D6C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhLIUf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:35:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34428 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIUf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:35:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4044EB82410
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C0C004DD;
        Thu,  9 Dec 2021 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639081942;
        bh=hofrRLNhVsXdZYBLyk1tJxzpgOSVSV7U3hnH+8gX/Jw=;
        h=Date:From:To:Subject:From;
        b=rC3v5oXDrb3o9gxkwT0P3Lkgt/Xuq3tQxE0ZQMMDooxG5Mt6iF5/VwBAAd2J4/n6b
         XanBOLPYFQ3hY9w4ucf+81wyrQniHf3eEtJMHl+Ze91NHLd7BlYQcsim/0l4XfMZdL
         KTddteqX2RBieNNc4huiyxvdUaKai0sCHZBnJzNo=
Date:   Thu, 09 Dec 2021 12:32:21 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-convert-macro-functions-to-static-inline-functions.patch added to
 -mm tree
Message-ID: <20211209203221.YUEBhvDSd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: convert macro functions to static inline functions
has been added to the -mm tree.  Its filename is
     mm-damon-convert-macro-functions-to-static-inline-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-convert-macro-functions-to-static-inline-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-convert-macro-functions-to-static-inline-functions.patch

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
Subject: mm/damon: convert macro functions to static inline functions

Patch series "mm/damon: Misc cleanups".

This patchset contains miscellaneous cleanups for DAMON's macro
functions and documentation.


This patch (of 6):

This commit converts macro functions in DAMON to static inline functions,
for better type checking, code documentation, etc[1].

[1] https://lore.kernel.org/linux-mm/20211202151213.6ec830863342220da4141bc5@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211209131806.19317-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211209131806.19317-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   18 ++++++++++++------
 mm/damon/core.c       |    5 ++++-
 mm/damon/vaddr.c      |    6 ++++--
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/include/linux/damon.h
@@ -399,14 +399,20 @@ struct damon_ctx {
 	struct list_head schemes;
 };
 
-#define damon_next_region(r) \
-	(container_of(r->list.next, struct damon_region, list))
+static inline struct damon_region *damon_next_region(struct damon_region *r)
+{
+	return container_of(r->list.next, struct damon_region, list);
+}
 
-#define damon_prev_region(r) \
-	(container_of(r->list.prev, struct damon_region, list))
+static inline struct damon_region *damon_prev_region(struct damon_region *r)
+{
+	return container_of(r->list.prev, struct damon_region, list);
+}
 
-#define damon_last_region(t) \
-	(list_last_entry(&t->regions_list, struct damon_region, list))
+static inline struct damon_region *damon_last_region(struct damon_target *t)
+{
+	return list_last_entry(&t->regions_list, struct damon_region, list);
+}
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
--- a/mm/damon/core.c~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/mm/damon/core.c
@@ -729,7 +729,10 @@ static void kdamond_apply_schemes(struct
 	}
 }
 
-#define sz_damon_region(r) (r->ar.end - r->ar.start)
+static inline unsigned long sz_damon_region(struct damon_region *r)
+{
+	return r->ar.end - r->ar.start;
+}
 
 /*
  * Merge two adjacent regions into one region
--- a/mm/damon/vaddr.c~mm-damon-convert-macro-functions-to-static-inline-functions
+++ a/mm/damon/vaddr.c
@@ -25,8 +25,10 @@
  * 't->id' should be the pointer to the relevant 'struct pid' having reference
  * count.  Caller must put the returned task, unless it is NULL.
  */
-#define damon_get_task_struct(t) \
-	(get_pid_task((struct pid *)t->id, PIDTYPE_PID))
+static inline struct task_struct *damon_get_task_struct(struct damon_target *t)
+{
+	return get_pid_task((struct pid *)t->id, PIDTYPE_PID);
+}
 
 /*
  * Get the mm_struct of the given target
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

