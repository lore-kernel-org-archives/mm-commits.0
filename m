Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D61332A5;
	Thu,  4 Apr 2024 20:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261374; cv=none; b=bpckzGi8xROrZ4O1iOTTHwyn0kxjwrWJhi94ZCDLzkfb0wveoJ3MMgdML6OGiBSBbSMZCSFkvT79St3Lg9B9sApm8ghayNT+Asu8vGKRxRvbHag0uRT1/pWz76jt4T5nzg4S/kFM5aLEmgqRCqzUDXIZy2DvpN+XkE77xoQKEIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261374; c=relaxed/simple;
	bh=X/H1CHc0D+2EdqhFjLOoFlM2XCxEK1MPMzhCrV0Kj2k=;
	h=Date:To:From:Subject:Message-Id; b=UtB5uCeh74flSdTfi0zwCZx8vdFOAWD0BPR49gJvQ2CgL6u7RgOOARx/1nkjLmzL6NJ5PYE1DVJY3byIS/X/TPp+oytnRRKaWQjgNBrmtreblR6UsxRZ2dANilm2sVH9d9Z6rF/TVkVBSN/L2f9Imp9+ChIvFgY9EbrghBOJZ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sBGZTAnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sBGZTAnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B92C43390;
	Thu,  4 Apr 2024 20:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712261373;
	bh=X/H1CHc0D+2EdqhFjLOoFlM2XCxEK1MPMzhCrV0Kj2k=;
	h=Date:To:From:Subject:From;
	b=sBGZTAnNhaXaLYgeWrHrsSauvVJs7LFM3v84GUh2ieYhDCUauZBJSbw0jQlZv6z1Y
	 cxBC3NLU79poFSAvwOZDWjNhbGzzaRxoV4FlkuqNfYfEf5aq81TqcEYl0nBIb2Ebs4
	 fOCc7b12FohBOzWHToUqJUIuDkVgl/CgjjF9orkE=
Date: Thu, 04 Apr 2024 13:09:32 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,stable@vger.kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,david@redhat.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch added to mm-hotfixes-unstable branch
Message-Id: <20240404200933.D0B92C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: change src_folio after ensuring it's unpinned in UFFDIO_MOVE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
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

userfaultfd-change-src_folio-after-ensuring-its-unpinned-in-uffdio_move.patch

