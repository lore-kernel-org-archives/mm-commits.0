Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CD47764E
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 20:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711140509; cv=none; b=hg3Td9oqQ9beV3wAnw75Y7FrJJUQc5dF0RcDA95dOv1bq8FTAD+Kwk70tK3LvdE/a1esORMOytSmE7QpPh7x4XQw24RdrcYO2iOXuHiGdUUcUlsjpRV1x4j+ixOfBxgYvJT2ZYjI4baAMGnRgStAv2NgmJMHWwZ+TqiLoREWpQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711140509; c=relaxed/simple;
	bh=SH4VLBtmagCK3lAW9cBaeo6QfIPCxiGYCtLJbGHhhvY=;
	h=Date:To:From:Subject:Message-Id; b=DKuiijfriAGb39XCaddwGOBEnsd4oq2iXl4r6YWRg0GliHpmSP3Lc5IwZbhCcNLuSFtba66Nue3Wg2qGoKBF7Y+vw/DJzbUoiDUImNcq6WG5b5HV7eYFOwv1icRg680Xdn1PPEMDwIxcz2qd3q154KTDHdjXW8kulpfBuzj1OqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbx7dE35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbx7dE35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB32EC433C7;
	Fri, 22 Mar 2024 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711140508;
	bh=SH4VLBtmagCK3lAW9cBaeo6QfIPCxiGYCtLJbGHhhvY=;
	h=Date:To:From:Subject:From;
	b=dbx7dE35uLkJci6rVwfSmYdwIenh+uaVBf4pPG/pgjEpdjEFtigCo2a4R8IqwNsWD
	 3eDKassS7WoE3x+Hh5/CaZLNVUS8TwnTjNVFEEEYCmORbanf9NFhimEPV44kLO3zOB
	 dCYaoLHPanCI3BbjoLKCUj23rEoL2J4jaeZWUf28=
Date: Fri, 22 Mar 2024 13:48:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,rppt@kernel.org,riel@surriel.com,peterx@redhat.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-handle-hugepd-for-follow_page-fix.patch added to mm-unstable branch
Message-Id: <20240322204828.CB32EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-handle-hugepd-for-follow_page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-handle-hugepd-for-follow_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-handle-hugepd-for-follow_page-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-handle-hugepd-for-follow_page-fix
Date: Fri Mar 22 01:41:43 PM PDT 2024

fix build warning

mm/gup.c:33:21: warning: 'follow_hugepd' declared 'static' but never defined [-Wunused-function]
   33 | static struct page *follow_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
      |                     ^~~~~~~~~~~~~

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-handle-hugepd-for-follow_page-fix
+++ a/mm/gup.c
@@ -30,10 +30,12 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
 
+#ifdef CONFIG_HAVE_FAST_GUP
 static struct page *follow_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
 				  unsigned long addr, unsigned int pdshift,
 				  unsigned int flags,
 				  struct follow_page_context *ctx);
+#endif
 
 static inline void sanity_check_pinned_pages(struct page **pages,
 					     unsigned long npages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-gup-handle-hugepd-for-follow_page-fix.patch

