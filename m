Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B1A1C54B2
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765150; cv=none; b=kUxJRBTM6Jthb+0Z/hZ+NkkPOr/ToaGxUrUmvxDfXYKgVQptXX9eCB4aTFLn5ZhzMTqmf9cxtFUEAKXxxus0So3jlRSoiuow3MtEQ+oiiwMgv4pFDUik+whgRJD/v3JJpGle1s8jI92mHk2Ae2ecZPHhS714THSlZJBI0L/7UWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765150; c=relaxed/simple;
	bh=SVJK9b5ZNTjRvot8gOnjMhAYNUJQC5hIuwUCH563dX4=;
	h=Date:To:From:Subject:Message-Id; b=GzjWp7ZJ7gVASG1ZjqnS5aX/5gbK+X09LICDuKAyWGO4F++cN0wZXWywhP/GuwfsBRLSCse7LCo923ciEzo5POaJB+shs0bk63HN6XuVZ9Lmt57NaiRUiKi8CBzaMhqvMMRzSvHZANBRQNcUK2V5MWvLEdICEGzNoq2VEg+sIa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t13Av/aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t13Av/aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E31C4CEE7;
	Wed, 16 Apr 2025 00:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744765150;
	bh=SVJK9b5ZNTjRvot8gOnjMhAYNUJQC5hIuwUCH563dX4=;
	h=Date:To:From:Subject:From;
	b=t13Av/aN5uI9oM5mlhEfAyX6uVT3ncZCcpWBA1Q1SMrClQNFbq7omCp+o3dOjhqwl
	 IQXF7A3lhr5t5PwQEOfNO75XZokRN92dOKRiRDGrXR6bK2FmQKQr+o+qfJs0MwdSg+
	 +++cqnsgEa6oMbHBFBsTv3vApXq2LsPrQr2OhlgE=
Date: Tue, 15 Apr 2025 17:59:09 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch added to mm-new branch
Message-Id: <20250416005910.09E31C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: memcg: Increase error tolerance of child memory.current check in test_memcg_protection()
has been added to the -mm mm-new branch.  Its filename is
     selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

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
Subject: selftests: memcg: Increase error tolerance of child memory.current check in test_memcg_protection()
Date: Tue, 15 Apr 2025 17:04:15 -0400

The test_memcg_protection() function is used for the test_memcg_min and
test_memcg_low sub-tests. This function generates a set of parent/child
cgroups like:

  parent:  memory.min/low = 50M
  child 0: memory.min/low = 75M,  memory.current = 50M
  child 1: memory.min/low = 25M,  memory.current = 50M
  child 2: memory.min/low = 0,    memory.current = 50M

After applying memory pressure, the function expects the following
actual memory usages.

  parent:  memory.current ~= 50M
  child 0: memory.current ~= 29M
  child 1: memory.current ~= 21M
  child 2: memory.current ~= 0

In reality, the actual memory usages can differ quite a bit from the
expected values. It uses an error tolerance of 10% with the values_close()
helper.

Both the test_memcg_min and test_memcg_low sub-tests can fail
sporadically because the actual memory usage exceeds the 10% error
tolerance. Below are a sample of the usage data of the tests runs
that fail.

  Child   Actual usage    Expected usage    %err
  -----   ------------    --------------    ----
    1       16990208         22020096      -12.9%
    1       17252352         22020096      -12.1%
    0       37699584         30408704      +10.7%
    1       14368768         22020096      -21.0%
    1       16871424         22020096      -13.2%

The current 10% error tolerenace might be right at the time
test_memcontrol.c was first introduced in v4.18 kernel, but memory
reclaim have certainly evolved quite a bit since then which may result
in a bit more run-to-run variation than previously expected.

Increase the error tolerance to 15% for child 0 and 20% for child 1 to
minimize the chance of this type of failure. The tolerance is bigger
for child 1 because an upswing in child 0 corresponds to a smaller
%err than a similar downswing in child 1 due to the way %err is used
in values_close().

Before this patch, a 100 test runs of test_memcontrol produced the
following results:

     17 not ok 1 test_memcg_min
     22 not ok 2 test_memcg_low

After applying this patch, there were no test failure for test_memcg_min
and test_memcg_low in 100 test runs. However, these tests may still fail
once in a while if the memory usage goes beyond the newly extended range.

Link: https://lkml.kernel.org/r/20250415210415.13414-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -495,10 +495,10 @@ static int test_memcg_protection(const c
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(29), 10))
+	if (!values_close(c[0], MB(29), 15))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(21), 10))
+	if (!values_close(c[1], MB(21), 20))
 		goto cleanup;
 
 	if (c[3] != 0)
_

Patches currently in -mm which might be from longman@redhat.com are

selftests-memcg-allow-low-event-with-no-memorylow-and-memory_recursiveprot-on.patch
selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

