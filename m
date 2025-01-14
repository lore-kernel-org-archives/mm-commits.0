Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D723D3FC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837091; cv=none; b=RJaaaI0RidySY6wSYCjMO5VqwW/5gtQs+eo7tkWWtWL//lUJ9WMHvkXlZRgTUcjcojH/avAb639+DbJxegMiMa/BChYA753pBq/UsVXOAfM/3A+6skowC5nIF9vzgjvVHBtutcrWFePMUK90VNwpDJsq2ctvLQLekskkBCdJvU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837091; c=relaxed/simple;
	bh=WE+2+1D5Ke6GcxaCRBq4VUlXnWqUwz+ZUe08LpuDGn4=;
	h=Date:To:From:Subject:Message-Id; b=NFl1haNeRoYtlnA80oajUCnGDWiIGvbP3vs+2/Tpzk982OJjMTnAg8Xzmfxgx5PQdPUCQUIeVBZI2MgsRKM97Il7+J2Gk0HsDjIyJSdt1OXl4/Ig/LvGzAjxTYEOglNvFOwaJPmG555PCEWG7eyl9romzgAvgohl5aM6O5NrA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n+c9FadK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n+c9FadK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD75C4CEDD;
	Tue, 14 Jan 2025 06:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837091;
	bh=WE+2+1D5Ke6GcxaCRBq4VUlXnWqUwz+ZUe08LpuDGn4=;
	h=Date:To:From:Subject:From;
	b=n+c9FadKj/rIJrdCHVrmZ7/gsB5xFrIDDHpPgv80yd/r4cpTl/kNkjB5WpZqzcJNY
	 dQPWjFH3KmFhdId7hbIBdv+7CirVehdWeyjsv7okcvYoWb36w6Rw1VF+iHin6u9Mde
	 KYPmmzTTMgLqvMsoCa+N/kCBDecMH1wEm1dPJlO8=
Date: Mon, 13 Jan 2025 22:44:51 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-remove-global-swap-cgroup-lock.patch removed from -mm tree
Message-Id: <20250114064451.9FD75C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_cgroup: remove global swap cgroup lock
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-remove-global-swap-cgroup-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap_cgroup: remove global swap cgroup lock
Date: Wed, 18 Dec 2024 19:46:32 +0800

commit e9e58a4ec3b1 ("memcg: avoid use cmpxchg in swap cgroup
maintainance") replaced the cmpxchg/xchg with a global irq spinlock
because some archs doesn't support 2 bytes cmpxchg/xchg.  Clearly this
won't scale well.

And as commented in swap_cgroup.c, this lock is not needed for map
synchronization.

Emulation of 2 bytes xchg with atomic cmpxchg isn't hard, so implement it
to get rid of this lock.  Introduced two helpers for doing so and they can
be easily dropped if a generic 2 byte xchg is support.

Testing using 64G brd and build with build kernel with make -j96 in 1.5G
memory cgroup using 4k folios showed below improvement (6 test run):

Before this series:
Sys time: 10782.29 (stdev 42.353886)
Real time: 171.49 (stdev 0.595541)

After this commit:
Sys time: 9617.23 (stdev 37.764062), -10.81%
Real time: 159.65 (stdev 0.587388), -6.90%

With 64k folios and 2G memcg:
Before this series:
Sys time: 8176.94 (stdev 26.414712)
Real time: 141.98 (stdev 0.797382)

After this commit:
Sys time: 7358.98 (stdev 54.927593), -10.00%
Real time: 134.07 (stdev 0.757463), -5.57%

Sequential swapout of 8G 64k zero folios with madvise (24 test run):
Before this series:
5461409.12 us (stdev 183957.827084)

After this commit:
5420447.26 us (stdev 196419.240317)

Sequential swapin of 8G 4k zero folios (24 test run):
Before this series:
19736958.916667 us (stdev 189027.246676)

After this commit:
19662182.629630 us (stdev 172717.640614)

Performance is better or at least not worse for all tests above.

Link: https://lkml.kernel.org/r/20241218114633.85196-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |   77 ++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 28 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-global-swap-cgroup-lock
+++ a/mm/swap_cgroup.c
@@ -7,19 +7,20 @@
 
 static DEFINE_MUTEX(swap_cgroup_mutex);
 
+/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
+#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
+#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
+#define ID_MASK (BIT(ID_SHIFT) - 1)
 struct swap_cgroup {
-	unsigned short		id;
+	atomic_t ids;
 };
 
 struct swap_cgroup_ctrl {
 	struct swap_cgroup *map;
-	spinlock_t	lock;
 };
 
 static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
-#define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
-
 /*
  * SwapCgroup implements "lookup" and "exchange" operations.
  * In typical usage, this swap_cgroup is accessed via memcg's charge/uncharge
@@ -30,19 +31,35 @@ static struct swap_cgroup_ctrl swap_cgro
  *    SwapCache(and its swp_entry) is under lock.
  *  - When called via swap_free(), there is no user of this entry and no race.
  * Then, we don't need lock around "exchange".
- *
- * TODO: we can push these buffers out to HIGHMEM.
  */
-static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
-					struct swap_cgroup_ctrl **ctrlp)
+static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
+					      pgoff_t offset)
 {
-	pgoff_t offset = swp_offset(ent);
-	struct swap_cgroup_ctrl *ctrl;
+	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
+	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
 
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	if (ctrlp)
-		*ctrlp = ctrl;
-	return &ctrl->map[offset];
+	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
+	BUILD_BUG_ON(sizeof(struct swap_cgroup) != sizeof(atomic_t));
+
+	return (old_ids >> shift) & ID_MASK;
+}
+
+static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
+					    pgoff_t offset,
+					    unsigned short new_id)
+{
+	unsigned short old_id;
+	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
+	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
+	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
+
+	do {
+		old_id = (old_ids >> shift) & ID_MASK;
+		new_ids = (old_ids & ~(ID_MASK << shift));
+		new_ids |= ((unsigned int)new_id) << shift;
+	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
+
+	return old_id;
 }
 
 /**
@@ -58,21 +75,19 @@ unsigned short swap_cgroup_record(swp_en
 				  unsigned int nr_ents)
 {
 	struct swap_cgroup_ctrl *ctrl;
-	struct swap_cgroup *sc;
-	unsigned short old;
-	unsigned long flags;
 	pgoff_t offset = swp_offset(ent);
 	pgoff_t end = offset + nr_ents;
+	unsigned short old, iter;
+	struct swap_cgroup *map;
 
-	sc = lookup_swap_cgroup(ent, &ctrl);
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	map = ctrl->map;
 
-	spin_lock_irqsave(&ctrl->lock, flags);
-	old = sc->id;
-	for (; offset < end; offset++, sc++) {
-		VM_BUG_ON(sc->id != old);
-		sc->id = id;
-	}
-	spin_unlock_irqrestore(&ctrl->lock, flags);
+	old = __swap_cgroup_id_lookup(map, offset);
+	do {
+		iter = __swap_cgroup_id_xchg(map, offset, id);
+		VM_BUG_ON(iter != old);
+	} while (++offset != end);
 
 	return old;
 }
@@ -85,9 +100,13 @@ unsigned short swap_cgroup_record(swp_en
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	struct swap_cgroup_ctrl *ctrl;
+
 	if (mem_cgroup_disabled())
 		return 0;
-	return lookup_swap_cgroup(ent, NULL)->id;
+
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
 }
 
 int swap_cgroup_swapon(int type, unsigned long max_pages)
@@ -98,14 +117,16 @@ int swap_cgroup_swapon(int type, unsigne
 	if (mem_cgroup_disabled())
 		return 0;
 
-	map = vcalloc(max_pages, sizeof(struct swap_cgroup));
+	BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=
+		     sizeof(struct swap_cgroup));
+	map = vcalloc(DIV_ROUND_UP(max_pages, ID_PER_SC),
+		      sizeof(struct swap_cgroup));
 	if (!map)
 		goto nomem;
 
 	ctrl = &swap_cgroup_ctrl[type];
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl->map = map;
-	spin_lock_init(&ctrl->lock);
 	mutex_unlock(&swap_cgroup_mutex);
 
 	return 0;
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

