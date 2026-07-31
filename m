Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1F235C68A;
	Fri, 31 Jul 2026 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533057; cv=none; b=oAI8AjBG5cnwyg/tk/MPaAe6wobSqY5wBEe9CozJ0wRdu9okFDT3sKzOnQjJPK3K535PSs287pNTpMjNpkoeFpYyy3TTpybKaqTxx6TY+b/uVppLLJLAbL5JOUWZeiGAnqkGG/8Y8qOaiBF3fPhCnDG6M+o0tim9dQiu9iNNtq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533057; c=relaxed/simple;
	bh=LAVa+Jqi8e3kc30wzZjsT8ITerc7MFm/myygBSSE2r4=;
	h=Date:To:From:Subject:Message-Id; b=mOSUPaNsxZyWRmOs5fwvB4XYR7pYiBrM8oX3UO9RJvBiC3SJv+aM6Xzs1WQAlt6KjsakjO6obxQ+QRoYNzQQt1hPRH4zwCEuUrIjeuscrrYxRRhPSk7Y8bJSWjYceRmld4Hbryg1QmGdB7hfWgeUbyuW4ktWefvJYYx/sfncjaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YHfuv9Ew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YHfuv9Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C879F1F00AC4;
	Fri, 31 Jul 2026 21:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785533054;
	bh=yhTzcwMmo5+L4EEu+yeTY12a3tqiovbn/exVl/NGpII=;
	h=Date:To:From:Subject;
	b=YHfuv9Ewv/h/0FDtvym9ulmE0JXTb6nKkVm4lJoGi4hcjzlsZN7BQ44HH3OGD77dl
	 +L31hfP2hSTZL3SlDTDKLHN3awvJrXwTdkzPzuzTJWSUrQcCLPz00ynPo/daLNjPaz
	 tSqz22MYrwKHwp1A/21xQjDpQ2JGxQABESsUda10=
Date: Fri, 31 Jul 2026 14:24:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,hughd@google.com,ackerleytng@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch added to mm-new branch
Message-Id: <20260731212414.C879F1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
Date: Fri, 31 Jul 2026 22:27:53 +0200

folio_may_be_lru_cached() is currently only true for small folios, and
for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
of 1 in try_grab_folio()/try_grab_folio_fast().

Consequently, our

	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1

check in collect_longterm_unpinnable_folios() will currently always
identify "reference mismatch" and first drain the local LRU cache to then
drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
is really called after pinning the folios with FOLL_PIN.

Add a comment because the current code is not quite intuitive: we used to
drain only to make sure the folio_isolate_lru() would succeed. But then we
also started draining to make later migration more reliable.

We'll refactor that code soon a bit, to also make it usable in other
context where we really want to remove any references from LRU caches.

Let's add CC stable, because having an easy way for excessive LRU cache
draining on all CPUs does not sound right. In common scenarios we
don't expect to every have to drain.

Link: https://lore.kernel.org/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios
+++ a/mm/gup.c
@@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_un
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
+		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain_all();
 			drained = 2;
 		}
_

Patches currently in -mm which might be from david@kernel.org are

x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

