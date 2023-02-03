Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FA5C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjBCGmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBCGkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC98FB51
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB30461DAA
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C07C4339B;
        Fri,  3 Feb 2023 06:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406262;
        bh=RqTHXWdvJxLpitH1BlllXsmniQLAY2AQq3SiFFvFVAY=;
        h=Date:To:From:Subject:From;
        b=auHN/cmdscUKbpTe42OR20qkd6JHHNS+Jv0Dwn7W4Ds0s8CN/o4dDXf3TRNqCsaLh
         2WmxnADQkUnIpW6kSl4v7aLf6ckvL6b64CJPvNEn54mncnNx/YiNr8qd6VPIiSGTTB
         iDcHgAFug5Yy+g59VTDkdhad4THEAId38pr+AvFM=
Date:   Thu, 02 Feb 2023 22:37:41 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-add-folio-parameter-to-__page_set_anon_rmap.patch removed from -mm tree
Message-Id: <20230203063742.51C07C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rmap: add folio parameter to __page_set_anon_rmap()
has been removed from the -mm tree.  Its filename was
     rmap-add-folio-parameter-to-__page_set_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: add folio parameter to __page_set_anon_rmap()
Date: Mon, 16 Jan 2023 19:29:59 +0000

Avoid the compound_head() call in PageAnon() by passing in the folio that
all callers have.  Also save me from wondering whether page->mapping can
ever be overwritten on a tail page (I don't think it can, but I'm not 100%
sure).

Link: https://lkml.kernel.org/r/20230116192959.2147032-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/rmap.c~rmap-add-folio-parameter-to-__page_set_anon_rmap
+++ a/mm/rmap.c
@@ -1131,19 +1131,20 @@ void page_move_anon_rmap(struct page *pa
 
 /**
  * __page_set_anon_rmap - set up new anonymous rmap
- * @page:	Page or Hugepage to add to rmap
+ * @folio:	Folio which contains page.
+ * @page:	Page to add to rmap.
  * @vma:	VM area to add page to.
  * @address:	User virtual address of the mapping	
  * @exclusive:	the page is exclusively owned by the current process
  */
-static void __page_set_anon_rmap(struct page *page,
+static void __page_set_anon_rmap(struct folio *folio, struct page *page,
 	struct vm_area_struct *vma, unsigned long address, int exclusive)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
 	BUG_ON(!anon_vma);
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		goto out;
 
 	/*
@@ -1155,14 +1156,14 @@ static void __page_set_anon_rmap(struct
 		anon_vma = anon_vma->root;
 
 	/*
-	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
+	 * page_idle does a lockless/optimistic rmap scan on folio->mapping.
 	 * Make sure the compiler doesn't split the stores of anon_vma and
 	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
 	 * could mistake the mapping for a struct address_space and crash.
 	 */
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
-	page->index = linear_page_index(vma, address);
+	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
+	folio->index = linear_page_index(vma, address);
 out:
 	if (exclusive)
 		SetPageAnonExclusive(page);
@@ -1254,7 +1255,7 @@ void page_add_anon_rmap(struct page *pag
 	if (likely(!folio_test_ksm(folio))) {
 		/* address might be in next vma when migration races vma_adjust */
 		if (first)
-			__page_set_anon_rmap(page, vma, address,
+			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
 		else
 			__page_check_anon_rmap(page, vma, address);
@@ -1297,7 +1298,7 @@ void folio_add_new_anon_rmap(struct foli
 	}
 
 	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(&folio->page, vma, address, 1);
+	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
 }
 
 /**
@@ -2528,7 +2529,7 @@ void hugepage_add_anon_rmap(struct page
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
 	if (first)
-		__page_set_anon_rmap(page, vma, address,
+		__page_set_anon_rmap(folio, page, vma, address,
 				     !!(flags & RMAP_EXCLUSIVE));
 }
 
@@ -2541,6 +2542,6 @@ void hugepage_add_new_anon_rmap(struct p
 	/* increment count (starts at -1) */
 	atomic_set(&folio->_entire_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
-	__page_set_anon_rmap(page, vma, address, 1);
+	__page_set_anon_rmap(folio, page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from willy@infradead.org are


