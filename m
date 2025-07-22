Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715BC1A83E4
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 03:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154072; cv=none; b=SP0FFU2mK2Cd0/fyrwHWjmmAyTs9tkpU5vsv7HjedRoo6ffEULGiW1/1m9Xcy436z4WU8GjHhZ/t6zKeQKgsS1dLY3qjDbiTnSoT6rNPtp6udkV2QqiYlLYsnF08B2hvCXf56xL9eUE4LedOEsIpHPE3lpQ/HRfLF+JYB36LvBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154072; c=relaxed/simple;
	bh=jLhFtMscqAVHYKz9PiOc9nGiXSBv2X5byX/KVHstcbQ=;
	h=Date:To:From:Subject:Message-Id; b=lHONHzFF5PPgep8d+JqEsMRCuhn1aPGJoOq5LL+zx1QS/9bvdQqsBRO1kmxqnmqS/FCj4+2eBTxLCJhIuQsKuUXA6Ta5EwzpGNeeHgLiAmnHZPqMlTd1/E/DlpAfM0jHDkTRzqcnL8bLTns66lur6AsOPv3QyEav3DXaw6l0nbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b3Zk4pp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b3Zk4pp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EBFC4CEED;
	Tue, 22 Jul 2025 03:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753154072;
	bh=jLhFtMscqAVHYKz9PiOc9nGiXSBv2X5byX/KVHstcbQ=;
	h=Date:To:From:Subject:From;
	b=b3Zk4pp541L7n4Dsno7MPUp2sDKCOdESVw04iEFGdPh6IRAb8COlRbOEiLZCiK7e7
	 rCQAKYyBcPLkO9jv1AScx3vkn4XQVOOrEl8etrZtMOGwFRxm2nsoyeKwOZmuSFjLuu
	 O7fDMTk0MCX7ltWjKSxHD7k26u2J5PRBOJYNvZfk=
Date: Mon, 21 Jul 2025 20:14:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-introduce-_commonsh-to-host-shared-function.patch added to mm-new branch
Message-Id: <20250722031432.38EBFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: introduce _common.sh to host shared function
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-introduce-_commonsh-to-host-shared-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-introduce-_commonsh-to-host-shared-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

selftests-damon-introduce-_commonsh-to-host-shared-function.patch

