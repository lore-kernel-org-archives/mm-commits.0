Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38851E495
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408246; cv=none; b=Jbu2TQD838vCtjd3tDLm1czoQ01fLR7PgGBjqS9FT0bzceD9DQrzRKCCYkTKeqMhKEFSvvydd6nW1Vj1+E+LsXu0DfbaVaTtctvb3wST6vHX1gvdf3vuywlYhuHrNglH5IM6u8o1mkNnrton8Ky2SItvyo50eifQ8efC5l7SOmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408246; c=relaxed/simple;
	bh=61BQNuwFhQlXXVDy0JN/86aELUMAgi1RC9XhAztXhkE=;
	h=Date:To:From:Subject:Message-Id; b=Whi9DWO1VHZRZFrYjAsT0IYAG69GhJHCoCP4CdLTK4YuPguMibt6V5l3RMgNwA9OXOZ6HUyUrdhsJaURgxcGkc8sy/V6//qCEUs8fh1ukHDs9pk9NreRDqfE7/QTGl74bp3ddoRY8jRiB7rAE/zWoccj5iOBryF0aDbzp1M56IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/ZGfMpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/ZGfMpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51A1C113CD;
	Mon, 29 Apr 2024 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408246;
	bh=61BQNuwFhQlXXVDy0JN/86aELUMAgi1RC9XhAztXhkE=;
	h=Date:To:From:Subject:From;
	b=W/ZGfMpf6IrjRl87fFhWhAjVS4vCdtExuXermSVZC24bMGfg9G9onf/mJ+CO1wqAQ
	 p8yDn9meLjI/22BUl0AJxGE8dQLWE8c/LxELpODf0ScIFwpZmoEHRZc+4etAWQm4vH
	 7Z8aX7GyGeJTf3s3Oxv51V6Y9s+8NMV2JjvVfj68=
Date: Mon, 29 Apr 2024 09:30:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch added to mm-unstable branch
Message-Id: <20240429163045.E51A1C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: rename variable mm_slot to ksm_slot in unmerge_and_remove_all_rmap_items
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch

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
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: rename variable mm_slot to ksm_slot in unmerge_and_remove_all_rmap_items
Date: Sun, 28 Apr 2024 18:06:16 +0800

To distinguish ksm_mm_slot and mm_slot for better code readability, rename
ksm_mm_slot variable as ksm_slot in function
unmerge_and_remove_all_rmap_items.  No function changes.

Link: https://lkml.kernel.org/r/20240428100619.3332036-2-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items
+++ a/mm/ksm.c
@@ -1196,7 +1196,7 @@ static int remove_all_stable_nodes(void)
 
 static int unmerge_and_remove_all_rmap_items(void)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *ksm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -1208,11 +1208,11 @@ static int unmerge_and_remove_all_rmap_i
 	ksm_scan.ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 	spin_unlock(&ksm_mmlist_lock);
 
-	for (mm_slot = ksm_scan.ksm_slot; mm_slot != &ksm_mm_head;
-	     mm_slot = ksm_scan.ksm_slot) {
-		VMA_ITERATOR(vmi, mm_slot->slot.mm, 0);
+	for (ksm_slot = ksm_scan.ksm_slot; ksm_slot != &ksm_mm_head;
+	     ksm_slot = ksm_scan.ksm_slot) {
+		VMA_ITERATOR(vmi, ksm_slot->slot.mm, 0);
 
-		mm = mm_slot->slot.mm;
+		mm = ksm_slot->slot.mm;
 		mmap_read_lock(mm);
 
 		/*
@@ -1232,19 +1232,19 @@ static int unmerge_and_remove_all_rmap_i
 		}
 
 mm_exiting:
-		remove_trailing_rmap_items(&mm_slot->rmap_list);
+		remove_trailing_rmap_items(&ksm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
+		slot = list_entry(ksm_slot->slot.mm_node.next,
 				  struct mm_slot, mm_node);
 		ksm_scan.ksm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 		if (ksm_test_exit(mm)) {
-			hash_del(&mm_slot->slot.hash);
-			list_del(&mm_slot->slot.mm_node);
+			hash_del(&ksm_slot->slot.hash);
+			list_del(&ksm_slot->slot.mm_node);
 			spin_unlock(&ksm_mmlist_lock);
 
-			mm_slot_free(mm_slot_cache, mm_slot);
+			mm_slot_free(mm_slot_cache, ksm_slot);
 			clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 			clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 			mmdrop(mm);
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
mm-ksm-rename-mm_slot-members-to-ksm_slot-for-better-readability.patch
mm-ksm-rename-variable-mm_slot-to-ksm_slot-in-unmerge_and_remove_all_rmap_items.patch
mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch
mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

