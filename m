Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D305AC10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377134AbjK3WXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377137AbjK3WXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:23:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CC410DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:23:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A41C433CA;
        Thu, 30 Nov 2023 22:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701382999;
        bh=qlGngESKS7xifJjjmB9xip0068d9Jj5HKRXvQVqNBaE=;
        h=Date:To:From:Subject:From;
        b=aq8vjIJUZn5glR468oOvNnWe+/Lh5C6e1UHxlgFdzRICG+e/V/6tu8iLg6T7Z4Zda
         2jJNIRBt/GliI7/gTqIwsojNcOHJbZ34B8phnQrbACkXCmDUl5otmnCUxokGqLUOhk
         /bcwE1vhTdSC4APdT/g9wvrIzOD+22RY27M4qs0M=
Date:   Thu, 30 Nov 2023 14:23:18 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch added to mm-unstable branch
Message-Id: <20231130222319.03A41C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS
Date: Thu, 30 Nov 2023 02:36:46 +0000

Make DAMON sysfs interface to read the user inputs for DAMOS quota goals
and pass those to DAMOS, so that the users can use the quota auto-tuning
feature.  It uses the DAMON sysfs interface's user input commit mechanism,
which applies all user inputs for initial starting of DAMON and online
input updates, which can be done by writing 'on' and 'commit' to the
kdamond's 'state' file, respectively.  In other words, the user should
periodically write appropriate value to 'current_value' files and 'commit'
command to the 'state' file.  'target_value' files could also be similarly
updated at any time.

Note that the interface is supporting multiple goals while the core logic
supports only one goal.  DAMON sysfs interface passes only best feedback
among the given inputs, to avoid making DAMOS too aggressive.

Link: https://lkml.kernel.org/r/20231130023652.50284-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos
+++ a/mm/damon/sysfs-schemes.c
@@ -1868,6 +1868,34 @@ static int damon_sysfs_set_scheme_filter
 	return 0;
 }
 
+static unsigned long damos_sysfs_get_quota_score(void *arg)
+{
+	return (unsigned long)arg;
+}
+
+static void damos_sysfs_set_quota_score(
+		struct damos_sysfs_quota_goals *sysfs_goals,
+		struct damos_quota *quota)
+{
+	struct damos_sysfs_quota_goal *sysfs_goal;
+	int i;
+
+	quota->get_score = NULL;
+	quota->get_score_arg = (void *)0;
+	for (i = 0; i < sysfs_goals->nr; i++) {
+		sysfs_goal = sysfs_goals->goals_arr[i];
+		if (!sysfs_goal->target_value)
+			continue;
+
+		/* Higher score makes scheme less aggressive */
+		quota->get_score_arg = (void *)max(
+				(unsigned long)quota->get_score_arg,
+				sysfs_goal->current_value * 10000 /
+				sysfs_goal->target_value);
+		quota->get_score = damos_sysfs_get_quota_score;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
@@ -1905,6 +1933,8 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
+	damos_sysfs_set_quota_score(sysfs_quotas->goals, &quota);
+
 	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
 			sysfs_scheme->apply_interval_us, &quota, &wmarks);
 	if (!scheme)
@@ -1945,6 +1975,8 @@ static void damon_sysfs_update_scheme(st
 	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
 	scheme->quota.weight_age = sysfs_weights->age;
 
+	damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+
 	scheme->wmarks.metric = sysfs_wmarks->metric;
 	scheme->wmarks.interval = sysfs_wmarks->interval_us;
 	scheme->wmarks.high = sysfs_wmarks->high;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

