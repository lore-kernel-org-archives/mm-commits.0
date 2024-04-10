Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF0181BBC
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782835; cv=none; b=eflbXCXMKcA+xk/Fv3X5kmeX5uQ2XEZl41RjZaE80Nc0XoYSq7QR92TWbZXoSTDqifVXNU/J64IcmXKl332PI83y3xxLr1bWAZ34q/Xu9uWL3m7zejEZabaEBNwiRnvUiYeWsjSbLUZo/50s1X53MVPmAZ8MN5+Sc7sQqmJgh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782835; c=relaxed/simple;
	bh=CQ1EaGoVPBFs1UUBcK4EbRskUb1piUyE3IsaiFcK7P0=;
	h=Date:To:From:Subject:Message-Id; b=bG4je6zeGpYVNxOkyrQtzdoKSMYpoSID/ebmD984epoP44Az/GiLeGQGBy5WficJ3mTTob0sFk3SZ8QqnMoQCX23X8+zyz6opxI+XGdpzawn4/9fYlQcvWrWGhgkx6Yk+z386brImiRp87u/Q84WFxYsv/bR4LgbxdQs5YNu7ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKE5hVWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKE5hVWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20DCC433C7;
	Wed, 10 Apr 2024 21:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712782834;
	bh=CQ1EaGoVPBFs1UUBcK4EbRskUb1piUyE3IsaiFcK7P0=;
	h=Date:To:From:Subject:From;
	b=eKE5hVWzQ6QrJccAMFwT5A/LN+H+HVNOSv39RwvYOf34DbBaV0jPR8lexmsMHIdPx
	 ekTngvM5TLcKmGJGLt+3E/uLPMEIQid1wwVqqwGqz7aOVgi3xOB1fRL3aD1Cq/nkH4
	 ccvgnr40Uk4DnwB4JwrhruiL6XCuJojJQ6d64YPE=
Date: Wed, 10 Apr 2024 14:00:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch added to mm-unstable branch
Message-Id: <20240410210034.C20DCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xtensa/mm: convert check_tlb_entry() to sanity check folios
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch

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
Subject: xtensa/mm: convert check_tlb_entry() to sanity check folios
Date: Tue, 9 Apr 2024 21:22:59 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  So let's convert check_tlb_entry() to perform
sanity checks on folios instead of pages.

This essentially already happened: page_count() is mapped to
folio_ref_count(), and page_mapped() to folio_mapped() internally. 
However, we would have printed the page_mapount(), which does not really
match what page_mapped() would have checked.

Let's simply print the folio mapcount to avoid using page_mapcount().  For
small folios there is no change.

Link: https://lkml.kernel.org/r/20240409192301.907377-17-david@redhat.com
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

 arch/xtensa/mm/tlb.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/xtensa/mm/tlb.c~xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios
+++ a/arch/xtensa/mm/tlb.c
@@ -256,12 +256,13 @@ static int check_tlb_entry(unsigned w, u
 					dtlb ? 'D' : 'I', w, e, r0, r1, pte);
 			if (pte == 0 || !pte_present(__pte(pte))) {
 				struct page *p = pfn_to_page(r1 >> PAGE_SHIFT);
-				pr_err("page refcount: %d, mapcount: %d\n",
-						page_count(p),
-						page_mapcount(p));
-				if (!page_count(p))
+				struct folio *f = page_folio(p);
+
+				pr_err("folio refcount: %d, mapcount: %d\n",
+					folio_ref_count(f), folio_mapcount(f));
+				if (!folio_ref_count(f))
 					rc |= TLB_INSANE;
-				else if (page_mapcount(p))
+				else if (folio_mapped(f))
 					rc |= TLB_SUSPICIOUS;
 			} else {
 				rc |= TLB_INSANE;
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

