Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA86AC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK3XCw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiK3XCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AAE950CE
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 759E061E38
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE3FC433C1;
        Wed, 30 Nov 2022 23:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849331;
        bh=utNV4PSocTpo/o8i5kFgAXangoTgZt+YzGwhx1gs6c0=;
        h=Date:To:From:Subject:From;
        b=lcFzAa3CNL/E1cuxF7ra5mLttfTmjsYFvyW223erCsCddiMIBH3vyOO/Wr6HC8wop
         x7f8KJtKyO1/0qxHI9c3L1Ll4RLaf/eD7lfuCwjq9VBlY7++4o07X/5dmT4bpgE/in
         Y9GF5j/X4mHBZaBZdtFWWhcdJRe7mM3z6y3J8YdY=
Date:   Wed, 30 Nov 2022 15:02:11 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch removed from -mm tree
Message-Id: <20221130230211.CDE3FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: add tests for DAMON_LRU_SORT's enabled parameter
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add tests for DAMON_LRU_SORT's enabled parameter
Date: Tue, 25 Oct 2022 17:36:50 +0000

Add simple test cases for DAMON_LRU_SORT's 'enabled' parameter.  Those
tests are focusing on the synchronous behavior of DAMON_RECLAIM enabling
and disabling.

Link: https://lkml.kernel.org/r/20221025173650.90624-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile    |    2 
 tools/testing/selftests/damon/lru_sort.sh |   41 ++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/lru_sort.sh
@@ -0,0 +1,41 @@
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
+damon_lru_sort_enabled="/sys/module/damon_lru_sort/parameters/enabled"
+if [ ! -f "$damon_lru_sort_enabled" ]
+then
+	echo "No 'enabled' file.  Maybe DAMON_LRU_SORT not built"
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
+echo Y > "$damon_lru_sort_enabled"
+nr_kdamonds=$(pgrep kdamond | wc -l)
+if [ "$nr_kdamonds" -ne 1 ]
+then
+	echo "kdamond is not turned on"
+	exit 1
+fi
+
+echo N > "$damon_lru_sort_enabled"
+nr_kdamonds=$(pgrep kdamond | wc -l)
+if [ "$nr_kdamonds" -ne 0 ]
+then
+	echo "kdamond is not turned off"
+	exit 1
+fi
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter
+++ a/tools/testing/selftests/damon/Makefile
@@ -8,6 +8,6 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += sysfs.sh
-TEST_PROGS += reclaim.sh
+TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

