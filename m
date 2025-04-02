Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405841E8326
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631387; cv=none; b=BqXIjgsXI5Kra66q6wb5DcaasrpNDM4quw1bscOfeuSigMZCYiIOFG71nFx2h/rBDce+4yps2sYIUFilxh2QqX5+uu7gP51cv5kQRzCssB4KgHNkMMulE/TTdFAIppDnQ/mApW79u79dtAiYDIgEXoS5p34cAlsoH1gAwq84aKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631387; c=relaxed/simple;
	bh=9KaUpZb7YW1iFJXI5UOxiuMF4RF0PxW+0NekXCPMSdI=;
	h=Date:To:From:Subject:Message-Id; b=QeZ3975mp2z75PT4dOrN7PdJko2PjwNkNCJDHISu5xhYj24+5CiebXwnJ3ngN9aeOVKykWlMh59ZBVvJly/xlyzsyXt2xVjVLY09YhL8K4p3RNDda+sAVcDc3eGish9l33c5kgojekNvVQRiDq0C5VKJfmKXoB/o/339mqwZ624=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5m7gz0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5m7gz0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146E6C4CEDD;
	Wed,  2 Apr 2025 22:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631387;
	bh=9KaUpZb7YW1iFJXI5UOxiuMF4RF0PxW+0NekXCPMSdI=;
	h=Date:To:From:Subject:From;
	b=E5m7gz0/ecsIjMSybRBcPa4OSP7C0SEq3IkiyXt5KzCbWeyVDz91QJ6NFWhyLt76m
	 5cVEvem5qx7VNDlssWmDgZX/hYa6FQ2CAdEGzD6cOAvG94aS/XM71DFctJZ2d6aQvZ
	 bQnW5dE6t39jX27wTpDiQiC6zCNrKQogoYreE8ng=
Date: Wed, 02 Apr 2025 15:03:06 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-mk_pte-definition-unconditional.patch added to mm-new branch
Message-Id: <20250402220307.146E6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make mk_pte() definition unconditional
has been added to the -mm mm-new branch.  Its filename is
     mm-make-mk_pte-definition-unconditional.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-mk_pte-definition-unconditional.patch

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
Subject: mm: make mk_pte() definition unconditional
Date: Wed, 2 Apr 2025 19:17:00 +0100

All architectures now use the common mk_pte() definition, so we can remove
the condition.

Link: https://lkml.kernel.org/r/20250402181709.2386022-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 include/linux/mm.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mm.h~mm-make-mk_pte-definition-unconditional
+++ a/include/linux/mm.h
@@ -1987,14 +1987,12 @@ static inline struct folio *pfn_folio(un
 	return page_folio(pfn_to_page(pfn));
 }
 
-#ifndef mk_pte
 #ifdef CONFIG_MMU
 static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 {
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
 #endif
-#endif
 
 static inline bool folio_has_pincount(const struct folio *folio)
 {
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

