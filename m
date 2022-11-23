Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37933C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239600AbiKWTLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiKWTLp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:11:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA1FF3E
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33234B82438
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97D5C433D6;
        Wed, 23 Nov 2022 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669230699;
        bh=JwLWY0I99u56cuflyrbMcg7stZ9J8qQGOqxdcrIjYtk=;
        h=Date:To:From:Subject:From;
        b=jPtA42+Sud6jV/S7fnRYGMCIDDKKO4KLnjM5heUDJnPciu/r+0aOlPkaH9SvtUWGt
         VZtJ34dNhuZCyx+p2ZsFeYpb5iAnkyd1rvTrr9wDtm9HNwLhKdoOqEu81+GN3w0Zca
         gMJu6crTct2bNfWf5Cxh0xq9tIEMIEnlRi5KLAyQ=
Date:   Wed, 23 Nov 2022 11:11:39 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-lock_page_memcg-from-rmap.patch added to mm-unstable branch
Message-Id: <20221123191139.D97D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lock_page_memcg() from rmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-lock_page_memcg-from-rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-lock_page_memcg-from-rmap.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove lock_page_memcg() from rmap
Date: Wed, 23 Nov 2022 13:18:38 -0500

rmap changes (mapping and unmapping) of a page currently take
lock_page_memcg() to serialize 1) update of the mapcount and the cgroup
mapped counter with 2) cgroup moving the page and updating the old cgroup
and the new cgroup counters based on page_mapped().

Before b2052564e66d ("mm: memcontrol: continue cache reclaim from offlined
groups"), we used to reassign all pages that could be found on a cgroup's
LRU list on deletion - something that rmap didn't naturally serialize
against.  Since that commit, however, the only pages that get moved are
those mapped into page tables of a task that's being migrated.  In that
case, the pte lock is always held (and we know the page is mapped), which
keeps rmap changes at bay already.

The additional lock_page_memcg() by rmap is redundant. Remove it.

Link: https://lkml.kernel.org/r/20221123181838.1373440-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++++++++++++++---------------
 mm/rmap.c       |   12 ------------
 2 files changed, 20 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~mm-remove-lock_page_memcg-from-rmap
+++ a/mm/memcontrol.c
@@ -5676,7 +5676,10 @@ static struct page *mc_handle_file_pte(s
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
- * The caller must make sure the page is not on LRU (isolate_page() is useful.)
+ * This function acquires folio_lock() and folio_lock_memcg(). The
+ * caller must exclude all other possible ways of accessing
+ * page->memcg, such as LRU isolation (to lock out isolation) and
+ * having the page mapped and pte-locked (to lock out rmap).
  *
  * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
  * from old cgroup.
@@ -5697,6 +5700,13 @@ static int mem_cgroup_move_account(struc
 	VM_BUG_ON(compound && !folio_test_large(folio));
 
 	/*
+	 * We're only moving pages mapped into the moving process's
+	 * page tables. The caller's pte lock prevents rmap from
+	 * removing the NR_x_MAPPED state while we transfer it.
+	 */
+	VM_WARN_ON_ONCE(!folio_mapped(folio));
+
+	/*
 	 * Prevent mem_cgroup_migrate() from looking at
 	 * page's memory cgroup of its source page while we change it.
 	 */
@@ -5715,30 +5725,25 @@ static int mem_cgroup_move_account(struc
 	folio_memcg_lock(folio);
 
 	if (folio_test_anon(folio)) {
-		if (folio_mapped(folio)) {
-			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
-			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
-			if (folio_test_transhuge(folio)) {
-				__mod_lruvec_state(from_vec, NR_ANON_THPS,
-						   -nr_pages);
-				__mod_lruvec_state(to_vec, NR_ANON_THPS,
-						   nr_pages);
-			}
+		__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
+
+		if (folio_test_transhuge(folio)) {
+			__mod_lruvec_state(from_vec, NR_ANON_THPS, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_ANON_THPS, nr_pages);
 		}
 	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
 
+		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
+
 		if (folio_test_swapbacked(folio)) {
 			__mod_lruvec_state(from_vec, NR_SHMEM, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_SHMEM, nr_pages);
 		}
 
-		if (folio_mapped(folio)) {
-			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
-			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
-		}
-
 		if (folio_test_dirty(folio)) {
 			struct address_space *mapping = folio_mapping(folio);
 
--- a/mm/rmap.c~mm-remove-lock_page_memcg-from-rmap
+++ a/mm/rmap.c
@@ -1222,9 +1222,6 @@ void page_add_anon_rmap(struct page *pag
 	bool compound = flags & RMAP_COMPOUND;
 	bool first = true;
 
-	if (unlikely(PageKsm(page)))
-		lock_page_memcg(page);
-
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
@@ -1254,9 +1251,6 @@ void page_add_anon_rmap(struct page *pag
 	if (nr)
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 
-	if (unlikely(PageKsm(page)))
-		unlock_page_memcg(page);
-
 	/* address might be in next vma when migration races vma_adjust */
 	else if (first)
 		__page_set_anon_rmap(page, vma, address,
@@ -1321,7 +1315,6 @@ void page_add_file_rmap(struct page *pag
 	bool first;
 
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
-	lock_page_memcg(page);
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
@@ -1349,7 +1342,6 @@ void page_add_file_rmap(struct page *pag
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
 		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
-	unlock_page_memcg(page);
 
 	mlock_vma_page(page, vma, compound);
 }
@@ -1378,8 +1370,6 @@ void page_remove_rmap(struct page *page,
 		return;
 	}
 
-	lock_page_memcg(page);
-
 	/* Is page being unmapped by PTE? Is this its last map to be removed? */
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
@@ -1427,8 +1417,6 @@ void page_remove_rmap(struct page *page,
 	 * and remember that it's only reliable while mapped.
 	 */
 
-	unlock_page_memcg(page);
-
 	munlock_vma_page(page, vma, compound);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch
zswap-fix-writeback-lock-ordering-for-zsmalloc.patch
zpool-clean-out-dead-code.patch
mm-remove-lock_page_memcg-from-rmap.patch

