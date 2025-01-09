Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0702F2F
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736397289; cv=none; b=uzadHd7qvhYeDHhtX/Fj8jyYjSr9nyY31d0WfUsf/p1fs3opcp1H8rUmR5F+DyYLVFyP7n7UPmZXPdBwVOT8Mst7zo6s8DpEhgl42EIPYeFeNmuwpeOMxSGvEjggCLtxKu7R0+mpBKyWAkU8e5weuRN9cYVmdrM2VV1dIRuDNSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736397289; c=relaxed/simple;
	bh=ZR8k0Gsy8BsJXLaTDOX23L38DwDGX33iaeqZ1taMqGY=;
	h=Date:To:From:Subject:Message-Id; b=aaJOhnSQUFSArmWRzwGjW+66kTohbSFemC8EUjMSUbSSEIjGDiZGKvZqQLCow1fHeTYCNqbhDE2GQ64pPzMBaeZBpHKyRPkim5k9FjXyygFG71kY565TCvPTGmrfJ15POooCZk7jj+tn2TbGqF/Q5JZH1tFeG7zn1rktUn2D75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ey1bZDmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ey1bZDmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80788C4CED2;
	Thu,  9 Jan 2025 04:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736397288;
	bh=ZR8k0Gsy8BsJXLaTDOX23L38DwDGX33iaeqZ1taMqGY=;
	h=Date:To:From:Subject:From;
	b=ey1bZDmJSSAoj5mvNlw2Val+5PV93oFK+MfbxCGWIICSxsdeh23Dx+5frCIzEgTmY
	 8zLvbwts3tbJhkuh23rSQlMMFWFQDvb7+QxZNIDAAHlJwsNUpWGVvFQMfSMeIScwOG
	 3P8C8Ue5bx2bP69jTnqZFBX95NgLCdeNzyrapRSU=
Date: Wed, 08 Jan 2025 20:34:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,david@redhat.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch added to mm-hotfixes-unstable branch
Message-Id: <20250109043448.80788C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: fix memory loads ordering
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/hugetlb_vmemmap: fix memory loads ordering
Date: Wed, 8 Jan 2025 00:48:21 -0700

Using x86_64 as an example, for a 32KB struct page[] area describing a 2MB
hugeTLB, HVO reduces the area to 4KB by the following steps:

1. Split the (r/w vmemmap) PMD mapping the area into 512 (r/w) PTEs;
2. For the 8 PTEs mapping the area, remap PTE 1-7 to the page mapped
   by PTE 0, and at the same time change the permission from r/w to
   r/o;
3. Free the pages PTE 1-7 used to map, hence the reduction from 32KB
   to 4KB.

However, the following race can happen due to improperly memory loads
ordering:
  CPU 1 (HVO)                     CPU 2 (speculative PFN walker)

  page_ref_freeze()
  synchronize_rcu()
                                  rcu_read_lock()
                                  page_is_fake_head() is false
  vmemmap_remap_pte()
  XXX: struct page[] becomes r/o

  page_ref_unfreeze()
                                  page_ref_count() is not zero

                                  atomic_add_unless(&page->_refcount)
                                  XXX: try to modify r/o struct page[]

Specifically, page_is_fake_head() must be ordered after page_ref_count()
on CPU 2 so that it can only return true for this case, to avoid the later
attempt to modify r/o struct page[].

This patch adds the missing memory barrier and makes the tests on
page_is_fake_head() and page_ref_count() done in the proper order.

Link: https://lkml.kernel.org/r/20250108074822.722696-1-yuzhao@google.com
Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/20241128142028.GA3506@willie-the-truck/
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   37 +++++++++++++++++++++++++++++++++++
 include/linux/page_ref.h   |    2 -
 2 files changed, 38 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-fix-memory-loads-ordering
+++ a/include/linux/page-flags.h
@@ -225,11 +225,48 @@ static __always_inline const struct page
 	}
 	return page;
 }
+
+static __always_inline bool page_count_writable(const struct page *page, int u)
+{
+	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
+		return true;
+
+	/*
+	 * The refcount check is ordered before the fake-head check to prevent
+	 * the following race:
+	 *   CPU 1 (HVO)                     CPU 2 (speculative PFN walker)
+	 *
+	 *   page_ref_freeze()
+	 *   synchronize_rcu()
+	 *                                   rcu_read_lock()
+	 *                                   page_is_fake_head() is false
+	 *   vmemmap_remap_pte()
+	 *   XXX: struct page[] becomes r/o
+	 *
+	 *   page_ref_unfreeze()
+	 *                                   page_ref_count() is not zero
+	 *
+	 *                                   atomic_add_unless(&page->_refcount)
+	 *                                   XXX: try to modify r/o struct page[]
+	 *
+	 * The refcount check also prevents modification attempts to other (r/o)
+	 * tail pages that are not fake heads.
+	 */
+	if (atomic_read_acquire(&page->_refcount) == u)
+		return false;
+
+	return page_fixed_fake_head(page) == page;
+}
 #else
 static inline const struct page *page_fixed_fake_head(const struct page *page)
 {
 	return page;
 }
+
+static inline bool page_count_writable(const struct page *page, int u)
+{
+	return true;
+}
 #endif
 
 static __always_inline int page_is_fake_head(const struct page *page)
--- a/include/linux/page_ref.h~mm-hugetlb_vmemmap-fix-memory-loads-ordering
+++ a/include/linux/page_ref.h
@@ -234,7 +234,7 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page) && page_ref_count(page) != u)
+	if (page_count_writable(page, u))
 		ret = atomic_add_unless(&page->_refcount, nr, u);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch
mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-fix-pte-mapped-large-folios.patch

