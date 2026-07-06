Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409FF233926
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360619; cv=none; b=AR2jqIib+8353/KTesOlxFQ4H0YgP5h4uN/UrEyRWl7EpSopOcnsRQmePZ0U/MpzrNXHA7cZNr7FhJalgweN3hGYRo1jq/x5yCb+wGHmYT+nXK51hG6hHYImYazegvnfwFUA/H85Ir+QmikrW1OMUj68ao9n6IgZL7coMWfiQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360619; c=relaxed/simple;
	bh=KJ0tNeQoT6OtnP8zAd4/IHIB0mfaIb9wI5bLbI19eF8=;
	h=Date:To:From:Subject:Message-Id; b=FVHTi3fv6C6FQQNzpUEfT2T/NErftFUPz8F2a9MrmuipjsAsUYbW4to4KkEjyYqk5qfcEw6omk5eaim+AANR/MQ1tS3LmhrTNo7gYYJyX89ywXXkXYAjT5m+ITdINhVBlyiNBbOuV7129iaYQToKesndvRCDE4ef8lCzcfzNemY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKntZDfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKntZDfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF49D1F000E9;
	Mon,  6 Jul 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360618;
	bh=n+o7hYpZL1QIsxXsih0YdKD/6JJS9RInOntAfB8251o=;
	h=Date:To:From:Subject;
	b=EKntZDfoPXzcRnfzfW2NkPdGyMc+uk262fYXLsNL31iMNFyu+E1s7PnZXBC/IsjEc
	 mm9nild42Rj1MOP5n6HzSPGM1ShzHsN1goqyIgXXWbeTgWrRWmcXFCKMCDtfKkuzH5
	 c4ULTmXMvRxZrzjloK4GhWBjtVB2zO3Do14M2pjI=
Date: Mon, 06 Jul 2026 10:56:57 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch added to mm-unstable branch
Message-Id: <20260706175657.DF49D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch

This patch will later appear in the mm-unstable branch at
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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
Date: Mon, 6 Jul 2026 04:42:07 -0700

migrate_vma_collect_pmd() calls softleaf_to_folio() on a non-present PMD
before checking the entry's type.  softleaf_to_folio() converts the
entry's offset to a PFN, which is only meaningful for migration or
device-private entries.

A PMD swap entry's offset is a swap offset, not a PFN, so the lookup would
either return a bogus folio pointer or trip pfn_to_page validation on a
debug kernel.  In the non-device-private path the returned folio is then
unused (the OR short-circuits to migrate_vma_collect_skip()), but the
lookup itself is already unsafe.

Move the softleaf_to_folio() call inside the device-private branch where
the folio is actually needed, mirroring the equivalent
change_non_present_huge_pmd() fix.

Link: https://lore.kernel.org/20260706114320.1643046-6-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch
+++ a/mm/migrate_device.c
@@ -166,11 +166,14 @@ static int migrate_vma_collect_huge_pmd(
 	} else if (!pmd_present(*pmdp)) {
 		const softleaf_t entry = softleaf_from_pmd(*pmdp);
 
-		folio = softleaf_to_folio(entry);
-
 		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
+		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner) {
 			spin_unlock(ptl);
 			return migrate_vma_collect_skip(start, end, walk);
 		}
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

