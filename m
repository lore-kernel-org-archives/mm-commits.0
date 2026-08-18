Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EA735C6BE;
	Tue, 18 Aug 2026 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787090798; cv=none; b=tJTFFE4+eL7WCdfBZq0SyXwWe/AQPy7aQUoZ3vkmVioTA6TDyKNGBKJCiudwfmDRQ/SS3Ao72OOhGenSkI7/SYrNCeSVu5avFHkh/zMrchn5+gSAwYBNcTB1r6frTJYU3LsmOrt4ffpxDGT5QYk1iTkugJ7YcvcK7C9E2N6KnDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787090798; c=relaxed/simple;
	bh=gAJTYSYiWXhrolRSqJCWY3mR3i51mMFQ9lQZc8faHYY=;
	h=Date:To:From:Subject:Message-Id; b=hVxb6kUtYukNlbK5x/gRWEAfY+QZhmR9uMFQ49JuwF5Fdjissj9kI5ODGM43sZLgj12tfFduJma0WozeWHZ5hsh7nTpQVo/E8Sb84WStPliqzSoMIbD0LUr/MylOPfONaHG6a0Weuwm6pBQ8lR6Ns7GB0sKP7w8lny2Zm+YZU6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tsAg317A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tsAg317A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF0E1F000E9;
	Tue, 18 Aug 2026 22:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787090796;
	bh=RZXxTjxEKKa9cwKqC1gQMFwrwsAMnH8GocVEsS1q4u8=;
	h=Date:To:From:Subject;
	b=tsAg317AOZfYk/IZvG58yV2+Uf/GHtIUIYs85OCAwFZWPyf1en6J2+jFr8+kQe5A0
	 va8qQKLaIGUbiyJWRDFvCIVlIRUbPYouJOrtaPXJYKMms70FFPrmyIBl6La42SzCtr
	 GQ7tDDwU5+aq9OVWEu72tdgxr0br4wSaJbV+ZFkc=
Date: Tue, 18 Aug 2026 15:06:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20260818220636.CEF0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Tue, 18 Aug 2026 10:47:26 +0800

Lance reported that when nothing else causes the mm to be considered for
khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not
trigger scanning.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
into shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order
check reads vma->flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for
collapse.  As a result, khugepaged does not collapse the tmpfs file into
PMD order in time.

Fix this by calling khugepaged_enter_vma() with the new VMA flags in
madvise_update_vma().  Meanwhile we can remove the khugepaged_enter_vma()
in hugepage_madvise().

Link: https://lore.kernel.org/7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 ------
 mm/madvise.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs
+++ a/mm/khugepaged.c
@@ -452,12 +452,6 @@ int hugepage_madvise(struct vm_area_stru
 	case MADV_HUGEPAGE:
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
--- a/mm/madvise.c~mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs
+++ a/mm/madvise.c
@@ -177,6 +177,14 @@ static int madvise_update_vma(vm_flags_t
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vma->flags = new_vma_flags;
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
+		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
+
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch
mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch
selftests-mm-extend-the-check_huge-to-support-mthp-check.patch
selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch
selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch
selftests-mm-add-mthp-collapse-test-cases.patch

