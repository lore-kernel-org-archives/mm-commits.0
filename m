Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE902CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjJRVgb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F581134
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39725C43140;
        Wed, 18 Oct 2023 21:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664917;
        bh=PMhfYvP25fS28swTTxf7XD2KdgbBIutKHybHAi/iXts=;
        h=Date:To:From:Subject:From;
        b=SWjJcSWNL/lx7oOQboNzDexb8BBSq8VebEb5Q9S72LhWgcTBlKiOfehHnCcBJkKUk
         cYnWb6zZ+hHKcrdG5rJP4Txj5l3ccj+co4dpVDhBdZ+H5kAm1/whpPxfmll+fxiGfd
         Xhmv3Ziy6DH9V98dTxBwX/UPp39BDIugLsbBG0eE=
Date:   Wed, 18 Oct 2023 14:35:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, surenb@google.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch removed from -mm tree
Message-Id: <20231018213517.39725C43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: convert page_move_anon_rmap() to folio_move_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: convert page_move_anon_rmap() to folio_move_anon_rmap()
Date: Mon, 2 Oct 2023 16:29:48 +0200

Let's convert it to consume a folio.

[akpm@linux-foundation.org: fix kerneldoc]
Link: https://lkml.kernel.org/r/20231002142949.235104-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/hugetlb.c         |    2 +-
 mm/memory.c          |    2 +-
 mm/rmap.c            |   16 +++++++---------
 5 files changed, 11 insertions(+), 13 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/include/linux/rmap.h
@@ -189,7 +189,7 @@ typedef int __bitwise rmap_t;
 /*
  * rmap interfaces called when adding or removing pte of page
  */
-void page_move_anon_rmap(struct page *, struct vm_area_struct *);
+void folio_move_anon_rmap(struct folio *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
--- a/mm/huge_memory.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/huge_memory.c
@@ -1376,7 +1376,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	if (folio_ref_count(folio) == 1) {
 		pmd_t entry;
 
-		page_move_anon_rmap(page, vma);
+		folio_move_anon_rmap(folio, vma);
 		SetPageAnonExclusive(page);
 		folio_unlock(folio);
 reuse:
--- a/mm/hugetlb.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/hugetlb.c
@@ -5653,7 +5653,7 @@ retry_avoidcopy:
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
 		if (!PageAnonExclusive(&old_folio->page)) {
-			page_move_anon_rmap(&old_folio->page, vma);
+			folio_move_anon_rmap(old_folio, vma);
 			SetPageAnonExclusive(&old_folio->page);
 		}
 		if (likely(!unshare))
--- a/mm/memory.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/memory.c
@@ -3480,7 +3480,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * and the folio is locked, it's dark out, and we're wearing
 		 * sunglasses. Hit it.
 		 */
-		page_move_anon_rmap(vmf->page, vma);
+		folio_move_anon_rmap(folio, vma);
 		SetPageAnonExclusive(vmf->page);
 		folio_unlock(folio);
 reuse:
--- a/mm/rmap.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap
+++ a/mm/rmap.c
@@ -1128,19 +1128,17 @@ int folio_total_mapcount(struct folio *f
 }
 
 /**
- * page_move_anon_rmap - move a page to our anon_vma
- * @page:	the page to move to our anon_vma
- * @vma:	the vma the page belongs to
+ * folio_move_anon_rmap - move a folio to our anon_vma
+ * @folio:	The folio to move to our anon_vma
+ * @vma:	The vma the folio belongs to
  *
- * When a page belongs exclusively to one process after a COW event,
- * that page can be moved into the anon_vma that belongs to just that
- * process, so the rmap code will not search the parent or sibling
- * processes.
+ * When a folio belongs exclusively to one process after a COW event,
+ * that folio can be moved into the anon_vma that belongs to just that
+ * process, so the rmap code will not search the parent or sibling processes.
  */
-void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
+void folio_move_anon_rmap(struct folio *folio, struct vm_area_struct *vma)
 {
 	void *anon_vma = vma->anon_vma;
-	struct folio *folio = page_folio(page);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(!anon_vma, vma);
_

Patches currently in -mm which might be from david@redhat.com are


