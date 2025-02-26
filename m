Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C826BD90
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607631; cv=none; b=l+XokyCx7mxeiRRKFhcJZrMOlxoOyt/Ko/K9VRWgslvOaRe1Sevy0aeZAXGTDV/95VUdI5SohkLzX82cX5kAv7LlycppKzmj1M16Sa9xHkIR/W7C7DvxuSHhBAowONK/b2+WxriQ+ngYQIvdUnv6a7J/4s7T7F+rwY8rc2CZy9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607631; c=relaxed/simple;
	bh=OzLP3/iisklz61ULgAEAdIgVkE/Jk5iFiFJsbm5KNTw=;
	h=Date:To:From:Subject:Message-Id; b=P0x7fZBRIolRWzOkJtPoSxyZVul8AQnEeUS017YBMsflcti7ulb9IfjoZxvWwbiwRB6fR60V59pDpOf9GE4TKC6/jhrI113KXLbAvrbqCit9Ah0wDINjwtdm2wbfw2nqUAUFW3CADWJvDVgfKHku0ApJpZ4yBna+4y5St+QsSdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w5r4zmC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w5r4zmC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA3CC4CEE7;
	Wed, 26 Feb 2025 22:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740607630;
	bh=OzLP3/iisklz61ULgAEAdIgVkE/Jk5iFiFJsbm5KNTw=;
	h=Date:To:From:Subject:From;
	b=w5r4zmC5MU2cCk/ZNYrXldWbosATq/bgVL6nNl4xWaC1VQ1OvgUk0XvIDvR7myEmG
	 S5TNPVLwlmGhUttRnqhM84a39owPEnEfGP5+ffAf20U4LjEHfa2VcKm2xU6nlY4UgB
	 XFGGoHgwJYIOW4JSs5nB+ADGWXyi8p9OT0M1I1Bg=
Date: Wed, 26 Feb 2025 14:07:10 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-document-restore_exclusive_pte.patch added to mm-unstable branch
Message-Id: <20250226220710.DAA3CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: document restore_exclusive_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-document-restore_exclusive_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-document-restore_exclusive_pte.patch

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
@@ -718,6 +718,32 @@ struct folio *vm_normal_folio_pmd(struct
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

