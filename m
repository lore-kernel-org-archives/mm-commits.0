Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A3302775
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675125; cv=none; b=WSdT1a4ydlc57iKj9sKs59HkwuqI59FtMuLt54CzFntdJHT5moAj/g003K3qlrV1XyWtRLwvxwkjpIwKOIb/lI8XqdvbZuGPdMTZ/yU93rwUXUm5hQkQjmhLOlJwyjtux7EiBTyXRtWuPSnPZtEuRiNpUX7M2rpF+/lQuqbDPM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675125; c=relaxed/simple;
	bh=txI1ZcU/peKf4hNuclrtfY6CV9veOKvkufRN6O0Se6A=;
	h=Date:To:From:Subject:Message-Id; b=JHMYfYkI54QCz2DenAhooOMn9dk/e/AlOLy7y+k4wYVHdWc9fOc0ZzkPiCfoKf/kfzWvh3873kbZ17qPSyezqv/vNZ7tdFRh3Ev8YfZX9IbpEpZsxx38RzLsU5u4njsGpvt9LmLolclnOSKIBYaCst7rxKsNpybthJ5AmEInf6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iqDsCARX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqDsCARX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704ABC4CEF1;
	Thu, 20 Nov 2025 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675125;
	bh=txI1ZcU/peKf4hNuclrtfY6CV9veOKvkufRN6O0Se6A=;
	h=Date:To:From:Subject:From;
	b=iqDsCARXuYWWeRPyemZ5dssF17qHk/ui053OG++JBERbUIgzzzpVIXPi+6zTycfUl
	 ZOH1x/A6Dg354bhhmGJusXyRgpdvo1YI2HBL3Q3tlE1WeCv1p3oF2r5w9z63uz6/p5
	 M4Kb4KqTqKiICWXUlt9aLTIl8tFummNxXzsdlSQM=
Date: Thu, 20 Nov 2025 13:45:24 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch removed from -mm tree
Message-Id: <20251120214525.704ABC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
Date: Wed, 12 Nov 2025 07:41:10 -0800

For each test case, sysfs.py makes changes to DAMON, dumps DAMON internal
status and asserts the expectation is met.  The dumping part should be the
same for all cases, so it is duplicated for each test case.  Which means
it is easy to make mistakes.  Actually a few of those duplicates are not
turning DAMON off in case of the dumping failure.  It makes following
selftests that need to turn DAMON on fails with -EBUSY.  Merge the status
dumping into commitment assertion with proper dumping failure handling, to
deduplicate and avoid the unnecessary following tests failures.

Link: https://lkml.kernel.org/r/20251112154114.66053-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   43 ++++++-----------------
 1 file changed, 13 insertions(+), 30 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -185,7 +185,15 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
-def assert_ctxs_committed(ctxs, dump):
+def assert_ctxs_committed(kdamonds):
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    ctxs = kdamonds.kdamonds[0].contexts
+    dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
@@ -202,13 +210,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     context = _damon_sysfs.DamonCtx(
             monitoring_attrs=_damon_sysfs.DamonAttrs(
@@ -256,12 +258,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     # test online commitment of minimum context.
     context = _damon_sysfs.DamonCtx()
@@ -270,12 +267,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     kdamonds.stop()
 
@@ -303,17 +295,8 @@ def main():
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
     kdamonds.kdamonds[0].commit()
-
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
     del kdamonds.kdamonds[0].contexts[0].targets[1]
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
-
+    assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from sj@kernel.org are


