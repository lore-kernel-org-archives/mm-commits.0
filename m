Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA3C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011127; cv=none; b=c6A2VjatdBj6XNsSGwUbnTflTeSVBKNo9sl5+VmN3Wq2p7GjwL0/AKv8e01WKAATCEMm6VdTJPhBGlFJHJTCL7IrV2fzOXBvEhqHhF8v7Dz9epKv8TU0jHzOF5oMeZ6MEzAGsOpkWkS0c/ln4cA041sfA39z+XB/oTrIx0Twwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011127; c=relaxed/simple;
	bh=beJO3ig6Jv5LrkKarDaL5D02YLaILcEXytAGJpJLfXc=;
	h=Date:To:From:Subject:Message-Id; b=gLTSnm3xCystw1Kj9kI2YBQ79s5JnJiNBDQncSbPCt7/iUmCYns6Hzfb5dxSynz7oX+KFxtHnBS3+JWQeZIbJWWOlXXQhzmN+2GLKCqtIG0NCWQb771CAYggzTvS+V5DMXGMQrddeA2Mvb2DzmT3OkPnF8tPDYmNWlZpvkVvuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5905ycu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5905ycu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B95C4CEE4;
	Mon, 12 May 2025 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011126;
	bh=beJO3ig6Jv5LrkKarDaL5D02YLaILcEXytAGJpJLfXc=;
	h=Date:To:From:Subject:From;
	b=E5905ycu7TlcdDx3miUbMAbYppif/BPqEwEBmtR6oC5eI8GzkBWytuBpoFTVAyODA
	 DMdiy58Agh3dFOS2VLOJHGx04giE4MXiv0+DCNgcZxI0ZHZtKnFnVNKnZIbJE1I8An
	 zv8M76xZrKzuMcGz2rNcLtzSHfQxMlEeKQMcZrT4=
Date: Sun, 11 May 2025 17:52:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch removed from -mm tree
Message-Id: <20250512005206.C4B95C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: remove the remaining test scripts for DAMON debugfs interface
has been removed from the -mm tree.  Its filename was
     selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon: remove the remaining test scripts for DAMON debugfs interface
Date: Fri, 11 Apr 2025 10:43:32 +0800

DAMON has dropped debugfs support; therefore, remove these unused scripts.

Link: https://lkml.kernel.org/r/20250411024332.1373861-1-enze.li@linux.dev
Fixes: 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile           |    2 
 tools/testing/selftests/damon/_chk_dependency.sh |   52 ----------
 tools/testing/selftests/damon/_debugfs_common.sh |   64 -------------
 3 files changed, 1 insertion(+), 117 deletions(-)

diff --git a/tools/testing/selftests/damon/_chk_dependency.sh a/tools/testing/selftests/damon/_chk_dependency.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/_chk_dependency.sh
+++ /dev/null
@@ -1,52 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-DBGFS=$(grep debugfs /proc/mounts --max-count 1 | awk '{print $2}')
-if [ "$DBGFS" = "" ]
-then
-	echo "debugfs not mounted"
-	exit $ksft_skip
-fi
-
-DBGFS+="/damon"
-
-if [ $EUID -ne 0 ];
-then
-	echo "Run as root"
-	exit $ksft_skip
-fi
-
-if [ ! -d "$DBGFS" ]
-then
-	echo "$DBGFS not found"
-	exit $ksft_skip
-fi
-
-if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
-then
-	monitor_on_file="monitor_on_DEPRECATED"
-else
-	monitor_on_file="monitor_on"
-fi
-
-for f in attrs target_ids "$monitor_on_file"
-do
-	if [ ! -f "$DBGFS/$f" ]
-	then
-		echo "$f not found"
-		exit 1
-	fi
-done
-
-permission_error="Operation not permitted"
-for f in attrs target_ids "$monitor_on_file"
-do
-	status=$( cat "$DBGFS/$f" 2>&1 )
-	if [ "${status#*$permission_error}" != "$status" ]; then
-		echo "Permission for reading $DBGFS/$f denied; maybe secureboot enabled?"
-		exit $ksft_skip
-	fi
-done
diff --git a/tools/testing/selftests/damon/_debugfs_common.sh a/tools/testing/selftests/damon/_debugfs_common.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/_debugfs_common.sh
+++ /dev/null
@@ -1,64 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-test_write_result() {
-	file=$1
-	content=$2
-	orig_content=$3
-	expect_reason=$4
-	expected=$5
-
-	if [ "$expected" = "0" ]
-	then
-		echo "$content" > "$file"
-	else
-		echo "$content" > "$file" 2> /dev/null
-	fi
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
-damon_onoff="$DBGFS/monitor_on"
-if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
-then
-	damon_onoff="$DBGFS/monitor_on_DEPRECATED"
-else
-	damon_onoff="$DBGFS/monitor_on"
-fi
-
-if [ $(cat "$damon_onoff") = "on" ]
-then
-	echo "monitoring is on"
-	exit $ksft_skip
-fi
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface
+++ a/tools/testing/selftests/damon/Makefile
@@ -3,7 +3,7 @@
 
 TEST_GEN_FILES += access_memory access_memory_even
 
-TEST_FILES = _chk_dependency.sh _damon_sysfs.py
+TEST_FILES = _damon_sysfs.py
 
 # functionality tests
 TEST_PROGS += sysfs.sh
_

Patches currently in -mm which might be from lienze@kylinos.cn are


