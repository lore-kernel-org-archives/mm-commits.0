Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2D33EC;
	Sun,  5 Jul 2026 02:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783217310; cv=none; b=Dp2pRiO5xH0BCMGfbW5Lir1Z50vCd4uYYx1kmbyV1cNv6xInB3r8lfm//CKk4Dy07OCUGzCz7P1RmvH1+6yOLnLML7A4Xw2IK2BEsDhRCrU+bIc16gqE1EbYTre6gsZuTMxA3+PojN1n7EmG4gjK6eLihVrsLPTvUtB9Z7dXgSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783217310; c=relaxed/simple;
	bh=lTaUj7uF+90n/LsGOVnBH+5mFS/xSTVXDsvE8jJZ++g=;
	h=Date:To:From:Subject:Message-Id; b=FJKFqwMtYBEYj3hL7X68kE9cYNB5EB2qLjSfGJX95kGm1Jfxa0IgK9CTfhYW9/CgTY9NVItervfsyWipZARYs1FhGBRyfh9VSBOHBQOGUpbf8ovSuI3n2BMkSDuI1MubR4fxLl+rVCLHTAl1MqmwoM7gPXD4aydaHDT+pPsOA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uN+1IFvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uN+1IFvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AC81F000E9;
	Sun,  5 Jul 2026 02:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783217308;
	bh=nl3EQnBacKgUws6evdkNL++HkX2qCNVYd/S8Pfi4pYY=;
	h=Date:To:From:Subject;
	b=uN+1IFvxLHeKbOsJWcTb5DJpa+O2TviVGc0eQ9t06cGa2fYbyM90r/rA4HAWWQXLX
	 pPuofPSbHueUfMnMmrM3Jc6Cuw/gUhMemu2nIkbI3qJZCJWRWE6X62B2J5okj9gGsC
	 g/BDzkPcANEGU2AHHR//IIulEfeXq1Yl51Hg28v4=
Date: Sat, 04 Jul 2026 19:08:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch added to mm-hotfixes-unstable branch
Message-Id: <20260705020828.93AC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Fri, 3 Jul 2026 17:18:33 +0100

copy_hugetlb_page_range() clears the uffd-wp bit of hwpoison and migration
entries with huge_pte_clear_uffd_wp(), which operates on the present-PTE
bit position.  Swap entries keep the uffd-wp state elsewhere -- the same
branches read and set it with pte_swp_uffd_wp() and pte_swp_mkuffd_wp() --
and the present-PTE position falls into the swap payload.  On x86-64 it
lands in the inverted swap offset, where a naturally-aligned hugetlb PFN
always has the affected bit set, so the clear advances the encoded PFN by
two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child.  Instrumenting the hwpoison branch and
forking after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by folio
range and remove_migration_pte() rebuilds the PTE from the folio, so a
within-folio PFN skew heals once migration completes.  But any path that
re-encodes the corrupted offset -- e.g.  hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it, and an
hwpoison entry misidentifies which page is poisoned.

Use pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

Link: https://lore.kernel.org/20260703161833.57416-1-kirill@shutemov.name
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork
+++ a/mm/hugetlb.c
@@ -4918,7 +4918,7 @@ again:
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -4936,7 +4936,7 @@ again:
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
 			const pte_marker marker = copy_pte_marker(softleaf, dst_vma);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch

