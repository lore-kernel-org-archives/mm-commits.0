Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831BA155327
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663345; cv=none; b=aQR6OPjAIKVVFgE3TsXyN4Fv5EfqM9bgdM5H4UKlKlkvok3mVES3h34mouZDCFW0vL5KzXZh1U5t0eJ8kirEtNFeqeFtmJOD2FQ0qOpzKbmftxFrTPDTp+lUZwH2mnYR3+HSHsQppldZClYsj8mKerdA8ZsO6BAWauiepN5satg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663345; c=relaxed/simple;
	bh=2WRKGBWRlQN1Kgojf08G+j2sStXBWdyKWvAA9HgPu6Y=;
	h=Date:To:From:Subject:Message-Id; b=lt6abNMtpUMF640EiE4qM3Pq7erW7SYh6lkcndyFwj7ymTLJact/qhVJDZycuYhgMY1BMPManVo9vlqpMb3yhUa4oizdnLkSuaEBGOFGp8WVuYX0O5SMYbx1AxtqVezmm3bhXpN49PR14v7kQ8OGyLypFKHLKEgm43W+hx7/xwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecG2OXcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecG2OXcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB17AC113CC;
	Thu,  2 May 2024 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663344;
	bh=2WRKGBWRlQN1Kgojf08G+j2sStXBWdyKWvAA9HgPu6Y=;
	h=Date:To:From:Subject:From;
	b=ecG2OXcdy+FYKZseAqkshxqGSSvsUSp4p9w+UDnVU8viG00u0rEW1jvPwK868KPf2
	 4Ipf5iTjYWeKlow1PY2YIj6njMyGnm1B91j4CbCC9CbcZ9FDNye4BwdHECzqGzkTgn
	 fLpS9AjITHaX6/6YMnX1YwSkbB/aLWcMkhhi/s88=
Date: Thu, 02 May 2024 08:22:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-ksm-rename-mm_slot-members-to-ksm_slot-for-better-readability.patch removed from -mm tree
Message-Id: <20240502152223.DB17AC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: rename mm_slot members to ksm_slot for better readability
has been removed from the -mm tree.  Its filename was
     mm-ksm-rename-mm_slot-members-to-ksm_slot-for-better-readability.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: rename mm_slot members to ksm_slot for better readability
Date: Sun, 28 Apr 2024 18:06:15 +0800

mm_slot is a struct of mm, and ksm_mm_slot is named the same again in
ksm_scan struct.  Furthermore, the ksm_mm_slot pointer is named as mm_slot
again in functions, beside with 'struct mm_slot' variable.  That makes
code readability pretty worse.

struct ksm_mm_slot {
        struct mm_slot slot;
	...
};

struct ksm_scan {
        struct ksm_mm_slot *mm_slot;
	...
};

int __ksm_enter(struct mm_struct *mm)
{
        struct ksm_mm_slot *mm_slot;
        struct mm_slot *slot;
	...

So let's rename the mm_slot member to ksm_slot in ksm_scan, and ksm_slot
for ksm_mm_slot* type variables in functions to reduce this confusing.

 struct ksm_scan {
-       struct ksm_mm_slot *mm_slot;
+       struct ksm_mm_slot *ksm_slot;

Link: https://lkml.kernel.org/r/20240428100619.3332036-1-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   84 ++++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-mm_slot-members-to-ksm_slot-for-better-readability
+++ a/mm/ksm.c
@@ -131,7 +131,7 @@ struct ksm_mm_slot {
 
 /**
  * struct ksm_scan - cursor for scanning
- * @mm_slot: the current mm_slot we are scanning
+ * @ksm_slot: the current ksm_slot we are scanning
  * @address: the next address inside that to be scanned
  * @rmap_list: link to the next rmap to be scanned in the rmap_list
  * @seqnr: count of completed full scans (needed when removing unstable node)
@@ -139,7 +139,7 @@ struct ksm_mm_slot {
  * There is only the one ksm_scan instance of this cursor structure.
  */
 struct ksm_scan {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *ksm_slot;
 	unsigned long address;
 	struct ksm_rmap_item **rmap_list;
 	unsigned long seqnr;
@@ -187,7 +187,7 @@ struct ksm_stable_node {
 
 /**
  * struct ksm_rmap_item - reverse mapping item for virtual addresses
- * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
+ * @rmap_list: next rmap_item in ksm_slot's singly-linked rmap_list
  * @anon_vma: pointer to anon_vma for this mm,address, when in stable tree
  * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @mm: the memory structure this rmap_item is pointing into
@@ -242,7 +242,7 @@ static struct ksm_mm_slot ksm_mm_head =
 	.slot.mm_node = LIST_HEAD_INIT(ksm_mm_head.slot.mm_node),
 };
 static struct ksm_scan ksm_scan = {
-	.mm_slot = &ksm_mm_head,
+	.ksm_slot = &ksm_mm_head,
 };
 
 static struct kmem_cache *rmap_item_cache;
@@ -1205,11 +1205,11 @@ static int unmerge_and_remove_all_rmap_i
 	spin_lock(&ksm_mmlist_lock);
 	slot = list_entry(ksm_mm_head.slot.mm_node.next,
 			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	ksm_scan.ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 	spin_unlock(&ksm_mmlist_lock);
 
-	for (mm_slot = ksm_scan.mm_slot; mm_slot != &ksm_mm_head;
-	     mm_slot = ksm_scan.mm_slot) {
+	for (mm_slot = ksm_scan.ksm_slot; mm_slot != &ksm_mm_head;
+	     mm_slot = ksm_scan.ksm_slot) {
 		VMA_ITERATOR(vmi, mm_slot->slot.mm, 0);
 
 		mm = mm_slot->slot.mm;
@@ -1238,7 +1238,7 @@ mm_exiting:
 		spin_lock(&ksm_mmlist_lock);
 		slot = list_entry(mm_slot->slot.mm_node.next,
 				  struct mm_slot, mm_node);
-		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		ksm_scan.ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 		if (ksm_test_exit(mm)) {
 			hash_del(&mm_slot->slot.hash);
 			list_del(&mm_slot->slot.mm_node);
@@ -1260,7 +1260,7 @@ mm_exiting:
 error:
 	mmap_read_unlock(mm);
 	spin_lock(&ksm_mmlist_lock);
-	ksm_scan.mm_slot = &ksm_mm_head;
+	ksm_scan.ksm_slot = &ksm_mm_head;
 	spin_unlock(&ksm_mmlist_lock);
 	return err;
 }
@@ -2568,7 +2568,7 @@ static bool should_skip_rmap_item(struct
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *ksm_slot;
 	struct mm_slot *slot;
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
@@ -2578,8 +2578,8 @@ static struct ksm_rmap_item *scan_get_ne
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
 
-	mm_slot = ksm_scan.mm_slot;
-	if (mm_slot == &ksm_mm_head) {
+	ksm_slot = ksm_scan.ksm_slot;
+	if (ksm_slot == &ksm_mm_head) {
 		advisor_start_scan();
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
@@ -2619,23 +2619,23 @@ static struct ksm_rmap_item *scan_get_ne
 			root_unstable_tree[nid] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
+		slot = list_entry(ksm_slot->slot.mm_node.next,
 				  struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		ksm_scan.mm_slot = mm_slot;
+		ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		ksm_scan.ksm_slot = ksm_slot;
 		spin_unlock(&ksm_mmlist_lock);
 		/*
 		 * Although we tested list_empty() above, a racing __ksm_exit
 		 * of the last mm on the list may have removed it since then.
 		 */
-		if (mm_slot == &ksm_mm_head)
+		if (ksm_slot == &ksm_mm_head)
 			return NULL;
 next_mm:
 		ksm_scan.address = 0;
-		ksm_scan.rmap_list = &mm_slot->rmap_list;
+		ksm_scan.rmap_list = &ksm_slot->rmap_list;
 	}
 
-	slot = &mm_slot->slot;
+	slot = &ksm_slot->slot;
 	mm = slot->mm;
 	vma_iter_init(&vmi, mm, ksm_scan.address);
 
@@ -2665,7 +2665,7 @@ next_mm:
 			if (PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
-				rmap_item = get_next_rmap_item(mm_slot,
+				rmap_item = get_next_rmap_item(ksm_slot,
 					ksm_scan.rmap_list, ksm_scan.address);
 				if (rmap_item) {
 					ksm_scan.rmap_list =
@@ -2690,7 +2690,7 @@ next_page:
 	if (ksm_test_exit(mm)) {
 no_vmas:
 		ksm_scan.address = 0;
-		ksm_scan.rmap_list = &mm_slot->rmap_list;
+		ksm_scan.rmap_list = &ksm_slot->rmap_list;
 	}
 	/*
 	 * Nuke all the rmap_items that are above this current rmap:
@@ -2699,9 +2699,9 @@ no_vmas:
 	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(mm_slot->slot.mm_node.next,
+	slot = list_entry(ksm_slot->slot.mm_node.next,
 			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	ksm_scan.ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 	if (ksm_scan.address == 0) {
 		/*
 		 * We've completed a full scan of all vmas, holding mmap_lock
@@ -2712,11 +2712,11 @@ no_vmas:
 		 * or when all VM_MERGEABLE areas have been unmapped (and
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
-		hash_del(&mm_slot->slot.hash);
-		list_del(&mm_slot->slot.mm_node);
+		hash_del(&ksm_slot->slot.hash);
+		list_del(&ksm_slot->slot.mm_node);
 		spin_unlock(&ksm_mmlist_lock);
 
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, ksm_slot);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 		clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 		mmap_read_unlock(mm);
@@ -2728,14 +2728,14 @@ no_vmas:
 		 * spin_unlock(&ksm_mmlist_lock) run, the "mm" may
 		 * already have been freed under us by __ksm_exit()
 		 * because the "mm_slot" is still hashed and
-		 * ksm_scan.mm_slot doesn't point to it anymore.
+		 * ksm_scan.ksm_slot doesn't point to it anymore.
 		 */
 		spin_unlock(&ksm_mmlist_lock);
 	}
 
 	/* Repeat until we've completed scanning the whole list */
-	mm_slot = ksm_scan.mm_slot;
-	if (mm_slot != &ksm_mm_head)
+	ksm_slot = ksm_scan.ksm_slot;
+	if (ksm_slot != &ksm_mm_head)
 		goto next_mm;
 
 	advisor_stop_scan();
@@ -2971,15 +2971,15 @@ EXPORT_SYMBOL_GPL(ksm_madvise);
 
 int __ksm_enter(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *ksm_slot;
 	struct mm_slot *slot;
 	int needs_wakeup;
 
-	mm_slot = mm_slot_alloc(mm_slot_cache);
-	if (!mm_slot)
+	ksm_slot = mm_slot_alloc(mm_slot_cache);
+	if (!ksm_slot)
 		return -ENOMEM;
 
-	slot = &mm_slot->slot;
+	slot = &ksm_slot->slot;
 
 	/* Check ksm_run too?  Would need tighter locking */
 	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
@@ -2999,7 +2999,7 @@ int __ksm_enter(struct mm_struct *mm)
 	if (ksm_run & KSM_RUN_UNMERGE)
 		list_add_tail(&slot->mm_node, &ksm_mm_head.slot.mm_node);
 	else
-		list_add_tail(&slot->mm_node, &ksm_scan.mm_slot->slot.mm_node);
+		list_add_tail(&slot->mm_node, &ksm_scan.ksm_slot->slot.mm_node);
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
@@ -3014,40 +3014,40 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *ksm_slot;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
 	/*
 	 * This process is exiting: if it's straightforward (as is the
-	 * case when ksmd was never running), free mm_slot immediately.
+	 * case when ksmd was never running), free ksm_slot immediately.
 	 * But if it's at the cursor or has rmap_items linked to it, use
 	 * mmap_lock to synchronize with any break_cows before pagetables
-	 * are freed, and leave the mm_slot on the list for ksmd to free.
+	 * are freed, and leave the ksm_slot on the list for ksmd to free.
 	 * Beware: ksm may already have noticed it exiting and freed the slot.
 	 */
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
+	ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	if (ksm_slot && ksm_scan.ksm_slot != ksm_slot) {
+		if (!ksm_slot->rmap_list) {
 			hash_del(&slot->hash);
 			list_del(&slot->mm_node);
 			easy_to_free = 1;
 		} else {
 			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
+				  &ksm_scan.ksm_slot->slot.mm_node);
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, ksm_slot);
 		clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 		mmdrop(mm);
-	} else if (mm_slot) {
+	} else if (ksm_slot) {
 		mmap_write_lock(mm);
 		mmap_write_unlock(mm);
 	}
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch
mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch
mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch
mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

