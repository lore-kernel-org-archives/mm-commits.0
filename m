Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880ED1A6828
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788047935; cv=none; b=iDEbqo4Bzx5zkRqZTdNEuRHPr3ezmeKOwfw6Ije110uOzyUlsGQswmxUJas8c6f1J8IwitolX2GPqhdV6Ktpx6fz3/Ta744iyBcifVUJ038AaQg4IIoxcpDMPS+taeWPafrETg/bO2fcQNxBIK8eKajygRo+XvD7niR5ElvjnNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788047935; c=relaxed/simple;
	bh=QJrgzMMOHeDc8Iuw+DOcYvXngzLzxjYbCMFjO+CyUz0=;
	h=Date:To:From:Subject:Message-Id; b=PIyj8kJo7x8GuC488SXf0G9VE8DFg6PIi8jKZ184Z6ZtfmNxymBZ2WHAOPAJt8XrWsxHA+0hXw/+eIuWMQLoqRx9qhjQb9GkqgtDPDcREbU/SmbKTf25airegNj8BMWHAozNmx4Ipi7q0rA6fPEuA2ySLaZkKXdYZ3kD4I9PbVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbendJXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbendJXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D191F000E9;
	Sat, 29 Aug 2026 23:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788047932;
	bh=ozrFj2iSsi3fL+A5liqfl6Gsdlu3NYDgnRsrL0jbTHo=;
	h=Date:To:From:Subject;
	b=vbendJXmbbZBQt8FGtRql7jGVfSzynn0Tv+S422kHybufyQk4K9G9y0TyK8lBjsLu
	 9fqfb70LSSpWfivvvunuoApmQNtQbDHGhdFPhB8SVwSWhgrtnwFEh1kG2lQAuDQkkk
	 37DYW743ftqyfgBihP+/gZt3mIok9BPyEn8rscbQ=
Date: Sat, 29 Aug 2026 16:58:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch added to mm-new branch
Message-Id: <20260829235852.D5D191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: distinguish a malformed swap entry from a dying device
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c      |    6 +++---
 mm/mincore.c     |    2 +-
 mm/shmem.c       |    2 +-
 mm/swap_state.c  |    4 ++--
 mm/swapfile.c    |   11 +++++++----
 mm/userfaultfd.c |    4 ++--
 mm/zswap.c       |    2 +-
 7 files changed, 17 insertions(+), 14 deletions(-)

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
@@ -2478,7 +2478,7 @@ static int shmem_swapin_folio(struct ino
 
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
@@ -2001,7 +2004,7 @@ int swp_swapcount(swp_entry_t entry)
 	int count;
 
 	si = get_swap_device(entry);
-	if (!si)
+	if (IS_ERR_OR_NULL(si))
 		return 0;
 
 	ci = swap_cluster_lock(si, swp_offset(entry));
@@ -2127,7 +2130,7 @@ void swap_put_entries_direct(swp_entry_t
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

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch

