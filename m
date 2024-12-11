Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80547080E
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 01:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733879192; cv=none; b=IX7TUjAbNJDwB0FeasU3JmBH6MN1WWmpXbCVr7oUBJ6nvpwMPMRAXeQSySg8SCrlwbZNbzqSyXP96TaUT/KF/gPeLUSKY0ylUGpdAfyjd1K633aDjM9iJdtA11sY62WNGconiJLuBZ3oFolXerbZ0swWSZvzU+WmAZ2VghJAC8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733879192; c=relaxed/simple;
	bh=ry/wv0aCWDQBoKA1HY9NAzQzWFqtrIqWGlyUFmBzr5o=;
	h=Date:To:From:Subject:Message-Id; b=uaAoKhLzXMYw2LXJAet7PmMwRyQYXUlxvXCma7YuYvvks3NzdDrV57cA/J7nLWDKZD47d9g79YauOWE4vfvFAnrmlOP81xM23UqsD7EZsJqT4EI2l2FTipTWdzURHHPMRd3eVUndDjry2zoA7J2eTnAFLdmYODpsql4FFzXwERs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOger2h0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOger2h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E0C4CED6;
	Wed, 11 Dec 2024 01:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733879192;
	bh=ry/wv0aCWDQBoKA1HY9NAzQzWFqtrIqWGlyUFmBzr5o=;
	h=Date:To:From:Subject:From;
	b=TOger2h0fMi9WiwB8PIoEhz1mCv6gN9W6CmbXDpzV+RVXCtUePpWuyHhM1/48SRYE
	 FOVDbP7/N5fbebrwS+4ffDqZU8YK3oZp10heF/nxNGUJ4dOPnKFhJ/Y0sDSveU7Frc
	 9QZQA/e0+tavuOP+CnIa+b11L/c2b/d29coSGqlE=
Date: Tue, 10 Dec 2024 17:06:31 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-remove-global-swap-cgroup-lock.patch added to mm-unstable branch
Message-Id: <20241211010632.1B4E0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap_cgroup: remove global swap cgroup lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_cgroup-remove-global-swap-cgroup-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-remove-global-swap-cgroup-lock.patch

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
Subject: mm, swap_cgroup: remove global swap cgroup lock
Date: Tue, 10 Dec 2024 17:28:05 +0800

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

Link: https://lkml.kernel.org/r/20241210092805.87281-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |   73 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 28 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-global-swap-cgroup-lock
+++ a/mm/swap_cgroup.c
@@ -7,19 +7,20 @@
 
 static DEFINE_MUTEX(swap_cgroup_mutex);
 
+/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
+#define ID_PER_SC (sizeof(atomic_t) / sizeof(unsigned short))
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
@@ -30,19 +31,32 @@ static struct swap_cgroup_ctrl swap_cgro
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
+	unsigned int shift = (offset & 1) ? 0 : ID_SHIFT;
+	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
 
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	if (ctrlp)
-		*ctrlp = ctrl;
-	return &ctrl->map[offset];
+	return (old_ids & (ID_MASK << shift)) >> shift;
+}
+
+static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
+					    pgoff_t offset,
+					    unsigned short new_id)
+{
+	unsigned short old_id;
+	unsigned int shift = (offset & 1) ? 0 : ID_SHIFT;
+	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
+	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
+
+	do {
+		old_id = (old_ids & (ID_MASK << shift)) >> shift;
+		new_ids = (old_ids & ~(ID_MASK << shift));
+		new_ids |= ((unsigned int)new_id) << shift;
+	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
+
+	return old_id;
 }
 
 /**
@@ -58,21 +72,19 @@ unsigned short swap_cgroup_record(swp_en
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
@@ -85,9 +97,13 @@ unsigned short swap_cgroup_record(swp_en
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
@@ -98,14 +114,15 @@ int swap_cgroup_swapon(int type, unsigne
 	if (mem_cgroup_disabled())
 		return 0;
 
-	map = vcalloc(max_pages, sizeof(struct swap_cgroup));
+	BUILD_BUG_ON(!ID_PER_SC);
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

zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
zram-fix-uninitialized-zram-not-releasing-backing-device.patch
mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch

