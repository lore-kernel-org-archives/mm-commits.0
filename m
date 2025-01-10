Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B2207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550274; cv=none; b=uHT+4dz8lPu0z3SiribyVrBs9HaRyypIvle+i2gg/MglU0YytRA4GsY/m5uxQSn100tAM8AGhPIJWNWg1vRFhdz5fbAhW7vgaDt+vtWoPYXWqAXD2PiIr69dxaXS+XG8MA7uHm4AZyaIazE+T9eWIKy8ziEXDq5Ai7bfMWHJOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550274; c=relaxed/simple;
	bh=cvt+GhVhXmGSwON/4icWiR7wlHouSbI4DRrXXbRyJ98=;
	h=Date:To:From:Subject:Message-Id; b=eSasEokZ8kc0e5nOqdWDWS1EbAarlqiRRTHMsGUj/HDJ5pfVnwYHIvTj02Wwq4SRZiFIMbxodbbtnqnjQMxY91Tg6aEyEIiotu/UKiAjNou2q6mo7Ie5/AD2EQQCcCvsEkKNBItqDzB/FqLD/4gh4wNP5r91Rm7RuycsvFUISAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Keajomb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Keajomb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B8FC4CED6;
	Fri, 10 Jan 2025 23:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550273;
	bh=cvt+GhVhXmGSwON/4icWiR7wlHouSbI4DRrXXbRyJ98=;
	h=Date:To:From:Subject:From;
	b=Keajomb9LY4Pq4FFF0z12Td8uc6Shj6zjvnVmewgugBElcekwNDTvpOKOcVvCgWfH
	 v0ZNSiq3vD4BEyy/lNFzxCQGJH+y+69Us5qnBQwnwsr8L74VZIxe51fbxkAj0MPOc0
	 kkSfJPdPBXb64X6+IjSnxJVzPCX8X41O3TORBTZI=
Date: Fri, 10 Jan 2025 15:04:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch added to mm-unstable branch
Message-Id: <20250110230433.74B8FC4CED6@smtp.kernel.org>
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
Date: Fri, 10 Jan 2025 19:21:44 +0100

Patch series "mm/hugetlb: folio and migration cleanups".

Some cleanups around more folio conversion and migration handling that I
collected working on random stuff.


This patch (of 6):

Let's stop setting it on pages, there is no need to anymore.

Link: https://lkml.kernel.org/r/20250110182149.746551-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250110182149.746551-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
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

