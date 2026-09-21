Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE180449EA8
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030933; cv=none; b=l1XYNzJQHvrNFRBlkXWBVNp3eXuEEX2WSq9x23X0h2IyHdemDhAMEYdOnVuIW3Tfr98nmhZWocD7GjKzQgp4JAtiFyd+vKxLVmAypqgLbeFEQPwQm+qb8QBrMklS9PQ7QU9tYeD9ewBa4i9qQ3IRddXw/vtqGlnvnKWnSXoClRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030933; c=relaxed/simple;
	bh=HmfbWtEjEhDt1AdXarMpJ+oknaUb03zqQi7sEkYbVmg=;
	h=Date:To:From:Subject:Message-Id; b=YSnH/mQnMJT5xeNJedru1iNgy3cQDd0Mh2pmXKPiFtKxiN7oveA+UI0QkhPDdn3lCDHohsxbaHBbyfN+VYWA6nWojtahT9IYUS68q78LfXXiUSi6doQNBxOZTSqZs3pafCMtn+0d5AfKf3Z7lJEjiBNgW/eOKKm1XOz8f2shmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbDJgSn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbDJgSn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C251F00893;
	Mon, 21 Sep 2026 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030931;
	bh=C0ADxdqZmUt9Cfinif4fdob002mUzv0WPMZ6YrWD0HY=;
	h=Date:To:From:Subject;
	b=qbDJgSn8efdPuJEpDSwIV11wrImSPte5CNCLPZj9YF+lC+AksG7lTVT4apFKpgekD
	 JanYLzZ7zMWFpb+gDUJjtia078ORld5kF5KWw7tONi9pk0v64qZ834Cm+8qgIx5uuQ
	 SRhsNlMYrIzLV3f+S31Tm5E+vb01bA7v5cLLWCj8=
Date: Mon, 21 Sep 2026 15:48:51 -0700
To: mm-commits@vger.kernel.org,bingfangguo@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-base-swap-charge-accounting-on-memcgid-root-status.patch added to mm-new branch
Message-Id: <20260921224851.67C251F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: base swap charge accounting on memcgid root status
has been added to the -mm mm-new branch.  Its filename is
     memcg-base-swap-charge-accounting-on-memcgid-root-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-base-swap-charge-accounting-on-memcgid-root-status.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Bingfang Guo <bingfangguo@tencent.com>
Subject: memcg: base swap charge accounting on memcgid root status
Date: Mon, 21 Sep 2026 14:16:25 +0800

A private ID currently pins its original memcg, so testing whether the ID
belongs to root is equivalent to testing whether the resolved memcg is
root.

That equivalence will no longer hold when IDs refer to objcgs.  A non-root
ID may resolve to root after reparenting, but its swap entries still carry
counter charges inherited by root.  Skipping their uncharge based on the
resolved memcg would leave those charges behind.

Use the private ID's root status to decide whether a swap entry carries a
counter charge.  A root-ID entry carries none, while a non-root-ID entry
must release its charge even if its current accounting memcg has become
root.

This patch adds a new helper to check if the memcgid equals to that of the
root memcg.  For swap uncharging and v2 swap charging, simply decide
whether to charge/uncharge memsw or swap counter based on the swap memcgid
is root or not.  For v1 swapout, don't recharge the memsw counter, just
cancel the charge if the swap memcg ID refers to the root memcg.

This makes memory and swap charging have similar semantics: one relys on
the objcg's root status, and the other relys on the memcgid's root status.

Link: https://lore.kernel.org/20260921-bingfangguo-memcgid-rework-v2-2-6c0637dc0edb@tencent.com
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Bingfang Guo <bfguo@icloud.com>
---

 mm/memcontrol-v1.c |   16 ++++++++--------
 mm/memcontrol-v1.h |    5 +++++
 mm/memcontrol.c    |    4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol.c
@@ -5976,7 +5976,7 @@ int __mem_cgroup_try_charge_swap(struct
 		/* memcg is pined by memcg ID. */
 		private_id = mem_cgroup_private_id(memcg);
 
-		if (!mem_cgroup_is_root(memcg) &&
+		if (!mem_cgroup_private_id_is_root(private_id) &&
 		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6005,7 +6005,7 @@ void __mem_cgroup_uncharge_swap(unsigned
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
 			else
--- a/mm/memcontrol-v1.c~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol-v1.c
@@ -271,6 +271,7 @@ void __memcg1_swapout(struct folio *foli
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
+	unsigned short private_id;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -293,25 +294,24 @@ void __memcg1_swapout(struct folio *foli
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead and cancel the memory+swap charge
+	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
+	private_id = mem_cgroup_private_id(swap_memcg);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
 
-	if (!obj_cgroup_is_root(objcg))
+	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
+		if (mem_cgroup_private_id_is_root(private_id))
+			page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
 	/*
--- a/mm/memcontrol-v1.h~memcg-base-swap-charge-accounting-on-memcgid-root-status
+++ a/mm/memcontrol-v1.h
@@ -22,6 +22,11 @@ void drain_all_stock(struct mem_cgroup *
 
 int memory_stat_show(struct seq_file *m, void *v);
 
+static inline bool mem_cgroup_private_id_is_root(unsigned short id)
+{
+	return id == mem_cgroup_private_id(root_mem_cgroup);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
_

Patches currently in -mm which might be from bingfangguo@tencent.com are

mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats.patch
memcg-keep-swap-charging-under-rcu-protection.patch
memcg-base-swap-charge-accounting-on-memcgid-root-status.patch
memcg-manipulate-memcg-private-id-references-by-id.patch
memcg-move-memcg-private-id-refcount-to-objcg.patch

