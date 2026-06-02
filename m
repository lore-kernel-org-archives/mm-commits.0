Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEC43C4576
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439079; cv=none; b=Xh4hgox2VIFhgQCi7+nO034Gs0Soazz64YbDXDdP9ZPqOQrEli34wgVhYH2LoKkf7/oasRlkh7YclqwxYTYE8ZA3EGyAF90lub3Kc/tD0U9xaeoOEKUcbLnM7YTTxcjx4WsQrr7bWQbX85tQ3rUfciy0ScNjI5wjCWVpYN9xoEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439079; c=relaxed/simple;
	bh=jQdyK7TMsoyjPDCtgaSoRXCNsru8LrR0cVMCzWekopU=;
	h=Date:To:From:Subject:Message-Id; b=WGmD6mz1cHinYB5h8HuhOqM4ezl8uK3+031GlRnQi0Gbu/kF79ViusIMd21/Vr+T7gIbtRyC+uk/L/xdUmQy6x9db5NjjNrzEuvmUJdt4rcp9kH9QXTAaiUlxOfBGSoQuPgpceqNoVTgr3nqWxNH+BmMkyy7RqY5p1hFoTuv2oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bmf2Nnff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bmf2Nnff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4391F00898;
	Tue,  2 Jun 2026 22:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439077;
	bh=a/KTKiMwFpoPHtwxNHE+2loCW1WL4N3aA27nvY2VS48=;
	h=Date:To:From:Subject;
	b=Bmf2Nnff2ufPpeg9rkBhpB22FVJNmX4TW8kgtRtAV8HGcXBzbRLn+pMA+5R65u3dE
	 le16qgu9Hf9l+oSB9OAhqvb/DMtDgKMwW9XS3A7qW4u5pSWlLaG8AO5LSC4tAYyShF
	 /QieuBOUSBW25Dr9mktJ2VEfj8608M8GDG7dmp4E=
Date: Tue, 02 Jun 2026 15:24:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-remove-no-longer-used-swap-cgroup-array.patch removed from -mm tree
Message-Id: <20260602222437.AB4391F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: remove no longer used swap cgroup array
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-no-longer-used-swap-cgroup-array.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/memcg: remove no longer used swap cgroup array
Date: Sun, 17 May 2026 23:39:50 +0800

Now all swap cgroup records are stored in the swap cluster directly, the
static array is no longer needed.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-11-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                 |    1 
 include/linux/swap_cgroup.h |   47 ---------
 mm/Makefile                 |    3 
 mm/internal.h               |    1 
 mm/memcontrol-v1.c          |    1 
 mm/memcontrol.c             |    1 
 mm/swap_cgroup.c            |  174 ----------------------------------
 mm/swapfile.c               |    8 -
 8 files changed, 236 deletions(-)

diff --git a/include/linux/swap_cgroup.h a/include/linux/swap_cgroup.h
deleted file mode 100644
--- a/include/linux/swap_cgroup.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_SWAP_CGROUP_H
-#define __LINUX_SWAP_CGROUP_H
-
-#include <linux/swap.h>
-
-#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-
-extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
-extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
-extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
-
-#else
-
-static inline
-void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
-{
-}
-
-static inline
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	return 0;
-}
-
-static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	return 0;
-}
-
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	return 0;
-}
-
-static inline void swap_cgroup_swapoff(int type)
-{
-	return;
-}
-
-#endif
-
-#endif /* __LINUX_SWAP_CGROUP_H */
--- a/MAINTAINERS~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/MAINTAINERS
@@ -6573,7 +6573,6 @@ F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
-F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
--- a/mm/internal.h~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/mm/internal.h
@@ -17,7 +17,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
--- a/mm/Makefile~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/mm/Makefile
@@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) += page_count
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-ifdef CONFIG_SWAP
-obj-$(CONFIG_MEMCG) += swap_cgroup.o
-endif
 ifdef CONFIG_BPF_SYSCALL
 obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
 endif
--- a/mm/memcontrol.c~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/mm/memcontrol.c
@@ -54,7 +54,6 @@
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
 #include <linux/mm_inline.h>
-#include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
 #include <linux/lockdep.h>
--- a/mm/memcontrol-v1.c~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/mm/memcontrol-v1.c
@@ -5,7 +5,6 @@
 #include <linux/mm_inline.h>
 #include <linux/pagewalk.h>
 #include <linux/backing-dev.h>
-#include <linux/swap_cgroup.h>
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/sort.h>
diff --git a/mm/swap_cgroup.c a/mm/swap_cgroup.c
deleted file mode 100644
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,174 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/swap_cgroup.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include <linux/swapops.h> /* depends on mm.h include */
-
-static DEFINE_MUTEX(swap_cgroup_mutex);
-
-/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
-#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
-#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
-#define ID_MASK (BIT(ID_SHIFT) - 1)
-struct swap_cgroup {
-	atomic_t ids;
-};
-
-struct swap_cgroup_ctrl {
-	struct swap_cgroup *map;
-};
-
-static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
-
-static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
-					      pgoff_t offset)
-{
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
-
-	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
-	BUILD_BUG_ON(sizeof(struct swap_cgroup) != sizeof(atomic_t));
-
-	return (old_ids >> shift) & ID_MASK;
-}
-
-static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
-					    pgoff_t offset,
-					    unsigned short new_id)
-{
-	unsigned short old_id;
-	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
-
-	do {
-		old_id = (old_ids >> shift) & ID_MASK;
-		new_ids = (old_ids & ~(ID_MASK << shift));
-		new_ids |= ((unsigned int)new_id) << shift;
-	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
-
-	return old_id;
-}
-
-/**
- * swap_cgroup_record - record mem_cgroup for a set of swap entries.
- * These entries must belong to one single folio, and that folio
- * must be being charged for swap space (swap out), and these
- * entries must not have been charged
- *
- * @folio: the folio that the swap entry belongs to
- * @id: mem_cgroup ID to be recorded
- * @ent: the first swap entry to be recorded
- */
-void swap_cgroup_record(struct folio *folio, unsigned short id,
-			swp_entry_t ent)
-{
-	unsigned int nr_ents = folio_nr_pages(folio);
-	struct swap_cgroup *map;
-	pgoff_t offset, end;
-	unsigned short old;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_BUG_ON(old);
-	} while (++offset != end);
-}
-
-/**
- * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
- * These entries must be being uncharged from swap. They either
- * belongs to one single folio in the swap cache (swap in for
- * cgroup v1), or no longer have any users (slot freeing).
- *
- * @ent: the first swap entry to be recorded into
- * @nr_ents: number of swap entries to be recorded
- *
- * Returns the existing old value.
- */
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	pgoff_t offset, end;
-	struct swap_cgroup *map;
-	unsigned short old, iter = 0;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, 0);
-		if (!iter)
-			iter = old;
-		VM_BUG_ON(iter != old);
-	} while (++offset != end);
-
-	return old;
-}
-
-/**
- * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
- * @ent: swap entry to be looked up.
- *
- * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
- */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	if (unlikely(!ctrl->map))
-		return 0;
-	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
-}
-
-int swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=
-		     sizeof(struct swap_cgroup));
-	map = vzalloc(DIV_ROUND_UP(max_pages, ID_PER_SC) *
-		      sizeof(struct swap_cgroup));
-	if (!map)
-		goto nomem;
-
-	ctrl = &swap_cgroup_ctrl[type];
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl->map = map;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	return 0;
-nomem:
-	pr_info("couldn't allocate enough memory for swap_cgroup\n");
-	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
-	return -ENOMEM;
-}
-
-void swap_cgroup_swapoff(int type)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl = &swap_cgroup_ctrl[type];
-	map = ctrl->map;
-	ctrl->map = NULL;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	vfree(map);
-}
--- a/mm/swapfile.c~mm-memcg-remove-no-longer-used-swap-cgroup-array
+++ a/mm/swapfile.c
@@ -45,7 +45,6 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
@@ -3058,8 +3057,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	p->global_cluster = NULL;
 	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3590,10 +3587,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
@@ -3704,7 +3697,6 @@ bad_swap:
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	swap_cgroup_swapoff(si->type);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	kvfree(si->zeromap);
_

Patches currently in -mm which might be from kasong@tencent.com are


