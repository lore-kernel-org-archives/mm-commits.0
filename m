Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82038C2A0;
	Mon,  2 Mar 2026 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484648; cv=none; b=je9O/ZQWmignDYNDgqHeG6EG28D4rKa4c+PAB8soGGX2BTljc0fgenVDtgAye/fhfQ8D10F5/iX3D+pYiyDNX5W2PfDwjNEY801Y4XwRN0ZQqLTy/4qEMPb+swxQ7hn8xhMunkGNH7ZRRLqoPGw7cImwOxb08GnhLf5VZ/4ARK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484648; c=relaxed/simple;
	bh=pCLHO0vnQiSXr/GSP2+voEAuCidxHvmeIhB2m/IisHs=;
	h=Date:To:From:Subject:Message-Id; b=MqLqajV/rekDJWe1niQ1OKm8Z9Yd0U+82grydNeOMYj95PScuNZhh9qrKlQnaYWXPhTSasSyd+UuqCkW0CXuEbLEWAybDeQ4xs5Imo8xVH++ljk1C+5Z0gPH72FIIJdB0NdJMxJJYF3S4km+SJ8Y9d2w78GeFMSe12YXlqB8bIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgPkmcCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgPkmcCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54B7C19425;
	Mon,  2 Mar 2026 20:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772484647;
	bh=pCLHO0vnQiSXr/GSP2+voEAuCidxHvmeIhB2m/IisHs=;
	h=Date:To:From:Subject:From;
	b=CgPkmcCQhXBI+a9KVqhec9owuSTntaLGCod+2L2hODJDFpZkJCFC6CXpnoA02DGwj
	 cCHUSUKBkbhl/brKQeCkCq6AMZYYLqA/kOfFTaPQ1DwNssFNNcLHnXz7GV19zui9zL
	 vsTKJ/Qs4hFWKZe5Upq28cDAQO3wm1w9aO4TFpjI=
Date: Mon, 02 Mar 2026 12:50:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-memory-corruption-on-huge-zero-page-move.patch added to mm-hotfixes-unstable branch
Message-Id: <20260302205047.A54B7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix memory corruption on huge zero page move
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-memory-corruption-on-huge-zero-page-move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-memory-corruption-on-huge-zero-page-move.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/huge_memory: fix memory corruption on huge zero page move
Date: Mon, 2 Mar 2026 17:06:19 +0000

In commit eb1521dad8f3 ("userfaultfd: handle zeropage moves by
UFFDIO_MOVE"), handling was added to enable the moving of huge zero pages
in move_pages_huge_pmd().

This achieves this by setting src_folio to NULL, and adding subsequent
checks for src_folio being NULL to determine whether to perform the usual
move operations or to simply establish the huge zero page in the
destination.

As part of this change, when installing the destination huge zero page it
invoked mk_huge_pmd() on src_page, correctly.

However, commit e3981db444a0 ("mm: add folio_mk_pmd()") updated the code
in the huge zero page branch from mk_huge_pmd(src_page, ...) to
folio_mk_pmd(src_folio, ...), where src_folio is guaranteed to be NULL at
this point.

This resulted in an invocation of folio_mk_pmd(NULL, ...) in effect, which
causes an invocation of page_to_pfn(0) and results in the installation of
a corrupted PMD entry and undefined behaviour.

This patch fixes the issue by obtaining the zero folio via
page_folio(src_page) and feeding this into folio_mk_pmd().  This retains
the use of folio_mk_pmd() whilst avoiding the memory corruption.

Additionally, this code path was not updated to reflect the changes
introduced by commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of
the huge zero folio special"), meaning a zero huge folio was installed but
not marked special in this case.

This patch additionally fixes that issue by invoking pmd_mkspecial().

With thanks to Chris Down who exposed this bug by adding an explicit test
for UFFDIO_MOVE in commit f07254dce67d ("selftests/mm: add UFFDIO_MOVE
huge zeropage PMD regression test").

Link: https://lkml.kernel.org/r/20260302170619.867056-1-lorenzo.stoakes@oracle.com
Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-memory-corruption-on-huge-zero-page-move
+++ a/mm/huge_memory.c
@@ -2796,8 +2796,12 @@ int move_pages_huge_pmd(struct mm_struct
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
+		struct folio *zero_folio = page_folio(src_page);
+
+		VM_WARN_ON_ONCE_FOLIO(!is_huge_zero_folio(zero_folio), zero_folio);
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = pmd_mkspecial(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-huge_memory-fix-memory-corruption-on-huge-zero-page-move.patch

