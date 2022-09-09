Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879DECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIIVac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIIVab (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9C558B7A
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47992B82628
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA58BC433D6;
        Fri,  9 Sep 2022 21:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759025;
        bh=C7Q9ubvsHq9uLdF5jk1wYL7GbbH5euvoRJMdQAmVWAY=;
        h=Date:To:From:Subject:From;
        b=wfyzdgiW35tb7VlAPUORu5aPmIq7VbOvvjtRYkWx7NPgXeMAm6c2+oDFvEc0H5iCf
         AeneupXTB6gWW2zceF+5q5YgpyYYvnG1aSlkrYlDJl/5/R3Y5s0f6rBQb9uDeaM7k5
         aqgsngSNXoItFeHtZeldJTMc66CKE4C02aYDN0lU=
Date:   Fri, 09 Sep 2022 14:30:24 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch added to mm-unstable branch
Message-Id: <20220909213025.AA58BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/damon: add a test for duplicate context dirs creation
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch

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

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

