Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A669CC004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjASWtj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjASWtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:49:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32759A839B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDDAE61D78
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242ACC433EF;
        Thu, 19 Jan 2023 22:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167547;
        bh=Hi1uOH5PGBpDaC8IORM2KWfqP8xB8Il+pr7i5zXRg9o=;
        h=Date:To:From:Subject:From;
        b=Luv6TX5HA+keAiwUvdgBwmAuWYzsS8eNuLtaP7qLuZ5EyhVfd2skDY9FErcfR01U4
         Z2sozcSJ6bh/g2sP8/iS4VQD8yLjKyyUbTib1UUYHQNdxZrkSVfbmt5lSCLkYi8yiv
         T2MWA3EGbRO9i6lZLdl8AfRZ+2OV+64JlJO73EWY=
Date:   Thu, 19 Jan 2023 14:32:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch added to mm-unstable branch
Message-Id: <20230119223227.242ACC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert hugetlbfs_pagecache_present() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlbfs_pagecache_present() to folios
Date: Thu, 19 Jan 2023 13:14:39 -0800

Convert hugetlbfs_pagecache_present() to use folios internally by
replacing a call to find_get_page() to filemap_get_folio().

Link: https://lkml.kernel.org/r/20230119211446.54165-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios
+++ a/mm/hugetlb.c
@@ -5653,15 +5653,15 @@ static bool hugetlbfs_pagecache_present(
 {
 	struct address_space *mapping;
 	pgoff_t idx;
-	struct page *page;
+	struct folio *folio;
 
 	mapping = vma->vm_file->f_mapping;
 	idx = vma_hugecache_offset(h, vma, address);
 
-	page = find_get_page(mapping, idx);
-	if (page)
-		put_page(page);
-	return page != NULL;
+	folio = filemap_get_folio(mapping, idx);
+	if (folio)
+		folio_put(folio);
+	return folio != NULL;
 }
 
 int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

