Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178D5C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiKIBmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiKIBkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A2E686B2
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CAC2B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A6AC433C1;
        Wed,  9 Nov 2022 01:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957992;
        bh=d2KXijOQ8jeBTSkt7vui4q6lT4qBmMRvjcCl/DYmpXs=;
        h=Date:To:From:Subject:From;
        b=aZm6auat4CKcHLmGEdoSeXDz0bZnbUkbZ3iEWWM/cEBlhbtv09apUUXc0V7uxEzKG
         lZLUOX4ZkweXYJG+IBJMlZpGj1Sgxqy3cbPZwhQMzsoKQqgFD/UwgaYDkxWPwGoTdn
         xNPDqHzFUmFFcRcXM0h17jBZXEeVwI67BV3PKejo=
Date:   Tue, 08 Nov 2022 17:39:51 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch removed from -mm tree
Message-Id: <20221109013952.29A6AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: add tests for DAMON_RECLAIM's enabled parameter
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add tests for DAMON_RECLAIM's enabled parameter
Date: Tue, 25 Oct 2022 17:36:48 +0000

Add simple test cases for DAMON_RECLAIM's 'enabled' parameter.  Those
tests are focusing on the synchronous behavior of DAMON_RECLAIM enabling
and disabling.

Link: https://lkml.kernel.org/r/20221025173650.90624-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile   |    1 
 tools/testing/selftests/damon/reclaim.sh |   42 +++++++++++++++++++++
 2 files changed, 43 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-tests-for-damon_reclaims-enabled-parameter
+++ a/tools/testing/selftests/damon/Makefile
@@ -8,5 +8,6 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += sysfs.sh
+TEST_PROGS += reclaim.sh
 
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/damon/reclaim.sh
@@ -0,0 +1,42 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if [ $EUID -ne 0 ]
+then
+	echo "Run as root"
+	exit $ksft_skip
+fi
+
+damon_reclaim_enabled="/sys/module/damon_reclaim/parameters/enabled"
+if [ ! -f "$damon_reclaim_enabled" ]
+then
+	echo "No 'enabled' file.  Maybe DAMON_RECLAIM not built"
+	exit $ksft_skip
+fi
+
+nr_kdamonds=$(pgrep kdamond | wc -l)
+if [ "$nr_kdamonds" -ne 0 ]
+then
+	echo "Another kdamond is running"
+	exit $ksft_skip
+fi
+
+echo Y > "$damon_reclaim_enabled"
+
+nr_kdamonds=$(pgrep kdamond | wc -l)
+if [ "$nr_kdamonds" -ne 1 ]
+then
+	echo "kdamond is not turned on"
+	exit 1
+fi
+
+echo N > "$damon_reclaim_enabled"
+nr_kdamonds=$(pgrep kdamond | wc -l)
+if [ "$nr_kdamonds" -ne 0 ]
+then
+	echo "kdamond is not turned off"
+	exit 1
+fi
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

