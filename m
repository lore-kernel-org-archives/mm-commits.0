Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B475ECDFA1
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiJZCOH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiJZCOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D6ED0CE6
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF4BB61C39
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C1BC43470;
        Wed, 26 Oct 2022 02:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666750444;
        bh=HttX/5nxlywlX9bngrBXnVpWPLYHsgPA7oumkSqzsmA=;
        h=Date:To:From:Subject:From;
        b=oAiTV4Y00jhbigOgWF/DHvpc9A0T9V5231CNRzwfhNybafD/KOJEfELNAJSPUNfJf
         PDilTWB4EMLXByINMDgXSolhaN++P4uf/fxMrdlcv4zZybN2H/8FY+YcTqHXizT9F1
         t7SwZM1RiRf4W5+CwtQWxWmLxlRKjxly3RsFC6z0=
Date:   Tue, 25 Oct 2022 19:14:03 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch added to mm-unstable branch
Message-Id: <20221026021404.01C1BC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: add tests for DAMON_RECLAIM's enabled parameter
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch

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

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch

