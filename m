Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCFEC41604
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4327B221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633088;
	bh=JBI364f1UNtCjn243U+XLFAXHbTaWslKyifAqjOA8vs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Hi2C3blvP7Ud+iVlj42GdWzU57o+tZ+FF/4PgINY+NZrLIkRbamgiHxqf3aXzEuID
	 bjD4KtJk0MWCgQBpEoaKkOt3yi3gxw+cKWTttDyfBVcspX9cb7iogrm3Zg/8CL90M7
	 lbn58R/tqdiNY2ojmERUWHmfPfTOUcujLj8wC2+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgJMXv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgJMXvW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D305C22246;
        Tue, 13 Oct 2020 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633082;
        bh=JBI364f1UNtCjn243U+XLFAXHbTaWslKyifAqjOA8vs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hS8OAxuLpbK/BlTdWssukHx1daTKdWdtrwPoQb7bJRHLWpqqoagMdVWURUa04p586
         2dDV7SCIJVQyiweU2ATrgAH9R5JBcC1MgnyHRS8SzSjKs4NU6K9ZU/46RP0VGpCJsT
         beWVDQCRY2JrU+MQMvTahKu+DV7LiYCm/obI4eik=
Date:   Tue, 13 Oct 2020 16:51:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 055/181] mm: use find_get_incore_page in
 memcontrol
Message-ID: <20201013235121.JdHdCFGU_%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use find_get_incore_page in memcontrol

The current code does not protect against swapoff of the underlying
swap device, so this is a bug fix as well as a worthwhile reduction in
code complexity.

Link: https://lkml.kernel.org/r/20200910183318.20139-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/memcontrol.c~mm-use-find_get_incore_page-in-memcontrol
+++ a/mm/memcontrol.c
@@ -5539,35 +5539,15 @@ static struct page *mc_handle_swap_pte(s
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	struct page *page = NULL;
-	struct address_space *mapping;
-	pgoff_t pgoff;
-
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
 	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
-	mapping = vma->vm_file->f_mapping;
-	pgoff = linear_page_index(vma, addr);
-
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-#ifdef CONFIG_SWAP
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	if (shmem_mapping(mapping)) {
-		page = find_get_entry(mapping, pgoff);
-		if (xa_is_value(page)) {
-			swp_entry_t swp = radix_to_swp_entry(page);
-			*entry = swp;
-			page = find_get_page(swap_address_space(swp),
-					     swp_offset(swp));
-		}
-	} else
-		page = find_get_page(mapping, pgoff);
-#else
-	page = find_get_page(mapping, pgoff);
-#endif
-	return page;
+	return find_get_incore_page(vma->vm_file->f_mapping,
+			linear_page_index(vma, addr));
 }
 
 /**
_
