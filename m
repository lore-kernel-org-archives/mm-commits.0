Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D86E14A4F0
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724197109; cv=none; b=s2Jw54xS5TYhkn6Au9pvZdd9/XOCbRa1by9bMnuYAERcv+s4paSfSci2LVex8M+nRaUluifOtw9ETxGcCHo+Yt7e8Ro/Y0su2HZPQ88F5fqawvS74HpmIAcSPxqoezSgcWYaHDQtbOAiMR4RN8C5Br88X+NWfbN2WElLRQ1p8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724197109; c=relaxed/simple;
	bh=7w25faizfnKHYKgjHo7SvEWdC+8HWlVV5yu2nQmM62s=;
	h=Date:To:From:Subject:Message-Id; b=fmZPXHOZiWmfsArHHGvR22nBeEMrx0ON1YhBpHBGfFI6kiM04y0YhN7WauvZYZGq5ei/n8EJVqL53ZWNO5YgslwCM9h4yvJzxAYYGC0tmuMfpYBRiCSLddTwdl7h4/WMLgvt1kqke6WsvUFmJQtMGI+5s5cB2mleyRV6E9t5J8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UWX1xkBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UWX1xkBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5567C4AF10;
	Tue, 20 Aug 2024 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724197108;
	bh=7w25faizfnKHYKgjHo7SvEWdC+8HWlVV5yu2nQmM62s=;
	h=Date:To:From:Subject:From;
	b=UWX1xkBN/kb7Nqpn3s8F3ayrhiuigiAE8oo6qaErHi2NcKadl2UHwz3ogGv50MVsC
	 L30Kj+nC07mImHoFvlygpTitFiYTmbqk8GaGU7WPbWuDeaFhUeMHAF1GJrb45lft/e
	 +gmAsGZsXLSCmSHpBkFvWcw3x7LNrNDzJZR0kZB0=
Date: Tue, 20 Aug 2024 16:38:28 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,oliver.sang@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch added to mm-unstable branch
Message-Id: <20240820233828.A5567C4AF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: always inline _compound_head() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: always inline _compound_head() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
Date: Tue, 20 Aug 2024 14:22:10 +0200

We already force-inline page_fixed_fake_head(), page_is_fake_head() and
PageTail(), however the compiler might decide that _compound_head() is not
worthy to be inlined, because of page_fixed_fake_head().

The result is that, for example, PageAnonExclusive() now might involve a
function call when checking PageHuge(), which performs a
page_folio()->_compound_head() call.  This can lead to a slight regression
of the stress-ng.clone benchmark.

This is not super-urgent to fix, but always inlining _compound_head()
seems like the obvious thing to do for this primitive, similar to the
other ones.

This change restores the slight regression and a compilation with
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y shows no relevant bloat [2]:

	add/remove: 15/14 grow/shrink: 79/87 up/down: 12836/-13917 (-1081)
	...
	Total: Before=32786363, After=32785282, chg -0.00%

[1] https://lkml.kernel.org/r/817150f2-abf7-430f-9973-540bd6cdd26f@intel.com
[2] https://lore.kernel.org/all/116e117c-2821-401d-8e62-b85cdec37f4a@redhat.com/

Link: https://lkml.kernel.org/r/20240820122210.660140-1-david@redhat.com
Fixes: c0bff412e67b ("mm: allow anon exclusive check over hugetlb tail pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407301049.5051dc19-oliver.sang@intel.com
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y
+++ a/include/linux/page-flags.h
@@ -232,7 +232,7 @@ static __always_inline int page_is_fake_
 	return page_fixed_fake_head(page) != page;
 }
 
-static inline unsigned long _compound_head(const struct page *page)
+static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long head = READ_ONCE(page->compound_head);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch
mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch

