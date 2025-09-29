Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC11DD9AD
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 22:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759184360; cv=none; b=aoEaV0ScYOzj5hqCCwLo4z1ry7kl1ovK53VeJaTr2nPOo22VL5HiW01bsRqKnUw3ltGf1b8iEfcSEO+rAI7s/9irt0K3DycPWLlA9NADfOjANpCy31MBJKjdkBO7OK4cmNw21/viXbLI6NYpWSYTyKq0xFsevkZS67ZOABPLU3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759184360; c=relaxed/simple;
	bh=NoKs4Qv2EDTqksMPBUqGnYvN46DJoluxSwdwKkSBI48=;
	h=Date:To:From:Subject:Message-Id; b=BXMK7gmDJOCxC5bzynWo0BtBgDKUbdQKeKXsTjsBOEsNoqZV2UhPzN3j57EcLXpK1iuOepMw+GcNzveozoyElqfnuzMCwzNAUTG1+xCv4yivnsVKFsqKeNshvV+FtzJzj1B1k26jcAUumbjucQhiZObnGp+nOyXz/cdmvcjgxmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sta72cpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sta72cpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E614C4CEF4;
	Mon, 29 Sep 2025 22:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759184358;
	bh=NoKs4Qv2EDTqksMPBUqGnYvN46DJoluxSwdwKkSBI48=;
	h=Date:To:From:Subject:From;
	b=Sta72cpZl2rCy20hCNOlCLx4LsSOif0EkYH96J7W0OrdcCLE6o9nkzw4ip+2zcioc
	 roBa/Qren356BoWaQwYYIBIy9ONsk8zYaPP/MPNstolAzUAVS/g4VM1TixjKZviOBD
	 ixHp0eGBN+0E60L+wH3CGHTQDmDH+7OZ0f1CrU30=
Date: Mon, 29 Sep 2025 15:19:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,usama.anjum@collabora.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,kas@kernel.org,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null.patch added to mm-unstable branch
Message-Id: <20250929221918.7E614C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: don't call mm_slot_entry() when the slot is NULL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null.patch

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
Subject: mm/ksm: don't call mm_slot_entry() when the slot is NULL
Date: Sat, 27 Sep 2025 00:45:38 +0000

Patch series "mm_slot: fix the usage of mm_slot_entry()", v4.

The usage of mm_slot_entry() in ksm/khugepaged is not correct. In case
mm_slot_lookup() return a NULL slot, mm_slot_entry() should not be called.

To fix this:

Patch 1: check slot before continue in ksm.c
Patch 2: remove the definition of khugepaged_mm_slot


This patch (of 2):

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally. 
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, only call mm_slot_entry() when
we have a valid slot.

Link: https://lkml.kernel.org/r/20250927004539.19308-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250927004539.19308-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/ksm.c~mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null
+++ a/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,17 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
+	if (!slot)
+		goto unlock;
 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
-		}
+	if (ksm_scan.mm_slot == mm_slot)
+		goto unlock;
+	if (!mm_slot->rmap_list) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		easy_to_free = 1;
+	} else {
+		list_move(&slot->mm_node,
+			  &ksm_scan.mm_slot->slot.mm_node);
 	}
+unlock:
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-dont-call-mm_slot_entry-when-the-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch

