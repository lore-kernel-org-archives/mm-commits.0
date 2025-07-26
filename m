Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1444C22129B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567830; cv=none; b=ha8Z1jaClSuZYbBZN6Ubo2sDTQQ5/TAhhH1cdd7u6BnOy4NXsP7gea9pShHrpvt7GP1NiHQ1IxwXd31+YJm/4Ds8+lJNcFffp+/MAgLMbXl8xIfHwGX1fXeARrGBbi8jMWE7PGzx1UmcJHPmZH70+qoCqDC1bzc93J26ua9/oWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567830; c=relaxed/simple;
	bh=rmoAZgaTJ6MCHPtqV3XAgOTteL29ch+RneBnLcEVVBI=;
	h=Date:To:From:Subject:Message-Id; b=ELxvh9QwEC5rUWb36MqyjHduFj+q7FjWRXCmv7eB8nz3Nik5KO/DVBQ01gVXdGiCtuNTBjlmVpjtOedEVns3Cl7sOH/4pzl+c7mrTgDsgZ/zyHoAq+c1lvWOSApy3qE0X/5fLJW7xcii4JKasEU5T/3gN0/NnFII1zeBZYGnrQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghjxKLlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghjxKLlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CEAC4CEED;
	Sat, 26 Jul 2025 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567829;
	bh=rmoAZgaTJ6MCHPtqV3XAgOTteL29ch+RneBnLcEVVBI=;
	h=Date:To:From:Subject:From;
	b=ghjxKLlx66tCpbE6sxUIakzLWSJF3cXreyMIQT+S0HgsBBqxxk69Y4b5NT3SAfSNd
	 KTPaKcaToc4YSvKbFGO4oIpKHf25BXMgWB4jvv1q0YgURgiCxrGkP5o2LqWfYRKZXh
	 FfCSCRzMi9dzZxWPjO0JFyI3IcXSf+NF7df1AP9s=
Date: Sat, 26 Jul 2025 15:10:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch removed from -mm tree
Message-Id: <20250726221029.62CEAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test non-default parameters runtime commit
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test non-default parameters runtime commit
Date: Sun, 20 Jul 2025 10:16:51 -0700

sysfs.py is testing only the default and minimum DAMON parameters.  Add
another test case for more non-default additional DAMON parameters
commitment on runtime.

Link: https://lkml.kernel.org/r/20250720171652.92309-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   53 +++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-non-default-parameters-runtime-commit
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -199,6 +199,59 @@ def main():
 
     assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
 
+    context = _damon_sysfs.DamonCtx(
+            monitoring_attrs=_damon_sysfs.DamonAttrs(
+                sample_us=100000, aggr_us=2000000,
+                intervals_goal=_damon_sysfs.IntervalsGoal(
+                    access_bp=400, aggrs=3, min_sample_us=5000,
+                    max_sample_us=10000000),
+                update_us=2000000),
+            schemes=[_damon_sysfs.Damos(
+                action='pageout',
+                access_pattern=_damon_sysfs.DamosAccessPattern(
+                    size=[4096, 2**10],
+                    nr_accesses=[3, 317],
+                    age=[5,71]),
+                quota=_damon_sysfs.DamosQuota(
+                    sz=100*1024*1024, ms=100,
+                    goals=[_damon_sysfs.DamosQuotaGoal(
+                        metric='node_mem_used_bp',
+                        target_value=9950,
+                        nid=1)],
+                    reset_interval_ms=1500,
+                    weight_sz_permil=20,
+                    weight_nr_accesses_permil=200,
+                    weight_age_permil=1000),
+                watermarks=_damon_sysfs.DamosWatermarks(
+                    metric = 'free_mem_rate', interval = 500000, # 500 ms
+                    high = 500, mid = 400, low = 50),
+                target_nid=1,
+                apply_interval_us=1000000,
+                dests=_damon_sysfs.DamosDests(
+                    dests=[_damon_sysfs.DamosDest(id=1, weight=30),
+                           _damon_sysfs.DamosDest(id=0, weight=70)]),
+                core_filters=[
+                    _damon_sysfs.DamosFilter(type_='addr', matching=True,
+                                             allow=False, addr_start=42,
+                                             addr_end=4242),
+                    ],
+                ops_filters=[
+                    _damon_sysfs.DamosFilter(type_='anon', matching=True,
+                                             allow=True),
+                    ],
+                )])
+    context.idx = 0
+    context.kdamond = kdamonds.kdamonds[0]
+    kdamonds.kdamonds[0].contexts = [context]
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        exit(1)
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
     kdamonds.stop()
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from sj@kernel.org are


