Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD06EFC0A
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631379; cv=none; b=emGGAvN0zHOUESCSVrlhR8MZR3HW8C6TT2ymuiJmrvQMQWaYuMbEnPbsQR7h+cbFn5x30hr5D6YAa1d3NBdh6Gf/65V1zcWoan4gf2PG/IRGKdHrkrdz0X6odzJsP0cj+/Lgd8fhOML0YTtqST4awXUSE4mJP71uzryKOFbXR+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631379; c=relaxed/simple;
	bh=Rzgsq53dN+TZNsFwoY0OY8cM+L2H2GnJZuNp6gcMtcY=;
	h=Date:To:From:Subject:Message-Id; b=BgSqPZcIznJ0+vr66Jo7SjENyKNSxPL16AiRQMpmb5ozivH/Bdc7ApNOfDZq7lun4i7vZeb5kxskgJR9EYHc2LMoikzU1Thd74utedoH+Ftcr4BRQ7uvMaDMkBzHttVpeqELZrkcz7IpU+zzJ6yladxfc5kbHifzddS1oMkkTLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l829XKlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l829XKlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8C2C4CEE7;
	Wed,  2 Apr 2025 22:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631377;
	bh=Rzgsq53dN+TZNsFwoY0OY8cM+L2H2GnJZuNp6gcMtcY=;
	h=Date:To:From:Subject:From;
	b=l829XKlg9h4gz3S/V34vBz1NOCy1PMcD46ebCGnhXmVRRwr7KuPHGv4pkVSfr04Y7
	 cSzXmwnINSlHInHNanH8ba8SNjp/af7+WqOualBmeMMTk2u6TQYZIHDKYbW3H1QT26
	 1UPYusmjxwPbzJqE6sDzaY6bKzitm+GL8Q6fsHpU=
Date: Wed, 02 Apr 2025 15:02:56 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch added to mm-new branch
Message-Id: <20250402220257.9D8C2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: set the pte dirty if the folio is already dirty
has been added to the -mm mm-new branch.  Its filename is
     mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch

This patch will later appear in the mm-new branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: set the pte dirty if the folio is already dirty
Date: Wed, 2 Apr 2025 19:16:55 +0100

Patch series "Add folio_mk_pte()", v2.

Today if you have a folio and want to create a PTE that points to the
first page in it, you have to convert from a folio to a page.  That's
zero-cost today but will be more expensive in the future.

I didn't want to add folio_mk_pte() to each architecture, and I didn't
want to lose any optimisations that architectures have from their own
implementation of mk_pte().  Fortunately, most architectures have by now
turned their mk_pte() into a fairly bland variant of pfn_pte(), but s390
has a special optimisation that needs to be moved into generic code in the
first patch.

At the end of this patch set, we have mk_pte() and folio_mk_pte() in mm.h
and each architecture only has to implement pfn_pte().  We've also
eliminated mk_huge_pte(), mk_huge_pmd() and mk_pmd().


This patch (of 11):

If the first access to a folio is a read that is then followed by a write,
we can save a page fault.  s390 implemented this in their mk_pte() in
commit abf09bed3cce ("s390/mm: implement software dirty bits"), but other
architectures can also benefit from this.

Link: https://lkml.kernel.org/r/20250402181709.2386022-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250402181709.2386022-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com> # for s390
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    7 +------
 mm/memory.c                     |    2 ++
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-set-the-pte-dirty-if-the-folio-is-already-dirty
+++ a/arch/s390/include/asm/pgtable.h
@@ -1450,12 +1450,7 @@ static inline pte_t mk_pte_phys(unsigned
 
 static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 {
-	unsigned long physpage = page_to_phys(page);
-	pte_t __pte = mk_pte_phys(physpage, pgprot);
-
-	if (pte_write(__pte) && PageDirty(page))
-		__pte = pte_mkdirty(__pte);
-	return __pte;
+	return mk_pte_phys(page_to_phys(page), pgprot);
 }
 
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
--- a/mm/memory.c~mm-set-the-pte-dirty-if-the-folio-is-already-dirty
+++ a/mm/memory.c
@@ -5245,6 +5245,8 @@ void set_pte_range(struct vm_fault *vmf,
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	else if (pte_write(entry) && folio_test_dirty(folio))
+		entry = pte_mkdirty(entry);
 	if (unlikely(vmf_orig_pte_uffd_wp(vmf)))
 		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch
mm-introduce-a-common-definition-of-mk_pte.patch
sparc32-remove-custom-definition-of-mk_pte.patch
x86-remove-custom-definition-of-mk_pte.patch
um-remove-custom-definition-of-mk_pte.patch
mm-make-mk_pte-definition-unconditional.patch
mm-add-folio_mk_pte.patch
hugetlb-simplify-make_huge_pte.patch
mm-remove-mk_huge_pte.patch
mm-add-folio_mk_pmd.patch
arch-remove-mk_pmd.patch
filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

