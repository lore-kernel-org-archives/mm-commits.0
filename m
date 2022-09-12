Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7DCC6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiILDgB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiILDdw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC2A2A27E
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 690FAB80C75
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDFFC433D6;
        Mon, 12 Sep 2022 03:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953448;
        bh=rcK7lB0dnR8cdkx95i8lQseZG7T9F+qhfCe9byaSUS0=;
        h=Date:To:From:Subject:From;
        b=DFGhCPaN+WUJr2arOt4Bs+ut/Fph941/oEbvt+qhF68k9OuiBDr8MYeZZHPtcdw8H
         0texp22te8jT68CTsTsfAVkK9spCW4tBuv0ZhNjmbXuFdXbJrzTskGHiD8bZozxIJN
         re/rz85UMzMU5BgKCapFR5FjADsSDeP2A/+DEjL0=
Date:   Sun, 11 Sep 2022 20:30:47 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-kill-hugetlbfs_pagecache_page.patch removed from -mm tree
Message-Id: <20220912033048.1FDFFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: kill hugetlbfs_pagecache_page()
has been removed from the -mm tree.  Its filename was
     hugetlb-kill-hugetlbfs_pagecache_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: kill hugetlbfs_pagecache_page()
Date: Thu, 1 Sep 2022 20:00:27 +0800

Fold hugetlbfs_pagecache_page() into its sole caller to remove some
duplicated code. No functional change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/mm/hugetlb.c~hugetlb-kill-hugetlbfs_pagecache_page
+++ a/mm/hugetlb.c
@@ -5433,19 +5433,6 @@ out_release_old:
 	return ret;
 }
 
-/* Return the pagecache page at a given address within a VMA */
-static struct page *hugetlbfs_pagecache_page(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address)
-{
-	struct address_space *mapping;
-	pgoff_t idx;
-
-	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
-
-	return find_lock_page(mapping, idx);
-}
-
 /*
  * Return whether there is a pagecache page to back given address within VMA.
  * Caller follow_hugetlb_page() holds page_table_lock so we cannot lock_page.
@@ -5840,7 +5827,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		pagecache_page = hugetlbfs_pagecache_page(h, vma, haddr);
+		pagecache_page = find_lock_page(mapping, idx);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

