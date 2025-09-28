Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7980259C87
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085546; cv=none; b=JEJi6pqUO6+NdqyB0CyLBXPxfPL298TopMwj4bvqHcUVL9xH2Fl92XHyEkwH/cYyzAGYCFoycwy50WIvGMfVwAA8cJDykycgTE/0l7vD8nqcqErhnzwaIMC+ZCwXplR6vo8ivCf2EcZKEa4/aof3NnPlSZjcsa5HRSuA98j09yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085546; c=relaxed/simple;
	bh=f6orpeERc5IF1WbSZ1gGNyfi3vEZc/RL6sjxBL1MsGo=;
	h=Date:To:From:Subject:Message-Id; b=ZY9Qn7AdLHGdROxo+vOs4z4jOkP7DJAUHny83LtFlxQHvSyLG4y0tUynUsqaS2UZnUc287xrAl9YVnDlcTZoAIcDu60mXyousuHCumxYRFbBHKZXGg4SyDNpLxi1e6KdJSOwK10BZFDXyMaVHBDDJo+iD1UgK9vyqXs8eug2gTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rzr7cjAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rzr7cjAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D44AC4CEF0;
	Sun, 28 Sep 2025 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085546;
	bh=f6orpeERc5IF1WbSZ1gGNyfi3vEZc/RL6sjxBL1MsGo=;
	h=Date:To:From:Subject:From;
	b=Rzr7cjAhn4LFF6MXvrDirlOvqkN0ncus/6XbNRLIMOSnX2vcLSlahj6azn/nSaUFG
	 5GcHb2ne8ZINdghvao30rE3+ZJzW2Wd6kTWjYdrXwNmwuW1iEXiu76MG6HGgTc3m9w
	 /rrIInjQ8d9ZHO9OVcBqOb7yay3VPGIX2YXOGczE=
Date: Sun, 28 Sep 2025 11:52:25 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch removed from -mm tree
Message-Id: <20250928185226.1D44AC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove definition of struct khugepaged_mm_slot
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Fri, 19 Sep 2025 07:12:44 +0000

Current code is not correct to get struct khugepaged_mm_slot by
mm_slot_entry() without checking mm_slot is !NULL.  There is no problem
reported since slot is the first element of struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not chance
to miss use mm_slot_entry().

[richard.weiyang@gmail.com: fix use-after-free crash]
  Link: https://lkml.kernel.org/r/20250922002834.vz6ntj36e75ehkyp@master
Link: https://lkml.kernel.org/r/20250919071244.17020-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   58 ++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot
+++ a/mm/khugepaged.c
@@ -104,14 +104,6 @@ struct collapse_control {
 };
 
 /**
- * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
- * @slot: hash lookup from mm to mm_slot
- */
-struct khugepaged_mm_slot {
-	struct mm_slot slot;
-};
-
-/**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
  * @mm_slot: the current mm_slot we are scanning
@@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *mm_slot;
 	unsigned long address;
 };
 
@@ -384,7 +376,10 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
+	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
+					  sizeof(struct mm_slot),
+					  __alignof__(struct mm_slot),
+					  0, NULL);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -438,7 +433,6 @@ static bool hugepage_pmd_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
@@ -447,12 +441,10 @@ void __khugepaged_enter(struct mm_struct
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
-	mm_slot = mm_slot_alloc(mm_slot_cache);
-	if (!mm_slot)
+	slot = mm_slot_alloc(mm_slot_cache);
+	if (!slot)
 		return;
 
-	slot = &mm_slot->slot;
-
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
@@ -480,14 +472,12 @@ void khugepaged_enter_vma(struct vm_area
 
 void __khugepaged_exit(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
+	if (slot && khugepaged_scan.mm_slot != slot) {
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 		free = 1;
@@ -496,9 +486,9 @@ void __khugepaged_exit(struct mm_struct
 
 	if (free) {
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
-	} else if (mm_slot) {
+	} else if (slot) {
 		/*
 		 * This is required to serialize against
 		 * hpage_collapse_test_exit() (which is guaranteed to run
@@ -1432,9 +1422,8 @@ out:
 	return result;
 }
 
-static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
+static void collect_mm_slot(struct mm_slot *slot)
 {
-	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1451,7 +1440,7 @@ static void collect_mm_slot(struct khuge
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
 	}
 }
@@ -2394,7 +2383,6 @@ static unsigned int khugepaged_scan_mm_s
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2405,14 +2393,12 @@ static unsigned int khugepaged_scan_mm_s
 	*result = SCAN_FAIL;
 
 	if (khugepaged_scan.mm_slot) {
-		mm_slot = khugepaged_scan.mm_slot;
-		slot = &mm_slot->slot;
+		slot = khugepaged_scan.mm_slot;
 	} else {
 		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
-		khugepaged_scan.mm_slot = mm_slot;
+		khugepaged_scan.mm_slot = slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
@@ -2510,7 +2496,7 @@ breakouterloop:
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
@@ -2522,16 +2508,14 @@ breakouterloop_mmap_lock:
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot =
-				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(mm_slot);
+		collect_mm_slot(slot);
 	}
 
 	return progress;
@@ -2618,7 +2602,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -2629,10 +2613,10 @@ static int khugepaged(void *none)
 	}
 
 	spin_lock(&khugepaged_mm_lock);
-	mm_slot = khugepaged_scan.mm_slot;
+	slot = khugepaged_scan.mm_slot;
 	khugepaged_scan.mm_slot = NULL;
-	if (mm_slot)
-		collect_mm_slot(mm_slot);
+	if (slot)
+		collect_mm_slot(slot);
 	spin_unlock(&khugepaged_mm_lock);
 	return 0;
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


