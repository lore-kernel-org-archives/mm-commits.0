Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8026AA9E
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607628; cv=none; b=EXYK8i6UzmkfnRSGscF24ezY572kf3IB7rki59Rhi79cst/3VORCJslnV1uhFNB95c/HANwWgP9aF8DHMPgparqAnvbhBq9mS4WQEFyHe58AxrvR++FLxTPgjSHW881urg/Dst71ggwEr5oYOsMNIE0GFpFIC7Wxh1Y+BcOxruw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607628; c=relaxed/simple;
	bh=l09wkjBCVvLj6InYmR1P1T6/uHrQNuLlJfX4PgrV3mA=;
	h=Date:To:From:Subject:Message-Id; b=HmXBPcGnZM7p+KS9UaF75bsNgT8oDU+DmFKjhfncmrbrq57D6XeA41PTWurvwxrkCUWGGKlZiZh+MuAPOAZWBXTQniRCETkZxW8AcylNH1fhJ44Z4AMRLicIasHsWDAe0AHDDiRwFEcKTND6bWuPflSpiH+lS0sp4hTCTMEAXic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=svrCG65H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="svrCG65H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DFBC4CED6;
	Wed, 26 Feb 2025 22:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740607627;
	bh=l09wkjBCVvLj6InYmR1P1T6/uHrQNuLlJfX4PgrV3mA=;
	h=Date:To:From:Subject:From;
	b=svrCG65HRUEP3uGQDueF7mJdv0ehRHX9/Lw31TcwBH40Ge6ckhd7qwRLDRCR2dMqB
	 /ZgYfq4sUoZ3aUgjTRIFWGBCmcyW/uU92E78O4nPLa5L0dHzkLg4N3ZlpR7QDB2xQn
	 QcB1eZl3pKZva54KN0aLsGfio92PYlG/15wV93zQ=
Date: Wed, 26 Feb 2025 14:07:06 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch added to mm-unstable branch
Message-Id: <20250226220707.43DFBC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: make dmirror_atomic_map() consume a single page
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch

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
Subject: lib/test_hmm: make dmirror_atomic_map() consume a single page
Date: Wed, 26 Feb 2025 14:22:53 +0100

Patch series "mm: cleanups for device-exclusive entries (hmm)", v2.

Some smaller device-exclusive cleanups I have lying around.


This patch (of 5):

The caller now always passes a single page; let's simplify, and return "0"
on success.

Link: https://lkml.kernel.org/r/20250226132257.2826043-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250226132257.2826043-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page
+++ a/lib/test_hmm.c
@@ -707,34 +707,23 @@ static int dmirror_check_atomic(struct d
 	return 0;
 }
 
-static int dmirror_atomic_map(unsigned long start, unsigned long end,
-			      struct page **pages, struct dmirror *dmirror)
+static int dmirror_atomic_map(unsigned long addr, struct page *page,
+		struct dmirror *dmirror)
 {
-	unsigned long pfn, mapped = 0;
-	int i;
+	void *entry;
 
 	/* Map the migrated pages into the device's page tables. */
 	mutex_lock(&dmirror->mutex);
 
-	for (i = 0, pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++, i++) {
-		void *entry;
-
-		if (!pages[i])
-			continue;
-
-		entry = pages[i];
-		entry = xa_tag_pointer(entry, DPT_XA_TAG_ATOMIC);
-		entry = xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
-		if (xa_is_err(entry)) {
-			mutex_unlock(&dmirror->mutex);
-			return xa_err(entry);
-		}
-
-		mapped++;
+	entry = xa_tag_pointer(page, DPT_XA_TAG_ATOMIC);
+	entry = xa_store(&dmirror->pt, addr >> PAGE_SHIFT, entry, GFP_ATOMIC);
+	if (xa_is_err(entry)) {
+		mutex_unlock(&dmirror->mutex);
+		return xa_err(entry);
 	}
 
 	mutex_unlock(&dmirror->mutex);
-	return mapped;
+	return 0;
 }
 
 static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
@@ -804,8 +793,7 @@ static int dmirror_exclusive(struct dmir
 			break;
 		}
 
-		ret = dmirror_atomic_map(addr, addr + PAGE_SIZE, &page, dmirror);
-		ret = ret == 1 ? 0 : -EBUSY;
+		ret = dmirror_atomic_map(addr, page, dmirror);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
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

