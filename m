Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8292C21CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567827; cv=none; b=Xm6q/B0mn8ayE9IkkWTLRKLhAtJ+G/VLvqx/lZYJrDk3rq+TmFBJx1+/uZ0dYEjDiCpR09ege71S0iSyf3Ez5Zt20n8US6UE4oMUqBQjhF5836I4J3FjlC2DBkUfUGkxv9Nvp10ESqI9neTE7LT+uajQW/3BOTQ2G+t44l4CNCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567827; c=relaxed/simple;
	bh=nEQR5yi/ECxPW6U7PbpLlvTtzEzMWZ9HklzK23WRJIY=;
	h=Date:To:From:Subject:Message-Id; b=u7ouOEYGGHBFd2ML70D67TKiLwhE1NaCz83gXf4HZEvuLCXhcNHUASIZU6h8H8gsQna6P+HEe2i8ix+/t9//ehRTnvKVJ9WnEa4J1nFGy3SjEmiRuiSM1KyEh4J5zc5JarHJzXNN+hDPHqInI3rcgHffc/QwDKkDFEXiZpmaT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxjZXs8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxjZXs8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07661C4CEED;
	Sat, 26 Jul 2025 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567827;
	bh=nEQR5yi/ECxPW6U7PbpLlvTtzEzMWZ9HklzK23WRJIY=;
	h=Date:To:From:Subject:From;
	b=rxjZXs8K1eGGPIC6/x/sK1kK5LLldBH+6rrbDhSSmvxaBxog/c8oM+FHu8XT/qrnf
	 ZADYqqzt8BBrplZ0d+5NELuUrrSACgziv4cO+uTQmX87DIY5fHYn0fr8NwISIPQXB+
	 1hwXjyZBljYgo85Azol/K285D4md/tCowEU4QbtU=
Date: Sat, 26 Jul 2025 15:10:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch removed from -mm tree
Message-Id: <20250726221027.07661C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: generalize monitoring attributes commit assertion
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: generalize monitoring attributes commit assertion
Date: Sun, 20 Jul 2025 10:16:49 -0700

DAMON monitoring attributes commitment assertion is hard-coded for a
specific test case.  Split it out into a general version that can be
reused for different test cases.

Link: https://lkml.kernel.org/r/20250720171652.92309-20-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   42 +++++++++++++----------
 1 file changed, 25 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -141,6 +141,29 @@ def assert_schemes_committed(schemes, du
     for idx, scheme in enumerate(schemes):
         assert_scheme_committed(scheme, dump[idx])
 
+def assert_monitoring_attrs_committed(attrs, dump):
+    assert_true(dump['sample_interval'] == attrs.sample_us, 'sample_interval',
+                dump)
+    assert_true(dump['aggr_interval'] == attrs.aggr_us, 'aggr_interval', dump)
+    assert_true(dump['intervals_goal']['access_bp'] ==
+                attrs.intervals_goal.access_bp, 'access_bp',
+                dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['aggrs'] == attrs.intervals_goal.aggrs,
+                'aggrs', dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['min_sample_us'] ==
+                attrs.intervals_goal.min_sample_us, 'min_sample_us',
+                dump['intervals_goal'])
+    assert_true(dump['intervals_goal']['max_sample_us'] ==
+                attrs.intervals_goal.max_sample_us, 'max_sample_us',
+                dump['intervals_goal'])
+
+    assert_true(dump['ops_update_interval'] == attrs.update_us,
+                'ops_update_interval', dump)
+    assert_true(dump['min_nr_regions'] == attrs.min_nr_regions,
+                'min_nr_regions', dump)
+    assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
+                'max_nr_regions', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -163,23 +186,8 @@ def main():
         fail('number of contexts', status)
 
     ctx = status['contexts'][0]
-    attrs = ctx['attrs']
-    if attrs['sample_interval'] != 5000:
-        fail('sample interval', status)
-    if attrs['aggr_interval'] != 100000:
-        fail('aggr interval', status)
-    if attrs['ops_update_interval'] != 1000000:
-        fail('ops updte interval', status)
-
-    if attrs['intervals_goal'] != {
-            'access_bp': 0, 'aggrs': 0,
-            'min_sample_us': 0, 'max_sample_us': 0}:
-        fail('intervals goal')
-
-    if attrs['min_nr_regions'] != 10:
-        fail('min_nr_regions')
-    if attrs['max_nr_regions'] != 1000:
-        fail('max_nr_regions')
+
+    assert_monitoring_attrs_committed(_damon_sysfs.DamonAttrs(), ctx['attrs'])
 
     if ctx['adaptive_targets'] != [
             { 'pid': 0, 'nr_regions': 0, 'regions_list': []}]:
_

Patches currently in -mm which might be from sj@kernel.org are


