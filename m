Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD7030E826
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380480; cv=none; b=b4Kw2zJsr4iTe7x2pX/0NJ3JBPz405SHESAE1T+5lhPphtCKe5PycXcr/AnIh8u7gPykf2Ahtn2jSxZNt9PEll4qUT+F7ZB29oJVAz5UNHynhOC2Oo2x9+yo9701o/9i4MME9wxTeF87FzJidrXQSVhfYR2lnQqADCGWcRg1Qkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380480; c=relaxed/simple;
	bh=MV+7TnloLem9sITZ5W2r1heSm7WBS77Vp2rGeZIweYs=;
	h=Date:To:From:Subject:Message-Id; b=CqUS2bW8OJGMIR3EBA27qPHmOop9/H8vglAUMZvtb5n4L1fhDEYpSA5GQoGawIZtUy4TtzoEX3qyqjIZqbgcIoPovXKn1eG6oU8HQZ/T87uaaTay2Q1MDBiUhLKszgv8jhr0nDSGJ6eS/sRCiJwVW1AdEGD59IBzhScnRld220s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yReNsQu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yReNsQu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439F5C4CEEA;
	Fri, 20 Jun 2025 00:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380480;
	bh=MV+7TnloLem9sITZ5W2r1heSm7WBS77Vp2rGeZIweYs=;
	h=Date:To:From:Subject:From;
	b=yReNsQu9+Fo1RHg9MQfzoQgkmVzAE5TYzVaCIbxgksDD4uZMEbxorq/Fn2AjCQtiw
	 uB0n9sy5kaTsckvEF7E1Rtx3GlIFmNa7h4ik9aW4FQNi/yvOnLVn2RRRKIK4MKc7pK
	 2eHNhKPCZfNUp3CYu7eIcBSuQkVtUWS8x435e1Rw=
Date: Thu, 19 Jun 2025 17:47:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftets-damon-add-a-test-for-memcg_path-leak.patch added to mm-new branch
Message-Id: <20250620004800.439F5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftets/damon: add a test for memcg_path leak
has been added to the -mm mm-new branch.  Its filename is
     selftets-damon-add-a-test-for-memcg_path-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftets-damon-add-a-test-for-memcg_path-leak.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftets/damon: add a test for memcg_path leak
Date: Thu, 19 Jun 2025 11:36:08 -0700

There was a memory leak bug in DAMOS sysfs memcg_path file.  Add a
selftest to ensure the bug never comes back.

Link: https://lkml.kernel.org/r/20250619183608.6647-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                 |    1 
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |   43 ++++++++++
 2 files changed, 44 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftets-damon-add-a-test-for-memcg_path-leak
+++ a/tools/testing/selftests/damon/Makefile
@@ -15,6 +15,7 @@ TEST_PROGS += reclaim.sh lru_sort.sh
 # regression tests (reproducers of previously found bugs)
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
+TEST_PROGS += sysfs_memcg_path_leak.sh
 
 EXTRA_CLEAN = __pycache__
 
diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [ $EUID -ne 0 ]
+then
+	echo "Run as root"
+	exit $ksft_skip
+fi
+
+damon_sysfs="/sys/kernel/mm/damon/admin"
+if [ ! -d "$damon_sysfs" ]
+then
+	echo "damon sysfs not found"
+	exit $ksft_skip
+fi
+
+# ensure filter directory
+echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/nr_schemes"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/nr_filters"
+
+filter_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/0"
+
+before_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
+
+# try to leak 3000 KiB
+for i in {1..102400};
+do
+	echo "012345678901234567890123456789" > "$filter_dir/memcg_path"
+done
+
+after_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
+# expect up to 1500 KiB free from other tasks memory
+expected_after_kb_max=$((before_kb + 1500))
+
+if [ "$after_kb" -gt "$expected_after_kb_max" ]
+then
+	echo "maybe memcg_path are leaking: $before_kb -> $after_kb"
+	exit 1
+else
+	exit 0
+fi
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch

