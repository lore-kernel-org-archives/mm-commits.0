Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89405964E4
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890130; cv=none; b=gD3PbG6Vp9/zRoVS7bcDSi2BXQXlFWjpr5myEObQkrKEAYvfND9cgc/DwyiXDkgVCKEnlAKKol4LMAD/O//8GBbNhnz0Z2M4wKIf4XOtlbsmJObhntnUuxJCKdiWfPkXtKV03vS61d5Pd7HtjcpuJXByzWCS7WuzahZhhz70QSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890130; c=relaxed/simple;
	bh=Itij2/SytrA7554sN/cekIgYKm1m+IT300+3l1Fz51g=;
	h=Date:To:From:Subject:Message-Id; b=u4WGMfhtLYAOCQJilUp5W5EuRfP0F6AFoInJS0U88jfAe7VphzFUMIQZ9gdJT7fj2K7GmR8puLZZlaM4eVp6iLKqQyf9tz+NWaD8ssljk2wky8lcUeBJKjFNwOhaAh3BXbkLFGHCmg/6ZWlf86qd8mU2SBc5ktig8Mzthw48qmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xYSc20lj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xYSc20lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AA81F00A3A;
	Tue,  8 Sep 2026 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890128;
	bh=pzmomtw165w/uZOZEPOLBdj0Gf0ol4LOj7VSF6A8Rbo=;
	h=Date:To:From:Subject;
	b=xYSc20ljaif1xSET1qyBh+WvyKQy2KP/vWylG6JqkR0Kr+HOiVRdCb6zLeWSHHc39
	 RD8QIAWb/SLSuEOUjKwbPSKVrXUALX/GM3VxXhKprSQcoc22hZEnhmslsnApbsfwBh
	 +3bSoFWqYDr/7VG8/f4Y4b4ixykuqTJLSIlHzUvw=
Date: Tue, 08 Sep 2026 10:55:27 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch added to mm-new branch
Message-Id: <20260908175528.32AA81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
Date: Tue, 08 Sep 2026 11:16:33 -0400

We already have the folio here, so use folio_page_swap_entry() instead of
going through page_swap_entry().  This saves a call to compound_head().

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-3-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio
+++ a/mm/rmap.c
@@ -2147,7 +2147,7 @@ static bool ttu_anon_swapbacked_folio(st
 {
 	const bool anon_exclusive = folio_test_anon(folio) &&
 				    PageAnonExclusive(page);
-	swp_entry_t entry = page_swap_entry(page);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (folio_dup_swap(folio, page) < 0)
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch

