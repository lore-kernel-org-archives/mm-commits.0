Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F61D1C54B2
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 00:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765148; cv=none; b=ilnlPbWZecDh4K+RC4w46BmDLDQdJGLm9LMlxfafze9iAljkzUDAai7+2YPrfm3z2I2/7KBxZZB/JlCTS0VCBgX5d9lLLyOyJziGdP7RNeMioKNHSDSWWOajdKM8rFbHWDhP2KmhpSF7v82f7KsLPE/Gqkmm1GWa4k2sVf5nB6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765148; c=relaxed/simple;
	bh=THRPEcqkHOLz8+1q3EF2Z/aw7KBmhwh7LD/hqpM0Azo=;
	h=Date:To:From:Subject:Message-Id; b=UYoSAN2UT48EUJY6DDotctK0CCHj5CvE+arm+cRrA57gaEeaNQbTwpAfEzPTCcPb02u3JaGWQedGUtpIf1Hb1AHS7PYuk+MfTRXO/D8tIKQ2fI93SYrZtlzRRFUOOxzWRJhl8gAiUPCXNd4F2X6ipo0K0VIFkm3X6Nb9/nN97Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fS+L51N6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fS+L51N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64EEC4CEE7;
	Wed, 16 Apr 2025 00:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744765147;
	bh=THRPEcqkHOLz8+1q3EF2Z/aw7KBmhwh7LD/hqpM0Azo=;
	h=Date:To:From:Subject:From;
	b=fS+L51N6WmjCg8IB8xrPeSssBPeZNSOH1arlY+Og3dbiReKqb2/CRx5qx076XrjUF
	 MyBB0S25EXM3VqNZY9YJz48hlAW5KCsZQXnmxuQ1hT4ik63Wvn8fomli7NyPe5neIP
	 N607sUDLXuIulr0OLwXXGyOxtXXla+PlDiTKvbVY=
Date: Tue, 15 Apr 2025 17:59:07 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch added to mm-new branch
Message-Id: <20250416005907.C64EEC4CEE7@smtp.kernel.org>
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
Suggested-by: Michal Koutný <mkoutny@suse.com>
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

selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch
selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

