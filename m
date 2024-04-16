Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF2E1E511;
	Tue, 16 Apr 2024 22:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307218; cv=none; b=flbfJCVN+8KMC1jO/9oJLJj7WbMdCeryrjxiWuCa6AQHeGBfAWgIrrEyVfSUoKpwDrXsg3DWnvXUQ7uPz7WDFufyknyyuEB7OFAxRtNEsE7Cu1mL9u1GoeU7Gxe9ZusqqPCzWBLx47RHIwC6OrIQVFna535Kv+s8epu0sMdqDYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307218; c=relaxed/simple;
	bh=n/hS5D3g+GGDIm69PXUIF4NlpDqcHGgRpIZkK8eIi3A=;
	h=Date:To:From:Subject:Message-Id; b=m93clQ2SqD7veOvdMiXdOI5N48YtwsBrpKq4bSPHYszO+Lz2ZugPzgYABGBCQE2v/XF10/PcboDcD6nwcQqjEidT5T523XDzyxitO2eQNYmuDVYF13+3PZ94vSoAnzs9exLHJUC3zEezKEqxAyTZFRzbfm0lVGkp+dPSPaqEnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AdtVpuPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AdtVpuPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7465C4AF08;
	Tue, 16 Apr 2024 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307217;
	bh=n/hS5D3g+GGDIm69PXUIF4NlpDqcHGgRpIZkK8eIi3A=;
	h=Date:To:From:Subject:From;
	b=AdtVpuPzj0cW9npObs4hYfEsofsgU83nNMVv6THC9TkeS7b13rXz/XxsMbxDy4r2t
	 ijyUWUBgAakODCo1B9HKR0mfsvYuqNSIiWgr3LpBZMugKSoampHRcSWQ8XAR1lEA9Y
	 4Tcs/5c43El4wPz/48u91Eiu/ahQl+4DSvGSIU8A=
Date: Tue, 16 Apr 2024 15:40:17 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,stable@vger.kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,david@redhat.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch removed from -mm tree
Message-Id: <20240416224017.C7465C4AF08@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: change src_folio after ensuring it's unpinned in UFFDIO_MOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: change src_folio after ensuring it's unpinned in UFFDIO_MOVE
Date: Thu, 4 Apr 2024 10:17:26 -0700

Commit d7a08838ab74 ("mm: userfaultfd: fix unexpected change to src_folio
when UFFDIO_MOVE fails") moved the src_folio->{mapping, index} changing to
after clearing the page-table and ensuring that it's not pinned.  This
avoids failure of swapout+migration and possibly memory corruption.

However, the commit missed fixing it in the huge-page case.

Link: https://lkml.kernel.org/r/20240404171726.2302435-1-lokeshgidra@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move
+++ a/mm/huge_memory.c
@@ -2259,9 +2259,6 @@ int move_pages_huge_pmd(struct mm_struct
 			goto unlock_ptls;
 		}
 
-		folio_move_anon_rmap(src_folio, dst_vma);
-		WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
-
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
 		/* Folio got pinned from under us. Put it back and fail the move. */
 		if (folio_maybe_dma_pinned(src_folio)) {
@@ -2270,6 +2267,9 @@ int move_pages_huge_pmd(struct mm_struct
 			goto unlock_ptls;
 		}
 
+		folio_move_anon_rmap(src_folio, dst_vma);
+		WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+
 		_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
_

Patches currently in -mm which might be from lokeshgidra@google.com are


