Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E483201
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408249; cv=none; b=FY9L6JlIqr54BsyTtpe0wFJKO2fLpVCH1EMRYj1vw8iOlUS+JizNcW1J0IzutimgBw5dTsvdQl9JPN8DhppXR3awmhslNrgFteD2c36eqnDq4/vmUl51mRtI7rQLkhRfy88uFqzjeHnPrvGyesHDI2WzhJo7qRzUu+Im527neGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408249; c=relaxed/simple;
	bh=YXMtqDICismin81B2n5A7mIkCxQc2YyE1ALk8AWMnOI=;
	h=Date:To:From:Subject:Message-Id; b=oBQZ0wQohaJ4bjz/BsADpdo+mNkaqihnM3jQ5Z+ToVTd6dgQi0ZYsySe8jhu+cyrz8rXeaBgkTwO2tfAhFLBsy19kl10OSr4Fr7SA2Uq3xGriDTXQV9Omh+6dUFRMJAwKsaWrhU0nEk8UEOct4I7hhYcfyQfBUOY82PX0CcS4AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1zvwftXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1zvwftXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A2C113CD;
	Mon, 29 Apr 2024 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408249;
	bh=YXMtqDICismin81B2n5A7mIkCxQc2YyE1ALk8AWMnOI=;
	h=Date:To:From:Subject:From;
	b=1zvwftXCkwXE0+OfnqF0iTFxlLY9IltswQtGo83C2IiJpiyY7iawoN87pysBNLmqs
	 01W/XGJ9wSaVlEaBxV+1bbHW/szPT6zKaLji/7lksbmEtV8IEHThPFdIiwMLKioMr7
	 EZyf70Sr8ig5aK8AaxknBm4NOoaCFOis4SkH0UMY=
Date: Mon, 29 Apr 2024 09:30:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch added to mm-unstable branch
Message-Id: <20240429163048.E45A2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: rename mm_slot_cache to ksm_slot_cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch

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
Subject: mm/ksm: rename mm_slot_cache to ksm_slot_cache
Date: Sun, 28 Apr 2024 18:06:17 +0800

To distinguish ksm_mm_slot and mm_slot for better code readability, rename
mm_slot_cache as ksm_slot_cache.  No function change.

Link: https://lkml.kernel.org/r/20240428100619.3332036-3-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache
+++ a/mm/ksm.c
@@ -247,7 +247,7 @@ static struct ksm_scan ksm_scan = {
 
 static struct kmem_cache *rmap_item_cache;
 static struct kmem_cache *stable_node_cache;
-static struct kmem_cache *mm_slot_cache;
+static struct kmem_cache *ksm_slot_cache;
 
 /* Default number of pages to scan per batch */
 #define DEFAULT_PAGES_TO_SCAN 100
@@ -502,8 +502,8 @@ static int __init ksm_slab_init(void)
 	if (!stable_node_cache)
 		goto out_free1;
 
-	mm_slot_cache = KSM_KMEM_CACHE(ksm_mm_slot, 0);
-	if (!mm_slot_cache)
+	ksm_slot_cache = KSM_KMEM_CACHE(ksm_mm_slot, 0);
+	if (!ksm_slot_cache)
 		goto out_free2;
 
 	return 0;
@@ -518,10 +518,10 @@ out:
 
 static void __init ksm_slab_free(void)
 {
-	kmem_cache_destroy(mm_slot_cache);
+	kmem_cache_destroy(ksm_slot_cache);
 	kmem_cache_destroy(stable_node_cache);
 	kmem_cache_destroy(rmap_item_cache);
-	mm_slot_cache = NULL;
+	ksm_slot_cache = NULL;
 }
 
 static __always_inline bool is_stable_node_chain(struct ksm_stable_node *chain)
@@ -1244,7 +1244,7 @@ mm_exiting:
 			list_del(&ksm_slot->slot.mm_node);
 			spin_unlock(&ksm_mmlist_lock);
 
-			mm_slot_free(mm_slot_cache, ksm_slot);
+			mm_slot_free(ksm_slot_cache, ksm_slot);
 			clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 			clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 			mmdrop(mm);
@@ -2716,7 +2716,7 @@ no_vmas:
 		list_del(&ksm_slot->slot.mm_node);
 		spin_unlock(&ksm_mmlist_lock);
 
-		mm_slot_free(mm_slot_cache, ksm_slot);
+		mm_slot_free(ksm_slot_cache, ksm_slot);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 		clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 		mmap_read_unlock(mm);
@@ -2975,7 +2975,7 @@ int __ksm_enter(struct mm_struct *mm)
 	struct mm_slot *slot;
 	int needs_wakeup;
 
-	ksm_slot = mm_slot_alloc(mm_slot_cache);
+	ksm_slot = mm_slot_alloc(ksm_slot_cache);
 	if (!ksm_slot)
 		return -ENOMEM;
 
@@ -3043,7 +3043,7 @@ void __ksm_exit(struct mm_struct *mm)
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
-		mm_slot_free(mm_slot_cache, ksm_slot);
+		mm_slot_free(ksm_slot_cache, ksm_slot);
 		clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
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

