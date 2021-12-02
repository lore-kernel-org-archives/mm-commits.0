Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF778C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355227AbhLBDp6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355256AbhLBDoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:44:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DFFC061758
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A26AB8221B
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D509BC00446;
        Thu,  2 Dec 2021 03:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416438;
        bh=sqQIbrgH1rvmE2Wzmc3WPK6Yvq0Wp3UXMamJkn7mUKk=;
        h=Date:From:To:Subject:From;
        b=l5KtJETrTx46bnMdWmSv0fYtvJt7BieOvD/Vtlf7JL641ZtoOwBSFNsCASZvRrJJ1
         NcNq/7sjXBTkv5MbWUQKjvfydcsSblGVnB/ciHSJNtHRYBqfTF/d+b0Z3TFmDT+b9Q
         gXPScl/sdoLDYnr758UmK3TJGVq6hXGxcP7+hmEs=
Date:   Wed, 01 Dec 2021 19:40:37 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  + selftests-damon-skip-test-if-damon-is-running.patch
 added to -mm tree
Message-ID: <20211202034037.z6eOH1FvU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: skip test if DAMON is running
has been added to the -mm tree.  Its filename is
     selftests-damon-skip-test-if-damon-is-running.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-skip-test-if-damon-is-running.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-skip-test-if-damon-is-running.patch

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
Subject: selftests/damon: skip test if DAMON is running

Testing the DAMON debugfs files while DAMON is running makes no sense, as
any write to the debugfs files will fails.  This commit makes the test be
skipped in the case.

Link: https://lkml.kernel.org/r/20211201150440.1088-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-skip-test-if-damon-is-running
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -44,6 +44,15 @@ test_content() {
 
 source ./_chk_dependency.sh
 
+ksft_skip=4
+
+damon_onoff="$DBGFS/monitor_on"
+if [ $(cat "$damon_onoff") = "on" ]
+then
+	echo "monitoring is on"
+	exit $ksft_skip
+fi
+
 # Test attrs file
 # ===============
 
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

