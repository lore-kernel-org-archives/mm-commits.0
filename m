Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE2DC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiLAADn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiLAACC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3259689AD4
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE20BB81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965C3C433B5;
        Thu,  1 Dec 2022 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852864;
        bh=y5ENwOSLwrVQitgxEfLQF1LCu0tnvWdOgcD5SlBYcfw=;
        h=Date:To:From:Subject:From;
        b=F8Sj/B+uQoAbIjr6oevlOXLnz58YchF7HGlmOD5TQVKPgY/KbOPjViJJ/4W/WDMsy
         QTmUnlHZjPmmfBigP8uaT6Pt9KfnFUuz4W/uWzOXm2Z0pg2uAFBtUJwGHBju7mIqih
         UxBhqdvl+eu/qO9QgMkHjk5fUogUe3cluyeg6gZ0=
Date:   Wed, 30 Nov 2022 16:01:03 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com, yuzhao@google.com,
        willy@infradead.org, vbabka@suse.cz, torvalds@linux-foundation.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        jhubbard@nvidia.com, hannes@cmpxchg.org, error27@gmail.com,
        david@redhat.com, almasrymina@google.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch removed from -mm tree
Message-Id: <20221201000104.965C3C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm,thp,rmap: clean up the end of __split_huge_pmd_locked()
has been removed from the -mm tree.  Its filename was
     mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp,rmap: clean up the end of __split_huge_pmd_locked()
Date: Tue, 22 Nov 2022 01:51:50 -0800 (PST)

It's hard to add a page_add_anon_rmap() into __split_huge_pmd_locked()'s
HPAGE_PMD_NR set_pte_at() loop, without wincing at the "freeze" case's
HPAGE_PMD_NR page_remove_rmap() loop below it.

It's just a mistake to add rmaps in the "freeze" (insert migration entries
prior to splitting huge page) case: the pmd_migration case already avoids
doing that, so just follow its lead.  page_add_ref() versus put_page()
likewise.  But why is one more put_page() needed in the "freeze" case? 
Because it's removing the pmd rmap, already removed when pmd_migration
(and freeze and pmd_migration are mutually exclusive cases).

Link: https://lkml.kernel.org/r/d43748aa-fece-e0b9-c4ab-f23c9ebc9011@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
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
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2141,7 +2141,6 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_uffd_wp(old_pmd);
 
 		VM_BUG_ON_PAGE(!page_count(page), page);
-		page_ref_add(page, HPAGE_PMD_NR - 1);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
@@ -2161,6 +2160,8 @@ static void __split_huge_pmd_locked(stru
 		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
 			freeze = false;
+		if (!freeze)
+			page_ref_add(page, HPAGE_PMD_NR - 1);
 	}
 
 	/*
@@ -2216,27 +2217,21 @@ static void __split_huge_pmd_locked(stru
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


