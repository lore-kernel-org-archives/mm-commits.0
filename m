Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BAC46434
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247741; cv=none; b=sIszVscOfR/wMHfcENISlNaOalSiqMdHQRsyo0ioUiJm3Om4OMojulzmjGY/uSO///Mrei/4JiPQlanvcaW8O3VxO6xxmtgBF+WuTz+FbAK4kOdD6U5MfO285Dkk4JOfWQO/D5sTKYcm0olzzXR7CF5xrlleJ7ltruyV1xueGnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247741; c=relaxed/simple;
	bh=6T8sF/h9+eEiaOqS3RCte/B8w9SmeURAdW0HLAt5avc=;
	h=Date:To:From:Subject:Message-Id; b=VRhz/ueFmhyH9CGZD7+dCkwHb31RnC/aULSiufkT0PC2YLi8Yr6ySWu8hsCEZjM9NE1+TqkbpnDA9d0ZeTpUZjQK7c7d/SlKNbFe5OWoh+jUz2aUTJeujCH6vLSuu+DugckCQhoP3AzyHoiPovg89r7nJW0O/DjVfYSR27Euinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FeOzo4t/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FeOzo4t/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C23C4CEC2;
	Mon,  2 Sep 2024 03:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247741;
	bh=6T8sF/h9+eEiaOqS3RCte/B8w9SmeURAdW0HLAt5avc=;
	h=Date:To:From:Subject:From;
	b=FeOzo4t/fUPhtfZ++RPQj50Rr5De1bELH6ScSOU6DIX3okg8X6PqTJiZ9TD1enZt+
	 86ylCChgYTx7t/yrgeZRvwocD2N+8hP4djMLrWnb1vjbSvqJXtg6IGJhc2bqwLph4i
	 X1cq5XhMY8H2yCqxL7h4kxppgDmyihNqjCPd3xW0=
Date: Sun, 01 Sep 2024 20:29:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch removed from -mm tree
Message-Id: <20240902032901.57C23C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: provide vm_normal_(page|folio)_pmd() with CONFIG_PGTABLE_HAS_HUGE_LEAVES
has been removed from the -mm tree.  Its filename was
     mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: provide vm_normal_(page|folio)_pmd() with CONFIG_PGTABLE_HAS_HUGE_LEAVES
Date: Fri, 2 Aug 2024 17:55:14 +0200

Patch series "mm: replace follow_page() by folio_walk".

Looking into a way of moving the last folio_likely_mapped_shared() call in
add_folio_for_migration() under the PTL, I found myself removing
follow_page().  This paves the way for cleaning up all the FOLL_, follow_*
terminology to just be called "GUP" nowadays.

The new page table walker will lookup a mapped folio and return to the
caller with the PTL held, such that the folio cannot get unmapped
concurrently.  Callers can then conditionally decide whether they really
want to take a short-term folio reference or whether the can simply unlock
the PTL and be done with it.

folio_walk is similar to page_vma_mapped_walk(), except that we don't know
the folio we want to walk to and that we are only walking to exactly one
PTE/PMD/PUD.

folio_walk provides access to the pte/pmd/pud (and the referenced folio
page because things like KSM need that), however, as part of this series
no page table modifications are performed by users.

We might be able to convert some other walk_page_range() users that really
only walk to one address, such as DAMON with
damon_mkold_ops/damon_young_ops.  It might make sense to extend folio_walk
in the future to optionally fault in a folio (if applicable), such that we
can replace some get_user_pages() users that really only want to lookup a
single page/folio under PTL without unconditionally grabbing a folio
reference.

I have plans to extend the approach to a range walker that will try
batching various page table entries (not just folio pages) to be a better
replace for walk_page_range() -- and users will be able to opt in which
type of page table entries they want to process -- but that will require
more work and more thoughts.

KSM seems to work just fine (ksm_functional_tests selftests) and
move_pages seems to work (migration selftest).  I tested the leaf
implementation excessively using various hugetlb sizes (64K, 2M, 32M, 1G)
on arm64 using move_pages and did some more testing on x86-64.  Cross
compiled on a bunch of architectures.


This patch (of 11):

We want to make use of vm_normal_page_pmd() in generic page table walking
code where we might walk hugetlb folios that are mapped by PMDs even
without CONFIG_TRANSPARENT_HUGEPAGE.

So let's expose vm_normal_page_pmd() + vm_normal_folio_pmd() with
CONFIG_PGTABLE_HAS_HUGE_LEAVES.

Link: https://lkml.kernel.org/r/20240802155524.517137-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240802155524.517137-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves
+++ a/mm/memory.c
@@ -666,7 +666,7 @@ struct folio *vm_normal_folio(struct vm_
 	return NULL;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

