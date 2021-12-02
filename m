Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D20C43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344724AbhLBDp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355265AbhLBDog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:44:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A3C06175A
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE6C7CE21A9
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9745C00446;
        Thu,  2 Dec 2021 03:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416444;
        bh=HF7sPuKbIokD0I9UGLYlucesw687yJr4OBUWOlMz1PE=;
        h=Date:From:To:Subject:From;
        b=NjZc/8T4uBBrSW9lrsc3u0/RY3nVfb2jPBN4Vy2G1Uu9jiibSCrJwYA5Yt00UZQwC
         L+01JIf7H1kjjSbDKtEj2sozFNHXXvdufJAHj+iEalwgX7jK+WZlb58SzeY//O7NRO
         OfgKbJ6IU+bTiXbW5rvuhI8gkfJX4F0N9r6PJNgI=
Date:   Wed, 01 Dec 2021 19:40:43 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  +
 selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch added
 to -mm tree
Message-ID: <20211202034043.eTSlWUcl3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: test debugfs file reads/writes with huge count
has been added to the -mm tree.  Its filename is
     selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch

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
Subject: selftests/damon: test debugfs file reads/writes with huge count

DAMON debugfs interface users were able to trigger warning by writing some
files with arbitrarily large 'count' parameter.  The issue is fixed with
commit db7a347b26fe ("mm/damon/dbgfs: use '__GFP_NOWARN' for
user-specified size buffer allocation").  This commit adds a test case for
the issue in DAMON selftests to avoid future regressions.

Link: https://lkml.kernel.org/r/20211201150440.1088-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore              |    2 
 tools/testing/selftests/damon/Makefile                |    2 
 tools/testing/selftests/damon/debugfs_attrs.sh        |   18 ++++
 tools/testing/selftests/damon/huge_count_read_write.c |   39 ++++++++++
 4 files changed, 61 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-test-debugfs-file-reads-writes-with-huge-count
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -105,4 +105,22 @@ orig_monitor_on=$(cat "$DBGFS/monitor_on
 test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
 echo "$orig_target_ids" > "$DBGFS/target_ids"
 
+# Test huge count read write
+# ==========================
+
+dmesg -C
+
+for file in "$DBGFS/"*
+do
+	./huge_count_read_write "$file"
+done
+
+if dmesg | grep -q WARNING
+then
+	dmesg
+	exit 1
+else
+	exit 0
+fi
+
 echo "PASS"
--- /dev/null
+++ a/tools/testing/selftests/damon/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+huge_count_read_write
--- /dev/null
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+
+void write_read_with_huge_count(char *file)
+{
+	int filedesc = open(file, O_RDWR);
+	char buf[25];
+	int ret;
+
+	printf("%s %s\n", __func__, file);
+	if (filedesc < 0) {
+		fprintf(stderr, "failed opening %s\n", file);
+		exit(1);
+	}
+
+	write(filedesc, "", 0xfffffffful);
+	perror("after write: ");
+	ret = read(filedesc, buf, 0xfffffffful);
+	perror("after read: ");
+	close(filedesc);
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
+		exit(1);
+	}
+	write_read_with_huge_count(argv[1]);
+
+	return 0;
+}
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-debugfs-file-reads-writes-with-huge-count
+++ a/tools/testing/selftests/damon/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for damon selftests
 
+TEST_GEN_FILES += huge_count_read_write
+
 TEST_FILES = _chk_dependency.sh
 TEST_PROGS = debugfs_attrs.sh
 
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

