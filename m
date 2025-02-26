Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2005C25E44D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607629; cv=none; b=FOVx/EhWCnCSWZav7j6XV84CnNcEXdGMjn003pHIUOkIXPoF0UkL1vOpuAnDQab3F1AR74FFr+fZQrNSlUz2UafBCHteM5oFfSdhJqUcyTw7ySeboVJocQ8YTC7ABv95sznczMuvychWeI1513NiqoboeR/ad5hp/0PqFXJ1cVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607629; c=relaxed/simple;
	bh=gAgjI0onngHA8wD8wY/w1w0iasSL4SQzVQPSilZCFZs=;
	h=Date:To:From:Subject:Message-Id; b=NiGupXXRdWqdC2abMShdI/TecYumPruY9GGINo8cfd/P7udmZPT3ETqjkoda3W+9HvY2fN9vjo7V9/lNscop1PXQLuMHLrtN1vmGZB6Uxs7yuU2ph0jBav9KKsvM3yJM888lIYjpI26N2vVRucHSZqv2gQj1HJpJHPy40txsq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClpjkkSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClpjkkSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCF0C4CEE7;
	Wed, 26 Feb 2025 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740607628;
	bh=gAgjI0onngHA8wD8wY/w1w0iasSL4SQzVQPSilZCFZs=;
	h=Date:To:From:Subject:From;
	b=ClpjkkSqeLUoseIk3IDi0pWgk2War2OV9BZOHyc3YswyqYzERgwCzZyFw0Le/VWYw
	 zfyr2+OOWZAxG8ulf2+srVOiMFM8dCCbIfC+KK6aiadDqqw7kGocQZDCTslHnPa9T+
	 I6RwqtM7OuDnTdMrf/yHZSeJb3zLfljDHc7Bpx58=
Date: Wed, 26 Feb 2025 14:07:07 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch added to mm-unstable branch
Message-Id: <20250226220708.7DCF0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: remove PageAnonExclusive sanity-check in restore_exclusive_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch

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
Subject: mm/memory: remove PageAnonExclusive sanity-check in restore_exclusive_pte()
Date: Wed, 26 Feb 2025 14:22:54 +0100

In commit b832a354d787 ("mm/memory: page_add_anon_rmap() ->
folio_add_anon_rmap_pte()") we accidentally changed the sanity check to
essentially ignore anonymous folio by mis-placing the "!" ...  but we
really always only get anonymous folios in restore_exclusive_pte().

However, in the meantime we removed the separate "writable
device-exclusive entries" and always detect if the PTE can be writable
using can_change_pte_writable() -- which also consults PageAnonExclusive.

So let's just get rid of this sanity check completely.

Link: https://lkml.kernel.org/r/20250226132257.2826043-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory.c~mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte
+++ a/mm/memory.c
@@ -740,9 +740,6 @@ static void restore_exclusive_pte(struct
 			pte = pte_mkdirty(pte);
 		pte = pte_mkwrite(pte, vma);
 	}
-
-	VM_BUG_ON_FOLIO(pte_write(pte) && (!folio_test_anon(folio) &&
-					   PageAnonExclusive(page)), folio);
 	set_pte_at(vma->vm_mm, address, ptep, pte);
 
 	/*
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

