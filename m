Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E5BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 22:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKRWBZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiKRWBY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 17:01:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA0591C0F
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 14:01:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B928AB8255C
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 22:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76664C433D6;
        Fri, 18 Nov 2022 22:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668808880;
        bh=ESV2Hy7BHNZH/4xFLDENoKcfbhLwHfL9BtpbYNsbVkc=;
        h=Date:To:From:Subject:From;
        b=xD/PC4fPY5YjOfgbK4ERN4QWpkSThrXD8M3PZwOCcKseTljDBbJVb/UEEtjK6fvnz
         4VwYbEVWBqb38aFaBr0aMWHQtfN6ZnbApjdqVL2+YJPjCoMnFPJ7AqBNqxFy5C11/u
         e2Llw8VRC1PLGgKrnYYMgoxbGlptRGfin3MedbQ0=
Date:   Fri, 18 Nov 2022 14:01:19 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, torvalds@linux-foundation.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        kirill@shutemov.name, jthoughton@google.com, jhubbard@nvidia.com,
        hannes@cmpxchg.org, david@redhat.com, almasrymina@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch added to mm-unstable branch
Message-Id: <20221118220120.76664C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,rmap: clean up the end of __split_huge_pmd_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp,rmap: clean up the end of __split_huge_pmd_locked()
Date: Fri, 18 Nov 2022 01:16:20 -0800 (PST)

It's hard to add a page_add_anon_rmap() into __split_huge_pmd_locked()'s
HPAGE_PMD_NR set_pte_at() loop, without wincing at the "freeze" case's
HPAGE_PMD_NR page_remove_rmap() loop below it.

It's just a mistake to add rmaps in the "freeze" (insert migration entries
prior to splitting huge page) case: the pmd_migration case already avoids
doing that, so just follow its lead.  page_add_ref() versus put_page()
likewise.  But why is one more put_page() needed in the "freeze" case? 
Because it's removing the pmd rmap, already removed when pmd_migration
(and freeze and pmd_migration are mutually exclusive cases).

Link: https://lkml.kernel.org/r/2f4afe60-40d2-706c-af21-914fbbbd164@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2095,7 +2095,6 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_uffd_wp(old_pmd);
 
 		VM_BUG_ON_PAGE(!page_count(page), page);
-		page_ref_add(page, HPAGE_PMD_NR - 1);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
@@ -2115,6 +2114,8 @@ static void __split_huge_pmd_locked(stru
 		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
 			freeze = false;
+		if (!freeze)
+			page_ref_add(page, HPAGE_PMD_NR - 1);
 	}
 
 	/*
@@ -2170,27 +2171,21 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_mkuffd_wp(entry);
+			page_add_anon_rmap(page + i, vma, addr, false);
 		}
 		pte = pte_offset_map(&_pmd, addr);
 		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, entry);
-		if (!pmd_migration)
-			page_add_anon_rmap(page + i, vma, addr, false);
 		pte_unmap(pte);
 	}
 
 	if (!pmd_migration)
 		page_remove_rmap(page, vma, true);
+	if (freeze)
+		put_page(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-
-	if (freeze) {
-		for (i = 0; i < HPAGE_PMD_NR; i++) {
-			page_remove_rmap(page + i, vma, false);
-			put_page(page + i);
-		}
-	}
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
_

Patches currently in -mm which might be from hughd@google.com are

mmhugetlb-use-folio-fields-in-second-tail-page.patch
mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch
mmthprmap-simplify-compound-page-mapcount-handling.patch
mmthprmap-lock_compound_mapcounts-on-thp-mapcounts.patch
mmthprmap-handle-the-normal-pagecompound-case-first.patch
mmthprmap-subpages_mapcount-of-pte-mapped-subpages.patch
mmthprmap-subpages_mapcount-compound_mapped-if-pmd-mapped.patch
mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch

