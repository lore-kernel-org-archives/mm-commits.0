Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA50C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjHKW6g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjHKW6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9C7268C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF866699C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6385C433C9;
        Fri, 11 Aug 2023 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794711;
        bh=R/boDc11fo8plnP6B6EOjujsNtDAiveOV+AinqLj/fA=;
        h=Date:To:From:Subject:From;
        b=I+EUTfxJcyv+uw56FcrLIuGq8pAnWimg7Dnh8Ksoo6arkNAt806BEq9jmm0deuOpi
         28Wq5PhExBR9mz55/IPmYRJYftASDPxFv/lhGJlbSc42OCExrbs6PM8U/r+FaETQOe
         IUXolyn81BxtIvRb+f61A8gHVvm4Y/hMHnHXXL6Y=
Date:   Fri, 11 Aug 2023 15:58:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-fault_dirty_shared_page.patch removed from -mm tree
Message-Id: <20230811225831.C6385C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use a folio in fault_dirty_shared_page()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-fault_dirty_shared_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: use a folio in fault_dirty_shared_page()
Date: Sat, 1 Jul 2023 11:28:52 +0800

We can replace four implicit calls to compound_head() with one by using
folio.

Link: https://lkml.kernel.org/r/20230701032853.258697-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-fault_dirty_shared_page
+++ a/mm/memory.c
@@ -2965,20 +2965,20 @@ static vm_fault_t fault_dirty_shared_pag
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping;
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	bool dirtied;
 	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
 
-	dirtied = set_page_dirty(page);
-	VM_BUG_ON_PAGE(PageAnon(page), page);
+	dirtied = folio_mark_dirty(folio);
+	VM_BUG_ON_FOLIO(folio_test_anon(folio), folio);
 	/*
-	 * Take a local copy of the address_space - page.mapping may be zeroed
-	 * by truncate after unlock_page().   The address_space itself remains
-	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
+	 * Take a local copy of the address_space - folio.mapping may be zeroed
+	 * by truncate after folio_unlock().   The address_space itself remains
+	 * pinned by vma->vm_file's reference.  We rely on folio_unlock()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = page_rmapping(page);
-	unlock_page(page);
+	mapping = folio_raw_mapping(folio);
+	folio_unlock(folio);
 
 	if (!page_mkwrite)
 		file_update_time(vma->vm_file);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

