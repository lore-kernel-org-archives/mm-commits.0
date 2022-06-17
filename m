Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C37C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379706AbiFQCM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiFQCMS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D396664BDC
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E01E61C61
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDAAC34114;
        Fri, 17 Jun 2022 02:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431936;
        bh=MdK/ELr36KNX8Bow28k5nt+ObN1Zs7rh3HQzza2Bk4s=;
        h=Date:To:From:Subject:From;
        b=KgF1hwUNIxb3u45DBTQtTIsDOh3FfXhDookVes3nw3Nq8tUjsUHGYfLhhmasBoZTq
         Qp8kzjmyqdQnJy5O3DsRfRXfux1WeM8Io1jr7nhCcf0awV64JRpHLe1AyQA9SfFQab
         A9f8SWmE6sbJeswe9j5tCeXK/8hnkR/dx18yDcng=
Date:   Thu, 16 Jun 2022 19:12:16 -0700
To:     mm-commits@vger.kernel.org, tuhailong@gmail.com,
        gwhite@kupulau.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch removed from -mm tree
Message-Id: <20220617021216.BFDAAC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: schedule 'damon_reclaim_timer' only after 'system_wq' is initialized
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: schedule 'damon_reclaim_timer' only after 'system_wq' is initialized
Date: Sat, 4 Jun 2022 19:50:51 +0000

Commit 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays
active") made DAMON_RECLAIM's 'enabled' parameter store callback,
'enabled_store()', to schedule 'damon_reclaim_timer'.  The scheduling uses
'system_wq', which is initialized in 'workqueue_init_early()'.  As kernel
parameters parsing function ('parse_args()') is called before
'workqueue_init_early()', 'enabled_store()' can be executed before
'workqueue_init_early()' and end up accessing the uninitialized
'system_wq'.  As a result, the booting hang[1].  This commit fixes the
issue by checking if the initialization is done before scheduling the
timer.

[1] https://lkml.kernel.org/20220604192222.1488-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20220604195051.1589-1-sj@kernel.org
Fixes: 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays active")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Greg White <gwhite@kupulau.com>
Cc: Hailong Tu <tuhailong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized
+++ a/mm/damon/reclaim.c
@@ -374,6 +374,8 @@ static void damon_reclaim_timer_fn(struc
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
+static bool damon_reclaim_initialized;
+
 static int enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
@@ -382,6 +384,10 @@ static int enabled_store(const char *val
 	if (rc < 0)
 		return rc;
 
+	/* system_wq might not initialized yet */
+	if (!damon_reclaim_initialized)
+		return rc;
+
 	if (enabled)
 		schedule_delayed_work(&damon_reclaim_timer, 0);
 
@@ -449,6 +455,8 @@ static int __init damon_reclaim_init(voi
 	damon_add_target(ctx, target);
 
 	schedule_delayed_work(&damon_reclaim_timer, 0);
+
+	damon_reclaim_initialized = true;
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

