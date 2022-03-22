Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EAAC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbiCVVno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiCVVnf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5505F279
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52EB9B81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91DEC340F3;
        Tue, 22 Mar 2022 21:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985314;
        bh=paGbHyEWO4fjAlnjjA8dly23PY250zM57eYN+jleBqs=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=sTZ2XgW4E9TKeEU6uYhAm0Ve4/UkkL2ZUGcA15UbqNUh+VviIoeoC6FQ2QRmqyVi5
         B42gRgT3VVfdvxgw3aupwrFAdoiNzbA5/5Gbtd677lp7tTpPYhbc/lJud052hFLAHH
         h4+OhxykYkGhqeTt+ID2bQHRDyaEoKZUc15BcR24=
Date:   Tue, 22 Mar 2022 14:41:53 -0700
To:     ziy@nvidia.com, rientjes@google.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 066/227] mm: thp: fix wrong cache flush in remove_migration_pmd()
Message-Id: <20220322214153.E91DEC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: thp: fix wrong cache flush in remove_migration_pmd()

Patch series "Fix some cache flush bugs", v5.

This series focuses on fixing cache maintenance.


This patch (of 7):

The flush_cache_range() is supposed to be justified only if the page is
already placed in process page table, and that is done right after
flush_cache_range().  So using this interface is wrong.  And there is no
need to invalite cache since it was non-present before in
remove_migration_pmd().  So just to remove it.

Link: https://lkml.kernel.org/r/20220210123058.79206-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220210123058.79206-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd
+++ a/mm/huge_memory.c
@@ -3197,7 +3197,6 @@ void remove_migration_pmd(struct page_vm
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
-	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
 		page_add_anon_rmap(new, vma, mmun_start, true);
 	else
@@ -3205,6 +3204,8 @@ void remove_migration_pmd(struct page_vm
 	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
 	if ((vma->vm_flags & VM_LOCKED) && !PageDoubleMap(new))
 		mlock_vma_page(new);
+
+	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
 }
 #endif
_
