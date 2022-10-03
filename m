Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648DDC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJCVEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJCVEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482144BD2B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14C2B815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AD8C433C1;
        Mon,  3 Oct 2022 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831069;
        bh=XkguODw+IBe1n6JJKCS/aO/LaI+uV7SSdsh2uwRlJJQ=;
        h=Date:To:From:Subject:From;
        b=PmTFS3D7+tbq61yZQ7ONfDYHHkAo4MA4jfg4CfJZpVoCcOoVWWgSeQA47rl9DCQjX
         /n0WQu13l8yxbfr/TuKwjEq/1U5CVYO3bIYoFxn0pkq6Mo092ypLPh8qSIxuLNRm+G
         dF5w8ZkYc8mNDUdmJORLINiGtXB268S9pWFP9Itg=
Date:   Mon, 03 Oct 2022 14:04:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-convert-to-use-common-struct-mm_slot.patch removed from -mm tree
Message-Id: <20221003210429.95AD8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: convert to use common struct mm_slot
has been removed from the -mm tree.  Its filename was
     mm-thp-convert-to-use-common-struct-mm_slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: convert to use common struct mm_slot
Date: Wed, 31 Aug 2022 11:19:46 +0800

Rename private struct mm_slot to struct khugepaged_mm_slot and convert to
use common struct mm_slot with no functional change.

[zhengqi.arch@bytedance.com: fix build error with CONFIG_SHMEM disabled]
  Link: https://lkml.kernel.org/r/639fa8d5-8e5b-2333-69dc-40ed46219364@bytedance.com
Link: https://lkml.kernel.org/r/20220831031951.43152-3-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  123 +++++++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 71 deletions(-)

--- a/mm/khugepaged.c~mm-thp-convert-to-use-common-struct-mm_slot
+++ a/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
+#include "mm_slot.h"
 
 enum scan_result {
 	SCAN_FAIL,
@@ -99,17 +100,13 @@ struct collapse_control {
 };
 
 /**
- * struct mm_slot - hash lookup from mm to mm_slot
- * @hash: hash collision list
- * @mm_node: khugepaged scan list headed in khugepaged_scan.mm_head
- * @mm: the mm that this information is valid for
+ * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
+ * @slot: hash lookup from mm to mm_slot
  * @nr_pte_mapped_thp: number of pte mapped THP
  * @pte_mapped_thp: address array corresponding pte mapped THP
  */
-struct mm_slot {
-	struct hlist_node hash;
-	struct list_head mm_node;
-	struct mm_struct *mm;
+struct khugepaged_mm_slot {
+	struct mm_slot slot;
 
 	/* pte-mapped THP in this mm */
 	int nr_pte_mapped_thp;
@@ -126,7 +123,7 @@ struct mm_slot {
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
 	unsigned long address;
 };
 
@@ -390,8 +387,9 @@ int hugepage_madvise(struct vm_area_stru
 int __init khugepaged_init(void)
 {
 	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct mm_slot),
-					  __alignof__(struct mm_slot), 0, NULL);
+					  sizeof(struct khugepaged_mm_slot),
+					  __alignof__(struct khugepaged_mm_slot),
+					  0, NULL);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -408,36 +406,6 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline struct mm_slot *alloc_mm_slot(void)
-{
-	if (!mm_slot_cache)	/* initialization failed */
-		return NULL;
-	return kmem_cache_zalloc(mm_slot_cache, GFP_KERNEL);
-}
-
-static inline void free_mm_slot(struct mm_slot *mm_slot)
-{
-	kmem_cache_free(mm_slot_cache, mm_slot);
-}
-
-static struct mm_slot *get_mm_slot(struct mm_struct *mm)
-{
-	struct mm_slot *mm_slot;
-
-	hash_for_each_possible(mm_slots_hash, mm_slot, hash, (unsigned long)mm)
-		if (mm == mm_slot->mm)
-			return mm_slot;
-
-	return NULL;
-}
-
-static void insert_to_mm_slots_hash(struct mm_struct *mm,
-				    struct mm_slot *mm_slot)
-{
-	mm_slot->mm = mm;
-	hash_add(mm_slots_hash, &mm_slot->hash, (long)mm);
-}
-
 static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
@@ -445,28 +413,31 @@ static inline int hpage_collapse_test_ex
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 	int wakeup;
 
-	mm_slot = alloc_mm_slot();
+	mm_slot = mm_slot_alloc(mm_slot_cache);
 	if (!mm_slot)
 		return;
 
+	slot = &mm_slot->slot;
+
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
-		free_mm_slot(mm_slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		return;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
-	insert_to_mm_slots_hash(mm, mm_slot);
+	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
 	 * Insert just behind the scanning cursor, to let the area settle
 	 * down a little.
 	 */
 	wakeup = list_empty(&khugepaged_scan.mm_head);
-	list_add_tail(&mm_slot->mm_node, &khugepaged_scan.mm_head);
+	list_add_tail(&slot->mm_node, &khugepaged_scan.mm_head);
 	spin_unlock(&khugepaged_mm_lock);
 
 	mmgrab(mm);
@@ -486,21 +457,23 @@ void khugepaged_enter_vma(struct vm_area
 
 void __khugepaged_exit(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
-	mm_slot = get_mm_slot(mm);
+	slot = mm_slot_lookup(mm_slots_hash, mm);
+	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
-		hash_del(&mm_slot->hash);
-		list_del(&mm_slot->mm_node);
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
 		free = 1;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
 	if (free) {
 		clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
-		free_mm_slot(mm_slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
 	} else if (mm_slot) {
 		/*
@@ -1318,16 +1291,17 @@ out:
 	return result;
 }
 
-static void collect_mm_slot(struct mm_slot *mm_slot)
+static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 {
-	struct mm_struct *mm = mm_slot->mm;
+	struct mm_slot *slot = &mm_slot->slot;
+	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
 	if (hpage_collapse_test_exit(mm)) {
 		/* free mm_slot */
-		hash_del(&mm_slot->hash);
-		list_del(&mm_slot->mm_node);
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
 
 		/*
 		 * Not strictly needed because the mm exited already.
@@ -1336,7 +1310,7 @@ static void collect_mm_slot(struct mm_sl
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		free_mm_slot(mm_slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
 	}
 }
@@ -1349,12 +1323,14 @@ static void collect_mm_slot(struct mm_sl
 static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
 					  unsigned long addr)
 {
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
 
 	spin_lock(&khugepaged_mm_lock);
-	mm_slot = get_mm_slot(mm);
+	slot = mm_slot_lookup(mm_slots_hash, mm);
+	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 	if (likely(mm_slot && mm_slot->nr_pte_mapped_thp < MAX_PTE_MAPPED_THP))
 		mm_slot->pte_mapped_thp[mm_slot->nr_pte_mapped_thp++] = addr;
 	spin_unlock(&khugepaged_mm_lock);
@@ -1486,9 +1462,10 @@ abort:
 	goto drop_hpage;
 }
 
-static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
 {
-	struct mm_struct *mm = mm_slot->mm;
+	struct mm_slot *slot = &mm_slot->slot;
+	struct mm_struct *mm = slot->mm;
 	int i;
 
 	if (likely(mm_slot->nr_pte_mapped_thp == 0))
@@ -2040,7 +2017,7 @@ static int khugepaged_scan_file(struct m
 	BUILD_BUG();
 }
 
-static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
 {
 }
 #endif
@@ -2051,7 +2028,8 @@ static unsigned int khugepaged_scan_mm_s
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	int progress = 0;
@@ -2060,18 +2038,20 @@ static unsigned int khugepaged_scan_mm_s
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
 
-	if (khugepaged_scan.mm_slot)
+	if (khugepaged_scan.mm_slot) {
 		mm_slot = khugepaged_scan.mm_slot;
-	else {
-		mm_slot = list_entry(khugepaged_scan.mm_head.next,
+		slot = &mm_slot->slot;
+	} else {
+		slot = list_entry(khugepaged_scan.mm_head.next,
 				     struct mm_slot, mm_node);
+		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
 		khugepaged_scan.mm_slot = mm_slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 	khugepaged_collapse_pte_mapped_thps(mm_slot);
 
-	mm = mm_slot->mm;
+	mm = slot->mm;
 	/*
 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
 	 * the next mm on the list.
@@ -2166,10 +2146,11 @@ breakouterloop_mmap_lock:
 		 * khugepaged runs here, khugepaged_exit will find
 		 * mm_slot not pointing to the exiting mm.
 		 */
-		if (mm_slot->mm_node.next != &khugepaged_scan.mm_head) {
-			khugepaged_scan.mm_slot = list_entry(
-				mm_slot->mm_node.next,
-				struct mm_slot, mm_node);
+		if (slot->mm_node.next != &khugepaged_scan.mm_head) {
+			slot = list_entry(slot->mm_node.next,
+					  struct mm_slot, mm_node);
+			khugepaged_scan.mm_slot =
+				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
@@ -2264,7 +2245,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch

