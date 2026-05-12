Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127DA3672BB
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624877; cv=none; b=HoVxz6fNJ+2JHFNvygOhYQOkrSHW+yjcuBApzrfsXgXGem/fxajnuDPtGu9RVYtkoa0aNHntViaWF8oAlNmTYX6+Xu3i4W2X9pylzb7neR7HNkDcJErqAnrV9XK4/cS/pMgc9RvRo2pzSOo7bODIuICCMwEIlFRmhMTOGjSMwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624877; c=relaxed/simple;
	bh=LrfXUWzuK/HD2ul+74C0VkUI1FThQyA/o99HHK8KFig=;
	h=Date:To:From:Subject:Message-Id; b=SSuqIrVBNzCgJBU5SDMhPD0X91P14bS0dYpHEpPA3KxQ7RC1rEZzJh8QxlEzi6AwpVM8lRwHAPC1eoCLGYduDoaIDYWkxKy64nnevRbK2YOhl9x+e8bKUygoKIFr+7T7slkJxjKvOzUZemnTyvjvaiZovcO1Y+oQCM/i/YJ2ECs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=At40739d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="At40739d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B440C2BCB0;
	Tue, 12 May 2026 22:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624876;
	bh=LrfXUWzuK/HD2ul+74C0VkUI1FThQyA/o99HHK8KFig=;
	h=Date:To:From:Subject:From;
	b=At40739dFHsKfrPbQh/eWFOmLQAGfUxq1c2YslogmhI6LdcmyIsvgrjzy1eN0c44q
	 V8q/Bo/U9KbFa5zqHO+nzZY6YqIDAyvpzQrx/9X+v18Wmz71fRX9WAizjnxih8MIHf
	 dtKHJZA3e94RbJg1cb779NMqDkWaBsm9ROgH+lho=
Date: Tue, 12 May 2026 15:27:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xhao@linux.alibaba.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch added to mm-new branch
Message-Id: <20260512222756.8B440C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
Date: Mon, 11 May 2026 10:54:07 +0800

__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
corresponding mm_slot.  If mm_slot_alloc() fails, the function returns
with the flag set but without inserting the mm into the khugepaged
tracking structures, leaving the mm in an inconsistent state where future
registration attempts are skipped.

Fix this by reordering: allocate the mm_slot first, then check and set the
flag.  If the flag is already set, free the allocated slot and return. 
This ensures the flag is only set when the mm is successfully registered
in the khugepaged tracking structures.

Link: https://lore.kernel.org/20260511025408.54035-1-ye.liu@linux.dev
Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order
+++ a/mm/khugepaged.c
@@ -559,13 +559,16 @@ void __khugepaged_enter(struct mm_struct
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
-	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
-		return;
 
 	slot = mm_slot_alloc(mm_slot_cache);
 	if (!slot)
 		return;
 
+	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
+		mm_slot_free(mm_slot_cache, slot);
+		return;
+	}
+
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch
mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch

