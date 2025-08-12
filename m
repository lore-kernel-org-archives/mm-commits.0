Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E4B2571C2
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 03:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754970621; cv=none; b=YqWFATIv9gCaXctQ/BGjzg5iXgye7rLtuxktyzI3uaxNNMQb35/HD0RwZTqm1XiP6C8y+FHk7MxNgvIwSwaM6lR89MuG+uqGee/luFnWn+/R7qieFAiodb8uIS6/QK7jqRYVXCSgL3J83TpGpSFZ/LcnPL3Lg0thPPnuGpKGgDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754970621; c=relaxed/simple;
	bh=MzltzPIpsR8aksxvwNAm7dlgw2ZEJlqPqyalLuFqX/U=;
	h=Date:To:From:Subject:Message-Id; b=H6sLmUWd4+7+p+cwlxAxQAyyo5PGmCYV9tWsATps+3hrJn2zh4GvReRaH5HwXfaVPPQpyUv6Ipo+dQLRKQypSihTfYnh09rrPrahEpnDx+Ah8hq16GD5G6aXuoUFxeMRb2I3Xc2TMOhYkOMDjgmL/xNxD55q26du9R0t8A16u+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdAbzy/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdAbzy/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71963C4CEF0;
	Tue, 12 Aug 2025 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754970619;
	bh=MzltzPIpsR8aksxvwNAm7dlgw2ZEJlqPqyalLuFqX/U=;
	h=Date:To:From:Subject:From;
	b=gdAbzy/jylc/yBWDdTGDROurnMYybVwrEo/yBRO6BrwOLWKRN8GdUb7wKdGViEmku
	 OYvIONB16yk6Lq5NcNL0XZoQxtpKjofzjrJ4uST4/C0OJf/okZMpqIwCJUC4IkIxrR
	 Mnu9xKCh1P+ue0+auNbD4LeTdMyInU6+VaSH5Y10=
Date: Mon, 11 Aug 2025 20:50:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-test-no-op-commit-broke-damon-status.patch added to mm-new branch
Message-Id: <20250812035019.71963C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: test no-op commit broke DAMON status
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-test-no-op-commit-broke-damon-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-test-no-op-commit-broke-damon-status.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: selftests/damon: test no-op commit broke DAMON status
Date: Sun, 10 Aug 2025 21:43:54 +0900

Add test to verify that DAMON status is not changed after a no-op commit.

Link: https://lkml.kernel.org/r/20250810124354.16456-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                    |    1 
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py |   72 ++++++++++
 2 files changed, 73 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-no-op-commit-broke-damon-status
+++ a/tools/testing/selftests/damon/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS += reclaim.sh lru_sort.sh
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_memcg_path_leak.sh
+TEST_PROGS += sysfs_no_op_commit_break.py
 
 EXTRA_CLEAN = __pycache__
 
diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -0,0 +1,72 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import json
+import os
+import subprocess
+import sys
+
+import _damon_sysfs
+
+def dump_damon_status_dict(pid):
+    try:
+        subprocess.check_output(['which', 'drgn'], stderr=subprocess.DEVNULL)
+    except:
+        return None, 'drgn not found'
+    file_dir = os.path.dirname(os.path.abspath(__file__))
+    dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
+    rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
+        stderr=subprocess.DEVNULL)
+
+    if rc != 0:
+        return None, f'drgn fail: return code({rc})'
+    try:
+        with open('damon_dump_output', 'r') as f:
+            return json.load(f), None
+    except Exception as e:
+        return None, 'json.load fail (%s)' % e
+
+def main():
+    kdamonds = _damon_sysfs.Kdamonds(
+        [_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                schemes=[_damon_sysfs.Damos(
+                    ops_filters=[
+                        _damon_sysfs.DamosFilter(
+                            type_='anon',
+                            matching=True,
+                            allow=True,
+                        )
+                    ]
+                )],
+            )])]
+    )
+
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    before_commit_status, err = \
+        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print('before-commit status dump failed: %s' % err)
+        exit(1)
+
+    kdamonds.kdamonds[0].commit()
+
+    after_commit_status, err = \
+        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print('after-commit status dump failed: %s' % err)
+        exit(1)
+
+    if before_commit_status != after_commit_status:
+        print(f'before: {json.dump(before_commit_status, indent=2)}')
+        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        exit(1)
+
+    kdamonds.stop()
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch

