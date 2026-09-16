Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640074EBAC5
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595688; cv=none; b=ggIJHpgeit8qj0mdRjeq2p5vCymLoAoOpIdj4xVDuXZpVBfFvZeZqV9jp85JXMuaNAnxM97KbWG7onOZFq6EHUlPT3Ta1jISDkmIEzOjv9UVKy5V+2uALweeX2fRWsO826icqdLIW+FFr9Uis7UunxvUui1pTPh8Z42gfED4GOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595688; c=relaxed/simple;
	bh=ytTVIwVFp35HvShf4apJ9T9S0luTM0ntnJ4GE3FsrL0=;
	h=Date:To:From:Subject:Message-Id; b=D9Qe720kxzGoi1LtNjU2CaiD6k7D8+a1RWICbjW1Ek56334BnHNpAEA7IaKw1D09N9rfIqrgOzATnVRP+d2DVJsp+gzxYP/RDkX0/ILzzu5fslZ6K+2t2blm/q6mHbHy26n+5vHimDub71ZyTIIeOjvAjP/xBCukvxKhQLL3b6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ya15fU9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ya15fU9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D021F00899;
	Wed, 16 Sep 2026 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789595681;
	bh=+CKQfw82plyG9EXAR7gyGbK32vyyb1FxHEmX9BR3WJ0=;
	h=Date:To:From:Subject;
	b=Ya15fU9l6CWQUAoZGcUa1nFdWrikzDPR1hiupooEHbxf9KXiozxVOT02YcYkCC+Dj
	 kCSUMpUgCFw87bG1dsydkgZSg+AnbqGe5KLAfYgtS1f+r3eJz8XNfCBSHkbiH03v+Q
	 jQARxGmiLj0dl3pkcaBCNPZoMwSpAaV/75fEJFd8=
Date: Wed, 16 Sep 2026 14:54:41 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch added to mm-new branch
Message-Id: <20260916215441.98D021F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: take a const folio in bio_associate_blkg_from_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch

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
Subject: mm/page_io: take a const folio in bio_associate_blkg_from_folio()
Date: Tue, 15 Sep 2026 19:20:08 -0400

bio_associate_blkg_from_folio() and its helpers only read from the folio. 
Constify their folio arguments.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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

 mm/page_io.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio
+++ a/mm/page_io.c
@@ -256,12 +256,13 @@ out_unlock:
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_foli
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
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

