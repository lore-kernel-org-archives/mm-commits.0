Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A01421858D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188488; cv=none; b=DX/+I79C+rwmuO9oBpFX1ZU8B9CrpK7pnJ9XhzEo1TOLJWqZEb1xa2+hOy6DwEnXH9d1NwYhh6ibxB/n0eSnmwtrjL2ZTJpyDvjXYcav3L8Y4Yw00uPsV6oaAMLeHFZw7TCpZuNdkmpZDsoR9szoPeHY8BWhK4YhZ6pixL8n7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188488; c=relaxed/simple;
	bh=W2WNNA6lUvOe3myQgx1dnSay4XBhAJw+pn+d0Tcs0fY=;
	h=Date:To:From:Subject:Message-Id; b=qMY7ZR6PpjmOOu3NjUce3t3AX0ZrE0COgncovmlggXQUoYC3s1rpJHX73ApU4K2j1iojvwv1o2LtsoEeoPd0YUJyWJe4lWqnVwwbbCXp0pYkElZ8m4eEM59q38WTffakzmjnt+yQNavaC18Tjwuw74D+WeNmB0TOCjk9U9DKyHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1+GMJMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1+GMJMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D778C4CEEC;
	Mon, 17 Mar 2025 05:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188488;
	bh=W2WNNA6lUvOe3myQgx1dnSay4XBhAJw+pn+d0Tcs0fY=;
	h=Date:To:From:Subject:From;
	b=r1+GMJMmp/zsakJXfizeQsJOKVoJwSj+dx2V+OEMYDdKuBci9dZZfhIOEullmZVcl
	 k6sBXqfwzaVYs7e9ZDiyWtvpKDxlL8zoyD23y12KsrLpNwJ1NqYpG3LHdePg5WA+4f
	 6Hfit0EhYEN/q/Qj0Z93eJvHoVYi5aaebmr4OC8E=
Date: Sun, 16 Mar 2025 22:14:47 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch removed from -mm tree
Message-Id: <20250317051448.1D778C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_notifier: use MMU_NOTIFY_CLEAR in remove_device_exclusive_entry()
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4003,7 +4003,7 @@ static vm_fault_t remove_device_exclusiv
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

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

