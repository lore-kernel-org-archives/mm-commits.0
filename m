Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F7A155A4D;
	Tue, 18 Feb 2025 03:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739848085; cv=none; b=RSI1MjVLWgO1EBbHL6AOHPgXwemjieaJibgwvjs7dqvpmDRm36O4YvE+0/rD9OhA5cKZZFSBwvNUfBm5NEopZyAGcWtbSnf+oLc3GTrcVJINRYr5l4DJHyD/B0fqRx4O7fhHt6YUWURTCvxIjoPhlkDcP1hyMCbW1zZBhopCYp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739848085; c=relaxed/simple;
	bh=oTlFsX6aZVrtdL09xzaP0vAPsZFlP+QEOX2tiSGMTDM=;
	h=Date:To:From:Subject:Message-Id; b=b2lhsa8FTM09F4pIQdRGDd3w2gURPBySQQEvzb55cvlxVpgIb09eY94fie/4Rs1nfKM2dNEzeUWjaNsOJLucqPhjeYGD6SZu2AJEmG7zUzTDBV63lXStBBCWicqR+ydgVW7wW18tB+s3HZdongV+ctsT9GlOBV3S03cmdAb0f2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LAZIkyqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LAZIkyqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E76C4CED1;
	Tue, 18 Feb 2025 03:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739848084;
	bh=oTlFsX6aZVrtdL09xzaP0vAPsZFlP+QEOX2tiSGMTDM=;
	h=Date:To:From:Subject:From;
	b=LAZIkyqT5uVRfFJkEMtkOfxqo5aMWNtjodM3dHnm28griRO+XMwIPc3TaMOWiWZze
	 7h4/ho1wj/tSUO2cQc4ZTW6bvVS5seLYOrwsSOQqvztDEDjmrYxLv3a4j0GtUPSR8K
	 Wd3WtHUCeBnVGeYfe5jNS95m2nBHKmkNCydOtcag=
Date: Mon, 17 Feb 2025 19:08:04 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch added to mm-hotfixes-unstable branch
Message-Id: <20250218030804.A4E76C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
Date: Mon, 17 Feb 2025 10:23:04 -0800

damos_quota_goal.py selftest see if DAMOS quota goals tuning feature
increases or reduces the effective size quota for given score as expected.
The tuning feature sets the minimum quota size as one byte, so if the
effective size quota is already one, we cannot expect it further be
reduced.  However the test is not aware of the edge case, and fails since
it shown no expected change of the effective quota.  Handle the case by
updating the failure logic for no change to see if it was the case, and
simply skips to next test input.

Link: https://lkml.kernel.org/r/20250217182304.45215-1-sj@kernel.org
Fixes: f1c07c0a1662b ("selftests/damon: add a test for DAMOS quota goal")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502171423.b28a918d-lkp@intel.com
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[6.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damos_quota_goal.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/damos_quota_goal.py~selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced
+++ a/tools/testing/selftests/damon/damos_quota_goal.py
@@ -63,6 +63,9 @@ def main():
             if last_effective_bytes != 0 else -1.0))
 
         if last_effective_bytes == goal.effective_bytes:
+            # effective quota was already minimum that cannot be more reduced
+            if expect_increase is False and last_effective_bytes == 1:
+                continue
             print('efective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

