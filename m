Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DA1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119345; cv=none; b=NkU+RJ8/MhIDbAlholuvWuTLOzuxY9ZK8YJL6u/kEZbYtXpJmD3Qo1WuYt0vczyTogi5NDBgRuJIz66bBaYiz9TpNPG/SrQCGCcwk5Kyw+Wi4requ1jVt9fNxPW/QCEgS6Kp6phCAdpWDXi1/myRk15/I4+h9cEzGerQ/IwNL1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119345; c=relaxed/simple;
	bh=dFIpC2K6Y/MQk88YooNhnTgflWVSaoigtfOiyiPSdek=;
	h=Date:To:From:Subject:Message-Id; b=f0m4OWEB/71woH5a+7OlVDhUoLrn8YbgIIfiJYhTMRadrqHfB1yPjMopY93P4S7t6qVzziRmI1mpyNdgLnDjI+AwlzizJK5dO07yjniloABmF2xdDI18H1W1YteBM/MHmRZMWFiajOpiO9f9shVRDLIj3Lr1uN/AaiFuYVdYksI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IuceEd6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IuceEd6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E58C4CEE4;
	Tue, 13 May 2025 06:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119345;
	bh=dFIpC2K6Y/MQk88YooNhnTgflWVSaoigtfOiyiPSdek=;
	h=Date:To:From:Subject:From;
	b=IuceEd6r2PVv2Nsbsn7Niz1/Q4P1X7IX9l1lli5dNbUxJwQQGIfX3eLKoDBH+1fLG
	 5v+ECMLeEPrI/2QCjjuXBkxXsRna6Ocgr//j+6TfDKhj+aAsz3ogJC6nBalcoAEulH
	 9dyMC5AZ75xbvEVeLFPDRyGtjgIhnj4LKeLrjk+0=
Date: Mon, 12 May 2025 23:55:44 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch removed from -mm tree
Message-Id: <20250513065544.E9E58C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
has been removed from the -mm tree.  Its filename was
     selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
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


