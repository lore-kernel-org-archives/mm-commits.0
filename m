Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9124C1A7264
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663042; cv=none; b=YByNnjgQyLCeRJFbUftKFcYWZU5Ih3FhA/7dUWTnspHIyz+YwLwgp+0r+1BU4Gn3KkR2kkkhcEhqRp8Be4uZtTgpu50DnNIYSHZ1dlVysCnNJkki2Hx+hhu41laZfMvVDxhhgUEQT2/30X69Zc0nQvtQHCBY0HDUrGyHc5ASvdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663042; c=relaxed/simple;
	bh=3ElD82j6agF19z4OU4blVTAr+2wxIkOCYzAk1g1sGUk=;
	h=Date:To:From:Subject:Message-Id; b=os99JpqNrxY6oZ6umIMGZcwdIxxJqCXFWSX64Jmziw0jCeD4qJIWxqTmcSaY5H/o1G4PFBpDubtfsr3IHVsv/NXyDQvdAF+tgzNrNYFxHQL8X/I5kPGHodvAZI9MqiWubwq2Y89q7MtZHx2IeUuJ5Akyn6t/Z1HvzXdxsZ0FlrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fHZpss4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fHZpss4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F2C4CEF5;
	Tue, 23 Sep 2025 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663042;
	bh=3ElD82j6agF19z4OU4blVTAr+2wxIkOCYzAk1g1sGUk=;
	h=Date:To:From:Subject:From;
	b=fHZpss4c5E7jnYIUyxdIUKKgD/wwhPCEA9OGe55MvI48vtcIwhqFP+7AGkW/UKl8k
	 S09lc+sXdkkNtB0c78zSOLAoIQ7xlHBcJJ8OGR3jkzUzG/MPidF37rmvueo/+fPtkz
	 PXzEVpyyHspSmohsINgM1Y4a9ZPV2iXQpt2gtH/g=
Date: Tue, 23 Sep 2025 14:30:41 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch added to mm-unstable branch
Message-Id: <20250923213042.0A3F2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: mlock large folios in try_to_unmap_one()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: mlock large folios in try_to_unmap_one()
Date: Tue, 23 Sep 2025 12:07:08 +0100

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios: only do
this for fully mapped folios and under page table lock that protects all
page table entries.

Link: https://lkml.kernel.org/r/20250923110711.690639-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-mlock-large-folios-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct foli
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,34 @@ static bool try_to_unmap_one(struct foli
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+
+			/*
+			 * Set 'ret' to indicate the page cannot be unmapped.
+			 *
+			 * Do not jump to walk_abort immediately as additional
+			 * iteration might be required to detect fully mapped
+			 * folio an mlock it.
+			 */
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-filemap-map-entire-large-folio-faultaround.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

