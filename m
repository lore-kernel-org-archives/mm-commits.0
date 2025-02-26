Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE826BDBB
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607632; cv=none; b=L2AqRyJ9qktWEinVuA5otuIS4HCAbIWYT6eZ7GQ3INgftx5ebOWBpEWoRI4pafW5AZqOpNw3AkPkl8GwNQjuxkZucoYJU558NrBB+hsptQJgPVgnMwyUjvGqjKyZSfwsZx8yFwplOLSPCcupm1+f/AFJqU1xJnMf85jikXLXsGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607632; c=relaxed/simple;
	bh=o6PwRoiE5Fo82LQSM/hWrRYobTedCbZLD/S2l2Ov0LQ=;
	h=Date:To:From:Subject:Message-Id; b=kOjBkw+MehZlCXEzX6w0DvwT+Q1O7NM9Tehz+Y6CmNI4PnmeE8JHQCK/5/pblfFD0TqN9XWURpU3WYQh6PyBe3qVtRVaDUKex4M9NQhLgbhLtzW/9AO5DA6A5uMipmlGs+HZe6ZSjc5BfnK5/UIyZsfQLlX1DPfa6FRP2L3Ij3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJyqTP7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJyqTP7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27460C4CED6;
	Wed, 26 Feb 2025 22:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740607632;
	bh=o6PwRoiE5Fo82LQSM/hWrRYobTedCbZLD/S2l2Ov0LQ=;
	h=Date:To:From:Subject:From;
	b=jJyqTP7r9wc6kSqkZz1HbxqygXjglvi15u0MkulTK1cCocqZhxMNl8OkmRWFPMIAP
	 jDvI19dV9fXkweZq52ePjUxIQ1izhsXc5Z7BGWAHeeK8gTgBdGsxRUSDYRgsCwHOUX
	 S7footLjnLXiigmdRX6nZxD8Wy6+ZXoKpdWQ3EB4=
Date: Wed, 26 Feb 2025 14:07:11 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch added to mm-unstable branch
Message-Id: <20250226220712.27460C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_notifier: use MMU_NOTIFY_CLEAR in remove_device_exclusive_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/mmu_notifier: use MMU_NOTIFY_CLEAR in remove_device_exclusive_entry()
Date: Wed, 26 Feb 2025 14:22:57 +0100

Let's limit the use of MMU_NOTIFY_EXCLUSIVE to the case where we convert a
present PTE to device-exclusive.  For the other case, we can simply use
MMU_NOTIFY_CLEAR, because it really is clearing the device-exclusive entry
first, to then install the present entry.

Update the documentation of MMU_NOTIFY_EXCLUSIVE, to document the single
use case more thoroughly.

If ever required, we could add a separate MMU_NOTIFY_CLEAR_EXCLUSIVE; for
now using MMU_NOTIFY_CLEAR seems to be sufficient.

Link: https://lkml.kernel.org/r/20250226132257.2826043-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    8 ++++----
 mm/memory.c                  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry
+++ a/include/linux/mmu_notifier.h
@@ -43,10 +43,10 @@ struct mmu_interval_notifier;
  * a device driver to possibly ignore the invalidation if the
  * owner field matches the driver's device private pgmap owner.
  *
- * @MMU_NOTIFY_EXCLUSIVE: to signal a device driver that the device will no
- * longer have exclusive access to the page. When sent during creation of an
- * exclusive range the owner will be initialised to the value provided by the
- * caller of make_device_exclusive(), otherwise the owner will be NULL.
+ * @MMU_NOTIFY_EXCLUSIVE: conversion of a page table entry to device-exclusive.
+ * The owner is initialized to the value provided by the caller of
+ * make_device_exclusive(), such that this caller can filter out these
+ * events.
  */
 enum mmu_notifier_event {
 	MMU_NOTIFY_UNMAP = 0,
--- a/mm/memory.c~mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry
+++ a/mm/memory.c
@@ -4046,7 +4046,7 @@ static vm_fault_t remove_device_exclusiv
 		folio_put(folio);
 		return ret;
 	}
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_CLEAR, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
 	mmu_notifier_invalidate_range_start(&range);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch
lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch
mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch
mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch
mm-memory-document-restore_exclusive_pte.patch
mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch

