Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837C1D516F
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744340420; cv=none; b=BX9ZOnvlzqLXzJ3nmopRRcQBEHF/VW1oRzr/00fOxJaAboYUfZjt31Th2nwRS7FsZXiTFQiC8WxUBFsY9IYhILU5OeWyGibu9MT74SpIJvJKwBtTviLKnxE4BBY3XHiQtni8JlvLPKHGh1HtuldB+pA4oVA+ay5cL//Y/sZAbA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744340420; c=relaxed/simple;
	bh=MawYz+WVD1Z0q9GOKsbpEivYbe/QBlLPznmcEGD1v+c=;
	h=Date:To:From:Subject:Message-Id; b=UByR1U7SiWkU9V58xd54PMri2vQlTKa23MDYBbC/64C/cdtvykCTO6EfbdXLswyNkyLNcAFRAyqin8ElvlSEL5olsrK/4+1tG1+VL0j9OLH3Dn7k8t6PtRJnU88LGesvnTcGWs2fMmB464p5R7Lb1t83J8RZB7GcjnvFHY3mAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PWH0KOvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PWH0KOvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C73DC4CEDD;
	Fri, 11 Apr 2025 03:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744340419;
	bh=MawYz+WVD1Z0q9GOKsbpEivYbe/QBlLPznmcEGD1v+c=;
	h=Date:To:From:Subject:From;
	b=PWH0KOvdYpq+A0KDguKJnQYiXPLEtjmI3Xg48WBC7t/89ULRKGWCOD290LSuum2ft
	 LnZ1luNrYoePs2xgE3PcQrHm5smo5zmta2UV33lh7oaQgRw9NbiCoX0it+HBwdZ49g
	 kuWCFVNWCPvzvlguj6ATM3nf2Zl6AwIzVesFtCpI=
Date: Thu, 10 Apr 2025 20:00:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,osalvador@suse.de,hannes@cmpxchg.org,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch added to mm-new branch
Message-Id: <20250411030019.5C73DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.txt
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.txt
Date: Fri, 11 Apr 2025 09:07:16 +0800

add comment

Link: https://lkml.kernel.org/r/23fdc11d-e983-4627-89a8-79e9ecf9a45a@linux.alibaba.com
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix
+++ a/mm/huge_memory.c
@@ -2260,6 +2260,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
 
+			/*
+			 * Use flush_needed to indicate whether the PMD entry
+			 * is present, instead of checking pmd_present() again.
+			 */
 			if (flush_needed && pmd_young(orig_pmd) &&
 			    likely(vma_has_recency(vma)))
 				folio_mark_accessed(folio);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

selftests-mincore-fix-tmpfs-mincore-test-failure.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch

