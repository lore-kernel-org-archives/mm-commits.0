Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C55C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357367AbiCYBdn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352465AbiCYBcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F40403CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD823B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D60DC340EC;
        Fri, 25 Mar 2022 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171850;
        bh=Hnz0bFMA3LvsJnbPtJv2USqa03IXoMsFpkKVRpBmYPA=;
        h=Date:To:From:Subject:From;
        b=0ct8/wkMgDMP9Pjc+8Owf6Qn+PAiYTQ8MGqHC77eNnqYT6FJamlEaLsad81194OOb
         7gKqFtE2Dp3cBXTW5CisSkCemm9O0VBAZIzDGoLMJV40ddw4TS3x6y8JSwf2lGk7kz
         ZDZ+11FgL1em2o9buIRaIco2TUljLBJj0UnxzGhY=
Date:   Thu, 24 Mar 2022 18:30:49 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch removed from -mm tree
Message-Id: <20220325013050.4D60DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix wrong cache flush in remove_migration_pmd()
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are


