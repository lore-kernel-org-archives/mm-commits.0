Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7468A320F
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746335991; cv=none; b=EU48ALXTRgHW7dfQC5Bsli9bga9WOiPPQyKPQGVDwBcqQ2J+orGVuXc/8CiQB3Pb4DAPnRhrmYMoQhgdbw5AZiboEyFpvyTJtFjyeD/TvZSrCEsak0zSJIjKjrYIsrht68PcFVVFX5bt09uoQDcPNKpOGSqOY0QkEQusjkE2Krk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746335991; c=relaxed/simple;
	bh=cEL5oQKOIIqnYU1pcxBR4EQ4mZqlv/o1DDdI557bUSQ=;
	h=Date:To:From:Subject:Message-Id; b=je91k2ql+TzZRywNZKRLL0MLdzscBCphtj2BLDzbG5KwCLXGd3yWL8CzZNUpjCoLyEps7qzFyn+mLOSojdnRwgWT90HAILDc45vA0C646XqHAagOyu27xbfeJ0p813+qp/bhYdowCKdCO1hipZaBfw4q9ji2P588d6I9mxtlxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yb72a8wQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yb72a8wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B47C4CEE9;
	Sun,  4 May 2025 05:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746335991;
	bh=cEL5oQKOIIqnYU1pcxBR4EQ4mZqlv/o1DDdI557bUSQ=;
	h=Date:To:From:Subject:From;
	b=yb72a8wQwB95mP59tqI06ckCLbrXxd/EgAGijMJK8S/lyjxQix5izXWt3Mg2ykC2m
	 vKhyNC8JYRCmpFdYYXZbpZZ8Xk2OU/vPJAUwVOSJt25FN3PTAvqvqrOtUbbgiz/P74
	 stXbnOJHfpPWaJ1ebsEyhMZdUPaosvaMSEo4ODB4=
Date: Sat, 03 May 2025 22:19:50 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch added to mm-new branch
Message-Id: <20250504051950.E7B47C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
has been added to the -mm mm-new branch.  Its filename is
     selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Waiman Long <longman@redhat.com>
Subject: selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
Date: Thu, 1 May 2025 21:04:42 -0400

Patch series "memcg: Fix test_memcg_min/low test failures", v8.

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test (with memory_recursiveprot enabled) and sporadically fails its
test_memcg_min sub-test.  This patchset fixes the test_memcg_min and
test_memcg_low failures by adjusting the test_memcontrol selftest to fix
these test failures.


This patch (of 8):

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test due to the fact that its 3rd test child cgroup which have a
memmory.low of 0 have low event count.  This happens when
memory_recursiveprot mount option is enabled which is the default setting
used by systemd to mount cgroup2 filesystem.

This issue was originally fixed by commit cdc69458a5f3 ("cgroup: account
for memory_recursiveprot in test_memcg_low()").  It was later reverted by
commit 1d09069f5313 ("selftests: memcg: expect no low events in
unprotected sibling") expecting the memory reclaim code would be fixed. 
However, it turns out the unprotected cgroup may still have some residual
effective memory.low protection depending on the memory.low settings in
its parent and its siblings.  As a result, low events may still be
triggered.

One way to fix the test failure is to revert the revert commit.  However,
Michal suggested that it might be better to ignore the low event count
with memory_recursiveprot enabled as low event may or may not happen
depending on the actual test configuration.

Modify the test_memcontrol.c to ignore low event in the 3rd child cgroup
with memory_recursiveprot on.

The 4th child cgroup has no memory usage and so has an effective low of 0.
It has no low event count because the mem_cgroup_below_low() check in
shrink_node_memcgs() is skipped as mem_cgroup_below_min() returns true. 
If we ever change mem_cgroup_below_min() in such a way that it no longer
skips the no usage case, we will have to add code to explicitly skip it.

With this patch applied, the test_memcg_low sub-test finishes successfully
without failure in most cases.  Though both test_memcg_low and
test_memcg_min sub-tests may still fail occasionally if the memory.current
values fall outside of the expected ranges.

Link: https://lkml.kernel.org/r/20250502010443.106022-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20250502010443.106022-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   18 ++++++++++---
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -380,10 +380,11 @@ static bool reclaim_until(const char *me
  *
  * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
- * A/B/C  memory.current ~= 29M
- * A/B/D  memory.current ~= 21M
- * A/B/E  memory.current ~= 0
- * A/B/F  memory.current  = 0
+ * A/B/C  memory.current ~= 29M [memory.events:low > 0]
+ * A/B/D  memory.current ~= 21M [memory.events:low > 0]
+ * A/B/E  memory.current ~= 0   [memory.events:low == 0 if !memory_recursiveprot,
+ *				 undefined otherwise]
+ * A/B/F  memory.current  = 0   [memory.events:low == 0]
  * (for origin of the numbers, see model in memcg_protection.m.)
  *
  * After that it tries to allocate more than there is
@@ -525,7 +526,14 @@ static int test_memcg_protection(const c
 		goto cleanup;
 	}
 
+	/*
+	 * Child 2 has memory.low=0, but some low protection may still be
+	 * distributed down from its parent with memory.low=50M if cgroup2
+	 * memory_recursiveprot mount option is enabled. Ignore the low
+	 * event count in this case.
+	 */
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		int ignore_low_events_index = has_recursiveprot ? 2 : -1;
 		int no_low_events_index = 1;
 		long low, oom;
 
@@ -534,6 +542,8 @@ static int test_memcg_protection(const c
 
 		if (oom)
 			goto cleanup;
+		if (i == ignore_low_events_index)
+			continue;
 		if (i <= no_low_events_index && low <= 0)
 			goto cleanup;
 		if (i > no_low_events_index && low)
_

Patches currently in -mm which might be from longman@redhat.com are

selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch
selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

