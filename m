Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85C4CE17
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elmYIY5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEFFC433C7;
	Wed, 20 Dec 2023 22:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112563;
	bh=/CrVCZLjF9YcezqYSL1KwUK509JbN5NQi+vlnrh7lgU=;
	h=Date:To:From:Subject:From;
	b=elmYIY5ro7JK4VRtC7TZY94u3xIw8eTqee0l2T7VOTa8AG/Bfud3IbODU7+OTNiPX
	 aw0+4S3FtHCNEn+g+0utxwcpN+JvVcg/miND3lWHde4FEEABtGKkIwUxxZFINHZw+g
	 9KwYFFXQidP3vRmF696pzZ5wPM1Ls0IoE3o0b8k8=
Date: Wed, 20 Dec 2023 14:49:22 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch removed from -mm tree
Message-Id: <20231220224923.3EEFFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for update_schemes_tried_regions hang bug
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


