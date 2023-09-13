Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85637EE0207
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjIMTsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIMTsV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:48:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A4D9B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:48:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ED0C433C8;
        Wed, 13 Sep 2023 19:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694634497;
        bh=u3q5CBTP1Dy2XFh38qD/jvL7g4WObdPaVLoYjvEnun4=;
        h=Date:To:From:Subject:From;
        b=ksm4xUQb2DTTOkQTTqbG5j5S4eKWoV/mtZSBHjc/HZk7XK/K1qvaH/70+1txPHoIR
         tFg2DfB6bKn9EyuUL8/TiQTrQTjC89XJuBE9P5Led2CloQlJUlsDwoX0gFCDwF/HMr
         /f9oE+VFnIdTqcEhWZZ/ecbkzSkRezjbTScZ7qjU=
Date:   Wed, 13 Sep 2023 12:48:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch added to mm-unstable branch
Message-Id: <20230913194817.34ED0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: simplify PageAnonExclusive sanity checks when adding anon rmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch

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
Subject: mm/rmap: simplify PageAnonExclusive sanity checks when adding anon rmap
Date: Wed, 13 Sep 2023 14:51:12 +0200

Let's sanity-check PageAnonExclusive vs.  mapcount in page_add_anon_rmap()
and hugepage_add_anon_rmap() after setting PageAnonExclusive simply by
re-reading the mapcounts.

We can stop initializing the "first" variable in page_add_anon_rmap() and
no longer need an atomic_inc_and_test() in hugepage_add_anon_rmap().

While at it, switch to VM_WARN_ON_FOLIO().

Link: https://lkml.kernel.org/r/20230913125113.313322-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

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
@@ -1252,6 +1249,8 @@ void page_add_anon_rmap(struct page *pag
 	}
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
+	VM_WARN_ON_FOLIO(page_mapcount(page) > 1 && PageAnonExclusive(page),
+			 folio);
 
 	mlock_vma_folio(folio, vma, compound);
 }
@@ -2532,15 +2531,14 @@ void hugepage_add_anon_rmap(struct page
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

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

