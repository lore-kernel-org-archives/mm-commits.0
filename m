Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E9137C2A
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 01:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733879189; cv=none; b=nP8QsFHW47abwkQkUxA1qMppq3rnCN/KgqnHahaBVimHHUym6PwY6d1bRwkMC0yNSOAVGrMrWLi5CD0yld6KJala2UpEo0nmNCiAR7u6IBl0NquDqDIXfyP5YxRKuA50XzLYZafRBU4lqoW1d+CpwpPVS11aZJPAM+bZ1cuOrTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733879189; c=relaxed/simple;
	bh=GzCEbGK+25Qa+UdT3SExotHtmBCLC2dBOJE6O/4Eg4E=;
	h=Date:To:From:Subject:Message-Id; b=tw6oR1obxdThfafYky7UOjam2Nb8yZKgu6ZYYTbjZa+07MW7W6Bj0RaJH2XfsfIQXWu+9CMrf5OmE+v572LD0NEOSRncQOucZQUQn2gaBkrYyROQ/ROFAQIIb4PXl2BCmrPIBNSAiMEOKJpX1L/KyQ/zAPMyLECeQvO2elR17Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgT3CpMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgT3CpMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AFBC4CED6;
	Wed, 11 Dec 2024 01:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733879187;
	bh=GzCEbGK+25Qa+UdT3SExotHtmBCLC2dBOJE6O/4Eg4E=;
	h=Date:To:From:Subject:From;
	b=wgT3CpMtY2kPTE3SWhM1VyCEKRrFshvPJA5GxdW4ZFK1jfa1DSEOnxyHYdmlBAJwY
	 D9oQbUGByMWut+x4zufcbvXXi6Zc+0GPeWfsZnlIpvpLewso3P0Ot8ZHnDqdULWtcM
	 G5uY9D5ll3MxJMjSpraj2fpXRWZMYEKF+pG86TTo=
Date: Tue, 10 Dec 2024 17:06:27 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-avoid-duplicated-memcg-enable-check.patch added to mm-unstable branch
Message-Id: <20241211010627.C5AFBC4CED6@smtp.kernel.org>
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
Date: Tue, 10 Dec 2024 17:28:03 +0800

Patch series "mm/swap_cgroup: remove global swap cgroup lock", v2.

This series removes the global swap cgroup lock.  The critical section of
this lock is very short but it's still a bottle neck for mass parallel
swap workloads.

Up to 10% performance gain for tmpfs build kernel test on a 48c96t system,
and no regression for other cases:

Testing using 64G brd and build with build kernel with make -j96 in 1.5G
memory cgroup using 4k folios showed below improvement (10 test run):

Before this series:
Sys time: 10809.46 (stdev 80.831491)
Real time: 171.41 (stdev 1.239894)

After this commit:
Sys time: 9621.26 (stdev 34.620000), -10.42%
Real time: 160.00 (stdev 0.497814), -6.57%

With 64k folios and 2G memcg:
Before this series:
Sys time: 8231.99 (stdev 30.030994)
Real time: 143.57 (stdev 0.577394)

After this commit:
Sys time: 7403.47 (stdev 6.270000), -10.06%
Real time: 135.18 (stdev 0.605000), -5.84%

Sequential swapout of 8G 64k zero folios (24 test run):
Before this series:
5461409.12 us (stdev 183957.827084)

After this commit:
5420447.26 us (stdev 196419.240317)

Sequential swapin of 8G 4k zero folios (24 test run):
Before this series:
19736958.916667 us (stdev 189027.246676)

After this commit:
19662182.629630 us (stdev 172717.640614)


This patch (of 3):

mem_cgroup_uncharge_swap() includes a mem_cgroup_disabled() check, so the
caller doesn't need to check that.

Link: https://lkml.kernel.org/r/20241210092805.87281-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241210092805.87281-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-duplicated-memcg-enable-check
+++ a/mm/memcontrol.c
@@ -4609,7 +4609,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
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

