Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739B8C4338F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5508B61181
	for <mm-commits@archiver.kernel.org>; Fri,  6 Aug 2021 00:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbhHFAms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 20:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241328AbhHFAmm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 20:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0D8461179;
        Fri,  6 Aug 2021 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628210547;
        bh=Ft4Vyhy/j9kyk32ZrFq80oyoBvYj7eqBnWs/HMlYxLs=;
        h=Date:From:To:Subject:From;
        b=P3OoTAIYHjZISC4cRxYxqTTyWiURlfXFAJwdYNmaiN4DkzkxQWcjUi3U2v28mbxj6
         +YWLml4WHmkBCQP+f7c0sewJp0+LwUsEginN1/fpx9+hbs/QVRYogDx9uO7BOJDd/f
         DXPvS5uJ7F9OH7RJGxGVj9FzoUUCz/Kl2kWn4zJM=
Date:   Thu, 05 Aug 2021 17:42:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        sieberf@amazon.com, shuah@kernel.org, shakeelb@google.com,
        rostedt@goodmis.org, rientjes@google.com, riel@surriel.com,
        peterz@infradead.org, namhyung@kernel.org, mingo@redhat.com,
        minchan@kernel.org, mheyne@amazon.de, mgorman@suse.de,
        markubo@amazon.de, Jonathan.Cameron@huawei.com, joe@perches.com,
        gthelen@google.com, greg@kroah.com, foersleo@amazon.de,
        fan.du@intel.com, elver@google.com, dwmw@amazon.com,
        david@redhat.com, corbet@lwn.net, brendanhiggins@google.com,
        benh@kernel.crashing.org, amit@kernel.org,
        alexander.shishkin@linux.intel.com, sjpark@amazon.de
Subject:  + mm-damon-add-user-space-selftests.patch added to -mm tree
Message-ID: <20210806004226.47nyd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: add user space selftests
has been added to the -mm tree.  Its filename is
     mm-damon-add-user-space-selftests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-user-space-selftests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-user-space-selftests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon: add user space selftests

This commit adds a simple user space tests for DAMON.  The tests are using
kselftest framework.

Link: https://lkml.kernel.org/r/20210716081449.22187-13-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Markus Boehme <markubo@amazon.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile           |    7 +
 tools/testing/selftests/damon/_chk_dependency.sh |   28 ++++
 tools/testing/selftests/damon/debugfs_attrs.sh   |   75 +++++++++++++
 3 files changed, 110 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/_chk_dependency.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+DBGFS=/sys/kernel/debug/damon
+
+if [ $EUID -ne 0 ];
+then
+	echo "Run as root"
+	exit $ksft_skip
+fi
+
+if [ ! -d "$DBGFS" ]
+then
+	echo "$DBGFS not found"
+	exit $ksft_skip
+fi
+
+for f in attrs target_ids monitor_on
+do
+	if [ ! -f "$DBGFS/$f" ]
+	then
+		echo "$f not found"
+		exit 1
+	fi
+done
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -0,0 +1,75 @@
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
+# Test attrs file
+# ===============
+
+file="$DBGFS/attrs"
+orig_content=$(cat "$file")
+
+test_write_succ "$file" "1 2 3 4 5" "$orig_content" "valid input"
+test_write_fail "$file" "1 2 3 4" "$orig_content" "no enough fields"
+test_write_fail "$file" "1 2 3 5 4" "$orig_content" \
+	"min_nr_regions > max_nr_regions"
+test_content "$file" "$orig_content" "1 2 3 4 5" "successfully written"
+echo "$orig_content" > "$file"
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
+
+echo "PASS"
--- /dev/null
+++ a/tools/testing/selftests/damon/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for damon selftests
+
+TEST_FILES = _chk_dependency.sh
+TEST_PROGS = debugfs_attrs.sh
+
+include ../lib.mk
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

