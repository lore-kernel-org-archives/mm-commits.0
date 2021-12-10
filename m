Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D5EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344986AbhLJWup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345004AbhLJWum (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F78C0617A2
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90A5ECE2D8B
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFDAC341D5;
        Fri, 10 Dec 2021 22:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176419;
        bh=8PFL2hU+aqClMN7E8TzwzdWKP6OcUsLs1v/vELPKT8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mZ2S8ufz/ffX9pGM/AXL7e5w9PE7vq6uXfzfLiBwVSup/Pv1ofz3ExNsHUEs3u1D2
         61hlgYBWENuiS0eKYX8pKT6G8RfjGLEn5wAjq1iXacSnbpgXVLBE3bX1d9O6uKk9Pg
         pQAq0YmxPUXgsJT/ljHgg8hWzvf7ajoJpO9bBpKA=
Date:   Fri, 10 Dec 2021 14:46:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 17/21] selftests/damon: split test cases
Message-ID: <20211210224659.U3T9o0WbW%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: split test cases

Currently, the single test program, debugfs.sh, contains all test cases
for DAMON.  When one of the cases fails, finding which case is failed from
the test log is not so easy, and all remaining tests will be skipped.  To
improve the situation, this commit splits the single program into small
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
