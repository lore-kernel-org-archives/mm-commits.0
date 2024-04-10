Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312411E877
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783328; cv=none; b=ZlBq0b2TOJANtzJkqoJgK3dTPnFR8o2Q0OE34eLHkZB5jWNaHgvF8ZD7H2fYsEXkSexeiGT4+iHpwGzxWLibhQ6glp0K3rPkwNpPxeUrL5ouqcIOq5GWsVFiqDcLRGv/MDE2p5C+tfbJuny1HGgaUxeTREAkUnrSxaMQFtf2/Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783328; c=relaxed/simple;
	bh=c/hfH9gyp1zormhK+4bPLzR8lYRRSYIiyQg7IruPgOk=;
	h=Date:To:From:Subject:Message-Id; b=QjWEl84QvNVOCALsbVPoCdn9DmIU2F1OGNiL32jtJNgaw0TG4W1rzfwlzoDz3w/w17JJM6tA0QebOv/t0we9CH7eVikP1reQCfTbo7yId3AhCDIiPM9qghpxSoKRV5IW3n//MW7Lv4UnLtyLhPkRDvdCznHcyGyNKgjZGzvN8/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=negKBBWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="negKBBWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0422C433C7;
	Wed, 10 Apr 2024 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712783327;
	bh=c/hfH9gyp1zormhK+4bPLzR8lYRRSYIiyQg7IruPgOk=;
	h=Date:To:From:Subject:From;
	b=negKBBWqYD9AsyakA+C6Q/z+uJtPTJRcmFhQBCt6unl8al4dww2AP++bPXPjWmW+R
	 EhnirkGYyXZFSflMfI1LV034FzoDwkPX0hKppe5hnJIUcP7jBTsUgWDVjg2LN2F6cl
	 xNPyVv7dDAPYapp8Rciu6pxI5YN+N1FlEDvzPMuA=
Date: Wed, 10 Apr 2024 14:08:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch added to mm-unstable branch
Message-Id: <20240410210847.B0422C433C7@smtp.kernel.org>
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
Date: Tue, 9 Apr 2024 20:26:27 +1200

Patch series "large folios swap-in: handle refault cases first", v2.

This patchset is extracted from the large folio swapin series[1],
primarily addressing the handling of scenarios involving large folios in
the swap cache.  Currently, it is particularly focused on addressing the
refaulting of mTHP, which is still undergoing reclamation.  This approach
aims to streamline code review and expedite the integration of this
segment into the MM tree.

Presently, do_swap_page only encounters a large folio in the swap cache
before the large folio is released by vmscan.  However, the code should
remain equally useful once we support large folio swap-in via
swapin_readahead().  This approach can effectively reduce page faults and
eliminate most redundant checks and early exits for MTE restoration in
recent MTE patchset[3].

The large folio swap-in for SWP_SYNCHRONOUS_IO and swapin_readahead() will
be split into separate patch sets and sent at a later time.


This patch (of 5):

While swapping in a large folio, we need to free swaps related to the
whole folio.  To avoid frequently acquiring and releasing swap locks, it
is better to introduce an API for batched free.

Link: https://lkml.kernel.org/r/20240409082631.187483-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240409082631.187483-2-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 ++++
 mm/swapfile.c        |   51 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

--- a/include/linux/swap.h~mm-swap-introduce-swap_free_nr-for-batched-swap_free
+++ a/include/linux/swap.h
@@ -480,6 +480,7 @@ extern void swap_shmem_alloc(swp_entry_t
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t);
 extern void swap_free(swp_entry_t);
+extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
 int swap_type_of(dev_t device, sector_t offset);
@@ -561,6 +562,10 @@ static inline void swap_free(swp_entry_t
 {
 }
 
+void swap_free_nr(swp_entry_t entry, int nr_pages)
+{
+}
+
 static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
 {
 }
--- a/mm/swapfile.c~mm-swap-introduce-swap_free_nr-for-batched-swap_free
+++ a/mm/swapfile.c
@@ -1357,6 +1357,57 @@ void swap_free(swp_entry_t entry)
 }
 
 /*
+ * Free up the maximum number of swap entries at once to limit the
+ * maximum kernel stack usage.
+ */
+#define SWAP_BATCH_NR (SWAPFILE_CLUSTER > 512 ? 512 : SWAPFILE_CLUSTER)
+
+/*
+ * Called after swapping in a large folio, batched free swap entries
+ * for this large folio, entry should be for the first subpage and
+ * its offset is aligned with nr_pages
+ */
+void swap_free_nr(swp_entry_t entry, int nr_pages)
+{
+	int i, j;
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *p;
+	unsigned int type = swp_type(entry);
+	unsigned long offset = swp_offset(entry);
+	int batch_nr, remain_nr;
+	DECLARE_BITMAP(usage, SWAP_BATCH_NR) = { 0 };
+
+	/* all swap entries are within a cluster for mTHP */
+	VM_BUG_ON(offset % SWAPFILE_CLUSTER + nr_pages > SWAPFILE_CLUSTER);
+
+	if (nr_pages == 1) {
+		swap_free(entry);
+		return;
+	}
+
+	remain_nr = nr_pages;
+	p = _swap_info_get(entry);
+	if (p) {
+		for (i = 0; i < nr_pages; i += batch_nr) {
+			batch_nr = min_t(int, SWAP_BATCH_NR, remain_nr);
+
+			ci = lock_cluster_or_swap_info(p, offset);
+			for (j = 0; j < batch_nr; j++) {
+				if (__swap_entry_free_locked(p, offset + i * SWAP_BATCH_NR + j, 1))
+					__bitmap_set(usage, j, 1);
+			}
+			unlock_cluster_or_swap_info(p, ci);
+
+			for_each_clear_bit(j, usage, batch_nr)
+				free_swap_slot(swp_entry(type, offset + i * SWAP_BATCH_NR + j));
+
+			bitmap_clear(usage, 0, SWAP_BATCH_NR);
+			remain_nr -= batch_nr;
+		}
+	}
+}
+
+/*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are

mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch
mm-swap-make-should_try_to_free_swap-support-large-folio.patch
mm-swap-entirely-map-large-folios-found-in-swapcache.patch

