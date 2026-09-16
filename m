Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062F472096
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595705; cv=none; b=QyqcX/J5n2NjvZ1KdGdNX1DIhc0899iXPyB0DT8SvDNSdfICp/ej7e07SeeXjtAerfMNJNys8gvrC6+/QM7CcHpo3NbJsrfY3BOJShCTOdo5GthiVzKbKJ9EDT/u5bAIL3qGOTId+B/b5PjyH7KvByZgH/4eYVMIqRmbdxdzUh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595705; c=relaxed/simple;
	bh=dg4yuFUXz/UdFVlGj7QP5OkjEsWKUCviUWKtkcrBNkQ=;
	h=Date:To:From:Subject:Message-Id; b=bjxMcBJJlQHy5tnc5JWEYuFYjHCJzOO9z+FRG4Bf2IO7e/b0S7iwh3Fg/I/pg1kZeERPnEequHy34sYbhPhZeTidZzgnwregHKndkB15/mL1GVvM7lPBQfSiRsKi/VB69MsYJU8gHjS3KlNtoqyLNC2HCzts8oULmLOcyZUsz/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uQ6/tIps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uQ6/tIps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEAE1F00899;
	Wed, 16 Sep 2026 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789595689;
	bh=REh7+aH/riQD2Z2QErXvVj/227tBW34FsJFeXSN/02c=;
	h=Date:To:From:Subject;
	b=uQ6/tIpsIHo5ogrPozTjOuTviLCQJbi3fusrT2uIerhTTj7WFXgs27hcEPeFDONyl
	 gDWnU1NCuvhptN2fxAvRgGplsxmcYrBm9VnEtPVaFSDXDXyuJ6RCrN9Ow8FrgUMwnm
	 eI+01IscVlRt9K5gchzZMsghA22Rj3xltWgn2weA=
Date: Wed, 16 Sep 2026 14:54:48 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-constify-the-reclaim-protection-helpers.patch added to mm-new branch
Message-Id: <20260916215449.2EEAE1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: constify the reclaim protection helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-constify-the-reclaim-protection-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-constify-the-reclaim-protection-helpers.patch

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
Subject: mm: memcontrol: constify the reclaim protection helpers
Date: Tue, 15 Sep 2026 19:20:11 -0400

mem_cgroup_protection(), mem_cgroup_unprotected(), mem_cgroup_below_low(),
and mem_cgroup_below_min() only read the protection state.  Constify them.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu
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

 include/linux/memcontrol.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-constify-the-reclaim-protection-helpers
+++ a/include/linux/memcontrol.h
@@ -570,8 +570,8 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -637,8 +637,8 @@ static inline bool mem_cgroup_unprotecte
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -647,8 +647,8 @@ static inline bool mem_cgroup_below_low(
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1149,8 +1149,8 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1163,19 +1163,19 @@ static inline void mem_cgroup_calculate_
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
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

