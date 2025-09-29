Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778B31F09B3
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759184360; cv=none; b=uwDOnyVuHQMWVbOn0I18wnCFxxFe2sNIwo5+xBu/qyjn6nk0XN975r816j78wBhPt+f3G3Dyzm40tJU8m7U+MnOUpRArCjT1uRVET9j0tW8k9c5dmin8R8mNXTQxsau5tV5eco9MqtBqJtEOxN/63bSLcfKRfiRwALgl4guoHY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759184360; c=relaxed/simple;
	bh=acnmyRMN0JQQTxONsXpGvDgULIRx8GNmsAR5OeyjB8U=;
	h=Date:To:From:Subject:Message-Id; b=Zt8k9zPm+QvmVcyTKP6ryR7pfMgi+2TTUlWhUju1OlvuDBU2V9b7fQL9GxrJBq9nDS1d5qIVnsSVBzCsPu/c7J66cI8CPNwnI/FIxiXaoVAkRgm5QMh7d7WLCCUpJbJjigwAXyGPMVTwcoeGPv7oFoFBouNKZhPTrB7cipCU4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yk9CKItQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yk9CKItQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8FCC116B1;
	Mon, 29 Sep 2025 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759184359;
	bh=acnmyRMN0JQQTxONsXpGvDgULIRx8GNmsAR5OeyjB8U=;
	h=Date:To:From:Subject:From;
	b=Yk9CKItQAzzYavvXuCGGJfMMki/K9L7EEjjnC6SDpthl5LGF2n4GfEDJUliyQzRff
	 AeuwozVtiyg/hDg/GL3ERdPFX4Z3EKb5Fg/G4lcHzR3rGtCXnpBK+znwO9m2fHdL0v
	 en7+XkzZxc/tj55X6GuSNKzpxp2KlmoLlufNtV3k=
Date: Mon, 29 Sep 2025 15:19:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,usama.anjum@collabora.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,kas@kernel.org,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch added to mm-unstable branch
Message-Id: <20250929221919.CE8FCC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove definition of struct khugepaged_mm_slot
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Sat, 27 Sep 2025 00:45:39 +0000

Current code calls mm_slot_entry() even when we don't have a valid slot,
which is not future proof. Currently, this is not a problem because
"slot" is the first member in struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not chance
to miss use mm_slot_entry().

Link: https://lkml.kernel.org/r/20250927004539.19308-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   55 +++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 37 deletions(-)

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
 
@@ -384,7 +376,7 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -438,7 +430,6 @@ static bool hugepage_pmd_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
@@ -447,12 +438,10 @@ void __khugepaged_enter(struct mm_struct
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
@@ -480,14 +469,12 @@ void khugepaged_enter_vma(struct vm_area
 
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
@@ -496,9 +483,9 @@ void __khugepaged_exit(struct mm_struct
 
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
@@ -1432,9 +1419,8 @@ out:
 	return result;
 }
 
-static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
+static void collect_mm_slot(struct mm_slot *slot)
 {
-	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1451,7 +1437,7 @@ static void collect_mm_slot(struct khuge
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
 	}
 }
@@ -2394,7 +2380,6 @@ static unsigned int khugepaged_scan_mm_s
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2405,14 +2390,12 @@ static unsigned int khugepaged_scan_mm_s
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
 
@@ -2510,7 +2493,7 @@ breakouterloop:
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
@@ -2522,16 +2505,14 @@ breakouterloop_mmap_lock:
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
@@ -2618,7 +2599,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -2629,10 +2610,10 @@ static int khugepaged(void *none)
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

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch

