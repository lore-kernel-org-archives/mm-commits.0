Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C0D63C11
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 20:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GyebpgEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95733C433C7;
	Tue, 12 Dec 2023 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702412965;
	bh=F0bEnvGeg0GOKWZzEcrFje+Pl2zWSuNfqk3iY2HblwI=;
	h=Date:To:From:Subject:From;
	b=GyebpgEP5XoQJD7W9WlQYImU681w0HzM1t0wa2hZbMKYCRLnspX75zKyDDWdOyRGf
	 u3UZwbGMKo2wQFx/qcU7bc5HDdJZ8rZoCEC7hCY96w6XUiNScWjtUVZX3GtXuKyZPI
	 rg7IebFeCCGiJbYy3K+EZOU8Lkozjskn4auxqI/4=
Date: Tue, 12 Dec 2023 12:29:25 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch added to mm-unstable branch
Message-Id: <20231212202925.95733C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for update_schemes_tried_regions hang bug
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

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
Subject: selftests/damon: add a test for update_schemes_tried_regions hang bug
Date: Tue, 12 Dec 2023 19:48:10 +0000

Add a test for reproducing the update_schemes_tried_{regions,bytes}
command-causing indefinite hang bug that fixed by commit 7d6fa31a2fd7
("mm/damon/sysfs-schemes: add timeout for update_schemes_tried_regions"),
to avoid mistakenly re-introducing the bug.  Refer to the fix commit for
more details of the bug.

Link: https://lkml.kernel.org/r/20231212194810.54457-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                                   |    1 
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py |   33 ++++++++++
 2 files changed, 34 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug
+++ a/tools/testing/selftests/damon/Makefile
@@ -10,6 +10,7 @@ TEST_PROGS += debugfs_empty_targets.sh d
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
+TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -0,0 +1,33 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    proc = subprocess.Popen(['sleep', '2'])
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        nr_accesses=[200, 200]))] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err != None:
+        print('kdmaond start failed: %s' % err)
+        exit(1)
+
+    while proc.poll() == None:
+        err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
+        if err != None:
+            print('tried bytes update failed: %s' % err)
+            exit(1)
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

