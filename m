Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28E91EB37
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663349; cv=none; b=N2bD+WB/zxdwnxojKR1QPxpCncKfu2yKz9eY8YCPOkC/ZA9K4IfyixW/fJibAHV7y3KZtNkA0DOBNjyBA0zQJr2skjlIZShIawaEFOsQUwK66wb4cnsB9dT853YELtihn2q57GRkowuJXlExN92Fcw4fMU/LPtlcYyHxFIa29Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663349; c=relaxed/simple;
	bh=v46svU8fq64XVMRsV4d9FpvCJcQbhiNZuU8jG/3VeOk=;
	h=Date:To:From:Subject:Message-Id; b=r+LtJPeoEc8KoXNVaMnPSPynFE6zcD2UKaaAdIO7zwZlq4eYNdYti6WvVf1rvpk4N5x/oQg05j3T+HMawiOHrOnJZRNkI5bsujlBpsAqX6YBTtqdnHcLIZuXIqAYegifUboDD8HHkIETlXzX3XW4BkFQigiysXXbeVwTSINQkVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yp/LO3Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yp/LO3Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5422CC113CC;
	Thu,  2 May 2024 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663348;
	bh=v46svU8fq64XVMRsV4d9FpvCJcQbhiNZuU8jG/3VeOk=;
	h=Date:To:From:Subject:From;
	b=Yp/LO3QeMnS0mQxYY8kSxOc+deyONmKlUgqy8rE3w73uRVVnY77MP0aRU+9vVwoaM
	 x5rLUIjvHshMi5LwRQPmjY0tsbFDeAFnT6iLrzZ6dBeZrO+I2TZ2W7zCNlz8GWARzM
	 srCvLdc7KX5W+Jc0k+dMoCbgKYSRXZG7wB2uRRhY=
Date: Thu, 02 May 2024 08:22:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch removed from -mm tree
Message-Id: <20240502152228.5422CC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: rename mm_slot_cache to ksm_slot_cache
has been removed from the -mm tree.  Its filename was
     mm-ksm-rename-mm_slot_cache-to-ksm_slot_cache.patch

This patch was dropped because it was nacked

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
mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

