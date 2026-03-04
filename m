Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F95196C7C;
	Wed,  4 Mar 2026 01:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772588570; cv=none; b=uEL7eabKDw/M08EehlgqMH+v2hKcZIS60KTd3ux7OpCOJYfyHaz7de1k5/cmHme7Ul7xHb+XA4AVPYRNevbLe9eeama6NhPJ4fWjk+YagYju0hQR7DNGdHomBjd1WSgvTLMj2tgs4tCFate4spzKQ5FZUQA1ZQ+94aPy+Z7OzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772588570; c=relaxed/simple;
	bh=8gOQlvdoI19rixxVH2WjXRTfXkvIs7I0lb0cQJLNYx0=;
	h=Date:To:From:Subject:Message-Id; b=eZocmwDbiHGgfJzqPvamgoz2swO2aBoIp8QsfMBZg4UO8cF3wuTm0kSVh3wVfdpSQJR+LZDCAhe5sAZZPeKApDuPDhhUAOc6njCdXmramZQzMZ0iB/fvYGpgGWMiZKN5qZ2hFik3ikouO6/jmV1H0JRXQ/CbUytKi8FjCESkfgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zSQGIbJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zSQGIbJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B658C116C6;
	Wed,  4 Mar 2026 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772588570;
	bh=8gOQlvdoI19rixxVH2WjXRTfXkvIs7I0lb0cQJLNYx0=;
	h=Date:To:From:Subject:From;
	b=zSQGIbJuSxzJo+VSY/P1DfBAapqI/RG38aoEl8SpZ6m9md6DsVqP0UmIqjjX1/Kie
	 wXfbjhXmMMO5oMkIRcOyj5laS0t+seuUdtxaYIQL7Xq3/Ne+qfRAr7eipJVeUJoYgY
	 wW+bQCTHdqS8khiUdewe3enrrG0x293CC+DR+IaE=
Date: Tue, 03 Mar 2026 17:42:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-use-of-null-folio-in-move_pages_huge_pmd.patch added to mm-hotfixes-unstable branch
Message-Id: <20260304014250.1B658C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-use-of-null-folio-in-move_pages_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-use-of-null-folio-in-move_pages_huge_pmd.patch

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
From: Chris Down <chris@chrisdown.name>
Subject: mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()
Date: Tue, 3 Mar 2026 07:21:21 +0000

move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
zero pages.  For the huge zero page path, src_folio is explicitly set to
NULL, and is used as a sentinel to skip folio operations like lock and
rmap.

In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
pgprot) passes NULL through folio_pfn() and page_to_pfn().  With
SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
pointing to non-existent physical memory.  On other memory models it is a
NULL dereference.

Use page_folio(src_page) to obtain the valid huge zero folio from the
page, which was obtained from pmd_page() and remains valid throughout.

After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge
zero folio special"), moved huge zero PMDs must remain special so
vm_normal_page_pmd() continues to treat them as special mappings.

move_pages_huge_pmd() currently reconstructs the destination PMD in the
huge zero page branch, which drops PMD state such as pmd_special() on
architectures with CONFIG_ARCH_HAS_PTE_SPECIAL.  As a result,
vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
and corrupt its refcount.

Instead of reconstructing the PMD from the folio, derive the destination
entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
metadata the same way move_huge_pmd() does for moved entries by marking it
soft-dirty and clearing uffd-wp.

Link: https://lkml.kernel.org/r/a1e787dd-b911-474d-8570-f37685357d86@lucifer.local
Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-use-of-null-folio-in-move_pages_huge_pmd
+++ a/mm/huge_memory.c
@@ -2797,7 +2797,8 @@ int move_pages_huge_pmd(struct mm_struct
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
+		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-huge_memory-fix-use-of-null-folio-in-move_pages_huge_pmd.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

