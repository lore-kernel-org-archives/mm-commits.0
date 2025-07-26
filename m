Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C8220F3F
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567825; cv=none; b=AmzY/dHH61nFGU83tpnhG2jeTgtFDGLQeHrfbVhklRCVPzNNC0wFIBmqtB29EFjnHN6pg0qh++YKexQN1M9t+Mox4vcwNLlyR3ou/8Y6AL4oVOGXIFDxOe/LvoKXBxL34/HXgT2Jhi8c2sdkJo6h4JSWPUUQx4PkGClmiDl1snI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567825; c=relaxed/simple;
	bh=pw2TKQBxLX70G5zVI9/ZRqjFMR4epz+su2jUM0dVPGQ=;
	h=Date:To:From:Subject:Message-Id; b=feUhQxO+lQXCl4NVUzFNoAW3y2uyB7gX0dS0nAgzjCYupv8Dw6IVmWQL9/Ky/G/fyH7SrvF5pZz3Cl3BqsLy/cTbDNEVr1aOJx5uYYCYJHl8nRC0KBf1YN1KAllmmuEmb1dpcATFr4vVflxXMMiVJsDpqg/hxEUlYa5iLn4RWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PDTjP4sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PDTjP4sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10D9C4CEED;
	Sat, 26 Jul 2025 22:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567824;
	bh=pw2TKQBxLX70G5zVI9/ZRqjFMR4epz+su2jUM0dVPGQ=;
	h=Date:To:From:Subject:From;
	b=PDTjP4sE3EemFjkAE7tcmGwJRKw/a2rG31ALJlizMT/4yiU3vsBOb2pOi2qATeLBm
	 TdUjkTxWtD+zeEOsxt/yKW64DANn0QJDp2PvyZYEZoBPavLxXrRoYTVHRArWmcxv+X
	 llgNoqgWi29w4dLaHegXZJFaGOi+K9e3n+JaQyXI=
Date: Sat, 26 Jul 2025 15:10:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-damos-filters-commitment.patch removed from -mm tree
Message-Id: <20250726221024.B10D9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS filters commitment
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-damos-filters-commitment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test DAMOS filters commitment
Date: Sun, 20 Jul 2025 10:16:47 -0700

Current DAMOS scheme commitment assertion is not testing DAMOS filters. 
Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-18-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damos-filters-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -80,6 +80,21 @@ def assert_migrate_dests_committed(dests
         assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
         assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
 
+def assert_filter_committed(filter_, dump):
+    assert_true(filter_.type_ == dump['type'], 'type', dump)
+    assert_true(filter_.matching == dump['matching'], 'matching', dump)
+    assert_true(filter_.allow == dump['allow'], 'allow', dump)
+    # TODO: check memcg_path and memcg_id if type is memcg
+    if filter_.type_ == 'addr':
+        assert_true([filter_.addr_start, filter_.addr_end] ==
+                    dump['addr_range'], 'addr_range', dump)
+    elif filter_.type_ == 'target':
+        assert_true(filter_.target_idx == dump['target_idx'], 'target_idx',
+                    dump)
+    elif filter_.type_ == 'hugepage_size':
+        assert_true([filter_.min_, filter_.max_] == dump['sz_range'],
+                    'sz_range', dump)
+
 def assert_access_pattern_committed(pattern, dump):
     assert_true(dump['min_sz_region'] == pattern.size[0], 'min_sz_region',
                 dump)
@@ -115,6 +130,11 @@ def assert_scheme_committed(scheme, dump
     assert_migrate_dests_committed(scheme.dests, dump['migrate_dests'])
     assert_quota_committed(scheme.quota, dump['quota'])
     assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
+    # TODO: test filters directory
+    for idx, f in enumerate(scheme.core_filters.filters):
+        assert_filter_committed(f, dump['filters'][idx])
+    for idx, f in enumerate(scheme.ops_filters.filters):
+        assert_filter_committed(f, dump['ops_filters'][idx])
 
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
_

Patches currently in -mm which might be from sj@kernel.org are


