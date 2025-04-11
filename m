Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5A627BF7C
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343304; cv=none; b=l0qddbK0ojlLUUwiBkP2CAocePYtz7JdjSgLu/PTactaJrinnfCkLulW+LwhqT/Qo86aghFW/j/IxTWp0c48FOLNti5N1CHdd9vqwHxmsvBk776eqbBSSc3nb0eg0qBWgdXcLWOyTrNW8wL3D/C0quScHS9T9W857mG/GN3jVlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343304; c=relaxed/simple;
	bh=1ugWcToKgAycXvSRB4LLdwPnuMpIu2CQPef/mhB0gdo=;
	h=Date:To:From:Subject:Message-Id; b=VR4d3IwxfgJzDWJK+Mtj6PUnaqP8mMTzjba0b+v4YSFpSa3cCyM+f8DDbY58r2T6hL/Hz1aoddz5AI9CwvcBXFYjRJc7lZfUTL5eBJ9NkEPiTlxU4lkaFd2LJ9hqRbk09rj23u1A6F5th64ZvKumsxDnBORLdyVbXJIZUNymFtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QdoKgs6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QdoKgs6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAC4C4CEE2;
	Fri, 11 Apr 2025 03:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343303;
	bh=1ugWcToKgAycXvSRB4LLdwPnuMpIu2CQPef/mhB0gdo=;
	h=Date:To:From:Subject:From;
	b=QdoKgs6xX+J441ZYQbNsCWZpSEBkvFKskV6SNZdvvWhyFVK+jD5jW3nbccHXB7j6n
	 kGim5ViyuVsuChwVfduERNGPJwQg6tb8VN5iamaIldcus6+aiJssIPfT+eVtGgT497
	 q3fQgmOYW9TKckDrl+kzXShvjHEB9FbhGtJpizCk=
Date: Thu, 10 Apr 2025 20:48:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch added to mm-new branch
Message-Id: <20250411034823.9EAC4C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: remove the remaining test scripts for DAMON debugfs interface
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch

This patch will later appear in the mm-new branch at
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
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon: remove the remaining test scripts for DAMON debugfs interface
Date: Fri, 11 Apr 2025 10:43:32 +0800

DAMON has dropped debugfs support; therefore, remove these unused scripts.

Link: https://lkml.kernel.org/r/20250411024332.1373861-1-enze.li@linux.dev
Fixes: 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>
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

selftests-damon-remove-the-remaining-test-scripts-for-damon-debugfs-interface.patch

