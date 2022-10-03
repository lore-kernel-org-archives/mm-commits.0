Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145B4C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJCVLo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJCVKY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3365053F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D7866118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6571BC433B5;
        Mon,  3 Oct 2022 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831209;
        bh=HislkYV7y7wvneZRRzrFrhi7LXqZWERDrlnr4oiCSyg=;
        h=Date:To:From:Subject:From;
        b=Qb75MZDCyNQL05JlHPssH3vGpB1WKUAxlLnsS1lgxrtiTHjAHSzh/iPIwgVUeHcvC
         C3mASWKnX073wxYUgXtXdkf2Voq4FkBcdIqjrDnQQUb5HBbFYvyjvnj1SSW77rjJAb
         c9yVIH3xl214JdXLbsZFyPuA7LUe3Kw1yF85wklU=
Date:   Mon, 03 Oct 2022 14:06:48 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch removed from -mm tree
Message-Id: <20221003210649.6571BC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest/damon: add a test for duplicate context dirs creation
has been removed from the -mm tree.  Its filename was
     selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftest/damon: add a test for duplicate context dirs creation
Date: Fri, 9 Sep 2022 20:28:55 +0000

Patch series "mm/damon: minor fixes and cleanups".

This patchset contains minor fixes and cleanups for DAMON including

- selftest for a bug we found before (Patch 1), 
- fix of region holes in vaddr corner case and a kunit test for it
  (Patches 2 and 3), and
- documents/Kconfig updates for title wordsmithing (Patch 4) and more
  aggressive DAMON debugfs interface deprecation announcement
  (Patches 5-7).


This patch (of 7):

Commit d26f60703606 ("mm/damon/dbgfs: avoid duplicate context directory
creation") fixes a bug which could result in memory leak and DAMON
disablement.  This commit adds a selftest for verifying the fix and avoid
regression.

Link: https://lkml.kernel.org/r/20220909202901.57977-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220909202901.57977-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                              |    1 
 tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh |   27 ++++++++++
 2 files changed, 28 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
@@ -0,0 +1,27 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test duplicated context creation
+# ================================
+
+if ! echo foo > "$DBGFS/mk_contexts"
+then
+	echo "context creation failed"
+	exit 1
+fi
+
+if echo foo > "$DBGFS/mk_contexts"
+then
+	echo "duplicate context creation success"
+	exit 1
+fi
+
+if ! echo foo > "$DBGFS/rm_contexts"
+then
+	echo "context deletion failed"
+	exit 1
+fi
+
+exit 0
--- a/tools/testing/selftests/damon/Makefile~selftest-damon-add-a-test-for-duplicate-context-dirs-creation
+++ a/tools/testing/selftests/damon/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_FILES += huge_count_read_write
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
+TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += sysfs.sh
 
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

