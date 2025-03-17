Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6328F217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188486; cv=none; b=sv/N7l6KaBOuoS/MnGVQYqx6Ir42tpukZFETFPSU2jT+HvaCDp29G9nFEHVre4+B0VMmVJ0nPoZT7ry6nqh6FYfG59w4gZjlXQNqCRL+L/R2e9M55ynwePaUn6NQwl78e7euMFY0XORSIgzg+LWupszkRZ6HquigzHz1dfLQT0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188486; c=relaxed/simple;
	bh=JeADjEuSmYdv65SQsOYafHIZxQTe5i7g6LvHtDv3Hr0=;
	h=Date:To:From:Subject:Message-Id; b=nFF9rSRHCy++BNfmGp6EXrR4cRRLjS/+DXU0uR7aV8+ybaF7JiXf3ZEy0cgipM+YR+WD3TOK7z7Xui2rVuJsTk4XaQP2sFC7E9umWZoTt+4Xk/olzMOc6RbPA8d28SfRIyVaM7/cMflYfqyGJQ/+Nl7KKX28dwpEAog0GNIY+3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCysXMdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCysXMdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379ABC4CEEC;
	Mon, 17 Mar 2025 05:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188486;
	bh=JeADjEuSmYdv65SQsOYafHIZxQTe5i7g6LvHtDv3Hr0=;
	h=Date:To:From:Subject:From;
	b=XCysXMdQpwvhkc65FMw5FkC9x1E7mXd47WNTEGkKj0vSdo7h0XSUwxAOeRPUQtJLz
	 dW3FiN4P5LpiDNXc6cnFTYUb3T9U4WaMAVXjY+BQgZ5H91OJhdxJmgpYBXtfdNTGCx
	 xsBnuxqh/0tjEbsfAtFBgj+pz8bsbChICabnAKWA=
Date: Sun, 16 Mar 2025 22:14:45 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-document-restore_exclusive_pte.patch removed from -mm tree
Message-Id: <20250317051446.379ABC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: document restore_exclusive_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-document-restore_exclusive_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: document restore_exclusive_pte()
Date: Wed, 26 Feb 2025 14:22:56 +0100

Let's document how this function is to be used, and why the folio lock is
involved.

Link: https://lkml.kernel.org/r/20250226132257.2826043-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/memory.c~mm-memory-document-restore_exclusive_pte
+++ a/mm/memory.c
@@ -716,6 +716,32 @@ struct folio *vm_normal_folio_pmd(struct
 }
 #endif
 
+/**
+ * restore_exclusive_pte - Restore a device-exclusive entry
+ * @vma: VMA covering @address
+ * @folio: the mapped folio
+ * @page: the mapped folio page
+ * @address: the virtual address
+ * @ptep: pte pointer into the locked page table mapping the folio page
+ * @orig_pte: pte value at @ptep
+ *
+ * Restore a device-exclusive non-swap entry to an ordinary present pte.
+ *
+ * The folio and the page table must be locked, and MMU notifiers must have
+ * been called to invalidate any (exclusive) device mappings.
+ *
+ * Locking the folio makes sure that anybody who just converted the pte to
+ * a device-exclusive entry can map it into the device to make forward
+ * progress without others converting it back until the folio was unlocked.
+ *
+ * If the folio lock ever becomes an issue, we can stop relying on the folio
+ * lock; it might make some scenarios with heavy thrashing less likely to
+ * make forward progress, but these scenarios might not be valid use cases.
+ *
+ * Note that the folio lock does not protect against all cases of concurrent
+ * page table modifications (e.g., MADV_DONTNEED, mprotect), so device drivers
+ * must use MMU notifiers to sync against any concurrent changes.
+ */
 static void restore_exclusive_pte(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long address,
 		pte_t *ptep, pte_t orig_pte)
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

