Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99167522A
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010436; cv=none; b=fcZS6TCzJn8YyP2mgpmmmwK1iShwD/tJ6ksg4NJhDj79VzHNkZbsUVP829yx8B7QEo/cR0lcoYknHjgxgvO/60v50/TFYz31Rkp1EbUP31FkeNL1+ESg91FBKXOz29rZTkxhdcZuUlTuCJDhr8o4rSCb6gC52ahOhYEZW/l57Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010436; c=relaxed/simple;
	bh=51gH/c0NZPoD/NohhkiDeNl4Z3up62eAs79EAwSNz7c=;
	h=Date:To:From:Subject:Message-Id; b=gd0gzd0s7GSCYIL6g446czi3fMDZgUCJGIh/pjf7e/Ju+mfKU3a6Sol5JFqSNsvDJMWEnez/aq0cltJzzD4EkuM0dXG0Eer0gD72hpdKWHe15Tahh0O440YoRVA0a2tLG6HikstQhc0r8+nkUcGW0+7OCv9eDrOUNF1GGidgJYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jF/NJP53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jF/NJP53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E837CC32781;
	Wed, 29 May 2024 19:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717010436;
	bh=51gH/c0NZPoD/NohhkiDeNl4Z3up62eAs79EAwSNz7c=;
	h=Date:To:From:Subject:From;
	b=jF/NJP537wvyf5S+sGck+8rb2x1n6a9xweLG2EtYUmAkjpHvSf+HohSER2Bv7ptFj
	 bJQdVT8/3TaH1ft6/BNTwNrsCi8fi03F8ttGxa08FT9C4Ssv4wz93LVSrZBIva4FT+
	 rNYQoNKo02YilVBa5AjWVTjyiGV51ZT3t2NlxkrU=
Date: Wed, 29 May 2024 12:20:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch added to mm-unstable branch
Message-Id: <20240529192035.E837CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: introduce swap_free_nr() for batched swap_free()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch

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
From: Chuanhua Han <hanchuanhua@oppo.com>
Subject: mm: swap: introduce swap_free_nr() for batched swap_free()
Date: Wed, 29 May 2024 20:28:19 +1200

Patch series "large folios swap-in: handle refault cases first", v5.

This patchset is extracted from the large folio swapin series[1],
primarily addressing the handling of scenarios involving large folios in
the swap cache.  Currently, it is particularly focused on addressing the
refaulting of mTHP, which is still undergoing reclamation.  This approach
aims to streamline code review and expedite the integration of this
segment into the MM tree.

It relies on Ryan's swap-out series[2], leveraging the helper function
swap_pte_batch() introduced by that series.

Presently, do_swap_page only encounters a large folio in the swap cache
before the large folio is released by vmscan.  However, the code should
remain equally useful once we support large folio swap-in via
swapin_readahead().  This approach can effectively reduce page faults and
eliminate most redundant checks and early exits for MTE restoration in
recent MTE patchset[3].

The large folio swap-in for SWP_SYNCHRONOUS_IO and swapin_readahead() will
be split into separate patch sets and sent at a later time.

[1] https://lore.kernel.org/linux-mm/20240304081348.197341-1-21cnbao@gmail.com/
[2] https://lore.kernel.org/linux-mm/20240408183946.2991168-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/linux-mm/20240322114136.61386-1-21cnbao@gmail.com/ 


This patch (of 6):

While swapping in a large folio, we need to free swaps related to the
whole folio.  To avoid frequently acquiring and releasing swap locks, it
is better to introduce an API for batched free.  Furthermore, this new
function, swap_free_nr(), is designed to efficiently handle various
scenarios for releasing a specified number, nr, of swap entries.

Link: https://lkml.kernel.org/r/20240529082824.150954-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240529082824.150954-2-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 ++++
 mm/swapfile.c        |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

--- a/include/linux/swap.h~mm-swap-introduce-swap_free_nr-for-batched-swap_free
+++ a/include/linux/swap.h
@@ -478,6 +478,7 @@ extern void swap_shmem_alloc(swp_entry_t
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
+extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
 int swap_type_of(dev_t device, sector_t offset);
@@ -559,6 +560,10 @@ static inline void swap_free(swp_entry_t
 {
 }
 
+static inline void swap_free_nr(swp_entry_t entry, int nr_pages)
+{
+}
+
 static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
 {
 }
--- a/mm/swapfile.c~mm-swap-introduce-swap_free_nr-for-batched-swap_free
+++ a/mm/swapfile.c
@@ -1356,6 +1356,53 @@ void swap_free(swp_entry_t entry)
 		__swap_entry_free(p, entry);
 }
 
+static void cluster_swap_free_nr(struct swap_info_struct *sis,
+		unsigned long offset, int nr_pages)
+{
+	struct swap_cluster_info *ci;
+	DECLARE_BITMAP(to_free, BITS_PER_LONG) = { 0 };
+	int i, nr;
+
+	ci = lock_cluster_or_swap_info(sis, offset);
+	while (nr_pages) {
+		nr = min(BITS_PER_LONG, nr_pages);
+		for (i = 0; i < nr; i++) {
+			if (!__swap_entry_free_locked(sis, offset + i, 1))
+				bitmap_set(to_free, i, 1);
+		}
+		if (!bitmap_empty(to_free, BITS_PER_LONG)) {
+			unlock_cluster_or_swap_info(sis, ci);
+			for_each_set_bit(i, to_free, BITS_PER_LONG)
+				free_swap_slot(swp_entry(sis->type, offset + i));
+			if (nr == nr_pages)
+				return;
+			bitmap_clear(to_free, 0, BITS_PER_LONG);
+			ci = lock_cluster_or_swap_info(sis, offset);
+		}
+		offset += nr;
+		nr_pages -= nr;
+	}
+	unlock_cluster_or_swap_info(sis, ci);
+}
+
+void swap_free_nr(swp_entry_t entry, int nr_pages)
+{
+	int nr;
+	struct swap_info_struct *sis;
+	unsigned long offset = swp_offset(entry);
+
+	sis = _swap_info_get(entry);
+	if (!sis)
+		return;
+
+	while (nr_pages) {
+		nr = min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+		cluster_swap_free_nr(sis, offset, nr);
+		offset += nr;
+		nr_pages -= nr;
+	}
+}
+
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are

mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch
mm-swap-make-should_try_to_free_swap-support-large-folio.patch
mm-swap-entirely-map-large-folios-found-in-swapcache.patch

