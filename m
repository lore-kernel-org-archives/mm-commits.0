Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E0239099
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567821; cv=none; b=VGupdEuFNw5zoSNA+sJvW3epzW3M0F6iiDPZoTUoK8mw4xxyYW5JHgaGeJ0WU3W+EX2pLBWfszqBVlfa9+SF71wUuE3Vwk6s6fSfeKsdjCBjsi3WZIsHjYieS1H/WrFYVNdORuig/1OiZ4nTjp4JqjX43WbuJt5dQgRc0X89ens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567821; c=relaxed/simple;
	bh=78iljMrkCZbTcAAvxmeIdujYHhWmcXHkch/QDI/YFGg=;
	h=Date:To:From:Subject:Message-Id; b=EBXr/SgGhwDVS2t5jGYFVhfTI48EOaIRN1ItqSJP8F5Ufy23ZtZ2jepBYeEjLVd7cGvHvXn5uY635Hdwkm+DBtTPGEsVPpWB48Ob2fNEGvMmoi+Nn3EV/qoTLTthShEcUha5qc24YvAfyv9gScMyZQTCA8p08h3KfTDRljHcX/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbd2/6Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbd2/6Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9A4C4CEED;
	Sat, 26 Jul 2025 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567821;
	bh=78iljMrkCZbTcAAvxmeIdujYHhWmcXHkch/QDI/YFGg=;
	h=Date:To:From:Subject:From;
	b=tbd2/6YvNSUa3kE/awS688AFasDRDRaNaRbZJx5L4FcSVyiCaQfbzw0qYKmbndZ11
	 4r3AFfUQTkQJNZxrLOV1Q3NKZsnA5sAiAH9U6bNUy6q6SoSQuQS2SPMalBQnPHzgSC
	 z3aSY+VSrWtJ7monM6k/8F1W+EICB/hmyRcTTGCg=
Date: Sat, 26 Jul 2025 15:10:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-quota-goal-commitment.patch removed from -mm tree
Message-Id: <20250726221021.3C9A4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test quota goal commitment
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-quota-goal-commitment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test quota goal commitment
Date: Sun, 20 Jul 2025 10:16:44 -0700

Current DAMOS quota commitment assertion is not testing quota goal
commitment.  Add the test.

Link: https://lkml.kernel.org/r/20250720171652.92309-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-quota-goal-commitment
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -45,12 +45,28 @@ def assert_watermarks_committed(watermar
     assert_true(dump['mid'] == watermarks.mid, 'mid', dump)
     assert_true(dump['low'] == watermarks.low, 'low', dump)
 
+def assert_quota_goal_committed(qgoal, dump):
+    metric_val = {
+            'user_input': 0,
+            'some_mem_psi_us': 1,
+            'node_mem_used_bp': 2,
+            'node_mem_free_bp': 3,
+            }
+    assert_true(dump['metric'] == metric_val[qgoal.metric], 'metric', dump)
+    assert_true(dump['target_value'] == qgoal.target_value, 'target_value',
+                dump)
+    if qgoal.metric == 'user_input':
+        assert_true(dump['current_value'] == qgoal.current_value,
+                    'current_value', dump)
+    assert_true(dump['nid'] == qgoal.nid, 'nid', dump)
+
 def assert_quota_committed(quota, dump):
     assert_true(dump['reset_interval'] == quota.reset_interval_ms,
                 'reset_interval', dump)
     assert_true(dump['ms'] == quota.ms, 'ms', dump)
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
-    # TODO: assert goals are committed
+    for idx, qgoal in enumerate(quota.goals):
+        assert_quota_goal_committed(qgoal, dump['goals'][idx])
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
_

Patches currently in -mm which might be from sj@kernel.org are


