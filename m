Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8C6181D17
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782823; cv=none; b=adxmCrmgy5fGnzTo86ZkoP942g7b80dlsYhPSxsp4gyZLojyTg0S53DnDE//E0LY3ZGM7qz/psoAnIlkQYZgHDs208UKSlFQCOg748Y1z00vnXxSsuPnRFJ/so9GmOLH2shd8nLpikQssM3a4TyUZixYCc/eTvUAhxRNkGSfcmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782823; c=relaxed/simple;
	bh=0vuFLXG4h3OBpPY+WYLiVcUoSUBzlbTbSw22yu6rvYs=;
	h=Date:To:From:Subject:Message-Id; b=irR8xznJ18F4CZWnFOb2Z0+rf/TDvjmBXxFBvWoS77gu/CP/+xoOpx2ryWLYB7VX8CFJURMLxs5XXcXEvygkM0sGCZImwXKB1Jy6xqd6D26ohdKr2Y87vcnZANE7W3Rf+Igo9lYkF51JcqVHJMPA8jYCd5SbsKYX1WwHNlkjtWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GuOH7Q46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GuOH7Q46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E10C433F1;
	Wed, 10 Apr 2024 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782822;
	bh=0vuFLXG4h3OBpPY+WYLiVcUoSUBzlbTbSw22yu6rvYs=;
	h=Date:To:From:Subject:From;
	b=GuOH7Q46ZqxAALO8Wcy2e8lrxgrOc4+nfxe9HjLaSdF6RWJOs8V60LwVKYHpEYBHk
	 47sIROrbc4d+Ff/3URF3us7TK8eqCp7/kOvTTKn2S9MnsVqRIUnJ+ulpXQPA4AKgw7
	 ASMN/acqfE4QrGD4pt/ZN9bFiVYhA8fKIbpV5udU=
Date: Wed, 10 Apr 2024 14:00:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch added to mm-unstable branch
Message-Id: <20240410210022.78E10C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: use folio_mapcount() in zap_huge_pmd() sanity check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch

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
Subject: mm/huge_memory: use folio_mapcount() in zap_huge_pmd() sanity check
Date: Tue, 9 Apr 2024 21:22:51 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  Let's similarly check for folio_mapcount()
underflows instead of page_mapcount() underflows like we do in
zap_present_folio_ptes() now.

Instead of the VM_BUG_ON(), we should actually be doing something like
print_bad_pte().  For now, let's keep it simple and use WARN_ON_ONCE(),
performing that check independently of DEBUG_VM.

Link: https://lkml.kernel.org/r/20240409192301.907377-9-david@redhat.com
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

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check
+++ a/mm/huge_memory.c
@@ -1851,7 +1851,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 			folio = page_folio(page);
 			folio_remove_rmap_pmd(folio, page, vma);
-			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
 			swp_entry_t entry;
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

