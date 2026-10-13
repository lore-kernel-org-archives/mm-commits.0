Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0634048124E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865909; cv=none; b=ZWt9A9ySDdSD8it0d0EqAn3pCYHxQdmGOSQ2ZiXdDj4MwWMAwH1xp+Rt3f23MUOf6v4xUbq26yDGpSLhdLAytozoPZ79MGeBd4wNtW0fBut3aNJEcUE4XnahMqHK5e3dt+PSrDHuGPMX5PhtgjlVjiYuJzgKjqc/dY25jxEC2Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865909; c=relaxed/simple;
	bh=ReRKTQPk2c/PxJLEX7B8DWmjSDEym7opNXa8MfWUoug=;
	h=Date:To:From:Subject:Message-Id; b=rlPajubJucb2fyOmAutFV7sEz0BlQiiQDWrJFFs9x99bhEhJ9RYOiShoXNyIkiL/7SD0sojI1JRrKX/Dig1ECmCQhhmyaLzO6q2ihIPqYW3bHDQ+PJ6B7W6Zf69TDykj23ywmVLHh/L1+OQpMYDqlX5CpOClJm0Ms0HLS77VIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Moa9h8Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Moa9h8Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA361F000FF;
	Tue, 13 Oct 2026 04:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865907;
	bh=rJFqKW0G+1TsMhMckz4aL6wz7E9y8jra/njq40t7Yho=;
	h=Date:To:From:Subject;
	b=Moa9h8Rh+0lzHijLCnRByBcAMjUjCs/72C+OWBoTXqJyu8PZsH1jS1+/e2DvO/uoF
	 35WDCABnItEyEdqWB0Avlak2mEOXHBf+dbhZWmA56PimdaMDuOhbSvnePIMby0v3br
	 LvyGb7n6z53M+XqE5VnOf00vFPw2EhXCMhN24UbA=
Date: Mon, 12 Oct 2026 21:31:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,eva.kurchatova@virtuozzo.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch removed from -mm tree
Message-Id: <20261013043147.AAA361F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: stop kdamond on error exits of no-op commit test
has been removed from the -mm tree.  Its filename was
     selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Assisted-by: GLM-5.3 OpenCode
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

mm-damon-api-remove-unused-nr_damos_-enumerators.patch
selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

