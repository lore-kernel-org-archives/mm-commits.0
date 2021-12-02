Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70729C43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhLBDp6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355266AbhLBDog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:44:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDD9C06175B
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D6923CE219A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CF8C00446;
        Thu,  2 Dec 2021 03:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416448;
        bh=Xuu7LalqTeneO4QizPRAu2NS0yTm77VyLbfJZCTdUlQ=;
        h=Date:From:To:Subject:From;
        b=IjJ8IiEXVp3m3j5QK6Oi29Z4Er1PZnN0hRhStotZvxYC/dFk+36kY0mmrgCIru3PQ
         pmDSIF+/cD+gkwqHMW2Qz1sYPTwnUVolUyKeUsoIDYLHxFddn1yh7V09dcTgUb9psU
         UWzRy8gLDQGFJSww87bSq2qDEHQkr8vRT1pSnpPw=
Date:   Wed, 01 Dec 2021 19:40:47 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  + selftests-damon-split-test-cases.patch added to -mm
 tree
Message-ID: <20211202034047.88Zvyvbrv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: split test cases
has been added to the -mm tree.  Its filename is
     selftests-damon-split-test-cases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-split-test-cases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-split-test-cases.patch

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
Subject: selftests/damon: split test cases

Currently, the single test program, debugfs.sh, contains all test cases
for DAMON.  When one of the cases is failed, finding which case is failed
from the test log is not so easy, and all remaining test will be skipped. 
To improve the situation, this commit splits the single program into small
test programs having their own names.

Link: https://lkml.kernel.org/r/20211201150440.1088-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                         |    5 
 tools/testing/selftests/damon/_debugfs_common.sh               |   52 ++++
 tools/testing/selftests/damon/debugfs_attrs.sh                 |  111 ----------
 tools/testing/selftests/damon/debugfs_empty_targets.sh         |   13 +
 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh |   22 +
 tools/testing/selftests/damon/debugfs_schemes.sh               |   19 +
 tools/testing/selftests/damon/debugfs_target_ids.sh            |   19 +
 7 files changed, 129 insertions(+), 112 deletions(-)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-split-test-cases
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -1,57 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-test_write_result() {
-	file=$1
-	content=$2
-	orig_content=$3
-	expect_reason=$4
-	expected=$5
-
-	echo "$content" > "$file"
-	if [ $? -ne "$expected" ]
-	then
-		echo "writing $content to $file doesn't return $expected"
-		echo "expected because: $expect_reason"
-		echo "$orig_content" > "$file"
-		exit 1
-	fi
-}
-
-test_write_succ() {
-	test_write_result "$1" "$2" "$3" "$4" 0
-}
-
-test_write_fail() {
-	test_write_result "$1" "$2" "$3" "$4" 1
-}
-
-test_content() {
-	file=$1
-	orig_content=$2
-	expected=$3
-	expect_reason=$4
-
-	content=$(cat "$file")
-	if [ "$content" != "$expected" ]
-	then
-		echo "reading $file expected $expected but $content"
-		echo "expected because: $expect_reason"
-		echo "$orig_content" > "$file"
-		exit 1
-	fi
-}
-
-source ./_chk_dependency.sh
-
-ksft_skip=4
-
-damon_onoff="$DBGFS/monitor_on"
-if [ $(cat "$damon_onoff") = "on" ]
-then
-	echo "monitoring is on"
-	exit $ksft_skip
-fi
+source _debugfs_common.sh
 
 # Test attrs file
 # ===============
@@ -65,62 +15,3 @@ test_write_fail "$file" "1 2 3 5 4" "$or
 	"min_nr_regions > max_nr_regions"
 test_content "$file" "$orig_content" "1 2 3 4 5" "successfully written"
 echo "$orig_content" > "$file"
-
-# Test schemes file
-# =================
-
-file="$DBGFS/schemes"
-orig_content=$(cat "$file")
-
-test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3 1 100 3 2 1" \
-	"$orig_content" "valid input"
-test_write_fail "$file" "1 2
-3 4 5 6 3 0 0 0 1 2 3 1 100 3 2 1" "$orig_content" "multi lines"
-test_write_succ "$file" "" "$orig_content" "disabling"
-test_write_fail "$file" "2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3" \
-	"$orig_content" "wrong condition ranges"
-echo "$orig_content" > "$file"
-
-# Test target_ids file
-# ====================
-
-file="$DBGFS/target_ids"
-orig_content=$(cat "$file")
-
-test_write_succ "$file" "1 2 3 4" "$orig_content" "valid input"
-test_write_succ "$file" "1 2 abc 4" "$orig_content" "still valid input"
-test_content "$file" "$orig_content" "1 2" "non-integer was there"
-test_write_succ "$file" "abc 2 3" "$orig_content" "the file allows wrong input"
-test_content "$file" "$orig_content" "" "wrong input written"
-test_write_succ "$file" "" "$orig_content" "empty input"
-test_content "$file" "$orig_content" "" "empty input written"
-echo "$orig_content" > "$file"
-
-# Test empty targets case
-# =======================
-
-orig_target_ids=$(cat "$DBGFS/target_ids")
-echo "" > "$DBGFS/target_ids"
-orig_monitor_on=$(cat "$DBGFS/monitor_on")
-test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
-echo "$orig_target_ids" > "$DBGFS/target_ids"
-
-# Test huge count read write
-# ==========================
-
-dmesg -C
-
-for file in "$DBGFS/"*
-do
-	./huge_count_read_write "$file"
-done
-
-if dmesg | grep -q WARNING
-then
-	dmesg
-	exit 1
-else
-	exit 0
-fi
-
-echo "PASS"
--- /dev/null
+++ a/tools/testing/selftests/damon/_debugfs_common.sh
@@ -0,0 +1,52 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+test_write_result() {
+	file=$1
+	content=$2
+	orig_content=$3
+	expect_reason=$4
+	expected=$5
+
+	echo "$content" > "$file"
+	if [ $? -ne "$expected" ]
+	then
+		echo "writing $content to $file doesn't return $expected"
+		echo "expected because: $expect_reason"
+		echo "$orig_content" > "$file"
+		exit 1
+	fi
+}
+
+test_write_succ() {
+	test_write_result "$1" "$2" "$3" "$4" 0
+}
+
+test_write_fail() {
+	test_write_result "$1" "$2" "$3" "$4" 1
+}
+
+test_content() {
+	file=$1
+	orig_content=$2
+	expected=$3
+	expect_reason=$4
+
+	content=$(cat "$file")
+	if [ "$content" != "$expected" ]
+	then
+		echo "reading $file expected $expected but $content"
+		echo "expected because: $expect_reason"
+		echo "$orig_content" > "$file"
+		exit 1
+	fi
+}
+
+source ./_chk_dependency.sh
+
+damon_onoff="$DBGFS/monitor_on"
+if [ $(cat "$damon_onoff") = "on" ]
+then
+	echo "monitoring is on"
+	exit $ksft_skip
+fi
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_empty_targets.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test empty targets case
+# =======================
+
+orig_target_ids=$(cat "$DBGFS/target_ids")
+echo "" > "$DBGFS/target_ids"
+orig_monitor_on=$(cat "$DBGFS/monitor_on")
+test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
+echo "$orig_target_ids" > "$DBGFS/target_ids"
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
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
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_schemes.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test schemes file
+# =================
+
+file="$DBGFS/schemes"
+orig_content=$(cat "$file")
+
+test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3 1 100 3 2 1" \
+	"$orig_content" "valid input"
+test_write_fail "$file" "1 2
+3 4 5 6 3 0 0 0 1 2 3 1 100 3 2 1" "$orig_content" "multi lines"
+test_write_succ "$file" "" "$orig_content" "disabling"
+test_write_fail "$file" "2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3" \
+	"$orig_content" "wrong condition ranges"
+echo "$orig_content" > "$file"
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_target_ids.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test target_ids file
+# ====================
+
+file="$DBGFS/target_ids"
+orig_content=$(cat "$file")
+
+test_write_succ "$file" "1 2 3 4" "$orig_content" "valid input"
+test_write_succ "$file" "1 2 abc 4" "$orig_content" "still valid input"
+test_content "$file" "$orig_content" "1 2" "non-integer was there"
+test_write_succ "$file" "abc 2 3" "$orig_content" "the file allows wrong input"
+test_content "$file" "$orig_content" "" "wrong input written"
+test_write_succ "$file" "" "$orig_content" "empty input"
+test_content "$file" "$orig_content" "" "empty input written"
+echo "$orig_content" > "$file"
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-split-test-cases
+++ a/tools/testing/selftests/damon/Makefile
@@ -3,7 +3,8 @@
 
 TEST_GEN_FILES += huge_count_read_write
 
-TEST_FILES = _chk_dependency.sh
-TEST_PROGS = debugfs_attrs.sh
+TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
+TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 
 include ../lib.mk
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

