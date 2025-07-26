Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B25227BB9
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567832; cv=none; b=HKuNZ9Sce5gHKDRQlL36GYjWsn1U0BrIMJ7kpFZxI/ln5deZcAAJqJpcCIKfX51zjboM6Ubqr3nbCKYE0n/iu3mLl7RxacFke3lPQcBd0L1fnTsXDhqJdSKEndz9o/KUdSaQg+8qko2OZBMenQzvIwpLF49n+wTTiRBQ4D6mr9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567832; c=relaxed/simple;
	bh=LXXqPzHDszB0M2LVmVcLKvMrHcP6kNrzbbDv4c9ATCQ=;
	h=Date:To:From:Subject:Message-Id; b=Tx7F4UQfN6GM92KMGBr1FCD1hdYR8IungD0mriogRSmbDufk+VHMb430hsMZ0VSinkbfzShrViUeRblJAIu9kqYdRKsEIqf1FlJAelTjAApNRFwanmPNBgBMMrBUWMBEl63qWAyxZBTKFIzKxRp6/nEC9N0QmvtV2c1jr14qBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F076pfz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F076pfz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1503C4CEED;
	Sat, 26 Jul 2025 22:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567831;
	bh=LXXqPzHDszB0M2LVmVcLKvMrHcP6kNrzbbDv4c9ATCQ=;
	h=Date:To:From:Subject:From;
	b=F076pfz3RI+/cfMbpUC4f0CJtJQ6RfjKFkuCWRkBsFEqfE01+p8xSBMjNkGG5dA3i
	 vWnyAgcxACn5W6T9cuqpCxcwEQShJO0D6tfu6/o6dRKCVPRKOnmpXq1imZ6bxTRKml
	 9/F2UJLDuiUM27uNS985Y3CnBS7h+3KrK9weRxWQ=
Date: Sat, 26 Jul 2025 15:10:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-introduce-_commonsh-to-host-shared-function.patch removed from -mm tree
Message-Id: <20250726221031.B1503C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: introduce _common.sh to host shared function
has been removed from the -mm tree.  Its filename was
     selftests-damon-introduce-_commonsh-to-host-shared-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon: introduce _common.sh to host shared function
Date: Fri, 18 Jul 2025 14:42:17 +0800

The current test scripts contain duplicated root permission checks in
multiple locations.  This patch consolidates these checks into _common.sh
to eliminate code redundancy.

Link: https://lkml.kernel.org/r/20250718064217.299300-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_common.sh                         |   11 ++++++++++
 tools/testing/selftests/damon/lru_sort.sh                        |    8 ++-----
 tools/testing/selftests/damon/reclaim.sh                         |    8 ++-----
 tools/testing/selftests/damon/sysfs.sh                           |   11 +---------
 tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh |    8 ++-----
 5 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/damon/_common.sh a/tools/testing/selftests/damon/_common.sh
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/damon/_common.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+check_dependencies()
+{
+	if [ $EUID -ne 0 ]
+	then
+		echo "Run as root"
+		exit $ksft_skip
+	fi
+}
--- a/tools/testing/selftests/damon/lru_sort.sh~selftests-damon-introduce-_commonsh-to-host-shared-function
+++ a/tools/testing/selftests/damon/lru_sort.sh
@@ -1,14 +1,12 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+source _common.sh
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-if [ $EUID -ne 0 ]
-then
-	echo "Run as root"
-	exit $ksft_skip
-fi
+check_dependencies
 
 damon_lru_sort_enabled="/sys/module/damon_lru_sort/parameters/enabled"
 if [ ! -f "$damon_lru_sort_enabled" ]
--- a/tools/testing/selftests/damon/reclaim.sh~selftests-damon-introduce-_commonsh-to-host-shared-function
+++ a/tools/testing/selftests/damon/reclaim.sh
@@ -1,14 +1,12 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+source _common.sh
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-if [ $EUID -ne 0 ]
-then
-	echo "Run as root"
-	exit $ksft_skip
-fi
+check_dependencies
 
 damon_reclaim_enabled="/sys/module/damon_reclaim/parameters/enabled"
 if [ ! -f "$damon_reclaim_enabled" ]
--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-introduce-_commonsh-to-host-shared-function
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+source _common.sh
+
 # Kselftest frmework requirement - SKIP code is 4.
 ksft_skip=4
 
@@ -364,14 +366,5 @@ test_damon_sysfs()
 	test_kdamonds "$damon_sysfs/kdamonds"
 }
 
-check_dependencies()
-{
-	if [ $EUID -ne 0 ]
-	then
-		echo "Run as root"
-		exit $ksft_skip
-	fi
-}
-
 check_dependencies
 test_damon_sysfs "/sys/kernel/mm/damon/admin"
--- a/tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh~selftests-damon-introduce-_commonsh-to-host-shared-function
+++ a/tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh
@@ -1,14 +1,12 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+source _common.sh
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-if [ $EUID -ne 0 ]
-then
-	echo "Run as root"
-	exit $ksft_skip
-fi
+check_dependencies
 
 damon_sysfs="/sys/kernel/mm/damon/admin"
 if [ ! -d "$damon_sysfs" ]
_

Patches currently in -mm which might be from lienze@kylinos.cn are


