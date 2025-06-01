Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31774156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756855; cv=none; b=dDuIOVPB8GlmZP6MJfj1Bk+9Yd3dEQUH7wIrc/6IWywKd0a7p9Cy1xG3kjUxelnGcSuJgtINBQ8lYsFbe/yvNjGjZ52+z+3r1v8bJ1/2WYToLjGRD4N5L30uGYuJsUPfA/NOAlvIpMV1T0KjJwIPj1lO8z0HxuK4dHLJv4+4q9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756855; c=relaxed/simple;
	bh=YOHBl1fQXtuM1cygVYTAgBdXi9+sOVgbmXIM3FFx6KM=;
	h=Date:To:From:Subject:Message-Id; b=HD8IyTrCmgFdCOBCfExr5+3CVVNr+4MTz5oHKX3Is86Pm11eYkutuZAy+z+Z1ZZPkwTMrVIpS+TdukGYCCv9uUU6AhyhDp2o+sfmyhb7Nxd6ntnfWEiPQpA44Y8Ehv7oXJokLGkDRMhN4XZc1lhcobEboNCbzha97JGKRfUBxEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rLZsxcIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rLZsxcIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A5BC4CEED;
	Sun,  1 Jun 2025 05:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756855;
	bh=YOHBl1fQXtuM1cygVYTAgBdXi9+sOVgbmXIM3FFx6KM=;
	h=Date:To:From:Subject:From;
	b=rLZsxcIiw4Ja5uZS+VjCx32vg6f5sEdXUQOQh28FfhECSXIc+v5+fVxtcKsakQJu3
	 hPAhlHO9+DjUUlxNfM6ihfu8Zub5wNZ0fKO+H4JJ4uPFp4zHvDqyVUSUxWt38/0o8u
	 zltjs6YXgwbajZMBz5XOJfEcs7vJBSvxctrxEDDc=
Date: Sat, 31 May 2025 22:47:34 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch removed from -mm tree
Message-Id: <20250601054735.04A5BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: update comment explaining why gup_fast() disables IRQs
has been removed from the -mm tree.  Its filename was
     mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/gup: update comment explaining why gup_fast() disables IRQs
Date: Wed, 28 May 2025 23:06:17 +0200

The current comment in gup_fast() talks about "IPIs that come from THPs
splitting", which is outdated and refers to the old THP splitting
implementation that was removed in commit ad0bed24e98b ("thp: drop all
split_huge_page()-related code"), which landed in v4.5.  Before then, THP
splitting involved a pmdp_splitting_flush(), which sent an IPI to
serialize against gup_fast().

Nowadays, we use tlb_remove_table_sync_one() to send IPIs that serialize
against gup_fast(); this is used, for example, in THP *collapsing* to stop
gup_fast() walks of a page table before depositing it.

Link: https://lkml.kernel.org/r/20250528-gup-irq-comment-fix-v1-1-b9d83c345333@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-update-comment-explaining-why-gup_fast-disables-irqs
+++ a/mm/gup.c
@@ -3299,7 +3299,7 @@ static unsigned long gup_fast(unsigned l
 	 * include/asm-generic/tlb.h for more details.
 	 *
 	 * We do not adopt an rcu_read_lock() here as we also want to block IPIs
-	 * that come from THPs splitting.
+	 * that come from callers of tlb_remove_table_sync_one().
 	 */
 	local_irq_save(flags);
 	gup_fast_pgd_range(start, end, gup_flags, pages, &nr_pinned);
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

