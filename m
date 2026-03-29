Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6E2580E1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744877; cv=none; b=I0ise6V1x04rLZvXYrimyG9d09Wmj+OTe7LCkIMY/99YfSl5tthDnofNiomDGCnswlwl1xcNKX4GMVGbdQFJDZ4lq2DGTXmp+mx8FhjtvWos9i1sZwpXTwrZh16SrilD//2O4EWx5Ct9nh6KEbhzgVH7FjnffJkJwz4jvetFxxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744877; c=relaxed/simple;
	bh=wibkOHEGlcbFdqTmAdP1wXlk1WFb+yCkZFp911VE5Vw=;
	h=Date:To:From:Subject:Message-Id; b=HNNOhowo7S4xwGzt8firv9Q8qCqShugW/KdHw6hGLqkG4s/S/iXLxxN42Ifgsd2CepXrHfjfTR8VHzVBQYjyy8Ccz/mri5O7u75vnIJl+2WvZi3/q2C5I1yK7/s80v7SHXlMsMDeHPoM41Le524xYQWL1Bsu+9VsUvcLufqMf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TajF3TmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TajF3TmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C7C4CEF7;
	Sun, 29 Mar 2026 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744877;
	bh=wibkOHEGlcbFdqTmAdP1wXlk1WFb+yCkZFp911VE5Vw=;
	h=Date:To:From:Subject:From;
	b=TajF3TmYvNl2rPNO3PqLukJUFQ8x0SC0J/82EHiIyMePakvxflS3yqm//j1fu41HF
	 eHN8R0AxDNstwgA5/dcNyzOO0EUD7YEoN6XqYPmkgkfypfXGQx1Kj+usRJ+tWyJ6qA
	 6G08TFH7RISc+rawLmmhmAQVVQnYohTfQ1SoXI7Q=
Date: Sat, 28 Mar 2026 17:41:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfspy-test-goal_tuner-commit.patch removed from -mm tree
Message-Id: <20260329004117.1F3C7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test goal_tuner commit
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-goal_tuner-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test goal_tuner commit
Date: Mon, 9 Mar 2026 18:05:27 -0700

Extend the near-full DAMON parameters commit selftest to commit goal_tuner
and confirm the internal status is updated as expected.

Link: https://lkml.kernel.org/r/20260310010529.91162-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-goal_tuner-commit
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -67,6 +67,12 @@ def assert_quota_committed(quota, dump):
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
     for idx, qgoal in enumerate(quota.goals):
         assert_quota_goal_committed(qgoal, dump['goals'][idx])
+    tuner_val = {
+            'consist': 0,
+            'temporal': 1,
+            }
+    assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
+                'goal_tuner', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -231,6 +237,7 @@ def main():
                         metric='node_mem_used_bp',
                         target_value=9950,
                         nid=1)],
+                    goal_tuner='temporal',
                     reset_interval_ms=1500,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

