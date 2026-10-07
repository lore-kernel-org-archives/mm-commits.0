Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5002F3614
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334247; cv=none; b=Lz7xXfHJa3/KaiD26JpYZDFxfoqlUi5kI1RTJpPU1jTjSY8ObdV4+G6J7I/UenrtclqgUik5CchqKzZJLOGV3Rfi0G1w/4NvDH36gUn84pgkt6Ltf/B3PyLPP94NkluIl3Lzs9m2+tzbOJGEck8YYCYtIr8PuoRXAfPstLVyiuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334247; c=relaxed/simple;
	bh=SYZ2HCjBqI+PuUikT3co7yIyaj5GurcOaZD4z+RJbH4=;
	h=Date:To:From:Subject:Message-Id; b=Izxaf0REizam5l7wmtBz1cTkxXJdCbdvihnKKT+KMJ5w1vyHLg+/sooIoLTPMAlnKcnaaPNdw/PwpHmEndKRZrE8KSQbqXBlEk00SdwhOl9+GTY/ll3jAbEamUlbkxWvEoRAmzzqio7Ac2YaNNORPOnTT2g5zPj8DRu+gx22FKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g99owgVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g99owgVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D671F0089C;
	Wed,  7 Oct 2026 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334246;
	bh=WjDqpfg+dVLQleAxzvTIFiq1Q584euNuCALeuT4QINs=;
	h=Date:To:From:Subject;
	b=g99owgVj90jho0mOd3I9PfvYtuyMh52lnnzn79Sdwl3fqZpCC+cfcde1/08e+arvk
	 xJdZR2BLa/jx2Stcal9h9CLj/E7PG78BOFPyLPezmjNVO6ZjwKdekoRUDXh7vTwv4O
	 YeWxYZVhPB3ULrFGkS3y8WCwN0YV4AWIyPrzTMLk=
Date: Tue, 06 Oct 2026 17:50:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch removed from -mm tree
Message-Id: <20261007005045.E9D671F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: distinguish a malformed swap entry from a dying device
has been removed from the -mm tree.  Its filename was
     mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm, swap: distinguish a malformed swap entry from a dying device
Date: Tue, 18 Aug 2026 03:06:23 -0700

Patch series "mm, swap: don't spin on a bad swap entry", v3.

I've seen some machines at Meta fleet that show the following type of
problem:

1) It gets some weird warning:

  BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
  addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01

The corruption is most likely the collapse/PT_RECLAIM race fixed by commit
366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM under
per-vma lock").  But this series is not about this one.

2) Then the fault never makes progress. do_swap_page() returns 0 when
   get_swap_device() fails, so the fault is retried, reads the same
   entry and faults again. Nothing in the round trip changes the PTE,
   and the same line comes out on every pass:

  get_swap_device: Bad swap offset entry 3ffffffc043c5

Patch 1 makes get_swap_device() return ERR_PTR(-EIO) for a malformed
entry, keeping NULL for a device swapoff is taking away, and converts the
callers.  No functional change expected.

Patch 2 uses that to return VM_FAULT_SIGBUS instead of retrying.


This patch (of 2):

get_swap_device() returns NULL for two different things: an entry whose
type names no swap device or whose offset is past the end of one, and a
device that swapoff is taking away.  The first never becomes valid, the
second does, and callers cannot tell them apart.

Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
swapoff.  copy_nonpresent_pte() already reports -EIO for an entry whose
type names no device.

Callers bail out on failure either way, so switch them to
IS_ERR_OR_NULL(), and let the two paths that drop the reference skip an
error pointer.  No functional change.

Link: https://lore.kernel.org/20260818-swap-v3-0-d3fa52598a59@debian.org
Link: https://lore.kernel.org/20260818-swap-v3-1-d3fa52598a59@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c      |    6 +++---
 mm/mincore.c     |    2 +-
 mm/shmem.c       |    2 +-
 mm/swap_state.c  |    4 ++--
 mm/swapfile.c    |   15 ++++++++++-----
 mm/userfaultfd.c |    4 ++--
 mm/zswap.c       |    2 +-
 7 files changed, 20 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/memory.c
@@ -4956,9 +4956,9 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out;
 	}
 
-	/* Prevent swapoff from happening to us. */
+	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
-	if (unlikely(!si))
+	if (IS_ERR_OR_NULL(si))
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
@@ -5268,7 +5268,7 @@ unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	if (si)
+	if (!IS_ERR_OR_NULL(si))
 		put_swap_device(si);
 	return ret;
 out_nomap:
--- a/mm/mincore.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/mincore.c
@@ -71,7 +71,7 @@ static unsigned char mincore_swap(swp_en
 	 */
 	if (shmem) {
 		si = get_swap_device(entry);
-		if (!si)
+		if (IS_ERR_OR_NULL(si))
 			return 0;
 	}
 	folio = swap_cache_get_folio(entry);
--- a/mm/shmem.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/shmem.c
@@ -2481,7 +2481,7 @@ static int shmem_swapin_folio(struct ino
 
 	si = get_swap_device(index_entry);
 	order = shmem_confirm_swap(mapping, index, index_entry);
-	if (unlikely(!si)) {
+	if (IS_ERR_OR_NULL(si)) {
 		if (order < 0)
 			return -EEXIST;
 		else
--- a/mm/swapfile.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/swapfile.c
@@ -1504,7 +1504,7 @@ int swap_retry_table_alloc(swp_entry_t e
 	unsigned long offset = swp_offset(entry);
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
@@ -1859,7 +1859,10 @@ void folio_put_swap(struct folio *folio,
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
- * put_swap_device() is called.  Otherwise return NULL.
+ * put_swap_device() is called.  Return NULL for an empty entry or a
+ * device that is going away, and ERR_PTR(-EIO) if the entry's type
+ * names no swap device or its offset is past the end of one. These EIOs
+ * are preceded by pr_err().
  *
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
@@ -1900,12 +1903,14 @@ struct swap_info_struct *get_swap_device
 	return si;
 bad_nofile:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	return ERR_PTR(-EIO);
+
 out:
 	return NULL;
 put_out:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
-	return NULL;
+	return ERR_PTR(-EIO);
 }
 
 /*
@@ -2001,7 +2006,7 @@ int swp_swapcount(swp_entry_t entry)
 	int count;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = swap_cluster_lock(si, swp_offset(entry));
@@ -2127,7 +2132,7 @@ void swap_put_entries_direct(swp_entry_t
 	struct swap_info_struct *si;
 
 	si = get_swap_device(entry);
-	if (WARN_ON_ONCE(!si))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(si)))
 		return;
 	if (WARN_ON_ONCE(end_offset > si->max))
 		goto out;
--- a/mm/swap_state.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/swap_state.c
@@ -716,7 +716,7 @@ struct folio *read_swap_cache_async(stru
 	struct folio *folio;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
@@ -952,7 +952,7 @@ static struct folio *swap_vma_readahead(
 		 */
 		if (swp_type(entry) != swp_type(targ_entry)) {
 			si = get_swap_device(entry);
-			if (!si)
+			if (IS_ERR_OR_NULL(si))
 				continue;
 		}
 		folio = swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
--- a/mm/userfaultfd.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/userfaultfd.c
@@ -1700,7 +1700,7 @@ retry:
 		}
 
 		si = get_swap_device(entry);
-		if (unlikely(!si)) {
+		if (IS_ERR_OR_NULL(si)) {
 			ret = -EAGAIN;
 			goto out;
 		}
@@ -1757,7 +1757,7 @@ out:
 	if (dst_pte)
 		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
-	if (si)
+	if (!IS_ERR_OR_NULL(si))
 		put_swap_device(si);
 
 	return ret;
--- a/mm/zswap.c~mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device
+++ a/mm/zswap.c
@@ -984,7 +984,7 @@ static int zswap_writeback_entry(struct
 
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
_

Patches currently in -mm which might be from leitao@debian.org are

documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch
mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch
mm-kmemleak-move-the-struct-page-scan-into-a-helper.patch
mm-kmemleak-scan-the-struct-page-array-in-max_scan_size-batches.patch

