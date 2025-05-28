Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6DBA55
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748471775; cv=none; b=SI1zLDicQPN0GBtjj3y7iKCk6sIGIlrrCu4nq9MXsy0DoUzCV+xqLH8NLqSV0DLnLUukuyVefq4gVeqxNTkrkZbN6GbkjlW/OSJXggTm/5K/EjXcYP7A140RCa3NlYGaH44LXWmUrmJEcRSUsnl1kT7qZ7Ncfid8QXt21mA0b9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748471775; c=relaxed/simple;
	bh=t0WB34nK56N7hxbnQ8tzVn+KZJPJtPQoARIhvAaAZ8U=;
	h=Date:To:From:Subject:Message-Id; b=qbctRjb/ohhv0IiMAGvENPkBbpISfrOydiTiJyPgEaePz3emO5CWM1N0RCm6pdTiNYP5BKMk5tdUBBA4jPzirD6HIjUePmYHfJ1MdAhJaVqjrie0HINL/P2V9XCHS17RqHnsuoQzR1od8M2kA9uvo5LmfnOEWjK3hvjzn+MarE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xw+u6hLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xw+u6hLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE1FC4CEE3;
	Wed, 28 May 2025 22:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748471774;
	bh=t0WB34nK56N7hxbnQ8tzVn+KZJPJtPQoARIhvAaAZ8U=;
	h=Date:To:From:Subject:From;
	b=Xw+u6hLHvZuAMEuj4XrGDwJc26NYcrGbtwCNZKais3BoSKLwi+hucqkdcV1JM2W64
	 fJhA4KUV4tNNqM0JjkRqmDECPHKbmhZknasTqkGnqq8+w0WkB9P3U3TNzBCajoevJK
	 +bvqaw6aAUMSczJKI2gyvQYlsD5zxn0fwRjT7m/8=
Date: Wed, 28 May 2025 15:36:14 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch added to mm-unstable branch
Message-Id: <20250528223614.BAE1FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: update comment explaining why gup_fast() disables IRQs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch

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
mmu_notifiers-remove-leftover-stub-macros.patch
mm-gup-update-comment-explaining-why-gup_fast-disables-irqs.patch

