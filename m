Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4257C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiDLXUR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiDLXTf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E1B6EB36
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 16:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D70ABB82077
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 23:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE00C385A1;
        Tue, 12 Apr 2022 23:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649804564;
        bh=GIkeamROFHESDzZAb5I2MxgFKTJgvGKsA491le2ItNY=;
        h=Date:To:From:Subject:From;
        b=F4m1K5r2wbJtEMXJ9ZOB8e1I5xGuszddKXLEvkJDd0vNi/nNmBYILvoWeqHYYr+X9
         gwhiBiehJDy0BLvaxTyDOlutmL9ISRH3D9Qn5Vsuh58UdcIfDztcRPyGrBl0xJWoQx
         +rF7oZl1uJ0eJ/Kbqnj4F+xx7HcUGYYUc6KDBLFM=
Date:   Tue, 12 Apr 2022 16:02:43 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failurec-dissolve-truncated-hugetlb-page.patch removed from -mm tree
Message-Id: <20220412230244.8CE00C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: dissolve truncated hugetlb page
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-dissolve-truncated-hugetlb-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: dissolve truncated hugetlb page

If me_huge_page meets a truncated huge page, hpage won't be dissolved even
if we hold the last refcnt.  It's because the truncated huge page has NULL
page_mapping while it's not anonymous page too.  Thus we lose the last
chance to dissolve it into buddy to save healthy subpages.  Remove
PageAnon check to handle these huge pages too.

Link: https://lkml.kernel.org/r/20220407130352.15618-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-dissolve-truncated-hugetlb-page
+++ a/mm/memory-failure.c
@@ -1046,8 +1046,7 @@ static int me_huge_page(struct page_stat
 		 * hugepage, so we can free and dissolve it into buddy to
 		 * save healthy subpages.
 		 */
-		if (PageAnon(hpage))
-			put_page(hpage);
+		put_page(hpage);
 		if (__page_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mmapc-use-helper-mlock_future_check.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mremap-avoid-unneeded-do_munmap-call.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-z3fold-declare-z3fold_mount-with-__init.patch
mm-z3fold-remove-obsolete-comment-in-z3fold_alloc.patch
mm-z3fold-minor-clean-up-for-z3fold_free.patch
mm-z3fold-remove-unneeded-page_mapcount_reset-and-clearpageprivate.patch
mm-z3fold-remove-confusing-local-variable-l-reassignment.patch
mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch
mm-z3fold-remove-redundant-list_del_init-of-zhdr-buddy-in-z3fold_free.patch
mm-z3fold-remove-unneeded-page_headless-check-in-free_handle.patch
mm-compaction-use-helper-isolation_suitable.patch
drivers-base-nodec-fix-compaction-sysfs-file-leak.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

