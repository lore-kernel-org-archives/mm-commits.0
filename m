Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA26C22333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567823; cv=none; b=osMJniHKTIK9m/h0GJEFkhKtA3juMGL4cEKZNMnO87dLE8D5ovIKAfmpq0Zplh9VuxqD7b88z/gYb6lxHI9ZNDNxKg5ikxxMWajOuWfgF3bnXEO1FobMpT2R4vyjx5AIIxcNYoMSftdFPdF+/nqG7Kj2Gm+MjkJOByKWSegreQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567823; c=relaxed/simple;
	bh=VZ9Kxbu4clQbKYrEejyFSs8tpdDzUuoqtVoFBZZUiN8=;
	h=Date:To:From:Subject:Message-Id; b=c4GCQ331eHg1VWYNu1tuEOhwCMUy4DOMRRio0HaDezBFNomV9Y9ImmcAuA6qCzQcus9kHJabzCudqgeMfEGPyOpBdDk7gYw2PAeF+jenU0qLNKlTIooMp2eXvjqVpqYBRc+vdQ5V2gyYI/9NATt2F3TJFMemu6HAsIGX7OK86xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0WNrmY+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0WNrmY+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E10CC4CEED;
	Sat, 26 Jul 2025 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567823;
	bh=VZ9Kxbu4clQbKYrEejyFSs8tpdDzUuoqtVoFBZZUiN8=;
	h=Date:To:From:Subject:From;
	b=0WNrmY+0AmMOZMRIFjt2HZnVrngbkmbdN+UGwiVrAeIhZ+H6UjQjehJbV6F4nWBN2
	 a0IWK2/9if3HnKHFPC/fq13ibBESMbprhldapXK90CD4dpI+qjWvHgqed3ocL2Zwj4
	 L9D1rlD901YkrK9eCFXk/E+lxC5rsYpCruBBzSAc=
Date: Sat, 26 Jul 2025 15:10:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221023.8E10CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion
Date: Sun, 20 Jul 2025 10:16:46 -0700

DAMOS scheme commitment assertion is hard-coded for a specific test case. 
Split it out into a general version that can be reused for different test
cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   59 ++++++++++++++---------
 1 file changed, 37 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -80,6 +80,42 @@ def assert_migrate_dests_committed(dests
         assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
         assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
 
+def assert_access_pattern_committed(pattern, dump):
+    assert_true(dump['min_sz_region'] == pattern.size[0], 'min_sz_region',
+                dump)
+    assert_true(dump['max_sz_region'] == pattern.size[1], 'max_sz_region',
+                dump)
+    assert_true(dump['min_nr_accesses'] == pattern.nr_accesses[0],
+                'min_nr_accesses', dump)
+    assert_true(dump['max_nr_accesses'] == pattern.nr_accesses[1],
+                'max_nr_accesses', dump)
+    assert_true(dump['min_age_region'] == pattern.age[0], 'min_age_region',
+                dump)
+    assert_true(dump['max_age_region'] == pattern.age[1], 'miaxage_region',
+                dump)
+
+def assert_scheme_committed(scheme, dump):
+    assert_access_pattern_committed(scheme.access_pattern, dump['pattern'])
+    action_val = {
+            'willneed': 0,
+            'cold': 1,
+            'pageout': 2,
+            'hugepage': 3,
+            'nohugeapge': 4,
+            'lru_prio': 5,
+            'lru_deprio': 6,
+            'migrate_hot': 7,
+            'migrate_cold': 8,
+            'stat': 9,
+            }
+    assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
+    assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
+                'apply_interval_us', dump)
+    assert_true(dump['target_nid'] == scheme.target_nid, 'target_nid', dump)
+    assert_migrate_dests_committed(scheme.dests, dump['migrate_dests'])
+    assert_quota_committed(scheme.quota, dump['quota'])
+    assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -127,28 +163,7 @@ def main():
     if len(ctx['schemes']) != 1:
         fail('number of schemes', status)
 
-    scheme = ctx['schemes'][0]
-    if scheme['pattern'] != {
-            'min_sz_region': 0,
-            'max_sz_region': 2**64 - 1,
-            'min_nr_accesses': 0,
-            'max_nr_accesses': 2**32 - 1,
-            'min_age_region': 0,
-            'max_age_region': 2**32 - 1,
-            }:
-        fail('damos pattern', status)
-    if scheme['action'] != 9:   # stat
-        fail('damos action', status)
-    if scheme['apply_interval_us'] != 0:
-        fail('damos apply interval', status)
-    if scheme['target_nid'] != -1:
-        fail('damos target nid', status)
-
-    assert_migrate_dests_committed(_damon_sysfs.DamosDests(),
-                                   scheme['migrate_dests'])
-    assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
-    assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
-                                scheme['wmarks'])
+    assert_scheme_committed(_damon_sysfs.Damos(), ctx['schemes'][0])
 
     kdamonds.stop()
 
_

Patches currently in -mm which might be from sj@kernel.org are


