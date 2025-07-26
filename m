Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063A239099
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567822; cv=none; b=m/ihDccE3yjzai8IkZa0gT0X9VTP75mB9kJ0eWUGtOR21OcbCV2edzdjhcSxb0X/1aSkPrpUJL+4jfsqcqTy/XxZCLPKbS7l+cyjerfv4tgRTuGkHkgXvBBNaNkQ+rG0UTQUOpdkwozd80il7YNqbDwb4TKdvqSAe3beYT70wlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567822; c=relaxed/simple;
	bh=90hN2HDjWm+QtArIfj3bbk3WEm5v+hfJTzsvakJTiaw=;
	h=Date:To:From:Subject:Message-Id; b=r3H88WEsHtyxPuqySbuHKgjpEwmpTizVW1p7Tyl8m4h0y3b1QgOhNG6djI8xACU8XDSamIvZXIrjq42PWx2cWTTCOM1ads5cG0cLZpNhHz78JkOgRuPxMNIn7bQx441sqE1RWZcDu9y5rrvsFf+6U1qt6xPW50WgpZA2QtTYaf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Evr3w5kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Evr3w5kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE29C4CEED;
	Sat, 26 Jul 2025 22:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567822;
	bh=90hN2HDjWm+QtArIfj3bbk3WEm5v+hfJTzsvakJTiaw=;
	h=Date:To:From:Subject:From;
	b=Evr3w5kjTp7xeT4C8kJlD1040JwAXpz5cx1UzJARWRYrqAtHPKbwwre2Dl+DEV4Y8
	 qvhTR3CXNVDapks7oDNoefHjgeySB1aFcSEYynxaZjRNp+j4cegobX05NSaZBSWUxe
	 MZ9Z2dupJZn4GwHUNk8WbanQM6SywJgWVMmdZWv8=
Date: Sat, 26 Jul 2025 15:10:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-damos-destinations-commitment.patch removed from -mm tree
Message-Id: <20250726221022.6BE29C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test DAMOS destinations commitment
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-damos-destinations-commitment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test DAMOS destinations commitment
Date: Sun, 20 Jul 2025 10:16:45 -0700

Current DAMOS commitment assertion is not testing quota destinations
commitment.  Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damos-destinations-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,13 @@ def assert_quota_committed(quota, dump):
     assert_true(
             dump['weight_age'] == quota.weight_age_permil, 'weight_age', dump)
 
+
+def assert_migrate_dests_committed(dests, dump):
+    assert_true(dump['nr_dests'] == len(dests.dests), 'nr_dests', dump)
+    for idx, dest in enumerate(dests.dests):
+        assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
+        assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -137,14 +144,8 @@ def main():
     if scheme['target_nid'] != -1:
         fail('damos target nid', status)
 
-    migrate_dests = scheme['migrate_dests']
-    if migrate_dests['nr_dests'] != 0:
-        fail('nr_dests', status)
-    if migrate_dests['node_id_arr'] != []:
-        fail('node_id_arr', status)
-    if migrate_dests['weight_arr'] != []:
-        fail('weight_arr', status)
-
+    assert_migrate_dests_committed(_damon_sysfs.DamosDests(),
+                                   scheme['migrate_dests'])
     assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
     assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
                                 scheme['wmarks'])
_

Patches currently in -mm which might be from sj@kernel.org are


