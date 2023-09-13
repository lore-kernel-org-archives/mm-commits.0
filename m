Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF723EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjIMTsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIMTsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:48:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84049B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:48:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C49C433C8;
        Wed, 13 Sep 2023 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694634488;
        bh=rOv8SkltPGI1N85/S6uqd2Nj2dGyVIurfwg6Z0/Rc80=;
        h=Date:To:From:Subject:From;
        b=w6x7Oviqsp6ygUaPY5scsGTgTjRGo9vynyFE0dcAuj/gcZHb4tQJuLpAq9b3FdZvy
         Kdi+NIzZLwFWZfirXpECEJmhyW2prrg5vf/PEpmup9zfx25Jl7lu70kbdCazhPKNoe
         J4U3JUvLq9VnchVbV5RyIGind072IOrjOsIplYxQ=
Date:   Wed, 13 Sep 2023 12:48:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230913194808.40C49C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: move SetPageAnonExclusive out of __page_set_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch

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
Subject: mm/rmap: move SetPageAnonExclusive out of __page_set_anon_rmap()
Date: Wed, 13 Sep 2023 14:51:09 +0200

Let's handle it in the caller.  No need to pass the page.  While at it,
rename the function to __folio_set_anon() and pass "bool exclusive"
instead of "int exclusive".

Link: https://lkml.kernel.org/r/20230913125113.313322-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/mm/rmap.c~mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap
+++ a/mm/rmap.c
@@ -1122,27 +1122,25 @@ void page_move_anon_rmap(struct page *pa
 }
 
 /**
- * __page_set_anon_rmap - set up new anonymous rmap
- * @folio:	Folio which contains page.
- * @page:	Page to add to rmap.
- * @vma:	VM area to add page to.
+ * __folio_set_anon - set up a new anonymous rmap for a folio
+ * @folio:	The folio to set up the new anonymous rmap for.
+ * @vma:	VM area to add the folio to.
  * @address:	User virtual address of the mapping
- * @exclusive:	the page is exclusively owned by the current process
+ * @exclusive:	Whether the folio is exclusive to the process.
  */
-static void __page_set_anon_rmap(struct folio *folio, struct page *page,
-	struct vm_area_struct *vma, unsigned long address, int exclusive)
+static void __folio_set_anon(struct folio *folio, struct vm_area_struct *vma,
+			     unsigned long address, bool exclusive)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
 	BUG_ON(!anon_vma);
 
 	if (folio_test_anon(folio))
-		goto out;
+		return;
 
 	/*
-	 * If the page isn't exclusively mapped into this vma,
-	 * we must use the _oldest_ possible anon_vma for the
-	 * page mapping!
+	 * If the folio isn't exclusive to this vma, we must use the _oldest_
+	 * possible anon_vma for the folio mapping!
 	 */
 	if (!exclusive)
 		anon_vma = anon_vma->root;
@@ -1156,9 +1154,6 @@ static void __page_set_anon_rmap(struct
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
 	folio->index = linear_page_index(vma, address);
-out:
-	if (exclusive)
-		SetPageAnonExclusive(page);
 }
 
 /**
@@ -1246,11 +1241,13 @@ void page_add_anon_rmap(struct page *pag
 
 	if (likely(!folio_test_ksm(folio))) {
 		if (first)
-			__page_set_anon_rmap(folio, page, vma, address,
-					     !!(flags & RMAP_EXCLUSIVE));
+			__folio_set_anon(folio, vma, address,
+					 !!(flags & RMAP_EXCLUSIVE));
 		else
 			__page_check_anon_rmap(folio, page, vma, address);
 	}
+	if (flags & RMAP_EXCLUSIVE)
+		SetPageAnonExclusive(page);
 
 	mlock_vma_folio(folio, vma, compound);
 }
@@ -1289,7 +1286,8 @@ void folio_add_new_anon_rmap(struct foli
 	}
 
 	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
+	__folio_set_anon(folio, vma, address, true);
+	SetPageAnonExclusive(&folio->page);
 }
 
 /**
@@ -2539,8 +2537,10 @@ void hugepage_add_anon_rmap(struct page
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 	if (first)
-		__page_set_anon_rmap(folio, page, vma, address,
-				     !!(flags & RMAP_EXCLUSIVE));
+		__folio_set_anon(folio, vma, address,
+				 !!(flags & RMAP_EXCLUSIVE));
+	if (flags & RMAP_EXCLUSIVE)
+		SetPageAnonExclusive(page);
 }
 
 void hugepage_add_new_anon_rmap(struct folio *folio,
@@ -2550,6 +2550,7 @@ void hugepage_add_new_anon_rmap(struct f
 	/* increment count (starts at -1) */
 	atomic_set(&folio->_entire_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
-	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
+	__folio_set_anon(folio, vma, address, true);
+	SetPageAnonExclusive(&folio->page);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

