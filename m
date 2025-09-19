Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD02C225D6
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758314642; cv=none; b=AYxteTvIMFoTOHWtsdTHNnz7xRxnKtE90bkHOZGfOSez53og+VErVDdm8Jzm0clBh9WnqP5oetS7w62NL3NkynsVogBtiIqZIADayXCijAuGBEbTzUPTmIQ13YuCJoLp1pwf9kUNip7vT6OlVZ0CilCbEADoy6omaesUbm8qu8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758314642; c=relaxed/simple;
	bh=bWDnCZDo83e9LzjyRDMQHAxh8nyfGpQLMGDo65jlj8s=;
	h=Date:To:From:Subject:Message-Id; b=ntgqNn4K+kyi61dg5CekVWs6a+0cLLwH1SES81KXRc5JxJYd+OUXr1b1EEehGJlkrwkrbRs6qd05dFQ3mXO1ol8O0opC21Ey/BFQTaKerLov/Mfn5IJIE7WsA8bH091v9z82HaGQQpOQG7PCt6oMMWuR7oPS9J0AvBtATS+ViOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sf7EMCyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sf7EMCyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543FDC4CEF0;
	Fri, 19 Sep 2025 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758314642;
	bh=bWDnCZDo83e9LzjyRDMQHAxh8nyfGpQLMGDo65jlj8s=;
	h=Date:To:From:Subject:From;
	b=Sf7EMCyrv7/W3vFJIxwwsRgx0ww1VSo4GQeDTNKsbSfYmjrmXMo+o9kzDe8Xm+csc
	 HdnzprYsBL2EBv4eHhMe17iwJ25koceuGvxEHf2geCK7b/iYh6EQY9N+OWJ8kUoNJh
	 Qr1CijWV/Gjwev1TMtO6Eyy5e+GzT+hocjS7fzPQ=
Date: Fri, 19 Sep 2025 13:44:01 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch added to mm-new branch
Message-Id: <20250919204402.543FDC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
Date: Fri, 19 Sep 2025 07:12:43 +0000

Patch series "mm_slot: fix the usage of mm_slot_entry", v2.

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally. 
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, access mm_slot_entry() when
slot is !NULL.

Link: https://lkml.kernel.org/r/20250919071244.17020-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250919071244.17020-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null
+++ a/mm/ksm.c
@@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
+	if (slot) {
+		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		if (ksm_scan.mm_slot != mm_slot) {
+			if (!mm_slot->rmap_list) {
+				hash_del(&slot->hash);
+				list_del(&slot->mm_node);
+				easy_to_free = 1;
+			} else {
+				list_move(&slot->mm_node,
+					  &ksm_scan.mm_slot->slot.mm_node);
+			}
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch
mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

