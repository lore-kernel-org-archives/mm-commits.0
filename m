Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AC81E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010980; cv=none; b=NniyRF89l0UjNSRGR8xCfa0ry1iiKpGxsebkeMuowHQAvIhcxiyf7zn8qgpz58PxK8WtlBKjbh11OkVVodqUxg0+1cdPYAtRYSibtWHrKNLQ6e5bAkIDIQx5dqWZeI1189Gopqh0BhRICtRtrhHziBIP7rDuMZW0M/WYVm6REwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010980; c=relaxed/simple;
	bh=VOZV95xtXxUMZUVOfsQ8wTiQkFhGUbX3spcFNlFl6Es=;
	h=Date:To:From:Subject:Message-Id; b=timWXl5grlByt/9tUGTTpNuByU0/l81UGxTSmcOzo5suFm5UeOVGtrZ1IkXHdhPlKXpwZiu4gg2cZFwnqqJDSovDMkS8bndZHgitTGdYvrOYJmnQvHuhzGkApc8sGGB59XH8UKxtl42r7+COLOsog9tXylccKzO9KLlej9W8CrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZU801hdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZU801hdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BACBC4CEE4;
	Mon, 12 May 2025 00:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010979;
	bh=VOZV95xtXxUMZUVOfsQ8wTiQkFhGUbX3spcFNlFl6Es=;
	h=Date:To:From:Subject:From;
	b=ZU801hdEinDbf+61zY4LSq1zJCg3FA6lg32rrWdrYhvQo5xhIwRtkLvplkJJQhPmM
	 h7n8eZAbh9lpJzESh3TCIVv5wW7VKdYsAy7PW2zNDTdVhesyj71HsSLqtTApBidDCd
	 qLU6wy4H+TVo7tQtLEACBuonxOhwak57cteWcpbM=
Date: Sun, 11 May 2025 17:49:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-remove-custom-definition-of-mk_pte.patch removed from -mm tree
Message-Id: <20250512004939.5BACBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: remove custom definition of mk_pte()
has been removed from the -mm tree.  Its filename was
     x86-remove-custom-definition-of-mk_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: x86: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:58 +0100

Move the shadow stack check to pfn_pte() which lets us use the common
definition of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-remove-custom-definition-of-mk_pte
+++ a/arch/x86/include/asm/pgtable.h
@@ -784,6 +784,9 @@ static inline pgprotval_t check_pgprot(p
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
+	/* This bit combination is used to mark shadow stacks */
+	WARN_ON_ONCE((pgprot_val(pgprot) & (_PAGE_DIRTY | _PAGE_RW)) ==
+			_PAGE_DIRTY);
 	pfn ^= protnone_mask(pgprot_val(pgprot));
 	pfn &= PTE_PFN_MASK;
 	return __pte(pfn | check_pgprot(pgprot));
@@ -1080,22 +1083,6 @@ static inline unsigned long pmd_page_vad
  */
 #define pmd_page(pmd)	pfn_to_page(pmd_pfn(pmd))
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- *
- * (Currently stuck as a macro because of indirect forward reference
- * to linux/mm.h:page_to_nid())
- */
-#define mk_pte(page, pgprot)						  \
-({									  \
-	pgprot_t __pgprot = pgprot;					  \
-									  \
-	WARN_ON_ONCE((pgprot_val(__pgprot) & (_PAGE_DIRTY | _PAGE_RW)) == \
-		    _PAGE_DIRTY);					  \
-	pfn_pte(page_to_pfn(page), __pgprot);				  \
-})
-
 static inline int pmd_bad(pmd_t pmd)
 {
 	return (pmd_flags(pmd) & ~(_PAGE_USER | _PAGE_ACCESSED)) !=
_

Patches currently in -mm which might be from willy@infradead.org are


