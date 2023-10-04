Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34489E936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjJDUcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244101AbjJDUWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB9E1BD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEA7C433CA;
        Wed,  4 Oct 2023 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450859;
        bh=Sx9KIingG7rdkwVf4VNSO0sNoXVEfY41O72caWyx5EY=;
        h=Date:To:From:Subject:From;
        b=NrxZAMUGR3fAjwFWFwMMgC8R8JnnstUsq0dTXkjcTHGD8RMvYHpvTfW5RVvJC97uX
         CLBh37X/66pssmDz4l+V4aAg/9+6izGxBWRzPZiJCtsRJyRUvtOkhaeYQqZOW1bY66
         Ul7KRtjrFAveuuS63jabSjJkYHxI5SXWJi6bD75g=
Date:   Wed, 04 Oct 2023 13:20:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch removed from -mm tree
Message-Id: <20231004202059.2FEA7C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: pass folio to hugepage_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: pass folio to hugepage_add_anon_rmap()
Date: Wed, 13 Sep 2023 14:51:13 +0200

Let's pass a folio; we are always mapping the entire thing.

Link: https://lkml.kernel.org/r/20230913125113.313322-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/migrate.c         |    2 +-
 mm/rmap.c            |    8 +++-----
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-pass-folio-to-hugepage_add_anon_rmap
+++ a/include/linux/rmap.h
@@ -203,7 +203,7 @@ void folio_add_file_rmap_range(struct fo
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 
-void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
+void hugepage_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void hugepage_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
--- a/mm/migrate.c~mm-rmap-pass-folio-to-hugepage_add_anon_rmap
+++ a/mm/migrate.c
@@ -249,7 +249,7 @@ static bool remove_migration_pte(struct
 
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
-				hugepage_add_anon_rmap(new, vma, pvmw.address,
+				hugepage_add_anon_rmap(folio, vma, pvmw.address,
 						       rmap_flags);
 			else
 				page_dup_file_rmap(new, true);
--- a/mm/rmap.c~mm-rmap-pass-folio-to-hugepage_add_anon_rmap
+++ a/mm/rmap.c
@@ -2542,18 +2542,16 @@ void rmap_walk_locked(struct folio *foli
  *
  * RMAP_COMPOUND is ignored.
  */
-void hugepage_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
+void hugepage_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 			    unsigned long address, rmap_t flags)
 {
-	struct folio *folio = page_folio(page);
-
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 	atomic_inc(&folio->_entire_mapcount);
 	if (flags & RMAP_EXCLUSIVE)
-		SetPageAnonExclusive(page);
+		SetPageAnonExclusive(&folio->page);
 	VM_WARN_ON_FOLIO(folio_entire_mapcount(folio) > 1 &&
-			 PageAnonExclusive(page), folio);
+			 PageAnonExclusive(&folio->page), folio);
 }
 
 void hugepage_add_new_anon_rmap(struct folio *folio,
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

