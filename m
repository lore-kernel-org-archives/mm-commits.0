Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A274E433C
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595715; cv=none; b=jzaesWWMLI0KDgf2dF74kpbI+5+dC5q9PDJ0sLYdv5u87KNfQtQQVVPW5Gj2kwWa9Azaj2FdcsrYtGMHyGdHvozbF93UY1zjGzLq0NZw7LUAhPD9VexI7Hz4anCOExAHYOraCRvb5Zl0HOgVPsBq+eLjXZVVD2MqBtFP/ph4MzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595715; c=relaxed/simple;
	bh=+G4EMWVWieIJAsMzRH3bNGiliqEbI705gfFS+DrJY3I=;
	h=Date:To:From:Subject:Message-Id; b=VKzUq3997I33pyJrnbdmjSP/Lpsen2d6qqETFlet0stJRla+Tc7b/qHqoY2IWlv/t4a58gLJFyVhnydzkJv9Khrk/gxc0jT241hxQ25DVr2N1c2RFLD4OyKCwvyiP+Q0G4T1W77VN2/Hx0o2ddHL2E9G0nPYkLtcRo7CVoHB7YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=haxft8Ao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="haxft8Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD601F00898;
	Wed, 16 Sep 2026 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789595700;
	bh=BlzRDve6XHVc23ygpSNZwg8AkCOVwxEzyTVg+cnw8yA=;
	h=Date:To:From:Subject;
	b=haxft8Ao+WdHG7k292EgRZdao7YFdE8Ex/2fnPeuLkZqo9IyKiwv0isLmIdj+UecS
	 4CJpKm/kFWX14XPVt0W1aEqg13B2cSmaKh14QsMhYMInXXkR1v+TOOlR++kE7tYTDZ
	 O8Gz8AJd/s3kQ2Pbu5nMhwkC/WH4j+hjB5I4V0QU=
Date: Wed, 16 Sep 2026 14:55:00 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch added to mm-new branch
Message-Id: <20260916215500.7BD601F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: constify the zswap and socket pressure helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: memcontrol: constify the zswap and socket pressure helpers
Date: Tue, 15 Sep 2026 19:20:15 -0400

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback flags,
and mem_cgroup_get_socket_pressure() only reads the socket pressure
timestamp.  Constify them.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/memcontrol.c            |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers
+++ a/include/linux/memcontrol.h
@@ -1684,7 +1684,7 @@ static inline void mem_cgroup_set_socket
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1702,7 +1702,7 @@ static inline void mem_cgroup_set_socket
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1937,7 +1937,7 @@ static inline void mem_cgroup_calculate_
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1951,7 +1951,7 @@ static inline void obj_cgroup_uncharge_z
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
--- a/mm/memcontrol.c~mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers
+++ a/mm/memcontrol.c
@@ -6304,7 +6304,7 @@ void obj_cgroup_uncharge_zswap(struct ob
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch

