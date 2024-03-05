Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B67F;
	Tue,  5 Mar 2024 00:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599270; cv=none; b=X0SHREuthSnshQukUj1HZ23OODSGOyUxyRfzOy3VbFHsLdokK/XZPrenMsWrUuIyRWBxdYKTCGzVg6ncA0sJ2PFfD1LXEhckTTmQPbGYpIG5bFuamJWMYzDCKHIYJiazoHXV2Ds8PPv/SjhYkUTAP0kHtHle374deOc4P1CbLyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599270; c=relaxed/simple;
	bh=svO+vCnjpoVUyWzVSvPntB+V9YKOifn/6utT2/jTpZw=;
	h=Date:To:From:Subject:Message-Id; b=BSWH5PS5WMG6beID8ZbxK9vihUmQebNLyz1v4YvOJNeo6SRwxK6otzMvfnnSG+XSlNJjub+bumWyfbaTDCZdjY595wauUby+QyG8Jrkd6n8CYGelX6Equ8mlVcu0XrRan21YX5dprW0tnGg2Fb9rMnqsHgo5+PoveaheblT3JF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2d0nukZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2d0nukZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCE5C433F1;
	Tue,  5 Mar 2024 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599270;
	bh=svO+vCnjpoVUyWzVSvPntB+V9YKOifn/6utT2/jTpZw=;
	h=Date:To:From:Subject:From;
	b=2d0nukZK6JP8rmRet5ocP5+3ceAZT8Q1viCnaM9VzGjdTekwTPSaw5OzX2atJ7RR5
	 XoynKTl/0PjLZZPUhOxrJG1MqqnWjaOKfAIllY7KFuCn56bHFNiopAhwAShXPLmgVi
	 8oyKYYnFyMcHlL3she9yUBRBBvxGnliQzmjfWxaQ=
Date: Mon, 04 Mar 2024 16:41:09 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,david@redhat.com,aarcange@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch removed from -mm tree
Message-Id: <20240305004110.0BCE5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: fix unexpected change to src_folio when UFFDIO_MOVE fails
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: userfaultfd: fix unexpected change to src_folio when UFFDIO_MOVE fails
Date: Thu, 22 Feb 2024 16:08:15 +0800

After ptep_clear_flush(), if we find that src_folio is pinned we will fail
UFFDIO_MOVE and put src_folio back to src_pte entry, but the change to
src_folio->{mapping,index} is not restored in this process. This is not
what we expected, so fix it.

This can cause the rmap for that page to be invalid, possibly resulting
in memory corruption.  At least swapout+migration would no longer work,
because we might fail to locate the mappings of that folio.

Link: https://lkml.kernel.org/r/20240222080815.46291-1-zhengqi.arch@bytedance.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
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

mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch
mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch
s390-supplement-for-ptdesc-conversion.patch

