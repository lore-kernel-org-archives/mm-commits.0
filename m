Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C258181BBC
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782836; cv=none; b=I/iwDa4PoTJ8AC6ywGxf4QtBqZPu07aaP/OaK+AJ/ZuGPVfd6nu3fFmx9Frznef2opBJIRPaBSwwHewJFb3xcNd3yJwhEJqVXePz/ljdHgvjAKRnhnqAmz0OBvd6x89gBuUbZrjF+yGH03e8lF4UguQ9RH1gBHl/pLP7lRZydn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782836; c=relaxed/simple;
	bh=Za5mrYu7s/sPTNkj0kuKLLIVHy5SWVmp7qkR6jRalOs=;
	h=Date:To:From:Subject:Message-Id; b=arICnkgohaVpVpBaT2HN3bd2kDtuAcWhHdUqEGRSQwanJGblM69Pz+I/ba3mfPAakDirS3n0odfXAUQLU+Hx00FxUymE9gAOUm6HF8GoIIYMCusTYtWqSqw4K6gjiy8o1EhhczYigefIcMoTuQfu6hEzxEVFqzEiN++GVpv+NQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcCuMbAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcCuMbAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F7EC433F1;
	Wed, 10 Apr 2024 21:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782836;
	bh=Za5mrYu7s/sPTNkj0kuKLLIVHy5SWVmp7qkR6jRalOs=;
	h=Date:To:From:Subject:From;
	b=PcCuMbAGt35T1Fol3Em6s5c6i6a66N6qDh+i/DJ5UTCC7oxXTznEYVMciCIXakkr2
	 C0BrOadCIFTMt05Usaq6/OQkQAWeaRErnSYMi6NiSrUQm7f6R652DdIgxmNVH6Chd+
	 Wuj4dz2q5W8WiDDEM89YxSXENRs72bzbfa2P6vyk=
Date: Wed, 10 Apr 2024 14:00:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch added to mm-unstable branch
Message-Id: <20240410210036.56F7EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: print only page mapcount (excluding folio entire mapcount) in __dump_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch

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
Subject: mm/debug: print only page mapcount (excluding folio entire mapcount) in __dump_folio()
Date: Tue, 9 Apr 2024 21:23:00 +0200

Let's simplify and only print the page mapcount: we already print the
large folio mapcount and the entire folio mapcount for large folios
separately; that should be sufficient to figure out what's happening.

While at it, print the page mapcount also if it had an underflow,
filtering out only typed pages.

Link: https://lkml.kernel.org/r/20240409192301.907377-18-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/debug.c~mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio
+++ a/mm/debug.c
@@ -55,15 +55,10 @@ static void __dump_folio(struct folio *f
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-	int mapcount = atomic_read(&page->_mapcount) + 1;
+	int mapcount = atomic_read(&page->_mapcount);
 	char *type = "";
 
-	/* Open-code page_mapcount() to avoid looking up a stale folio */
-	if (mapcount < 0)
-		mapcount = 0;
-	if (folio_test_large(folio))
-		mapcount += folio_entire_mapcount(folio);
-
+	mapcount = page_type_has_type(mapcount) ? 0 : mapcount + 1;
 	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch

