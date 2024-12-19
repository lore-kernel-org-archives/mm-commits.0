Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE58380
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734568397; cv=none; b=GJ2x226qYYm4ZrNIM4LgyBG/MR9a5gjUA7I9q4vejk4O3lLD9fkWid8bllSsedQhL4kqimGi4xzxq8+/tGGONXZ3koGEcWeBFUmuXyGphC1igKlbpX41wLfbIxsXd1uWH+nfX6QXXxzxMIQySOkFqH+1JXbAm0ugC3NjYfZNY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734568397; c=relaxed/simple;
	bh=UzW0ZvjVIQJT+YnebWLftiz2YW4fVdbONHTvrsg7YbU=;
	h=Date:To:From:Subject:Message-Id; b=WHb2S8RDsLuKe8lLwE763+Wzo+5RZtfleeyKwpAlIdsDE8OeNsuchewYBvBwfstRyfvXpjTyj8wtDcz5NNglzJhAOhpahlruWaj9inM6KrylRCGkeZtpm+7KJeWdlQsPQ5YMrCtTK4vVDztAonwo/EHpvgPaMV1z0ROmlHwaAk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b75p3X1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b75p3X1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F9CC4CECD;
	Thu, 19 Dec 2024 00:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734568396;
	bh=UzW0ZvjVIQJT+YnebWLftiz2YW4fVdbONHTvrsg7YbU=;
	h=Date:To:From:Subject:From;
	b=b75p3X1M1cCNAIRTtN76BoLj3ktVLEGKfIioIOnYToR7fJ0bRw3GA+C8tAaqruhce
	 kMlxmIO7IaZyLnEttgepdues/fDhriJuDeCoCcG/GgYw8NnAp1KACRevb9gJWO4eB1
	 B54Kus1IQTnyF/R0tu8RW74VoDOTTJZlxjz3m8oA=
Date: Wed, 18 Dec 2024 16:33:15 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-avoid-duplicated-memcg-enable-check.patch added to mm-unstable branch
Message-Id: <20241219003316.95F9CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, memcontrol: avoid duplicated memcg enable check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-avoid-duplicated-memcg-enable-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-avoid-duplicated-memcg-enable-check.patch

This patch will later appear in the mm-unstable branch at
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

zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
zram-fix-uninitialized-zram-not-releasing-backing-device.patch
mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch

