Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3343C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjBCGlf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBCGkd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA388F519
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B9ADB82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB0EC433EF;
        Fri,  3 Feb 2023 06:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406252;
        bh=/MDCpSS2hqBe6WEEiJXab5XH4KXZPsJ/vuCt6IbBeg4=;
        h=Date:To:From:Subject:From;
        b=OcF8j+UDGYVfH4HhuE8UIMGJVt7cElAfqZheaQ4ySDRhDPWmUpctrawS+F3l8+iq2
         e4Y7Z1zT9edzXF4emymoHOkQqxgktuDmtEIvIV1k6+F6Rd78RkG6kxoBfpaptX9zPG
         VSbeCvIaysUjo6PB9BHWqTBNf26tGi9LfmjoZNYs=
Date:   Thu, 02 Feb 2023 22:37:31 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_anonymous_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230203063732.1AB0EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_anonymous_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_anonymous_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_anonymous_page() to use a folio
Date: Mon, 16 Jan 2023 19:18:10 +0000

Removes six calls to compound_head(); some inline and some external.

Link: https://lkml.kernel.org/r/20230116191813.2145215-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-convert-do_anonymous_page-to-use-a-folio
+++ a/mm/memory.c
@@ -3996,7 +3996,6 @@ out_release:
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page;
 	struct folio *folio;
 	vm_fault_t ret = 0;
 	pte_t entry;
@@ -4051,19 +4050,18 @@ static vm_fault_t do_anonymous_page(stru
 	if (!folio)
 		goto oom;
 
-	page = &folio->page;
 	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
-	cgroup_throttle_swaprate(page, GFP_KERNEL);
+	cgroup_throttle_swaprate(&folio->page, GFP_KERNEL);
 
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
 	 * the set_pte_at() write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
-	entry = mk_pte(page, vma->vm_page_prot);
+	entry = mk_pte(&folio->page, vma->vm_page_prot);
 	entry = pte_sw_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
@@ -4082,13 +4080,13 @@ static vm_fault_t do_anonymous_page(stru
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		put_page(page);
+		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, vmf->address);
-	lru_cache_add_inactive_or_unevictable(page, vma);
+	folio_add_new_anon_rmap(folio, vma, vmf->address);
+	folio_add_lru_vma(folio, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
@@ -4098,10 +4096,10 @@ unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 release:
-	put_page(page);
+	folio_put(folio);
 	goto unlock;
 oom_free_page:
-	put_page(page);
+	folio_put(folio);
 oom:
 	return VM_FAULT_OOM;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


