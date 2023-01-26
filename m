Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1FCC27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbjAZAsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbjAZAsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:48:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556C436447
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4EBBB817BB
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B60C433D2;
        Thu, 26 Jan 2023 00:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674694092;
        bh=81mJA6U3bf4HTg3rdMOLAK8ORX+1L9nLykGcMJmS7f8=;
        h=Date:To:From:Subject:From;
        b=Z2jGfQFmRMIrO5yBbWhh08oz4wLQkYtopA8ylHVadNsRTByHmhdm5yQfUOxPh4bDc
         3X+iPG9tQJQo5J9r/A3IhAwlR3FALbM69L08GF/Z2AEDZ9QB7FPyV5NAVohrDa+glk
         eIIlcOSY62dNAckCimcocEuxAky/lXHngMdIcXSc=
Date:   Wed, 25 Jan 2023 16:48:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch added to mm-unstable branch
Message-Id: <20230126004812.72B60C433D2@smtp.kernel.org>
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
Date: Wed, 25 Jan 2023 09:05:31 -0800

Refactor hugetlbfs_pagecache_present() to avoid getting and dropping a
refcount on a page.  Use RCU and page_cache_next_miss() instead.

Link: https://lkml.kernel.org/r/20230125170537.96973-3-sidhartha.kumar@oracle.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios
+++ a/mm/hugetlb.c
@@ -5651,17 +5651,15 @@ out_release_old:
 static bool hugetlbfs_pagecache_present(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
-	struct address_space *mapping;
-	pgoff_t idx;
-	struct page *page;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	pgoff_t idx = vma_hugecache_offset(h, vma, address);
+	bool present;
 
-	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
+	rcu_read_lock();
+	present = page_cache_next_miss(mapping, idx, 1) != idx;
+	rcu_read_unlock();
 
-	page = find_get_page(mapping, idx);
-	if (page)
-		put_page(page);
-	return page != NULL;
+	return present;
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
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

