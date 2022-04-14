Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F1AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346651AbiDNUsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 16:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242193AbiDNUsc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 16:48:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C90EDF03
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 13:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1047B818EB
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96A1C385A8;
        Thu, 14 Apr 2022 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649969163;
        bh=ffNPa5RsuLLbfArR0ZWvNIiPEzu65cHJKaIslgCNee4=;
        h=Date:To:From:Subject:From;
        b=xfeEnzCdo3mMHE1fzOKnADBhKrZGxXvrsljCwqCJwuMCUd3yzgu8Jt2Nu/fHTjEA8
         psTXWIEyY/cyHC0vRcBea3SCc/iKDUrcRMRROx9Ta2eFJer9LoEsqhVx6YXBGJdbw1
         DZ51TJgfHHe2PnWxt5qgxZToPjPwNgRX8xPF7gYE=
Date:   Thu, 14 Apr 2022 13:46:02 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        naoya.horiguchi@nec.com, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-dissolve-truncated-hugetlb-page.patch added to -mm tree
Message-Id: <20220414204603.A96A1C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: dissolve truncated hugetlb page
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-dissolve-truncated-hugetlb-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-dissolve-truncated-hugetlb-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: dissolve truncated hugetlb page

If me_huge_page meets a truncated but not yet freed hugepage, it won't be
dissolved even if we hold the last refcnt. It's because the hugepage has
NULL page_mapping while it's not anonymous hugepage too. Thus we lose the
last chance to dissolve it into buddy to save healthy subpages. Remove
PageAnon check to handle these hugepages too.

Link: https://lkml.kernel.org/r/20220414114941.11223-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failurec-dissolve-truncated-hugetlb-page
+++ a/mm/memory-failure.c
@@ -1041,12 +1041,11 @@ static int me_huge_page(struct page_stat
 		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
-		 * migration entry prevents later access on error anonymous
-		 * hugepage, so we can free and dissolve it into buddy to
-		 * save healthy subpages.
+		 * migration entry prevents later access on error hugepage,
+		 * so we can free and dissolve it into buddy to save healthy
+		 * subpages.
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
mm-memory-failurec-minor-cleanup-for-hwpoisonhandlable.patch
mm-memory-failurec-dissolve-truncated-hugetlb-page.patch
mm-vmscan-remove-obsolete-comment-in-get_scan_count.patch
mm-vmscan-fix-comment-for-current_may_throttle.patch
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

