Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FC9225D6
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959028; cv=none; b=Bg0+ASQliah3Wo4+8RaOn68/oXTFK1B82RcwdTTD+lome5rTt5STAvwsQ4A3VptFX3U60vPQCBkZJkYIbqTldIgE0SkPiXDAo417gsMSLrnPkOgah9ra1jSp9v/gHLfS0QefhIvZkjI1zz7N4ZUKv1BLc0LVdHOlMUxonTIwTWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959028; c=relaxed/simple;
	bh=SWxp4+IHJeRD+39OufAlZlCVbolg29aRtA3fk+jIqxo=;
	h=Date:To:From:Subject:Message-Id; b=fyhFIqBV05KCAJjA/3vlcWpZbnOwlWllIltQnzpdGZS+b+wtKXjFCmjOnkMyv1gHevDzbjc0Z0Kk6eB4LDnBwLM6bNpD33bV5b+zwtW44E0KCKjBXuTzYz1gg2C22I30Nt+e4ec1UmlakG0fcNeJ7zrKONsimh1fo4Ct2DpeLXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1BSCmCiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1BSCmCiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA5FC4CEED;
	Tue, 12 Aug 2025 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959027;
	bh=SWxp4+IHJeRD+39OufAlZlCVbolg29aRtA3fk+jIqxo=;
	h=Date:To:From:Subject:From;
	b=1BSCmCiWSpBySDZWzyBV0QJLoWzJaFv+Kax/kswMq1w4kXk4uKVC87w+cdXQLgDz4
	 IVd1W0xxrtXC2b2pX9/yuXuUahr1W0a89xE0qAeCrCG9xmonRNGSTl3Ub8shP76/AK
	 5QqT3Q20RUU95h7HxXRO7xMshrF2GDb6eZeE4Oyo=
Date: Mon, 11 Aug 2025 17:37:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch added to mm-new branch
Message-Id: <20250812003707.8CA5FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Mon, 11 Aug 2025 13:26:23 +0200

Just like we do for vmf_insert_page_mkwrite() -> ...  ->
insert_page_into_pte_locked() with the shared zeropage, support the huge
zero folio in vmf_insert_folio_pmd().

When (un)mapping the huge zero folio in page tables, we neither adjust the
refcount nor the mapcount, just like for the shared zeropage.

For now, the huge zero folio is not marked as special yet, although
vm_normal_page_pmd() really wants to treat it as special.  We'll change
that next.

Link: https://lkml.kernel.org/r/20250811112631.759341-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd
+++ a/mm/huge_memory.c
@@ -1418,9 +1418,11 @@ static vm_fault_t insert_pmd(struct vm_a
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		folio_get(fop.folio);
-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		if (!is_huge_zero_folio(fop.folio)) {
+			folio_get(fop.folio);
+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		}
 	} else {
 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
 		entry = pmd_mkspecial(entry);
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

