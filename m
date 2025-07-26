Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32B728727E
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567818; cv=none; b=ucZb0R7k+TsNIb3EOTIt11iMRLt9i+79PmZnBPw0l/bQI4yiGQpRiawNjMtGVOfTTcA4Nr8zDlf/T2DkmE2Gx4ueEJl6gJoBaCOnecw9dTOOEMZ2x7dPziI3zDXt9fkfotbNIcGHq2imUAUrj5888Ynai2vkxiGfdXQWOUKB9D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567818; c=relaxed/simple;
	bh=MnJAuZd3wwVcHuFOzB/iuU1Iw2hjmV1aQHByVk+lkMI=;
	h=Date:To:From:Subject:Message-Id; b=Z41Gg3T25O7ih9S5EdiDu1fpzMRPbZ95xRSGllk1qJDSiAJ1DcrjwGMxnJPwlodeGRl+3AQUHYdJGokifAi02EW4CuQo9AyVUHK9/O0foWrlvV3EJAPMql57PDMVLvnAA0QuaXUoV/VfHOSzY8C28v9NFTpq2LXo9rf0ling4y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ddXM2E6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ddXM2E6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8370C4CEED;
	Sat, 26 Jul 2025 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567817;
	bh=MnJAuZd3wwVcHuFOzB/iuU1Iw2hjmV1aQHByVk+lkMI=;
	h=Date:To:From:Subject:From;
	b=ddXM2E6otgsNMU2tDW2c0uHXLRhUXmDpGGTuUc2QmygKwdYB0Mbrvz/fa7H4T6eg8
	 Wjuw5/4iuQ2YLqRb09YNx7ZLcEm6N+NQ4juyqlHu7QfMYh8DzG+S2I8GBg+XqmbNB2
	 uFC+PDbtjpX2QGxVY5hn0Zn2N58Sw0rznIOMXapk=
Date: Sat, 26 Jul 2025 15:10:17 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch removed from -mm tree
Message-Id: <20250726221017.C8370C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump DAMOS filters
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: dump DAMOS filters
Date: Sun, 20 Jul 2025 10:16:41 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add damos filters dumping for more
tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |   43 +++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-damos-filters
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -135,8 +135,37 @@ def damos_migrate_dests_to_dict(dests):
             'nr_dests': nr_dests,
             }
 
+def damos_filter_to_dict(damos_filter):
+    filter_type_keyword = {
+            0: 'anon',
+            1: 'active',
+            2: 'memcg',
+            3: 'young',
+            4: 'hugepage_size',
+            5: 'unmapped',
+            6: 'addr',
+            7: 'target'
+            }
+    dict_ = {
+            'type': filter_type_keyword[int(damos_filter.type)],
+            'matching': bool(damos_filter.matching),
+            'allow': bool(damos_filter.allow),
+            }
+    type_ = dict_['type']
+    if type_ == 'memcg':
+        dict_['memcg_id'] = int(damos_filter.memcg_id)
+    elif type_ == 'addr':
+        dict_['addr_range'] = [int(damos_filter.addr_range.start),
+                               int(damos_filter.addr_range.end)]
+    elif type_ == 'target':
+        dict_['target_idx'] = int(damos_filter.target_idx)
+    elif type_ == 'hugeapge_size':
+        dict_['sz_range'] = [int(damos_filter.sz_range.min),
+                             int(damos_filter.sz_range.max)]
+    return dict_
+
 def scheme_to_dict(scheme):
-    return to_dict(scheme, [
+    dict_ = to_dict(scheme, [
         ['pattern', damos_access_pattern_to_dict],
         ['action', int],
         ['apply_interval_us', int],
@@ -145,6 +174,18 @@ def scheme_to_dict(scheme):
         ['target_nid', int],
         ['migrate_dests', damos_migrate_dests_to_dict],
         ])
+    filters = []
+    for f in list_for_each_entry(
+            'struct damos_filter', scheme.filters.address_of_(), 'list'):
+        filters.append(damos_filter_to_dict(f))
+    dict_['filters'] = filters
+    ops_filters = []
+    for f in list_for_each_entry(
+            'struct damos_filter', scheme.ops_filters.address_of_(), 'list'):
+        ops_filters.append(damos_filter_to_dict(f))
+    dict_['ops_filters'] = ops_filters
+
+    return dict_
 
 def schemes_to_list(schemes):
     return [scheme_to_dict(s)
_

Patches currently in -mm which might be from sj@kernel.org are


