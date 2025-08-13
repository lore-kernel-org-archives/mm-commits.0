Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9102F39A1
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755124861; cv=none; b=gOaRzqhLs5Ilg/SpkfCY0Q+zCa12AiBpYZgKugv/zhbitzUS3HfgU4MQzB0bFRea6gYirzrwEUJPCqq7XBdc1vPf1hRxaWlSgW75ZTVGF9VXPRAF0yubQgVIZLQmKJdq2vNbw37tmIrQekoILx/Q6xc+Tw8uZlDuXl0Iujg97qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755124861; c=relaxed/simple;
	bh=oJE03MNy04RH0p38tjoQ6xMvpEt6PygXlzmtytCPEMU=;
	h=Date:To:From:Subject:Message-Id; b=uquGwvl3c6H3ENrch9Hs7QTDtg/paSoLg0SuTnoXNQssMi6R2g6bKhpT8NKu1JLj50MlJytJ9vvot9u5+vDQbgWlyW4d9hTJog6MWzJRj+HT8Oo1iLCcnq9DZu54loyAKreP33RpBCUjAFLzYLHvoy3aVx8gJeIj7OWln5pNoD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZEpFIk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZEpFIk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738FFC4CEEB;
	Wed, 13 Aug 2025 22:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755124860;
	bh=oJE03MNy04RH0p38tjoQ6xMvpEt6PygXlzmtytCPEMU=;
	h=Date:To:From:Subject:From;
	b=XZEpFIk6EoXmHg2ksy/Tkpr+jayQbec42jU+zE+H/TNJsmwTGI5exNt0gkFsNCWxL
	 0fW6sOlEHps+AU4dk7A/p04RUVjBIuzalKI31gDppSrSTvsdr8x2IhvmsBDbrSon1h
	 TEU5zOTNxH3t3TfsmvQknD5TTf+B70QDFi7bly0I=
Date: Wed, 13 Aug 2025 15:40:59 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,tglx@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-optimize-exit-to-user-space.patch added to mm-new branch
Message-Id: <20250813224100.738FFC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: optimize exit to user space
has been added to the -mm mm-new branch.  Its filename is
     memcg-optimize-exit-to-user-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-optimize-exit-to-user-space.patch

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
From: Thomas Gleixner <tglx@linutronix.de>
Subject: memcg: optimize exit to user space
Date: Wed, 13 Aug 2025 16:57:55 +0200

memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user space. 
TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by other
entities as well.

This results in a unconditional mem_cgroup_handle_over_high() call for
every invocation of resume_user_mode_work(), which is a pointless exercise
as most of the time there is no reclaim work to do.

Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised quite
frequently and the empty calls show up in exit path profiling.

Optimize this by doing a quick check of the reclaim condition before
invoking it.

Link: https://lkml.kernel.org/r/87tt2b6zgs.ffs@tglx
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +++++++-
 mm/memcontrol.c            |    4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~memcg-optimize-exit-to-user-space
+++ a/include/linux/memcontrol.h
@@ -900,7 +900,13 @@ unsigned long mem_cgroup_get_zone_lru_si
 	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
-void mem_cgroup_handle_over_high(gfp_t gfp_mask);
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
+
+static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
+{
+	if (unlikely(current->memcg_nr_pages_over_high))
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
--- a/mm/memcontrol.c~memcg-optimize-exit-to-user-space
+++ a/mm/memcontrol.c
@@ -2203,7 +2203,7 @@ static unsigned long calculate_high_dela
  * try_charge() (context permitting), as well as from the userland
  * return path where reclaim is always able to block.
  */
-void mem_cgroup_handle_over_high(gfp_t gfp_mask)
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
@@ -2486,7 +2486,7 @@ done_restock:
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
-		mem_cgroup_handle_over_high(gfp_mask);
+		__mem_cgroup_handle_over_high(gfp_mask);
 	return 0;
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

memcg-optimize-exit-to-user-space.patch

