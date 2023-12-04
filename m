Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F077C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjLDTA3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjLDTA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:00:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDAD5
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:00:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB3DC433C7;
        Mon,  4 Dec 2023 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701716434;
        bh=zBfK9FYty5dKvhhYYVxRPe28/YCwqPDKohOQ5alkyaE=;
        h=Date:To:From:Subject:From;
        b=D8aNjH//mX8aucGYYKY/faVjRPEfFIrkMPN8KJL0J7qO64UCoBnp+QZ1Q2WlJy3IL
         HoGVHmLvlgOlkH466vfL9Nf3dotP2qJZt/sJ8EtS4P9UoUxT/LoTMXD4HcbaLlaCK5
         aGQQAtOVCElOtjQkjC4p1jJfSQEOat/9bXJFrhhc=
Date:   Mon, 04 Dec 2023 11:00:33 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, davidgow@google.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch added to mm-unstable branch
Message-Id: <20231204190034.5CB3DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: document get_score_arg field of struct damos_quota
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch

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
Subject: mm/damon: document get_score_arg field of struct damos_quota
Date: Mon, 4 Dec 2023 17:01:06 +0000

Commit 99b36eab9c05 ("mm/damon/core: implement goal-oriented
feedback-driven quota auto-tuning") on mm-unstable missed documenting
'get_score_arg' field of 'struct damos_quota' on the kernel-doc comment. 
Fix it.

Link: https://lkml.kernel.org/r/20231204170106.60992-1-sj@kernel.org
Fixes: 99b36eab9c05 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix
+++ a/include/linux/damon.h
@@ -137,6 +137,7 @@ enum damos_action {
  * @weight_age:		Weight of the region's age for prioritization.
  *
  * @get_score:		Feedback function for self-tuning quota.
+ * @get_score_arg:	Parameter for @get_score
  *
  * To avoid consuming too much CPU time or IO resources for applying the
  * &struct damos->action to large memory, DAMON allows users to set time and/or
@@ -156,10 +157,10 @@ enum damos_action {
  * &weight_nr_accesses, and &weight_age, because monitoring operations are
  * encouraged to respect those.
  *
- * If @get_score function pointer is set, DAMON calls it back and get the
- * return value of it for every @reset_interval.  Then, DAMON adjusts the
- * effective quota using the return value as a feedback score to the current
- * quota, using its internal feedback loop algorithm.
+ * If @get_score function pointer is set, DAMON calls it back with
+ * @get_score_arg and get the return value of it for every @reset_interval.
+ * Then, DAMON adjusts the effective quota using the return value as a feedback
+ * score to the current quota, using its internal feedback loop algorithm.
  *
  * The feedback loop algorithem assumes the quota input and the feedback score
  * output are in a positive proportional relationship, and the goal of the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-sysfs-schemes-add-timeout-for-update_schemes_tried_regions.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

