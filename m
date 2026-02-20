Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEE2EEC0
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556891; cv=none; b=pMPGPmmQfhbJGDvjXjFiTOipIvfEocRzuX1FMMNPDxzig9Zhqws1ceo2ZLfaLQKVgwHtLfnAl6I3GyMXvRjii28+darYyhVj8VZR3TJbdkKVr5HEcphL+o9amJKiizOuHJUtWsd+/3JXk1akGZkZQUJcF9kt8hr9F1fm75KZFlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556891; c=relaxed/simple;
	bh=h+pIZgHfNPJQhvPj7FPBoW/whCZeImWBLoPi/s2ElfY=;
	h=Date:To:From:Subject:Message-Id; b=gcjIFpcEmi8XJYzT0+RSsWlheNtvlvlgUjkCyzAw2o8qCLy7eWw0qe1uyFqHGyHKGTcX9h+fqCEdBA9yLpt49aOhJ/D7TrdfeXWaS/c1Q4O3fpufksBXns9RrU2rlCxSr5ewJ0s1xVHK86jP8LN51gzSUg94VPycKYG6UWgmcWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJkX3fuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJkX3fuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC96C4CEF7;
	Fri, 20 Feb 2026 03:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771556891;
	bh=h+pIZgHfNPJQhvPj7FPBoW/whCZeImWBLoPi/s2ElfY=;
	h=Date:To:From:Subject:From;
	b=XJkX3fuRM/uGPhoHFBv+IJIYltLL6FEKVYejJLGHXNw89d60gxEPdyBM9WNGDQjb8
	 FI0UWv/SQ+ZXNyZOZFDQhNvNlBvmAarhusQBY68uI7UxwG/r0YPGnQP1EnCgM5SCa4
	 MkOHwpN+mDv+2g93bBXa+flHMUx6gAQ63YDyZJaY=
Date: Thu, 19 Feb 2026 19:08:10 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,chenridong@huaweicloud.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-consolidate-private-id-refcount-get-put-helpers.patch added to mm-new branch
Message-Id: <20260220030811.4FC96C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: consolidate private id refcount get/put helpers
has been added to the -mm mm-new branch.  Its filename is
     memcg-consolidate-private-id-refcount-get-put-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-consolidate-private-id-refcount-get-put-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: memcg: consolidate private id refcount get/put helpers
Date: Fri, 13 Feb 2026 18:03:32 +0800

We currently have two different sets of helpers for getting or putting the
private IDs' refcount for order 0 and large folios.  This is redundant. 
Just use one and always acquire the refcount of the swapout folio size
unless it's zero, and put the refcount using the folio size if the charge
failed, since the folio size can't change.  Then there is no need to
update the refcount for tail pages.

Same for freeing, then only one pair of get/put helper is needed now.

The performance might be slightly better, too: both "inc unless zero" and
"add unless zero" use the same cmpxchg implementation.  For large folios,
we saved an atomic operation.  And for both order 0 and large folios, we
saved a branch.

Link: https://lkml.kernel.org/r/20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Acked-by: Shakeel Butt <shakeel.butt@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    5 +----
 mm/memcontrol-v1.h |    4 ++--
 mm/memcontrol.c    |   29 +++++++----------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

--- a/mm/memcontrol.c~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol.c
@@ -3682,13 +3682,7 @@ static void mem_cgroup_private_id_remove
 	}
 }
 
-void __maybe_unused mem_cgroup_private_id_get_many(struct mem_cgroup *memcg,
-					   unsigned int n)
-{
-	refcount_add(n, &memcg->id.ref);
-}
-
-static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -3698,14 +3692,9 @@ static void mem_cgroup_private_id_put_ma
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg)
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	mem_cgroup_private_id_put_many(memcg, 1);
-}
-
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
-{
-	while (!refcount_inc_not_zero(&memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4006,7 +3995,7 @@ static void mem_cgroup_css_offline(struc
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg);
+	mem_cgroup_private_id_put(memcg, 1);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5302,19 +5291,15 @@ int __mem_cgroup_try_charge_swap(struct
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg);
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
-
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_private_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
@@ -5343,7 +5328,7 @@ void __mem_cgroup_uncharge_swap(swp_entr
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put_many(memcg, nr_pages);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
--- a/mm/memcontrol-v1.c~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol-v1.c
@@ -635,11 +635,8 @@ void memcg1_swapout(struct folio *folio,
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
-	swap_memcg = mem_cgroup_private_id_get_online(memcg);
 	nr_entries = folio_nr_pages(folio);
-	/* Get references for the tail pages, too */
-	if (nr_entries > 1)
-		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
+	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
--- a/mm/memcontrol-v1.h~memcg-consolidate-private-id-refcount-get-put-helpers
+++ a/mm/memcontrol-v1.h
@@ -28,8 +28,8 @@ void drain_all_stock(struct mem_cgroup *
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 int memory_stat_show(struct seq_file *m, void *v);
 
-void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
+						    unsigned int n);
 
 void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
 			      const char *name, char sep, u64 val);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch
memcg-consolidate-private-id-refcount-get-put-helpers.patch

