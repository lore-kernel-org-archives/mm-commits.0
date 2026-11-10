Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336366;
	b=Rq61khE45R39+xKce4AqWo6q+vp4abyN5vSSelpZv4VJGT1XamTPtnm5Vuj9rk5B86el
	 hZIIlrH6w5sba85+V6hw8CPXnD1XwIfrNrVupC04eYi3FXxlYLLU8hNMnDCfN1Sn/1hKC
	 HSkrHF6+3G218iUISTVayGIuC9MZ2Cdxi6/S+THFIiS3sZqeX7gOr+/R5EzKg+l4A0FSS
	 fG4lx6ynRycajh5bL6Uf1jx/WqvN5NNT+oMTC2Nqt5VBYsTNRSxg95WAvit6Y3JIhS+6H
	 2BcPhKdIrdZjDW1qtXeG6sju8VncBi7COaUpKWfYn2cAdD+/cOn8Dp6rdOLpJC46vNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336366;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PYVYPT8TNN0lw+vu97Pku2OCeG9Ksh7POBpvJjQ8V9A=;
	b=xSnShG/4a2CmgGfJuvqSjOiiu2fn/LPu52w3slL4MJXhrJoWhUPbx+Rf2zDXDpnAVmZi
	 NbwIUCh0M0xsutv5hR6sRwSba5GhQgQ0U6gIXoXwLDki4Fs/YijuYpLLmfBak2BXPxbYS
	 r2dq74CzDjB2HeoaJ87R4psMDzitwEn1ESGVfWBJF/7vzopZPz9NvJZLlP/IltzhG1gut
	 y898fwFmGdGe4sa0yP0UD2f3646UnN5nvUpsU/a/FwqjowTlmT6KMac+grJ3qp4vjYYIm
	 eAVRM9wB8QpR8svTNbLwh6Xew6wyVy7jejzdFmajryVOCGqWv9wolrumXdzkKGcaNjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HVAg7Xij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA35E606A320
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HVAg7Xij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711911F008A1;
	Tue, 10 Nov 2026 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336365;
	bh=PYVYPT8TNN0lw+vu97Pku2OCeG9Ksh7POBpvJjQ8V9A=;
	h=Date:To:From:Subject;
	b=HVAg7Xijsr6t5E3ZCD5kzCqVRbaVe/tPh/obg5kUyUwNRlt/RZbOwVHyJgARHiF5v
	 qsaN1lDr+Jzb0XLYrn9qMPPFv1dCgH4GOLWVrfVj8HA2opMj3qjzmr52Pw0b9MHpiy
	 pQ3WKLPfQXNNR/cYNI7Igy5KKyPVNfhUIuMzdAsA=
Date: Tue, 10 Nov 2026 10:46:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vernon2gm@gmail.com,
	usama.arif@linux.dev,ryan.roberts@arm.com,peterz@infradead.org,
	nico.pache@linux.dev,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,
	dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,azpijr@gmail.com,ast@kernel.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch added to mm-new branch
Message-Id: <20261110184605.711911F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
has been added to the -mm mm-new branch.  Its filename is
     revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
Date: Tue, 10 Nov 2026 17:19:11 +0000

Patch series "mm/khugepaged: bound mmap_lock hold time when walking an mm's
VMAs", v3.

This series introduces a couple small changes to khugepaged to improve its
behaviour both in the face of mm->mmap_lock contention and to reduce that
lock contention when possible.

Looking at the first change - if the mmap lock is contended, an attempted
mmap trylock in collapse_scan_mm_slot() will result in the scan being
aborted wherever it happens to be, and when next the mm is processed it
starts from the beginning again.

If an mm has a lot of ineligible VMAs and is undergoing significant
mmap_lock contention, collapsing the eligible VMAs there can take a very
long time.

Patch 2 of the series fixes this (patch 1 is a prerequisite) by keeping
track of where khugepaged was in the mm before aborting the scan.

This issue was noticed during some work in which an mm was instantiated
with a large number of small VMAs under significant mmap_lock contention,
during which collapse was observed to take 10.8s. With this patch applied
it took 3.6s to collapse the same mm.

Finally, patch 3 uses this to have khugepaged release + reacquire the mmap
read lock if it is contended after walking a large number of VMAs.

This was also observed as part of the previously mentioned work in the form
of mmap lock stalls, which patch 3 resolves. The reader stealing the lock
back from a queued writer on re-acquisition is addressed separately by the
rwsem change at [0].

Importantly, none of the changes introduces any regressions for khugepaged
anywhere. It is all upside, and implemented conservatively.


This patch (of 3):

This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
resurrect this type to store additional data alongside the mm_slot.

The stated intent of the commit was to address a NULL check in
__khugepaged_exit():

	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);

slot can be NULL and mm_slot_entry() is an alias for container_of(), so
this is container_of() a NULL value.

This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
NULL at 0 results in NULL), however it was right to fix this, so retain the
fix.

It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.

Link: https://lore.kernel.org/20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org
Link: https://lore.kernel.org/20261110-khugepaged-latency-fix-v3-1-6eea743cf9a3@kernel.org
Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/ [0]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
---

 mm/khugepaged.c |   57 ++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 19 deletions(-)

--- a/mm/khugepaged.c~revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot
+++ a/mm/khugepaged.c
@@ -67,6 +67,14 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
 /**
+ * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
+ * @slot: hash lookup from mm to mm_slot
+ */
+struct khugepaged_mm_slot {
+	struct mm_slot slot;
+};
+
+/**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
  * @mm_slot: the current mm_slot we are scanning
@@ -76,7 +84,7 @@ static struct kmem_cache *mm_slot_cache
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
 	unsigned long address;
 };
 
@@ -386,7 +394,7 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -446,20 +454,22 @@ static bool hugepage_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 
-	slot = mm_slot_alloc(mm_slot_cache);
-	if (!slot)
+	mm_slot = mm_slot_alloc(mm_slot_cache);
+	if (!mm_slot)
 		return;
 
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		return;
 	}
+	slot = &mm_slot->slot;
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
@@ -504,12 +514,15 @@ void khugepaged_enter_vma(struct vm_area
 
 void __khugepaged_exit(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	if (slot && khugepaged_scan.mm_slot != slot) {
+
+	mm_slot = slot ? mm_slot_entry(slot, struct khugepaged_mm_slot, slot) : NULL;
+	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
 		mm_slot_remove(slot);
 		free = 1;
 	}
@@ -517,9 +530,9 @@ void __khugepaged_exit(struct mm_struct
 
 	if (free) {
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
-	} else if (slot) {
+	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
@@ -1773,8 +1786,9 @@ out:
 	return result;
 }
 
-static void collect_mm_slot(struct mm_slot *slot)
+static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 {
+	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1790,7 +1804,7 @@ static void collect_mm_slot(struct mm_sl
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
 	}
 }
@@ -2914,6 +2928,7 @@ static void collapse_scan_mm_slot(unsign
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2923,12 +2938,14 @@ static void collapse_scan_mm_slot(unsign
 	*result = SCAN_FAIL;
 
 	if (khugepaged_scan.mm_slot) {
-		slot = khugepaged_scan.mm_slot;
+		mm_slot = khugepaged_scan.mm_slot;
+		slot = &mm_slot->slot;
 	} else {
 		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
+		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
-		khugepaged_scan.mm_slot = slot;
+		khugepaged_scan.mm_slot = mm_slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
@@ -3004,7 +3021,7 @@ breakouterloop:
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
@@ -3016,14 +3033,16 @@ breakouterloop_mmap_lock:
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
+			slot = list_next_entry(slot, mm_node);
+			khugepaged_scan.mm_slot =
+				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(slot);
+		collect_mm_slot(mm_slot);
 	}
 
 	trace_mm_khugepaged_scan(mm, cc->progress - progress_prev,
@@ -3113,7 +3132,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct mm_slot *slot;
+	struct khugepaged_mm_slot *mm_slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -3124,10 +3143,10 @@ static int khugepaged(void *none)
 	}
 
 	spin_lock(&khugepaged_mm_lock);
-	slot = khugepaged_scan.mm_slot;
+	mm_slot = khugepaged_scan.mm_slot;
 	khugepaged_scan.mm_slot = NULL;
-	if (slot)
-		collect_mm_slot(slot);
+	if (mm_slot)
+		collect_mm_slot(mm_slot);
 	spin_unlock(&khugepaged_mm_lock);
 	return 0;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-scan-mms-more-efficiently-under-mmap_lock-contention.patch
mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

