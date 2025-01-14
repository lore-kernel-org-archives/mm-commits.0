Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C74690
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817362; cv=none; b=j1L9+ITP4jv/vE28fY5HQgSugEF/7EdP53l6by+ZJxtZIGclBp5tEb6jJsq+fPKRkRaonjKKiaAN7UhvSjDkKwm2+UefocEdio/l4mr4RKx5K2BIMp1QQf8JtBlR+UT7LNrv0JrtOpzZtHe8ipWsKzSqoTKtpWASkLOUOHt9Zyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817362; c=relaxed/simple;
	bh=BgIwu2JQdbeDiYEnRlV6lSZNP3TFxD7/IF0hPc9bgUM=;
	h=Date:To:From:Subject:Message-Id; b=Poq4z3SLAnlJ7/GUnF2kbcRSiWLcxmWGIATdHIfQ3uMK13DxIiNoB5VTlbGSMd3nFlrsDObhQFLQdUck53ncqhgXEdnsYL5rjy+6aDcuJI6sYsLoXEvws3SYY+sjEyTKGVM2FWFGoFbdJS8VeLCd5hmYxeUSWJYpd7AkIfHsrRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gzoz6E78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gzoz6E78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C1DC4CED6;
	Tue, 14 Jan 2025 01:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817362;
	bh=BgIwu2JQdbeDiYEnRlV6lSZNP3TFxD7/IF0hPc9bgUM=;
	h=Date:To:From:Subject:From;
	b=gzoz6E78hPkY8PHsPQ/iWnd4H7ReN5/ko5lYOwxKf9QcHwwej34FvdQrD+1OjTkyX
	 dZVssSSdEtWZW3rstOOCXusqdmRBi0Pd2tTCVuqDfpZIZZpBlZqVqiRn05NsiGtbZ3
	 5UJIouPnUyPefZVq4WjbhRHc9HCf4WZXsfGNnw1k=
Date: Mon, 13 Jan 2025 17:16:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch added to mm-unstable branch
Message-Id: <20250114011602.07C1DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: convert has_hwpoisoned into a pure folio flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch

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
Subject: mm/huge_memory: convert has_hwpoisoned into a pure folio flag
Date: Mon, 13 Jan 2025 14:16:06 +0100

Patch series "mm: hugetlb+THP folio and migration cleanups", v2.

Some cleanups around more folio conversion and migration handling that I
collected working on random stuff.


This patch (of 6):

Let's stop setting it on pages, there is no need to anymore.

Link: https://lkml.kernel.org/r/20250113131611.2554758-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++----
 mm/huge_memory.c           |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag
+++ a/include/linux/page-flags.h
@@ -948,11 +948,9 @@ TESTPAGEFLAG_FALSE(TransCompound, transc
  *
  * This flag is set by hwpoison handler.  Cleared by THP split or free page.
  */
-PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
-	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
 #else
-PAGEFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
-	TESTSCFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
+FOLIO_FLAG_FALSE(has_hwpoisoned)
 #endif
 
 /*
--- a/mm/huge_memory.c~mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag
+++ a/mm/huge_memory.c
@@ -3290,7 +3290,7 @@ static void __split_huge_page(struct pag
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
 
-	ClearPageHasHWPoisoned(head);
+	folio_clear_has_hwpoisoned(folio);
 
 	for (i = nr - new_nr; i >= new_nr; i -= new_nr) {
 		struct folio *tail;
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

