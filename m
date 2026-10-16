Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCBF328616;
	Fri, 16 Oct 2026 02:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117272; cv=none; b=ql5HON5odvttLPN63boHlW1XVKUxm3qSQL4yisedHhUHifpSKUqooQYbWtaQfUFuPUKn6Snetva4HBLxk7afPtW5sDF8Pd/dtgDani8ZbHR20hNYZPP+BlKTWLgKDQs6j49siIYjc6Nt2kAcBObSLn/C9HnjwX/X2tFX+jpOqOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117272; c=relaxed/simple;
	bh=YCfWA++OUnih0PfTLsagLZ7URbZD/ILBkM3HYJe42qk=;
	h=Date:To:From:Subject:Message-Id; b=Y1oYBvOBm/BlCih1yLxbtuVIlaO4UyJwB8MBDGvFLNaZVxZw7ZdHOXDH3bnMucnNmUn3H9ob9fOBVL0Uib0IL2trbltumV2+ELB2XcDseSE2d+h6x+cU8U6N4FH6ywPhQDN8oKW46TJQ9SEh3+N/+BhScUmLdrhtQRSLQdT5UjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fXRchXs2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fXRchXs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF391F000C5;
	Fri, 16 Oct 2026 02:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792117271;
	bh=V1QedP4fN2M9thqPf0qlPISD2AKg2Ixnt39oi5YN/GI=;
	h=Date:To:From:Subject;
	b=fXRchXs2q8cZQrMX5LBEwo1vB2hBi/tu5LB34WNxsg/QXpWlLrV+w/QqUx7iooGV5
	 67mdg1ow9o4h3fu+lfkTZ9sF2Rj2KohPk07YflFFEIX/DblP9unJhcQXL7KKFSVeQ4
	 csrEDz7cF6ZOSr16814iJ/Q4vExaLsW+KiDlHAII=
Date: Thu, 15 Oct 2026 19:21:10 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch added to mm-unstable branch
Message-Id: <20261016022111.3DF391F000C5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
Date: Thu, 15 Oct 2026 14:05:27 +0800

swap_cache_get_folio() reads the folio from the swap table and takes a
reference with folio_try_get(), without any lock.  If the folio is removed
from the swap cache and freed in between, and its memory gets reused,
folio_try_get() still succeeds and we return a page that has nothing to do
with the swap entry:

  CPU 0                                  CPU 1
  do_swap_page()
    swap_cache_get_folio()
      swp_tb = swap_table_get()
      folio = swp_tb_to_folio(swp_tb)
                                         madvise(MADV_DONTNEED)
                                           zap_nonpresent_ptes()
                                             swap_put_entries_direct()
                                               swap_put_entries_cluster()
                                                 __try_to_reclaim_swap()
                                                   swap_cache_del_folio()
                                                   folio_put()   <- freed
                                         page reused, e.g. as an anon
                                         folio of another task
      folio_try_get(folio)               <- succeeds
      return folio
    swap_update_readahead()              <- may clear PG_readahead on it
    folio_lock_or_retry()                <- locks it
    folio_matches_swap_entry() fails, unlock and put

filemap_get_entry() does the same lockless lookup for the page cache, and
after folio_try_get() it rechecks the xarray, because the folio may have
been freed and reused in between.  swap_cache_get_folio() lost that
recheck when the swap cache moved to the swap table.

So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
takes the folio lock of someone else's page, before
folio_matches_swap_entry() finds out the folio is not ours.

When the race occurs, a swap fault can acquire a reference to a physical
page that has been freed and reused for an unrelated purpose, potentially
by another process.  The fault handler may then clear that page's
PG_readahead/PG_reclaim flag, wait on or acquire its folio lock, and
potentially attempt to remove it from an unrelated swap cache.

These operations can interfere with unrelated workloads and may cause
unexpected stalls, impaired reclaim or writeback, and potentially system
hangs.  The subsequent swap-entry validation normally prevents the wrong
folio from being mapped into the faulting process, and neither data
corruption nor a kernel crash has been demonstrated.

Recheck the slot after folio_try_get() and retry if it no longer holds
this folio.

[akpm@linux-foundation.org: add LLM-generated description of userspace impact]
Link: https://lore.kernel.org/20261015060528.302634-1-jiayuan.chen@linux.dev
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
---

 mm/swap_state.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache
+++ a/mm/swap_state.c
@@ -92,17 +92,27 @@ void show_swap_cache_info(void)
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	unsigned int ci_off = swp_cluster_offset(entry);
 	unsigned long swp_tb;
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-					swp_cluster_offset(entry));
+		swp_tb = swap_table_get(ci, ci_off);
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
-		if (likely(folio_try_get(folio)))
+		if (!folio_try_get(folio))
+			continue;
+		/*
+		 * The folio may have been freed and its memory reused before
+		 * we got the reference. Make sure it is still in the slot.
+		 */
+		swp_tb = swap_table_get(ci, ci_off);
+		if (likely(swp_tb_is_folio(swp_tb) &&
+			   swp_tb_to_folio(swp_tb) == folio))
 			return folio;
+		folio_put(folio);
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch

