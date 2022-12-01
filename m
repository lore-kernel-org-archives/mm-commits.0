Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E279DC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLAADV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiLAABS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3419287CA6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA76B81D88
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C18C433D6;
        Thu,  1 Dec 2022 00:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852858;
        bh=my24SsjCJu2JUynb9xUDMzIhygGo9qEwWBAkxggHLPc=;
        h=Date:To:From:Subject:From;
        b=o8aXkDibaCqOQtctdYGptQJS1pRj9qa7J2b8b+1cYI0FA+ZGj3wKTlEpiavrc9LAv
         COfdn1KDgtd+eGI6SrXxf2s73m7mf/9Db+KaV83+eqmlC8814yP4AIsZnnFFoEHfEq
         tZGLh0Qc0Q1t/5v89FG1TVl7iDBu0A6XLiQ1/bRQ=
Date:   Wed, 30 Nov 2022 16:00:57 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch removed from -mm tree
Message-Id: <20221201000058.73C18C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: test non-context inputs to rm_contexts file
has been removed from the -mm tree.  Its filename was
     selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test non-context inputs to rm_contexts file
Date: Mon, 7 Nov 2022 16:50:01 +0000

There was a bug[1] that triggered by writing non-context DAMON debugfs
file names to the 'rm_contexts' DAMON debugfs file.  Add a selftest for
the bug to avoid it happen again.

[1] https://lore.kernel.org/damon/000000000000ede3ac05ec4abf8e@google.com/

Link: https://lkml.kernel.org/r/20221107165001.5717-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                   |    1 
 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh |   19 ++++++++++
 2 files changed, 20 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test putting non-ctx files/dirs to rm_contexts file
+# ===================================================
+
+dmesg -C
+
+for file in "$DBGFS/"*
+do
+	echo "$(basename "$f")" > "$DBGFS/rm_contexts"
+	if dmesg | grep -q BUG
+	then
+		dmesg
+		exit 1
+	fi
+done
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-non-context-inputs-to-rm_contexts-file
+++ a/tools/testing/selftests/damon/Makefile
@@ -7,6 +7,7 @@ TEST_FILES = _chk_dependency.sh _debugfs
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
+TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh
 TEST_PROGS += reclaim.sh lru_sort.sh
 
_

Patches currently in -mm which might be from sj@kernel.org are


