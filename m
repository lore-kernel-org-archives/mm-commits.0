Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7413B9D9A
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068064; cv=none; b=qMhWWtdTzn6L47QszRoIoCAxwoj8d692cDAQb4zCSJaoqL/YunShsN58AEMdpSpjXnekoTsWSmdaf71vdHpHdXImIXOQFiqoy4OK9a/COBbr/0qzH7bi/Wq0q+lOeURwoPNhqy2DlGECdIMaW+gF8e36pK/hXFEL2iF4+f5Hhi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068064; c=relaxed/simple;
	bh=PjGDa9Wkt3j1iaU8M1f/isotnrX7y2ohR4+eSvQfVe8=;
	h=Date:To:From:Subject:Message-Id; b=O7+6HeOrpt56Nkh7TEnjB9tFxlYTkCNDeC+E/hEl7rM/2pwYg1GEogLw05EBqBbjSvTICfbogAcQEy1pPFR+JIvmke0WHa/rNp+cDuLeUXFn7NK1Si7F41UJEN/YQmvhq2MfheCxg9byxU70oeM+sw57W6cMAoyDwRngyTOZH5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2SRVlNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2SRVlNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034421F000E9;
	Fri,  7 Aug 2026 02:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068060;
	bh=tUgnon+KpNhrmHGyHIigA2uz7iTWjOkNCCsAj14fvP0=;
	h=Date:To:From:Subject;
	b=Z2SRVlNG6n71EdSvU6HEXlqatxmo4/RmOMISwB02C8WjRcTR52kSuqMxduoh8g34L
	 skkmOVaH4COHAhaN5TwZ/4TZdtLwddKUmIy7OuVwulgmcFvOMKGi0bTLNsQCqVNv4W
	 3Z9cdZwwF0OOnMf6QEM9rPQWLweZPIyQd26h113w=
Date: Thu, 06 Aug 2026 19:00:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wang.yaxin@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,npache@redhat.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch removed from -mm tree
Message-Id: <20260807020100.034421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_slot.h: add a helper function mm_slot_remove
has been removed from the -mm tree.  Its filename was
     mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/mm_slot.h: add a helper function mm_slot_remove
Date: Tue, 14 Jul 2026 09:26:22 +0800 (CST)

Patch series "Two small patches to clean up mm/mm_slot.h", v3.

mm_slot.h is mainly used by THP and KSM.

Patch 1 introduces mm_slot_remove() to abstract the common
hash_del() + list_del() sequence used in both khugepaged and KSM.

Patch 2 adds a comment explaining why mm_slot_lookup/insert cannot
be converted to static inline functions.


This patch (of 2):

Both THP and KSM manage per-mm scanning slots using the mm_slot structure.
The slot is kept in a hash table and a list, and removal from both
containers requires the same two operations: hash_del() and list_del().

Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
sequence used in both khugepaged and KSM.

No functional change is intended.

Link: https://lore.kernel.org/202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn
Link: https://lore.kernel.org/20260714092622583ayzGzGYSjAareKKHt_T91@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 ++----
 mm/ksm.c        |    9 +++------
 mm/mm_slot.h    |    5 +++++
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-mm_sloth-add-a-helper-function-mm_slot_remove
+++ a/mm/khugepaged.c
@@ -606,8 +606,7 @@ void __khugepaged_exit(struct mm_struct
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
 	if (slot && khugepaged_scan.mm_slot != slot) {
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);
 		free = 1;
 	}
 	spin_unlock(&khugepaged_mm_lock);
@@ -1802,8 +1801,7 @@ static void collect_mm_slot(struct mm_sl
 
 	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);
 
 		/*
 		 * Not strictly needed because the mm exited already.
--- a/mm/ksm.c~mm-mm_sloth-add-a-helper-function-mm_slot_remove
+++ a/mm/ksm.c
@@ -1257,8 +1257,7 @@ mm_exiting:
 				  struct mm_slot, mm_node);
 		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 		if (ksm_test_exit(mm)) {
-			hash_del(&mm_slot->slot.hash);
-			list_del(&mm_slot->slot.mm_node);
+			mm_slot_remove(&mm_slot->slot);
 			spin_unlock(&ksm_mmlist_lock);
 
 			mm_slot_free(mm_slot_cache, mm_slot);
@@ -2772,8 +2771,7 @@ no_vmas:
 		 * or when all VM_MERGEABLE areas have been unmapped (and
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
-		hash_del(&mm_slot->slot.hash);
-		list_del(&mm_slot->slot.mm_node);
+		mm_slot_remove(&mm_slot->slot);
 		spin_unlock(&ksm_mmlist_lock);
 
 		mm_slot_free(mm_slot_cache, mm_slot);
@@ -3116,8 +3114,7 @@ void __ksm_exit(struct mm_struct *mm)
 	if (ksm_scan.mm_slot == mm_slot)
 		goto unlock;
 	if (!mm_slot->rmap_list) {
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);
 		easy_to_free = 1;
 	} else {
 		list_move(&slot->mm_node,
--- a/mm/mm_slot.h~mm-mm_sloth-add-a-helper-function-mm_slot_remove
+++ a/mm/mm_slot.h
@@ -52,4 +52,9 @@ static inline void mm_slot_free(struct k
 	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
 })
 
+static inline void mm_slot_remove(struct mm_slot *slot)
+{
+	hash_del(&slot->hash);
+	list_del(&slot->mm_node);
+}
 #endif /* _LINUX_MM_SLOT_H */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


