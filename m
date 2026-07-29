Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA751E1A3D;
	Wed, 29 Jul 2026 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285482; cv=none; b=Z+6MCNs0ki6OzgFdlWuTGvHMK0PQ3SD/NrnOuhpAo4nARtoKC3O+zZ4rpRk+Z8uRyWy1OHFkD0Em0VvOE47vbyXn2bUPEgtJ4Az3lB/lWSj7avuB/0ocbFd/3q+YKehAHndmbZxbswCYRK5/KlNgsjHXRPLR2ffSV5f96/0P92k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285482; c=relaxed/simple;
	bh=psmy0dqWujLLDpvJN1fs+j6+HtvJaXlIqCiDGw3sy0I=;
	h=Date:To:From:Subject:Message-Id; b=Mfnk1hbPl+jO4ni/gCqcF3zIkTToDqT7QKzWYqrK4+Dg8WEdCkVbHO2+VlLTdT9MF+3TF04Exl7ewzewSMiTJ8FcZ4sCGn29ExahOC8Jme2IyU0VFzkuF6FvXW9H1jOlnarKP6np/xQwNJC2YQPqFES+Bw2AlMHhKrqB25hIyVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njL81rTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njL81rTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAAC1F000E9;
	Wed, 29 Jul 2026 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285480;
	bh=IzYnwY1+d+xXZS4xaefSVNnkcQ3h2RUilPMxXHK2bQY=;
	h=Date:To:From:Subject;
	b=njL81rTYQAqPvpSbMoRS/rGkLKxaaZdF4kXbvgylU0TtZNv26COXkKERj3ox2sTSY
	 ueHLyTLPAcjnCwfcXRgNFdogGKDaiWFzs1VKFx2Fyk+FTA92+uLgBRHtvYTLgKUjwO
	 ah9MkKov3qK9InpguhBcbgWDkH3mKH0xtgkv7orI=
Date: Tue, 28 Jul 2026 17:37:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch removed from -mm tree
Message-Id: <20260729003800.6FAAC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: initialize *locked in memcg1_oom_prepare() stub
has been removed from the -mm tree.  Its filename was
     mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Thu, 16 Jul 2026 06:42:18 -0700

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out there
is no OOM lock to take.

Link: https://lore.kernel.org/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org
Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h~mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub
+++ a/mm/memcontrol-v1.h
@@ -107,7 +107,11 @@ static inline void memcg1_remove_from_tr
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch

