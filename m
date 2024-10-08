Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7681863E
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352560; cv=none; b=kRG2qnskX7/+HXazikCczyoYzx7C64FZ2SreQivBkahHmt3fTl9Dk7YBSK9U/ge5MOYSbFLuzKLROmA7cusu5H5DFAYXh2WANqgl9FJfv5ODRWPrwvRH2UHkjrhjafMbRRTNMYXxDTtBfhPNU5azfdtkjyZM00xoKKnZ2mS7jnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352560; c=relaxed/simple;
	bh=OCCPNykeFmouIgJnyi6LdXc143zpi34M8EYQxvV2ukE=;
	h=Date:To:From:Subject:Message-Id; b=H8BlDD1cAHHlCIYir2SKUbpv6XdpvaMi6pMLk7CxHimEpTukdbhTsJHCf5iVdZoyhbVzRztvbxqfLtjMiQdjs5/ITxgAK/H569akVAD+mT1WOXr6z7yKUeApuYALiXXimzgHfALV/jYX7otMD0yqsebOqo+bDpS8Ik92xYwngNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rpm3pNSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rpm3pNSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05669C4CEC6;
	Tue,  8 Oct 2024 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352560;
	bh=OCCPNykeFmouIgJnyi6LdXc143zpi34M8EYQxvV2ukE=;
	h=Date:To:From:Subject:From;
	b=rpm3pNScstKehz09htyONKGj4QQSCpLXMJnxriTH5KI0SvoLn/BygTrNxe4mFYh7J
	 8RcLFVA93ajC+sWKa1hyHqQn3KYmHaXR3hHN4awMi7E4HNGnDE159VA3tATTFFxc6f
	 ie0rrQI7ZzO82OyaiXQc0UGDlZ+CXQt4DlqfbYB4=
Date: Mon, 07 Oct 2024 18:55:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-page_pgoff-in-more-places.patch added to mm-unstable branch
Message-Id: <20241008015600.05669C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use page_pgoff() in more places
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-page_pgoff-in-more-places.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-page_pgoff-in-more-places.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use page_pgoff() in more places
Date: Sat, 5 Oct 2024 21:01:13 +0100

There are several places which currently open-code page_pgoff(), convert
them to call it.

Link: https://lkml.kernel.org/r/20241005200121.3231142-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex/core.c  |    2 +-
 mm/page_vma_mapped.c |    3 +--
 mm/rmap.c            |    4 +---
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/futex/core.c~mm-use-page_pgoff-in-more-places
+++ a/kernel/futex/core.c
@@ -399,7 +399,7 @@ again:
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = folio->index + folio_page_idx(folio, page);
+		key->shared.pgoff = page_pgoff(folio, page);
 		rcu_read_unlock();
 	}
 
--- a/mm/page_vma_mapped.c~mm-use-page_pgoff-in-more-places
+++ a/mm/page_vma_mapped.c
@@ -340,7 +340,6 @@ next_pte:
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
-	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -348,7 +347,7 @@ unsigned long page_mapped_in_vma(struct
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(vma, pgoff, 1);
+	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
--- a/mm/rmap.c~mm-use-page_pgoff-in-more-places
+++ a/mm/rmap.c
@@ -775,7 +775,6 @@ static bool should_defer_flush(struct mm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
-	pgoff_t pgoff;
 
 	if (folio_test_anon(folio)) {
 		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
@@ -793,8 +792,7 @@ unsigned long page_address_in_vma(struct
 	}
 
 	/* The !page__anon_vma above handles KSM folios */
-	pgoff = folio->index + folio_page_idx(folio, page);
-	return vma_address(vma, pgoff, 1);
+	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

