Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BF418CC03
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382504; cv=none; b=Xn/bcXxiwxofHe5bfFwD5e0rT61t4iAbmUFliy4S8llxlHXT00GfIlYdXCIRGV/o5RBcr0XxPd6rTELESo6l63MnavgyslwXrBW0g7+owDatRS89MaarBBIA3HIz2GYFBuc0P2T8uSD4o175YgCaKaNaKEc2RBTG1iaM7SYDPZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382504; c=relaxed/simple;
	bh=9P9aYl8HH35jPvXj0vWySvgj3Pn2Bw10DRJUK89A9cI=;
	h=Date:To:From:Subject:Message-Id; b=QBtMTotU7RFlnUkRLGDG85sVRePThp7xWa1jw29wZ8JJeJ8rbPDG3Ji3fbBlPsZs3+PbGcJmCFE8xrLUynv0wXknKWRCXtmWV6RKbRmGW2y7n3itNfQqKXrJ+m6UduIfaIcep6DuL0AK4BQnCUzAaHL6Hh437UNdPsBPcfS7Yns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ONtAPFTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ONtAPFTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E63C32782;
	Tue, 30 Jul 2024 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722382503;
	bh=9P9aYl8HH35jPvXj0vWySvgj3Pn2Bw10DRJUK89A9cI=;
	h=Date:To:From:Subject:From;
	b=ONtAPFTNvaVq8nQ6KJ/Xy5jdwaWF3y/o+KlxGiRXJ/fMtGpKiGHndIMaepiWRa4KC
	 2xWvoRYaoeX1qxU4NqBEgpVNLMAOUPhMRJADmqhgAkFdCvjXGJzCPaesz3ReCeEE/8
	 m8oW8TDDvOGrWtu7bEfUnzDrYwxSkIEWDZKFIQgE=
Date: Tue, 30 Jul 2024 16:35:03 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch added to mm-unstable branch
Message-Id: <20240730233503.D3E63C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: add nr argument in swapcache_prepare and swapcache_clear to support large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: swap: add nr argument in swapcache_prepare and swapcache_clear to support large folios
Date: Tue, 30 Jul 2024 19:13:39 +1200

Right now, swapcache_prepare() and swapcache_clear() supports one entry
only, to support large folios, we need to handle multiple swap entries.

To optimize stack usage, we iterate twice in __swap_duplicate(): the first
time to verify that all entries are valid, and the second time to apply
the modifications to the entries.

Currently, we're using nr=1 for the existing users.

Link: https://lkml.kernel.org/r/20240730071339.107447-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 -
 mm/memory.c          |    6 +-
 mm/swap.h            |    5 +-
 mm/swap_state.c      |    2 
 mm/swapfile.c        |  101 +++++++++++++++++++++++------------------
 5 files changed, 68 insertions(+), 50 deletions(-)

--- a/include/linux/swap.h~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios
+++ a/include/linux/swap.h
@@ -480,7 +480,7 @@ extern int get_swap_pages(int n, swp_ent
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
-extern int swapcache_prepare(swp_entry_t);
+extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
 extern void swapcache_free_entries(swp_entry_t *entries, int n);
 extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
@@ -554,7 +554,7 @@ static inline int swap_duplicate(swp_ent
 	return 0;
 }
 
-static inline int swapcache_prepare(swp_entry_t swp)
+static inline int swapcache_prepare(swp_entry_t swp, int nr)
 {
 	return 0;
 }
--- a/mm/memory.c~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios
+++ a/mm/memory.c
@@ -4081,7 +4081,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 * reusing the same entry. It's undetectable as
 			 * pte_same() returns true due to entry reuse.
 			 */
-			if (swapcache_prepare(entry)) {
+			if (swapcache_prepare(entry, 1)) {
 				/* Relax a bit to prevent rapid repeated page faults */
 				schedule_timeout_uninterruptible(1);
 				goto out;
@@ -4387,7 +4387,7 @@ unlock:
 out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
 	if (need_clear_cache)
-		swapcache_clear(si, entry);
+		swapcache_clear(si, entry, 1);
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -4403,7 +4403,7 @@ out_release:
 		folio_put(swapcache);
 	}
 	if (need_clear_cache)
-		swapcache_clear(si, entry);
+		swapcache_clear(si, entry, 1);
 	if (si)
 		put_swap_device(si);
 	return ret;
--- a/mm/swapfile.c~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios
+++ a/mm/swapfile.c
@@ -3363,7 +3363,7 @@ void si_swapinfo(struct sysinfo *val)
 }
 
 /*
- * Verify that a swap entry is valid and increment its swap map count.
+ * Verify that nr swap entries are valid and increment their swap map counts.
  *
  * Returns error code in following case.
  * - success -> 0
@@ -3373,60 +3373,77 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 {
 	struct swap_info_struct *p;
 	struct swap_cluster_info *ci;
 	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
-	int err;
+	int err, i;
 
 	p = swp_swap_info(entry);
 
 	offset = swp_offset(entry);
+	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
 	ci = lock_cluster_or_swap_info(p, offset);
 
-	count = p->swap_map[offset];
+	err = 0;
+	for (i = 0; i < nr; i++) {
+		count = p->swap_map[offset + i];
 
-	/*
-	 * swapin_readahead() doesn't check if a swap entry is valid, so the
-	 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
-	 */
-	if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
-		err = -ENOENT;
-		goto unlock_out;
-	}
+		/*
+		 * swapin_readahead() doesn't check if a swap entry is valid, so the
+		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 */
+		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+			err = -ENOENT;
+			goto unlock_out;
+		}
 
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-	err = 0;
+		has_cache = count & SWAP_HAS_CACHE;
+		count &= ~SWAP_HAS_CACHE;
 
-	if (usage == SWAP_HAS_CACHE) {
+		if (usage == SWAP_HAS_CACHE) {
+			/* set SWAP_HAS_CACHE if there is no cache and entry is used */
+			if (!has_cache && count)
+				continue;
+			else if (has_cache)		/* someone else added cache */
+				err = -EEXIST;
+			else				/* no users remaining */
+				err = -ENOENT;
+
+		} else if (count || has_cache) {
+
+			if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+				continue;
+			else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
+				err = -EINVAL;
+			else if (swap_count_continued(p, offset + i, count))
+				continue;
+			else
+				err = -ENOMEM;
+		} else
+			err = -ENOENT;			/* unused swap entry */
 
-		/* set SWAP_HAS_CACHE if there is no cache and entry is used */
-		if (!has_cache && count)
-			has_cache = SWAP_HAS_CACHE;
-		else if (has_cache)		/* someone else added cache */
-			err = -EEXIST;
-		else				/* no users remaining */
-			err = -ENOENT;
+		if (err)
+			goto unlock_out;
+	}
 
-	} else if (count || has_cache) {
+	for (i = 0; i < nr; i++) {
+		count = p->swap_map[offset + i];
+		has_cache = count & SWAP_HAS_CACHE;
+		count &= ~SWAP_HAS_CACHE;
 
-		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+		if (usage == SWAP_HAS_CACHE)
+			has_cache = SWAP_HAS_CACHE;
+		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
-		else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
-			err = -EINVAL;
-		else if (swap_count_continued(p, offset, count))
-			count = COUNT_CONTINUED;
 		else
-			err = -ENOMEM;
-	} else
-		err = -ENOENT;			/* unused swap entry */
+			count = COUNT_CONTINUED;
 
-	if (!err)
-		WRITE_ONCE(p->swap_map[offset], count | has_cache);
+		WRITE_ONCE(p->swap_map[offset + i], count | has_cache);
+	}
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
@@ -3439,7 +3456,7 @@ unlock_out:
  */
 void swap_shmem_alloc(swp_entry_t entry)
 {
-	__swap_duplicate(entry, SWAP_MAP_SHMEM);
+	__swap_duplicate(entry, SWAP_MAP_SHMEM, 1);
 }
 
 /*
@@ -3453,29 +3470,29 @@ int swap_duplicate(swp_entry_t entry)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1) == -ENOMEM)
+	while (!err && __swap_duplicate(entry, 1, 1) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }
 
 /*
- * @entry: swap entry for which we allocate swap cache.
+ * @entry: first swap entry from which we allocate nr swap cache.
  *
- * Called when allocating swap cache for existing swap entry,
+ * Called when allocating swap cache for existing swap entries,
  * This can return error codes. Returns 0 at success.
  * -EEXIST means there is a swap cache.
  * Note: return code is different from swap_duplicate().
  */
-int swapcache_prepare(swp_entry_t entry)
+int swapcache_prepare(swp_entry_t entry, int nr)
 {
-	return __swap_duplicate(entry, SWAP_HAS_CACHE);
+	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
 }
 
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
+void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
 {
 	unsigned long offset = swp_offset(entry);
 
-	cluster_swap_free_nr(si, offset, 1, SWAP_HAS_CACHE);
+	cluster_swap_free_nr(si, offset, nr, SWAP_HAS_CACHE);
 }
 
 struct swap_info_struct *swp_swap_info(swp_entry_t entry)
--- a/mm/swap.h~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios
+++ a/mm/swap.h
@@ -59,7 +59,7 @@ void __delete_from_swap_cache(struct fol
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry);
+void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
 struct folio *filemap_get_incore_folio(struct address_space *mapping,
@@ -120,7 +120,7 @@ static inline int swap_writepage(struct
 	return 0;
 }
 
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
+static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
 {
 }
 
@@ -172,4 +172,5 @@ static inline unsigned int folio_swap_fl
 	return 0;
 }
 #endif /* CONFIG_SWAP */
+
 #endif /* _MM_SWAP_H */
--- a/mm/swap_state.c~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios
+++ a/mm/swap_state.c
@@ -477,7 +477,7 @@ struct folio *__read_swap_cache_async(sw
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
-		err = swapcache_prepare(entry);
+		err = swapcache_prepare(entry, 1);
 		if (!err)
 			break;
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch

