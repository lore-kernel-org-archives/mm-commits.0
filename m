Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3EE299A82
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970760; cv=none; b=EzqFAbj57Rnns3JDBHiTKuPIcanoZsM4XOv/aWU3y9GXo9w9WQBdqTYAb0Kdp+qzjsl7dDlwrTkjHa1stolkA7q+5YETZ02cytS5Zetv/zuNC/gdb88XbLZzFbCetpF77g3jDmvboZ/AbshhrOcRfQWVnxtS8MoqEqgsFqwPABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970760; c=relaxed/simple;
	bh=QjkebwzQP+AS8AJFHe2r+TOnVMoDmIVXVwFX7lmMUm8=;
	h=Date:To:From:Subject:Message-Id; b=DwDNF1BLsTmI/2Rj7PkDXT76s2XqHx+Ny6t8gd0BMbcwJT9OW2hJY9MT+uKQMLhfVmf0Wo6HSDM8vFqLYhe9TO6NfpnYaeuywwNGui6c3OLGLgqE0CUz/k4mmaqJdFS6bcBLBznbv+vPak4g7/wFRlW1maoiCzY9K5Uefw+DCDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIQD0JCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIQD0JCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F191F000E9;
	Mon, 13 Jul 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783970758;
	bh=ST+FbA0st5OaMuYufV9lCLzQMBnDdVIsibzffX0gD/U=;
	h=Date:To:From:Subject;
	b=zIQD0JCntWIH7GWizee55wAZnR6n/+O1wx2GTzjqNsaE70LkOkWJgpJ+AiNaMOOW2
	 7eywcPQK+OyYlnpggk2kHDLHw1G/XLlsp9N3wIk0OAaX+RJth4s4PzjSxbqBgnVfpE
	 JrPf5yDuynsKadBbQQyHU0Z6IiKQalCSCaTaBj7Q=
Date: Mon, 13 Jul 2026 12:25:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-page-folio-for-hwpoison-checks.patch added to mm-new branch
Message-Id: <20260713192558.42F191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: convert page -> folio for hwpoison checks
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-convert-page-folio-for-hwpoison-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-page-folio-for-hwpoison-checks.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: convert page -> folio for hwpoison checks
Date: Mon, 13 Jul 2026 05:00:44 +0000

Patch series "mm/rmap: Refactor try_to_unmap_one", v3.

In preparation for batching anonymous large folio unmapping to optimize
it, refactor try_to_unmap_one.  This series refactors hugetlb,
anon-lazyfree and anon-swapbacked logic into their own functions,
significantly reducing the length of the huge try_to_unmap_one.


This patch (of 5):

try_to_unmap() receives hugetlb folios only from the hwpoison path. 
hugetlb_update_hwpoison() sets the hugetlb folio's head-page hwpoison bit,
and page_vma_mapped_walk() reports the hugetlb mapping at the head PFN, so
the previous PageHWPoison(subpage) check happened to work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap().  Hence it is always the case that if
try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it, convert VM_BUG_*
to VM_WARN_*.

Link: https://lore.kernel.org/20260713050050.1017741-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260713050050.1017741-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-convert-page-folio-for-hwpoison-checks
+++ a/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct foli
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/*
+		 * With TTU_HWPOISON, we only expect small folios or hugetlb
+		 * folios here for now.
+		 */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch

