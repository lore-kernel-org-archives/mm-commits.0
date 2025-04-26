Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A602C187
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 02:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745633796; cv=none; b=WC0FkNPVM5VAnigbgbtA/g7okNHimBYwbYVwrEKeHMykMJge6wCVAnvesxTBYlMBzj0HBdnq7AzxWB85DQspgMrdbDmMwHobjk/E9qBQzfTqMi9++QaSr7iJO8dOcsjjHDf+4VG/WtiLNR9JkH4QAmHjGaIz/fLRpBy3mfJJxu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745633796; c=relaxed/simple;
	bh=YCGB0FnVgNIB0nW1J5A21/Sd40Zpq6wBJqfkwc4S27M=;
	h=Date:To:From:Subject:Message-Id; b=Eu5gcFytB+UVVghcJw+gN7wnBfkqhNczrIRhf8D0XROHNJ1FpiwTlfkzoVa3GmfCEFr18giK1r0T6awdiz9J+Ik4MQcd5pCqEsWwMg4cLRhQlyrB4xH0pq4lq8HuoNXDePdUybPDS5f1JBnYn/wRTA9rhD74ZX+nsN5JYQBCjII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oHLGcfzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHLGcfzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288F7C4CEE4;
	Sat, 26 Apr 2025 02:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745633796;
	bh=YCGB0FnVgNIB0nW1J5A21/Sd40Zpq6wBJqfkwc4S27M=;
	h=Date:To:From:Subject:From;
	b=oHLGcfzF3ILMHfUCdCV6Y9yQ4M6nehTch+EJ9J7up6kBtUs5/iVOTG0g/jPyZvyip
	 RoLgIN868SedkAw2YyvfmlWhJMQ81C/JA70MOpcVt3Ql0MX0j8JM6rRvl7mmw8Y0HD
	 78qKBPSCqPOJXPTVJTYWWNkX/52ihe5l5Ze7Aa1Q=
Date: Fri, 25 Apr 2025 19:16:35 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch removed from -mm tree
Message-Id: <20250426021636.288F7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
has been removed from the -mm tree.  Its filename was
     selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: selftests: memcg: allow low event with no memory.low and memory_recursiveprot on
Date: Tue, 15 Apr 2025 17:04:14 -0400

Patch series "memcg: Fix test_memcg_min/low test failures", v7.

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test (with memory_recursiveprot enabled) and sporadically fails its
test_memcg_min sub-test.  This patchset fixes the test_memcg_min and
test_memcg_low failures by adjusting the test_memcontrol selftest to fix
these test failures.


This patch (of 2):

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test due to the fact that its 3rd test child cgroup which have a
memmory.low of 0 have low event count.  This happens when
memory_recursiveprot mount option is enabled which is the default setting
used by systemd to mount cgroup2 filesystem.

Modify the test_memcontrol.c to allow non-zero low event count in this
particular case with memory_recursiveprot on.

With this patch applied, the test_memcg_low sub-test finishes successfully
without failure in most cases.  Though both test_memcg_low and
test_memcg_min sub-tests may still fail occasionally if the memory.current
values fall outside of the expected ranges.

The 4th test child cgroup has no memory usage and so has an effective low
of 0.  It has no low event count because the mem_cgroup_below_low() check
in shrink_node_memcgs() is skipped as mem_cgroup_below_min() returns true.
If we ever change mem_cgroup_below_min() in such a way that it no longer
skips the no usage case, we will have to add code to explicitly skip it.

Link: https://lkml.kernel.org/r/20250415210415.13414-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20250415210415.13414-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   16 ++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -380,10 +380,10 @@ static bool reclaim_until(const char *me
  *
  * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
- * A/B/C  memory.current ~= 29M
- * A/B/D  memory.current ~= 21M
- * A/B/E  memory.current ~= 0
- * A/B/F  memory.current  = 0
+ * A/B/C  memory.current ~= 29M [memory.events:low > 0]
+ * A/B/D  memory.current ~= 21M [memory.events:low > 0]
+ * A/B/E  memory.current ~= 0   [memory.events:low == 0 if !memory_recursiveprot, > 0 otherwise]
+ * A/B/F  memory.current  = 0   [memory.events:low == 0]
  * (for origin of the numbers, see model in memcg_protection.m.)
  *
  * After that it tries to allocate more than there is
@@ -525,8 +525,14 @@ static int test_memcg_protection(const c
 		goto cleanup;
 	}
 
+	/*
+	 * Child 2 has memory.low=0, but some low protection is still being
+	 * distributed down from its parent with memory.low=50M if cgroup2
+	 * memory_recursiveprot mount option is enabled. So the low event
+	 * count will be non-zero in this case.
+	 */
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
-		int no_low_events_index = 1;
+		int no_low_events_index = has_recursiveprot ? 2 : 1;
 		long low, oom;
 
 		oom = cg_read_key_long(children[i], "memory.events", "oom ");
_

Patches currently in -mm which might be from longman@redhat.com are


