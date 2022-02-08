Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FC3C35296
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387702AbiBHW0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386817AbiBHVPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:15:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C92C0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3C5161615
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08202C004E1;
        Tue,  8 Feb 2022 21:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644354951;
        bh=CIRNP3WDcQhzyXy7dlH8kly5KZTTQ2FSg0gsbUmx6jI=;
        h=Date:To:From:Subject:From;
        b=R4WSDVjntdoJp9uxgsnGdSfY2wYv69zxz6VXQG53IwPeb14RgqZ3RDoTFjtMAUwaQ
         srqZkl+UPOAXDOGiSONVjDjb1PmN7G90iTUcLy9SGXsEBqlcZ+YmIAlm1pYlGv45Wi
         6GTD1tK69KTOvglSq6Zt+KNVuJv4c5oySEvygx1c=
Date:   Tue, 08 Feb 2022 13:15:50 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rientjes@google.com, mike.kravetz@oracle.com,
        lars.persson@axis.com, kirill.shutemov@linux.intel.com,
        duanxiongchun@bytedance.com, almasrymina@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch added to -mm tree
Message-Id: <20220208211551.08202C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix wrong cache flush in remove_migration_pmd()
has been added to the -mm tree.  Its filename is
     mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: thp: fix wrong cache flush in remove_migration_pmd()

The flush_cache_range() is supposed to be justified only if the page is
already placed in process page table, and that is done right after
flush_cache_range().  So using this interface is wrong.  And there is no
need to invalite cache since it was non-present before in
remove_migration_pmd().  So just to remove it.

Link: https://lkml.kernel.org/r/20220208073617.70342-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd
+++ a/mm/huge_memory.c
@@ -3124,7 +3124,6 @@ void remove_migration_pmd(struct page_vm
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
-	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
 		page_add_anon_rmap(new, vma, mmun_start, true);
 	else
@@ -3132,6 +3131,8 @@ void remove_migration_pmd(struct page_vm
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

mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

