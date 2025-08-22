Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000C4EC2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 05:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755840137; cv=none; b=qJhxGvTB+qtQEVAAFh3WGXFB9uEHpyJHo6qlgG/oEMi2Ve3bn/H8cO/KUaAjQJEvzl8gyAG0OuZ/73V3YXDc5GOnLvfSBJrrOESTKk/drptSgXM3dtSQ7BwZQ2bsde9NKR+QZLOoaxlyy3BWvInLcCAa+hQjh1gddSIIYxtSjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755840137; c=relaxed/simple;
	bh=bHjPjU+0auzxixjUGvcjnqaUTSAC6f92CaodbeeTUos=;
	h=Date:To:From:Subject:Message-Id; b=M4/8AwuLMvA8WEvyDw099xzq3SaIB/Zd3gEdL/0rBrhDkmHGEKCKFmwCV6Bq2VKo0in0EVgpHVs2AOioCiEG1AUOlM/ZowxFY14OlHHMO+2mTRUxrwh32C/srT7kjNMHiKYxkbdHBigVJqJMm4r/NjUOCHVWNowaTPk6alve3hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4HCFnDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4HCFnDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC64C4CEF1;
	Fri, 22 Aug 2025 05:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755840135;
	bh=bHjPjU+0auzxixjUGvcjnqaUTSAC6f92CaodbeeTUos=;
	h=Date:To:From:Subject:From;
	b=V4HCFnDgzMjTvlmyNYpzHMyYNjupKyzAz+z5cMH3n/wyb00HEZWHcFzF7XbvfDUa0
	 hosRbTC6vu8oxt7HD/TG7YL5Rrq41eKeYfgItx1M/bvOFfDIStMs2koTEkMokCNSkb
	 OLraA2O2RmC2qG3Zw03emlYgD0yW6YnqyUbMubJA=
Date: Thu, 21 Aug 2025 22:22:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch added to mm-new branch
Message-Id: <20250822052215.7AC64C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use list_xxx() helper to improve readability
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch

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
Subject: mm/khugepaged: use list_xxx() helper to improve readability
Date: Fri, 22 Aug 2025 02:57:32 +0000

In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
to get a mm_struct for collapse memory.

Use list_xxx() helper would be more obvious to the list iteration
operation.

No functional change.

Link: https://lkml.kernel.org/r/20250822025732.9025-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-list_xxx-helper-to-improve-readability
+++ a/mm/khugepaged.c
@@ -2402,7 +2402,7 @@ static unsigned int khugepaged_scan_mm_s
 		mm_slot = khugepaged_scan.mm_slot;
 		slot = &mm_slot->slot;
 	} else {
-		slot = list_entry(khugepaged_scan.mm_head.next,
+		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
 		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
@@ -2515,9 +2515,8 @@ breakouterloop_mmap_lock:
 		 * khugepaged runs here, khugepaged_exit will find
 		 * mm_slot not pointing to the exiting mm.
 		 */
-		if (slot->mm_node.next != &khugepaged_scan.mm_head) {
-			slot = list_entry(slot->mm_node.next,
-					  struct mm_slot, mm_node);
+		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
+			slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.mm_slot =
 				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 			khugepaged_scan.address = 0;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch

