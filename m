Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFC735AC11
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019953; cv=none; b=MzjAZ5Y01Y5oaA7kgYP2GOmlFgpww6yP+kRPYx3t9CIQGyc0okajOguTpxN5kcyviTmqHCNMRKQptLhK60fChicqFRxSYnUcg2DqImARkQZCYBIOHqqnDk0fNjMkEyZrQQlhPM36ZEiKD4Rf4IrHZ1+PRODgEYo5n9EWh850kCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019953; c=relaxed/simple;
	bh=xf1Gcq1j4RM6+zD1SIpoLIR0M18hpKTgsDlfo9kWMIM=;
	h=Date:To:From:Subject:Message-Id; b=GBvuXHdE4XCEp2YTBlFXRvMo7XFr/C6w44/u+9bvFcFJ0muuRasUcPuaaGs3qNdcUmSw2UqeoDoKMQHwVF6XtdT/Vsj1XuuywYPe3whVHqv+LyNWItYUevlGXIWDyQ8PmL2EKsnOHh9eQ2llWl0c1s3lheJcw42wZzszCpU6MGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AqyiN3Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AqyiN3Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA7B1F00893;
	Mon, 21 Sep 2026 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019951;
	bh=KdjCSzcuBeTDGXA57mPFRciHrF9+qPU3BXqKYRTA/+c=;
	h=Date:To:From:Subject;
	b=AqyiN3Bg8pEUg4p4loQpmZr4yIvdTRxmQtK4MGfKsyHca7pNqpGzjWQhrh343jPwR
	 D4/ssb13+g1nyjq2utS4J9cq/BYFUGvqcdfInMIkMZGHlP/DfbaT/nviwefkCEytdY
	 UhXXQ7SM5+5CDiW+CAj45HI21dJSeZ230UUe1UNk=
Date: Mon, 21 Sep 2026 12:45:51 -0700
To: mm-commits@vger.kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch added to mm-new branch
Message-Id: <20260921194551.9AA7B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: drop dropbehind swap cache folios on writeback completion
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Mon, 21 Sep 2026 17:13:03 +0200

A PG_dropbehind folio is dropped from its cache once writeback completes
rather than left for reclaim to find later; this is implemented for file
folios in folio_end_dropbehind(). Extend it to swap cache folios.

The drop blocks on the folio lock, so it cannot run in interrupt
context. Set BIO_COMPLETE_IN_TASK on the write, as the file dropbehind
paths do, and drop the folio directly from folio_end_writeback().

It has to block rather than trylock: the folio is off the LRU, so
skipping it would leave it in the swap cache with nothing able to
reclaim it, and it cannot be put back while another thread holds its
lock.

Link: https://lore.kernel.org/20260921151306.625134-3-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chis Li <chrisl@kernel.org>
Cc: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/swap.h |    6 +++++
 mm/filemap.c         |   19 +++++++++++++++
 mm/page_io.c         |    9 +++++++
 mm/swap_state.c      |   42 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |   49 ++++++++++++++++++++++++++++++++---------
 5 files changed, 115 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion
+++ a/include/linux/swap.h
@@ -336,6 +336,9 @@ static inline bool lru_cache_disabled(vo
 
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 long remove_mapping(struct address_space *mapping, struct folio *folio);
+long remove_mapping_set_shadow(struct address_space *mapping,
+			       struct folio *folio,
+			       struct mem_cgroup *target_memcg);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
 extern int reclaim_register_node(struct node *node);
@@ -421,6 +424,8 @@ void swap_put_entries_direct(swp_entry_t
  */
 bool folio_free_swap(struct folio *folio);
 
+void swap_writeback_dropbehind_folio(struct folio *folio);
+
 /* Allocate / free (hibernation) exclusive entries */
 swp_entry_t swap_alloc_hibernation_slot(int type);
 void swap_free_hibernation_slot(swp_entry_t entry);
@@ -431,6 +436,7 @@ static inline void put_swap_device(struc
 }
 
 #else /* CONFIG_SWAP */
+static inline void swap_writeback_dropbehind_folio(struct folio *folio) {}
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
--- a/mm/filemap.c~mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion
+++ a/mm/filemap.c
@@ -1685,6 +1685,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool swap_dropbehind;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1694,7 +1696,24 @@ void folio_end_writeback(struct folio *f
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+
+	/*
+	 * Sample this before folio_end_writeback_no_dropbehind() clears
+	 * PG_writeback: until then a racing swapin cannot remove the folio from
+	 * the swap cache. Afterwards it can, and the drop below then finds a
+	 * non-swapcache folio and puts it back on the LRU instead. The
+	 * reference taken above keeps the folio alive across that window.
+	 */
+	swap_dropbehind = folio_test_swapcache(folio) &&
+			  folio_test_dropbehind(folio);
+
 	folio_end_writeback_no_dropbehind(folio);
+
+	if (swap_dropbehind) {
+		swap_writeback_dropbehind_folio(folio);
+		return;
+	}
+
 	folio_end_dropbehind(folio);
 	folio_put(folio);
 }
--- a/mm/page_io.c~mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion
+++ a/mm/page_io.c
@@ -608,6 +608,15 @@ static void swap_bdev_submit_write(struc
 		submit_bio_wait(bio);
 		end_swap_bio_write(bio);
 	} else {
+		int p;
+
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			if (folio_test_dropbehind(bvec_folio(&sio->bvecs[p]))) {
+				bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+				break;
+			}
+		}
+
 		bio->bi_end_io = end_swap_bio_write;
 		submit_bio(bio);
 	}
--- a/mm/swap_state.c~mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion
+++ a/mm/swap_state.c
@@ -551,6 +551,48 @@ struct folio *__swap_cache_alloc_folio(s
 	return ret;
 }
 
+/**
+ * swap_writeback_dropbehind_folio - drop a dropbehind swap cache folio
+ * @folio: the off-LRU folio whose writeback has completed
+ *
+ * Context: task context, with the reference taken by folio_end_writeback()
+ * donated to us.
+ */
+void swap_writeback_dropbehind_folio(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+
+	folio_lock(folio);
+
+	/* The folio was allocated off the LRU and nothing re-adds it here. */
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!mem_cgroup_tryget(memcg))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	/*
+	 * Gate remove_mapping_set_shadow() on folio_test_swapcache(): a racing
+	 * swapin may have freed the swap slot (folio_free_swap()) and dropped the
+	 * folio from the cache, and it must not run on a non-swapcache folio (it
+	 * would trip __remove_mapping()'s mapping == folio_mapping() check).
+	 */
+	if (!folio_test_swapcache(folio) || folio_test_writeback(folio) ||
+	    !remove_mapping_set_shadow(swap_address_space(folio->swap), folio,
+				       memcg)) {
+		/* Raced: the folio is now owned by the swapin; put it back. */
+		folio_clear_dropbehind(folio);
+		folio_add_lru(folio);
+	}
+
+	mem_cgroup_put(memcg);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 /*
  * If we are the only user, then try to free up the swap cache.
  *
--- a/mm/vmscan.c~mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion
+++ a/mm/vmscan.c
@@ -854,6 +854,22 @@ cannot_free:
 	return 0;
 }
 
+static long __remove_mapping_unfreeze(struct address_space *mapping,
+				      struct folio *folio, bool reclaimed,
+				      struct mem_cgroup *target_memcg)
+{
+	if (__remove_mapping(mapping, folio, reclaimed, target_memcg)) {
+		/*
+		 * Unfreezing the refcount with 1 effectively
+		 * drops the pagecache ref for us without requiring another
+		 * atomic operation.
+		 */
+		folio_ref_unfreeze(folio, 1);
+		return folio_nr_pages(folio);
+	}
+	return 0;
+}
+
 /**
  * remove_mapping() - Attempt to remove a folio from its mapping.
  * @mapping: The address space.
@@ -868,16 +884,29 @@ cannot_free:
  */
 long remove_mapping(struct address_space *mapping, struct folio *folio)
 {
-	if (__remove_mapping(mapping, folio, false, NULL)) {
-		/*
-		 * Unfreezing the refcount with 1 effectively
-		 * drops the pagecache ref for us without requiring another
-		 * atomic operation.
-		 */
-		folio_ref_unfreeze(folio, 1);
-		return folio_nr_pages(folio);
-	}
-	return 0;
+	return __remove_mapping_unfreeze(mapping, folio, false, NULL);
+}
+
+/**
+ * remove_mapping_set_shadow() - Remove a folio and record an eviction shadow.
+ * @mapping: The address space.
+ * @folio: The folio to remove.
+ * @target_memcg: The memcg to charge the eviction shadow to; the caller must
+ *                keep it alive across the call.
+ *
+ * Like remove_mapping(), but stores a workingset eviction shadow the way page
+ * reclaim does, so that a later refault can be detected and the folio
+ * re-activated.
+ * Return: The number of pages removed from the mapping.  0 if the folio
+ * could not be removed.
+ * Context: The caller should have a single refcount on the folio and
+ * hold its lock.
+ */
+long remove_mapping_set_shadow(struct address_space *mapping,
+			       struct folio *folio,
+			       struct mem_cgroup *target_memcg)
+{
+	return __remove_mapping_unfreeze(mapping, folio, true, target_memcg);
 }
 
 /**
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch
mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch
mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

