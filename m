Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F3C3CBE86
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 02:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437636; cv=none; b=oOYLd+aIbibAbnzEaho0klOtvKMOnS04fBhr2tMej3ymMBex9yJ0makcfXDcGOROQe7Lebl6hlMCy8TqlF5fcpqbtLHS3qyofml6WTLy+hSqGBiMnAiZt0UZFHXzlCNo6Ua49tlSsg9VAI8i6puC1tTOie8RoZ/XEGl7tYMSUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437636; c=relaxed/simple;
	bh=xkYwr8SW1CDgQ1un+v6CUdXUzYvg73rWo2MZyLI9nPE=;
	h=Date:To:From:Subject:Message-Id; b=obR7S+csfvhn3NITuYXXbthqW4qcLiSC+gwDy8ViIuI0LUDNClZl9EvyhM9d0FyjMNaH5KvhCLYX8IIh1cWyWxLECgHbcd9pvsxX88qX6WcNWZKDBHYYCSUFz1fnFVCTFf3x1QltmlsQMfrdCGgoC1LWZSucG0Q6oP2azbooSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+ncxyFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+ncxyFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDF21F00893;
	Tue, 15 Sep 2026 02:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437635;
	bh=EHekIpsn97ZxS/SI6Yvym4bV1M4RWsdeq4v9fHbDQQU=;
	h=Date:To:From:Subject;
	b=f+ncxyFGfieyxsP5Dx9Wm5uzIKcj+pqx2LYKDmg9LY+NMXeE84XrG8t5dFnrsiRca
	 iU60/hJ5hroLp4MQO+VAXhuEQsmNVzdwLjuudu39AuhZCOetnw2RMl2TZ7kkusDlGk
	 8mPeJIqb3cVslVMTlLpvuZ0r6mUdxSTgnmfmlgac=
Date: Mon, 14 Sep 2026 19:00:34 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch added to mm-new branch
Message-Id: <20260915020035.0FDF21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: stop kdamond on error exits of no-op commit test
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/damon: stop kdamond on error exits of no-op commit test
Date: Mon, 14 Sep 2026 07:19:46 -0700

Patch series "mm/damon: misc improvements in tests and documents".

Add various improvements to DAMON tests and documents.

Patch 1 and 2 from Zenghui Yu (Huawei) let DAMON selftest to clean up its
state and output after running the tests.  Patch 3 from Eva Kurchatova
makes a few selftest be able to run with Python's safe path mode.  Patch 4
from Kunwu Chan improves coverage of DAMON kunit tests.  Finally, patches
5 and 6 from Liew Rui Yan clarify and fix typos on documents for DAMOS
quota behaviors.

Below are notes that can be removed in the final commit message.

This is a batched repost of DAMON patches that were individually posted. 
Please refer to each patch for changelog.


This patch (of 6):

The sysfs_no_op_commit_break test starts a kdamond via sysfs, but its
error paths (e.g., drgn not installed) exit without stopping it.  The
leaked kdamond then makes subsequent tests, e.g.  lru_sort.sh and
reclaim.sh, skip with "Another kdamond is running".

Wrap the post-start logic in try-finally so that kdamonds.stop() is
executed on every exit path.

Link: https://lore.kernel.org/20260914141952.91465-1-sj@kernel.org
Link: https://lore.kernel.org/20260914141952.91465-2-sj@kernel.org
Fixes: 10725cd2b09a ("selftests/damon: test no-op commit broke DAMON status")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Assisted-by: GLM-5.3 OpenCode
---

 tools/testing/selftests/damon/sysfs_no_op_commit_break.py |   41 +++++-----
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py~selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test
+++ a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -47,26 +47,27 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    before_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('before-commit status dump failed: %s' % err)
-        exit(1)
-
-    kdamonds.kdamonds[0].commit()
-
-    after_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('after-commit status dump failed: %s' % err)
-        exit(1)
-
-    if before_commit_status != after_commit_status:
-        print(f'before: {json.dumps(before_commit_status, indent=2)}')
-        print(f'after: {json.dumps(after_commit_status, indent=2)}')
-        exit(1)
-
-    kdamonds.stop()
+    try:
+        before_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('before-commit status dump failed: %s' % err)
+            exit(1)
+
+        kdamonds.kdamonds[0].commit()
+
+        after_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('after-commit status dump failed: %s' % err)
+            exit(1)
+
+        if before_commit_status != after_commit_status:
+            print(f'before: {json.dumps(before_commit_status, indent=2)}')
+            print(f'after: {json.dumps(after_commit_status, indent=2)}')
+            exit(1)
+    finally:
+        kdamonds.stop()
 
 if __name__ == '__main__':
     main()
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch
selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch

