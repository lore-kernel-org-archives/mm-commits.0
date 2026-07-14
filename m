Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34937EFFF
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783998538; cv=none; b=BlHtjouxSdsZVDKzxGAo0bO1Swy5mFa9ecLCS8aeqv9u5fsDgauseJprniB+r110vi1dDBqrNyt7JBM8Wi1SD+ujxcTLKxdMfgNO1QSa8bN+YOKXTc4ya3XIZN+b57G3B65VpvPsSDEj9Vf4/pKMGRz8yaHlnHiy/uK8YQeW1G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783998538; c=relaxed/simple;
	bh=DAAxH2nw+aShokgP91gdF4qcO2PGoUApZSpOmNbPBOc=;
	h=Date:To:From:Subject:Message-Id; b=rR1Vud7D2E/ynLTh9RmOMC9JtYKwr+haggPQ6hV+81IRCxMsU3KSh/veT3E6A75STfWGNZEAtVV9+iCc16mRygN1nxpbVFRoRrEDRFd4EjEfe4IHvut0PcoWCZeXR7OIG2h7YivZwKHf1SfrrE557EIM3MZTG53bkSSceL16wUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1HClh9Kp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1HClh9Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EBC1F000E9;
	Tue, 14 Jul 2026 03:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998537;
	bh=Zvmd+8gQKkbbtk4N/Z7EUEMbCQqS7PCs4Qnzd/GeCco=;
	h=Date:To:From:Subject;
	b=1HClh9KpxKqt7/h64foQz0iQb0MBUOMBB+Ap4TRc3UevjDbg4jm0q60KxqdO77KQI
	 0H+3cKbHMPKkCiBVylUuxQCL/l8e1CgDehDAGJ18p6jDSL4E5Lcc9VTC+QQPUCMKyE
	 jK1OkfpwdIm+8dZLUWtBsHI4sipEoCJhsAkvg7eU=
Date: Mon, 13 Jul 2026 20:08:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wang.yaxin@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch added to mm-new branch
Message-Id: <20260714030857.06EBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_slot.h: add a helper function mm_slot_remove
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch

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

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch
mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch
ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch
mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch
mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

