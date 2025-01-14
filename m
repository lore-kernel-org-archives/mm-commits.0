Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090DC23ED63
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837089; cv=none; b=mlLTlF3j+rq3puFpu8rBh8laTuEvALApVZhYZDKcuvQfLucmxERjBR3MZOOy/lhwH52W5aonqRPpRU5q2kXrMYG31SAGtObrwJ3OKAKkST/G90yjG/29V8BNCspFtpZHj5H7TSuxaGAc2TCoF7HCkDWlxthAdLvhrtv4OOsMdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837089; c=relaxed/simple;
	bh=mMZ7Q3QOmkFxOoDlgGllrWri3rhw1aJnPNfsZmbnnqk=;
	h=Date:To:From:Subject:Message-Id; b=HTvb3URnuk0adDLHFdSTlr6rop+3bG2Lb/aLlu6WtuYpR+lvdtiMshU6NfHIt2cTuxjbesWfAl0VFVWkV4DeLLbhtioaEqC9GE6r2FFAQqyLxwVie5evLYtpOO3SjA4AcqY6ud3pYS0vGyO5yVfbcx3hrCiy/XCt1+cPHhoAWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uAtggQW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uAtggQW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB88DC4CEDD;
	Tue, 14 Jan 2025 06:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837088;
	bh=mMZ7Q3QOmkFxOoDlgGllrWri3rhw1aJnPNfsZmbnnqk=;
	h=Date:To:From:Subject:From;
	b=uAtggQW9MLiAgdmcjCVJsGwNkiVUtsVU5tMI8J8+z4ohwLLqZtEmiBs7JXU/swR3O
	 ZQZxC3Y6bfyfp57aWrC65jx9mj7nr4F7nN40+kXkFsvhiI0cFshqd+9pZnhNXXug4L
	 29zcgC/AwIL+Q7c/IGIES5fBUNzoRYtPbt4KC/LU=
Date: Mon, 13 Jan 2025 22:44:48 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-avoid-duplicated-memcg-enable-check.patch removed from -mm tree
Message-Id: <20250114064448.CB88DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, memcontrol: avoid duplicated memcg enable check
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-avoid-duplicated-memcg-enable-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, memcontrol: avoid duplicated memcg enable check
Date: Wed, 18 Dec 2024 19:46:30 +0800

Patch series "mm/swap_cgroup: remove global swap cgroup lock", v3.

This series removes the global swap cgroup lock.  The critical section of
this lock is very short but it's still a bottle neck for mass parallel
swap workloads.

Up to 10% performance gain for tmpfs build kernel test on a 48c96t system
under memory pressure, and no regression for other cases:


This patch (of 3):

mem_cgroup_uncharge_swap() includes a mem_cgroup_disabled() check,
so the caller doesn't need to check that.

Link: https://lkml.kernel.org/r/20241218114633.85196-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241218114633.85196-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-duplicated-memcg-enable-check
+++ a/mm/memcontrol.c
@@ -4595,7 +4595,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
 	 * correspond 1:1 to page and swap slot lifetimes: we charge the
 	 * page to memory here, and uncharge swap when the slot is freed.
 	 */
-	if (!mem_cgroup_disabled() && do_memsw_account()) {
+	if (do_memsw_account()) {
 		/*
 		 * The swap entry might not get freed for a long time,
 		 * let's not wait for it.  The page already received a
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

