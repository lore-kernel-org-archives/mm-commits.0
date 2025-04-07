Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6581017BD9
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 04:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001395; cv=none; b=N8XDWLlmki7bttxuprlOzPmaOg7hgtETBi26vuZQ+SOI2dtNx2+lhDgYCQRZwy4jRaIXl2YIHAdRrd2DmpYYJpmNWA/IJR00X5xq59NRxA9+FMJN/snflvRKLSW2tZKsGTAwZlvEmcWUeLgupqM6qBNiu+CYpWR9tClXMhWsi1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001395; c=relaxed/simple;
	bh=ACdwCDKvabGU1MGNUXEw2I2yMT84xhEK8YYsIfTI4yU=;
	h=Date:To:From:Subject:Message-Id; b=cYFxtjRZEKeBG1JWJAOKML7alggJVYix8u6dQNHXsp2CWJVk8jYxuAvz99lbCoCy4jnHF87LwaacHqGM6Js9th9X5Oo1zSt8/V6RfR4Xt1RZ96Wtwn5uYRSVkF6GmtwbrulvRBU6yWZ7LnpHakfLR6KuvyaF74No8oD7gSkvUfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A4ovzxPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A4ovzxPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C22C4CEDD;
	Mon,  7 Apr 2025 04:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744001395;
	bh=ACdwCDKvabGU1MGNUXEw2I2yMT84xhEK8YYsIfTI4yU=;
	h=Date:To:From:Subject:From;
	b=A4ovzxPH3NGxGJYuoIyMjmrbpR3LGGL8sQ5aFDQGKTiEXM+jfG+FfypLLmjxZMwy2
	 5vmHkMI0XJNeewesERyaNUWv7PnOJaFnYK2zrfDFcJ54sAc8S+q1E3t+ei47TzVEYC
	 CirKm43GjlfNCvRz+pgiOQVBfuUSFy7wIVREOXcw=
Date: Sun, 06 Apr 2025 21:49:54 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs.patch added to mm-new branch
Message-Id: <20250407044955.02C22C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: skip memcg with !usage in shrink_node_memcgs()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs.patch

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
Subject: mm/vmscan: skip memcg with !usage in shrink_node_memcgs()
Date: Sun, 6 Apr 2025 21:41:58 -0400

Patch series "memcg: Fix test_memcg_min/low test failures", v4.

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test and sporadically fails its test_memcg_min sub-test.  This
patchset fixes the test_memcg_min and test_memcg_low failures by skipping
the !usage case in shrink_node_memcgs() and adjust the test_memcontrol
selftest to fix other causes of the test failures.

Note that I decide not to use the suggested mem_cgroup_usage() call as it
is a real function call defined in mm/memcontrol.c to be used mainly by
cgroup v1 code.


This patch (of 2):

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test due to the fact that two of its test child cgroups which have a
memmory.low of 0 or an effective memory.low of 0 still have low events
generated for them since mem_cgroup_below_low() use the ">=" operator when
comparing to elow.

The two failed use cases are as follows:

1) memory.low is set to 0, but low events can still be triggered and
   so the cgroup may have a non-zero low event count. I doubt users are
   looking for that as they didn't set memory.low at all.

2) memory.low is set to a non-zero value but the cgroup has no task in
   it so that it has an effective low value of 0. Again it may have a
   non-zero low event count if memory reclaim happens. This is probably
   not a result expected by the users and it is really doubtful that
   users will check an empty cgroup with no task in it and expecting
   some non-zero event counts.

In the first case, even though memory.low isn't set, it may still have
some low protection if memory.low is set in the parent.  So low event may
still be recorded.  The test_memcontrol.c test has to be modified to
account for that.

For the second case, it really doesn't make sense to have non-zero low
event if the cgroup has 0 usage.  So we need to skip this corner case in
shrink_node_memcgs() by skipping the !usage case.  The "#ifdef
CONFIG_MEMCG" directive is added to avoid problem with the
non-CONFIG_MEMCG case.

With this patch applied, the test_memcg_low sub-test finishes successfully
without failure in most cases.  Though both test_memcg_low and
test_memcg_min sub-tests may still fail occasionally if the memory.current
values fall outside of the expected ranges.

Link: https://lkml.kernel.org/r/20250407014159.1291785-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20250407014159.1291785-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c                                      |   10 ++++++++++
 tools/testing/selftests/cgroup/test_memcontrol.c |    7 ++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs
+++ a/mm/vmscan.c
@@ -5934,6 +5934,7 @@ static inline bool should_continue_recla
 	return inactive_lru_pages > pages_for_compaction;
 }
 
+#ifdef CONFIG_MEMCG
 static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
@@ -5971,6 +5972,10 @@ static void shrink_node_memcgs(pg_data_t
 
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
+		/* Skip memcg with no usage */
+		if (!page_counter_read(&memcg->memory))
+			continue;
+
 		if (mem_cgroup_below_min(target_memcg, memcg)) {
 			/*
 			 * Hard protection.
@@ -6012,6 +6017,11 @@ static void shrink_node_memcgs(pg_data_t
 		}
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
 }
+#else
+static inline void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
+{
+}
+#endif /* CONFIG_MEMCG */
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
--- a/tools/testing/selftests/cgroup/test_memcontrol.c~mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -525,8 +525,13 @@ static int test_memcg_protection(const c
 		goto cleanup;
 	}
 
+	/*
+	 * Child 2 has memory.low=0, but some low protection is still being
+	 * distributed down from its parent with memory.low=50M. So the low
+	 * event count will be non-zero.
+	 */
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
-		int no_low_events_index = 1;
+		int no_low_events_index = 2;
 		long low, oom;
 
 		oom = cg_read_key_long(children[i], "memory.events", "oom ");
_

Patches currently in -mm which might be from longman@redhat.com are

mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs.patch
selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

