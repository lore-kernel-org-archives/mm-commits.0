Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545C8E936E3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjJDUcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244674AbjJDUWJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908F1A2
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93AEC433C8;
        Wed,  4 Oct 2023 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450857;
        bh=yXVelFDYTXXhnXrYVn8ygZ3gcz7wNTe2fAYG7ws8Ufk=;
        h=Date:To:From:Subject:From;
        b=FX3TtA/SyOb+/iUQVXx8KHyXc2ucLzNPBKkOZW2hNzRrDkD7pzoX656VRX2SgrjDj
         J+OPK6FolZphjRPL2fLXn0YBQm+ItjTERp3kWZnFPjLc9BAcLVS++kn6OkfMMaO325
         J4Epa4/epQbvtpBpER2ncLVQMpuYb/cLzGJCePjI=
Date:   Wed, 04 Oct 2023 13:20:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch removed from -mm tree
Message-Id: <20231004202056.E93AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: simplify PageAnonExclusive sanity checks when adding anon rmap
has been removed from the -mm tree.  Its filename was
     mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: simplify PageAnonExclusive sanity checks when adding anon rmap
Date: Wed, 13 Sep 2023 14:51:12 +0200

Let's sanity-check PageAnonExclusive vs.  mapcount in page_add_anon_rmap()
and hugepage_add_anon_rmap() after setting PageAnonExclusive simply by
re-reading the mapcounts.

We can stop initializing the "first" variable in page_add_anon_rmap() and
no longer need an atomic_inc_and_test() in hugepage_add_anon_rmap().

While at it, switch to VM_WARN_ON_FOLIO().

[david@redhat.com: update check for doubly-mapped page]
  Link: https://lkml.kernel.org/r/d8e5a093-2e22-c14b-7e64-6da280398d9f@redhat.com
Link: https://lkml.kernel.org/r/20230913125113.313322-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap
+++ a/mm/rmap.c
@@ -1199,7 +1199,7 @@ void page_add_anon_rmap(struct page *pag
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool compound = flags & RMAP_COMPOUND;
-	bool first = true;
+	bool first;
 
 	/* Is page being mapped by PTE? Is this its first map to be added? */
 	if (likely(!compound)) {
@@ -1228,9 +1228,6 @@ void page_add_anon_rmap(struct page *pag
 		}
 	}
 
-	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
-	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
-
 	if (nr_pmdmapped)
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr_pmdmapped);
 	if (nr)
@@ -1252,6 +1249,10 @@ void page_add_anon_rmap(struct page *pag
 	}
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
+	/* While PTE-mapping a THP we have a PMD and a PTE mapping. */
+	VM_WARN_ON_FOLIO((atomic_read(&page->_mapcount) > 0 ||
+			  (folio_test_large(folio) && folio_entire_mapcount(folio) > 1)) &&
+			 PageAnonExclusive(page), folio);
 
 	mlock_vma_folio(folio, vma, compound);
 }
@@ -2545,15 +2546,14 @@ void hugepage_add_anon_rmap(struct page
 			    unsigned long address, rmap_t flags)
 {
 	struct folio *folio = page_folio(page);
-	int first;
 
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
-	first = atomic_inc_and_test(&folio->_entire_mapcount);
-	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
-	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
+	atomic_inc(&folio->_entire_mapcount);
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
+	VM_WARN_ON_FOLIO(folio_entire_mapcount(folio) > 1 &&
+			 PageAnonExclusive(page), folio);
 }
 
 void hugepage_add_new_anon_rmap(struct folio *folio,
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch

