Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC06BE66
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172242; cv=none; b=a++eKkmi+ukJPfQwsogZmQDtqu9EJ+BoTtNw2tMgRFgfKrd8JlZx7OkB+heOr7yiOh8KKuIwoSbmTCYcpvVRmj8uEFdZ7UjQhMor1WLTnjD6/QOSlbuyvPEiDbxj1iTZeFJsfZfaTOEJsdXMnaDLUG+Y50mi9K7oZqxDogAUzfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172242; c=relaxed/simple;
	bh=APmFag7oa4F23PQyIGfMuhmM4lc624FGKAnCvJlwlgw=;
	h=Date:To:From:Subject:Message-Id; b=nwwlwFxAONN8V0MdKHF/Z47EwUBLgPMxalLih4oQSu+NwfBwImacb4YhLih9V6VJJGggI2AV9FyRoWQXirhEw+NPj6EpElj0GFX9aQuobI7uCe271RkU+MeZTVeZGyN3B95VyJhiywWkIvbnkacBzgcycUqbwYnbjqRknhWGieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G4Aya9iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G4Aya9iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD50C433C7;
	Mon,  5 Feb 2024 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707172241;
	bh=APmFag7oa4F23PQyIGfMuhmM4lc624FGKAnCvJlwlgw=;
	h=Date:To:From:Subject:From;
	b=G4Aya9iUmRvZHtQUC2VHBbOWDOlhDYHnaUHXCGCoFyfBwLhLv8zFC6hU+oNg6okNe
	 cFKqQbZUqFp0ptyWk5jD/q9+4XGwS+kGQXuypmAiP+E9DpJNpQ5daw94r1/vSJieEx
	 zYdUbM9M77fJdggRpQBcuH8a7+/XBRimi7yaqKPM=
Date: Mon, 05 Feb 2024 14:30:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,minchan@kernel.org,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-race-condition-in-direct-swapin-path.patch added to mm-unstable branch
Message-Id: <20240205223041.5DD50C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix race condition in direct swapin path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fix-race-condition-in-direct-swapin-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-race-condition-in-direct-swapin-path.patch

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
Subject: mm/swap: fix race condition in direct swapin path
Date: Mon, 5 Feb 2024 19:09:59 +0800

In the direct swapin path, when two or more threads swapin the same entry
at the same time, they get different pages (A, B) because swap cache is
skipped.  Before one thread (T0) finishes the swapin and installs page (A)
to the PTE, another thread (T1) could finish swapin of page (B), swap_free
the entry, then modify and swap-out the page again, using the same entry. 
It break the pte_same check because PTE value is unchanged, causing ABA
problem.  Then thread (T0) will then install the stalled page (A) into the
PTE so new data in page (B) is lost, one possible callstack is like this:

CPU0                                CPU1
----                                ----
do_swap_page()                      do_swap_page() with same entry
<direct swapin path>                <direct swapin path>
<alloc page A>                      <alloc page B>
swap_readpage() <- read to page A   swap_readpage() <- read to page B
<slow on later locks or interrupt>  <finished swapin first>
...                                 set_pte_at()
                                    swap_free() <- Now the entry is freed.
                                    <write to page B, now page A stalled>
                                    <swap out page B using same swap entry>
pte_same() <- Check pass, PTE seems
              unchanged, but page A
              is stalled!
swap_free() <- page B content lost!
set_pte_at() <- staled page A installed!

To fix this, reuse swapcache_prepare which will pin the swap entry using
the cache flag, and allow only one thread to pin it.  Release the pin
after PT unlocked.  Racers will simply busy wait since it's a rare and
very short event.

Other methods like increasing the swap count don't seem to be a good idea
after some tests, that will cause racers to fall back to the cached swapin
path, two swapin path being used at the same time leads to a much more
complex scenario.

Reproducer:

This race issue can be triggered easily using a well constructed
reproducer and patched brd (with a delay in read path) [1]:

With latest 6.8 mainline, race caused data loss can be observed easily:
$ gcc -g -lpthread test-thread-swap-race.c && ./a.out
  Polulating 32MB of memory region...
  Keep swapping out...
  Starting round 0...
  Spawning 65536 workers...
  32746 workers spawned, wait for done...
  Round 0: Error on 0x5aa00, expected 32746, got 32743, 3 data loss!
  Round 0: Error on 0x395200, expected 32746, got 32743, 3 data loss!
  Round 0: Error on 0x3fd000, expected 32746, got 32737, 9 data loss!
  Round 0 Failed, 15 data loss!

This reproducer spawns multiple threads sharing the same memory region
using a small swap device.  Every two threads updates mapped pages one by
one in opposite direction trying to create a race, with one dedicated
thread keep swapping out the data out using madvise.

The reproducer created a reproduce rate of about once every 5 minutes,
so the race should be totally possible in production.

After this patch, I ran the reproducer for over a few hundred rounds
and no data loss observed.

Performance overhead is minimal, microbenchmark swapin 10G from 32G
zram:

Before:     10934698 us
After:      11157121 us
Non-direct: 13155355 us (Dropping SWP_SYNCHRONOUS_IO flag)

Link: https://lkml.kernel.org/r/20240205110959.4021-1-ryncsn@gmail.com
Fixes: 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous device")
Link: https://github.com/ryncsn/emm-test-project/tree/master/swap-stress-race [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |   19 +++++++++++++++++++
 mm/swap.h     |    5 +++++
 mm/swapfile.c |   16 ++++++++++++++++
 3 files changed, 40 insertions(+)

--- a/mm/memory.c~mm-swap-fix-race-condition-in-direct-swapin-path
+++ a/mm/memory.c
@@ -3990,6 +3990,20 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
+			/*
+			 * With swap count == 1, after we read the entry,
+			 * other threads could finish swapin first, free
+			 * the entry, then swapout the modified page using
+			 * the same entry. Now the content we just read is
+			 * stalled, and it's undetectable as pte_same()
+			 * returns true due to entry reuse.
+			 *
+			 * So pin the swap entry using the cache flag even
+			 * cache is not used.
+			 */
+			if (swapcache_prepare(entry))
+				goto out;
+
 			/* skip swapcache */
 			folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0,
 						vma, vmf->address, false);
@@ -4239,6 +4253,9 @@ vm_fault_t do_swap_page(struct vm_fault
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	/* Clear the swap cache pin for direct swapin after PTL unlock */
+	if (folio && !swapcache)
+		swapcache_clear(si, entry);
 out:
 	if (si)
 		put_swap_device(si);
@@ -4247,6 +4264,8 @@ out_nomap:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
+	if (!swapcache)
+		swapcache_clear(si, entry);
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
--- a/mm/swapfile.c~mm-swap-fix-race-condition-in-direct-swapin-path
+++ a/mm/swapfile.c
@@ -3381,6 +3381,22 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE);
 }
 
+/*
+ * Clear the cache flag and release pinned entry.
+ */
+void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
+{
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+	unsigned char usage;
+
+	ci = lock_cluster_or_swap_info(si, offset);
+	usage = __swap_entry_free_locked(si, offset, SWAP_HAS_CACHE);
+	unlock_cluster_or_swap_info(si, ci);
+	if (!usage)
+		free_swap_slot(entry);
+}
+
 struct swap_info_struct *swp_swap_info(swp_entry_t entry)
 {
 	return swap_type_to_swap_info(swp_type(entry));
--- a/mm/swap.h~mm-swap-fix-race-condition-in-direct-swapin-path
+++ a/mm/swap.h
@@ -41,6 +41,7 @@ void __delete_from_swap_cache(struct fol
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
+void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
 struct folio *filemap_get_incore_folio(struct address_space *mapping,
@@ -97,6 +98,10 @@ static inline int swap_writepage(struct
 	return 0;
 }
 
+static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
+{
+}
+
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr)
 {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-fix-race-condition-in-direct-swapin-path.patch

