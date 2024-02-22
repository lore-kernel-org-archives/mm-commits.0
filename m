Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28FF1B5B7
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708635976; cv=none; b=OzmGLTCXO5U6QQWifjbssmPEa1ssyhJYVFJIo6ta8S0m1d3njtIOg5Frw+Og3o4BbcDmOqn8O8s5vS3tvKYjlUSqzSMWVwUTOjBW/0ttdUi+mJ+hRKOYAuXY0/s4XIBjcA7sheefhTBnMLC2iHgPZiSegUoNXGCB35K3AHjYV4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708635976; c=relaxed/simple;
	bh=KTPgZFoaX8C5r8UTUB0kfiZLtk2aCRtqz4zzh9GGN4I=;
	h=Date:To:From:Subject:Message-Id; b=Q/GGaGDO6Q3/mlZCgQObMZmKGAG4sZ3cZfGujF/tBahZZxZmnOGuO9BytxW1kBesRRQqE7H/oG0M5Qg3DZkmsRPMQrC1iBzCt+HIugkaMDdcSe0hfIYX5PJg9SSOpeqdoP1d0fmmmw5jvPYbSb9WJLltJtWOE0q1D0Xt9iMJoG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PH+qKc+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PH+qKc+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13759C433F1;
	Thu, 22 Feb 2024 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708635976;
	bh=KTPgZFoaX8C5r8UTUB0kfiZLtk2aCRtqz4zzh9GGN4I=;
	h=Date:To:From:Subject:From;
	b=PH+qKc+f4mamLQsxFLgNwMRSYhJzGwLWiyKy0Lag0MS86LEJoDWv32Urw3IL6bH/H
	 w2eMy5wCAYdyzzQD+td3DfQKJq3IlZi2PsAGJ5NKfMTZE91fDpiOd1ieBiMIiqNBhA
	 oVEvmcB2oYqvK74CEZZfJvlCZSxhLFkBSsSjWhqQ=
Date: Thu, 22 Feb 2024 13:06:15 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,david@redhat.com,aarcange@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20240222210616.13759C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: fix unexpected change to src_folio when UFFDIO_MOVE fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: userfaultfd: fix unexpected change to src_folio when UFFDIO_MOVE fails
Date: Thu, 22 Feb 2024 16:08:15 +0800

After ptep_clear_flush(), if we find that src_folio is pinned we will fail
UFFDIO_MOVE and put src_folio back to src_pte entry, but the change to
src_folio->{mapping,index} is not restored in this process. This is not
what we expected, so fix it.

Link: https://lkml.kernel.org/r/20240222080815.46291-1-zhengqi.arch@bytedance.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails
+++ a/mm/userfaultfd.c
@@ -914,9 +914,6 @@ static int move_present_pte(struct mm_st
 		goto out;
 	}
 
-	folio_move_anon_rmap(src_folio, dst_vma);
-	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
-
 	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
 	/* Folio got pinned from under us. Put it back and fail the move. */
 	if (folio_maybe_dma_pinned(src_folio)) {
@@ -925,6 +922,9 @@ static int move_present_pte(struct mm_st
 		goto out;
 	}
 
+	folio_move_anon_rmap(src_folio, dst_vma);
+	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+
 	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
 	/* Follow mremap() behavior and treat the entry dirty after the move */
 	orig_dst_pte = pte_mkwrite(pte_mkdirty(orig_dst_pte), dst_vma);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch

