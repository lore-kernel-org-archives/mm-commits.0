Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD4CE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244598AbjJDUWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbjJDUUw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:20:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F410FC0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6528CC433CA;
        Wed,  4 Oct 2023 20:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450848;
        bh=WyCDoFj7mScX7KHDdyz7aFG7pkuurAKoli9+Y4rjgIs=;
        h=Date:To:From:Subject:From;
        b=z8Mla3NGp1waVm+DcevIFWLU/cqw9lnWdPo1esk9d6JmL/JnvoFSuHJa6KPY3UU+a
         PuDGQy7XNeTzZLidBv94YJHmNuadn0rgTcedW/6o2cVe0PJxG91p9NXbqePMm22nA7
         vxihicPIqJ+trtbf245uByH3FodexlrKuyD/Zgyw=
Date:   Wed, 04 Oct 2023 13:20:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch removed from -mm tree
Message-Id: <20231004202048.6528CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: drop stale comment in page_add_anon_rmap and hugepage_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: drop stale comment in page_add_anon_rmap and hugepage_add_anon_rmap()
Date: Wed, 13 Sep 2023 14:51:08 +0200

Patch series "Anon rmap cleanups".

Some cleanups around rmap for anon pages.  I'm working on more cleanups
also around file rmap -- also to handle the "compound" parameter
internally only and to let hugetlb use page_add_file_rmap(), but these
changes make sense separately.


This patch (of 6):

That comment was added in commit 5dbe0af47f8a ("mm: fix kernel BUG at
mm/rmap.c:1017!") to document why we can see vma->vm_end getting adjusted
concurrently due to a VMA split.

However, the optimized locking code was changed again in bf181b9f9d8 ("mm
anon rmap: replace same_anon_vma linked list with an interval tree.").

...  and later, the comment was changed in commit 0503ea8f5ba7 ("mm/mmap:
remove __vma_adjust()") to talk about "vma_merge" although the original
issue was with VMA splitting.

Let's just remove that comment.  Nowadays, it's outdated, imprecise and
confusing.

Link: https://lkml.kernel.org/r/20230913125113.313322-1-david@redhat.com
Link: https://lkml.kernel.org/r/20230913125113.313322-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap
+++ a/mm/rmap.c
@@ -1245,7 +1245,6 @@ void page_add_anon_rmap(struct page *pag
 		__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
 
 	if (likely(!folio_test_ksm(folio))) {
-		/* address might be in next vma when migration races vma_merge */
 		if (first)
 			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
@@ -2549,7 +2548,6 @@ void hugepage_add_anon_rmap(struct page
 
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(!anon_vma);
-	/* address might be in next vma when migration races vma_merge */
 	first = atomic_inc_and_test(&folio->_entire_mapcount);
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

