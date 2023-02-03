Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AF9C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjBCGmO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjBCGku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC28FB55
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A953CB828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CE2C433D2;
        Fri,  3 Feb 2023 06:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406263;
        bh=hj2V1ZZYHFfjxkrfMBxQLi0H6rfE+GbwadToWsRXJ+I=;
        h=Date:To:From:Subject:From;
        b=y5z2tJ/LplhEoRjzYr3YmXylq6i7vr496YR+ayEoBvaHAgavACrqJlrJLj60sBQ+u
         JAqY6QMxbyCBIRxA/pxieAhikM6IdCMoyuWPlwxkDQBOlQomiewxxz02XaiVo16ZQx
         lPMlcLRvA9wUlr10iNn/GVvWjmyfdJMAIO6YwBTk=
Date:   Thu, 02 Feb 2023 22:37:42 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-convert-filemap_map_pmd-to-take-a-folio.patch removed from -mm tree
Message-Id: <20230203063743.47CE2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: convert filemap_map_pmd() to take a folio
has been removed from the -mm tree.  Its filename was
     filemap-convert-filemap_map_pmd-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: convert filemap_map_pmd() to take a folio
Date: Mon, 16 Jan 2023 19:39:39 +0000

Patch series "Some more filemap folio conversions".

Three more places which could easily be converted to folios.  The third
one fixes a minor bug in readahead_expand(), but it's only a performance
bug and there are few users of readahead_expand(), so I don't think it's
worth backporting.


This patch (of 3):

Save a few calls to compound_head().  We specify exactly which page from
the folio to use by passing in start_pgoff, which means this will work for
a folio which is larger than PMD size.  The rest of the VM isn't prepared
for that yet, but now this function is.

Link: https://lkml.kernel.org/r/20230116193941.2148487-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230116193941.2148487-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/filemap.c~filemap-convert-filemap_map_pmd-to-take-a-folio
+++ a/mm/filemap.c
@@ -3259,22 +3259,24 @@ out_retry:
 }
 EXPORT_SYMBOL(filemap_fault);
 
-static bool filemap_map_pmd(struct vm_fault *vmf, struct page *page)
+static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
+		pgoff_t start)
 {
 	struct mm_struct *mm = vmf->vma->vm_mm;
 
 	/* Huge page is mapped? No need to proceed. */
 	if (pmd_trans_huge(*vmf->pmd)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		return true;
 	}
 
-	if (pmd_none(*vmf->pmd) && PageTransHuge(page)) {
+	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
+		struct page *page = folio_file_page(folio, start);
 		vm_fault_t ret = do_set_pmd(vmf, page);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
-			unlock_page(page);
+			folio_unlock(folio);
 			return true;
 		}
 	}
@@ -3284,8 +3286,8 @@ static bool filemap_map_pmd(struct vm_fa
 
 	/* See comment in handle_pte_fault() */
 	if (pmd_devmap_trans_unstable(vmf->pmd)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		return true;
 	}
 
@@ -3368,7 +3370,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 	if (!folio)
 		goto out;
 
-	if (filemap_map_pmd(vmf, &folio->page)) {
+	if (filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


