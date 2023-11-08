Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3897DC0018C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjKHVLk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjKHVLk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C92102;
        Wed,  8 Nov 2023 13:11:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC845C433C7;
        Wed,  8 Nov 2023 21:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477897;
        bh=mxFbaH3SDtEU+D90EFLTl7LbU5aK3w2tcammpo8YWu8=;
        h=Date:To:From:Subject:From;
        b=aGFx6a7RdAA4OHxum9TpiuY1QtJBFflVZNxmSshEYRtpboG/XYYNDOj24dXoCiJe6
         rWPWIxm4fllw9ObWrcte2PZvlAPhEcdqZjfD1PIxIDHlNi2CaGUzL+eKZeDrRWl8xE
         aapu+jG0P7FU9jUGWtKXTV1Rk8pCgAFxucgff/uU=
Date:   Wed, 08 Nov 2023 13:11:37 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-__do_fault-to-use-a-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211137.CC845C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert __do_fault() to use a folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-convert-__do_fault-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-__do_fault-to-use-a-folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert __do_fault() to use a folio
Date: Wed, 8 Nov 2023 18:28:05 +0000

Convert vmf->page to a folio as soon as we're going to use it.  This fixes
a bug if the fault handler returns a tail page with hardware poison; tail
pages have an invalid page->index, so we would fail to unmap the page from
the page tables.  We actually have to unmap the entire folio (or
mapping_evict_folio() will fail), so use unmap_mapping_folio() instead.

This also saves various calls to compound_head() hidden in lock_page(),
put_page(), etc.

Link: https://lkml.kernel.org/r/20231108182809.602073-3-willy@infradead.org
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-convert-__do_fault-to-use-a-folio
+++ a/mm/memory.c
@@ -4239,6 +4239,7 @@ oom:
 static vm_fault_t __do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	vm_fault_t ret;
 
 	/*
@@ -4267,27 +4268,26 @@ static vm_fault_t __do_fault(struct vm_f
 			    VM_FAULT_DONE_COW)))
 		return ret;
 
+	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
-		struct page *page = vmf->page;
 		vm_fault_t poisonret = VM_FAULT_HWPOISON;
 		if (ret & VM_FAULT_LOCKED) {
-			if (page_mapped(page))
-				unmap_mapping_pages(page_mapping(page),
-						    page->index, 1, false);
-			/* Retry if a clean page was removed from the cache. */
-			if (invalidate_inode_page(page))
+			if (page_mapped(vmf->page))
+				unmap_mapping_folio(folio);
+			/* Retry if a clean folio was removed from the cache. */
+			if (mapping_evict_folio(folio->mapping, folio))
 				poisonret = VM_FAULT_NOPAGE;
-			unlock_page(page);
+			folio_unlock(folio);
 		}
-		put_page(page);
+		folio_put(folio);
 		vmf->page = NULL;
 		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf->page);
+		folio_lock(folio);
 	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
+		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);
 
 	return ret;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

