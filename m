Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6657723D3EE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837090; cv=none; b=cnLsUBjJZC4ExD1txFkokuhiY8hksvIvt4FCI78wsR+f7hMFZuWw0BiFujF6/Fjdhr0oopaLu/qUOCwRQ7DCA6YS2vYcltV5d+ZLqeIO6GmlmjBlPtwT9jeNmMi47oUjGpEZY27TRQStFizmk9++ibH+sDbwwp9YnorZjAn1hxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837090; c=relaxed/simple;
	bh=2yaI1uUuDynP3+++e/V+tAwd1+MrJfIrEcVb+769Qlk=;
	h=Date:To:From:Subject:Message-Id; b=C4vT9snP7OPnFq55nE4ciLF9/e5UjxbyfTPnCQhYfVatiH8NrACZ1yCly1njfBkOPOjKlHzEnyYzzia04ULdn4zZA3tGFZkiKYQ7Foxefe3FKnD+wN5RvX/jqlnYicJ6tPU0GEyBHnrQ9RytdkulpVjP2Dx1m9ZO9CyheBltmQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG8OcB5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG8OcB5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371DCC4CEDD;
	Tue, 14 Jan 2025 06:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837090;
	bh=2yaI1uUuDynP3+++e/V+tAwd1+MrJfIrEcVb+769Qlk=;
	h=Date:To:From:Subject:From;
	b=CG8OcB5Y7MShdLijw8ahSV86kmv52Hl37EGgwaFYWTHwrv/4NK8g9WjbMawHGmhjD
	 RfmgyWdEaa3CVXLZQyegoJQOnMYbyZFimthethUorgPx8I4siBcqb81hzIe253T2Rz
	 +nMvjUKImwHlWij9Ow5q16KL5mx/rts/lJs3ggCs=
Date: Mon, 13 Jan 2025 22:44:49 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch removed from -mm tree
Message-Id: <20250114064450.371DCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_cgroup: remove swap_cgroup_cmpxchg
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap_cgroup: remove swap_cgroup_cmpxchg
Date: Wed, 18 Dec 2024 19:46:31 +0800

This function is never used after commit 6b611388b626 ("memcg-v1: remove
charge move code").

Link: https://lkml.kernel.org/r/20241218114633.85196-3-ryncsn@gmail.com
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

 include/linux/swap_cgroup.h |    2 --
 mm/swap_cgroup.c            |   29 -----------------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/swap_cgroup.h~mm-swap_cgroup-remove-swap_cgroup_cmpxchg
+++ a/include/linux/swap_cgroup.h
@@ -6,8 +6,6 @@
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 
-extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new);
 extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
 					 unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-swap_cgroup_cmpxchg
+++ a/mm/swap_cgroup.c
@@ -46,35 +46,6 @@ static struct swap_cgroup *lookup_swap_c
 }
 
 /**
- * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
- * @ent: swap entry to be cmpxchged
- * @old: old id
- * @new: new id
- *
- * Returns old id at success, 0 at failure.
- * (There is no mem_cgroup using 0 as its id)
- */
-unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
-					unsigned short old, unsigned short new)
-{
-	struct swap_cgroup_ctrl *ctrl;
-	struct swap_cgroup *sc;
-	unsigned long flags;
-	unsigned short retval;
-
-	sc = lookup_swap_cgroup(ent, &ctrl);
-
-	spin_lock_irqsave(&ctrl->lock, flags);
-	retval = sc->id;
-	if (retval == old)
-		sc->id = new;
-	else
-		retval = 0;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-	return retval;
-}
-
-/**
  * swap_cgroup_record - record mem_cgroup for a set of swap entries
  * @ent: the first swap entry to be recorded into
  * @id: mem_cgroup to be recorded
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

