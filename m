Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76543EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjIMTsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIMTsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:48:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30689B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:48:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4AAC433C8;
        Wed, 13 Sep 2023 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694634499;
        bh=Ay24G4tsT2/KaTbs1W7+tO7rm0wL/feoG0ELMaVfytA=;
        h=Date:To:From:Subject:From;
        b=2iaklftUpOyT7/n8tEBcGQIN+M0zq4jFMynxDQgGVBAvjYulCSxqTpMS5zK4wmVlR
         PUFQDQDxsszHoUUMpUqNYmNViLNlxh0iLifxKxgUcZt19nugf4uOs5Lbrcn799kfeh
         uHtn277rSFlQsDx9hdiD4egs4eS/pPYel4BU7ZoM=
Date:   Wed, 13 Sep 2023 12:48:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230913194819.7D4AAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: pass folio to hugepage_add_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

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
@@ -247,7 +247,7 @@ static bool remove_migration_pte(struct
 
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
-				hugepage_add_anon_rmap(new, vma, pvmw.address,
+				hugepage_add_anon_rmap(folio, vma, pvmw.address,
 						       rmap_flags);
 			else
 				page_dup_file_rmap(new, true);
--- a/mm/rmap.c~mm-rmap-pass-folio-to-hugepage_add_anon_rmap
+++ a/mm/rmap.c
@@ -2527,18 +2527,16 @@ void rmap_walk_locked(struct folio *foli
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

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

