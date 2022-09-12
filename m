Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34365ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiILDfw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiILDdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1662A269
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD010611AD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21634C433C1;
        Mon, 12 Sep 2022 03:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953443;
        bh=i67NmiDRhW7eH1WcLJ4Q1hcn1nrosundKZfl+MSRgU4=;
        h=Date:To:From:Subject:From;
        b=EtodZ1ruiy9rBpkyhnLpZgBxvrmRhDtBAzmGovz/AVfryEoudHeJdzHAUtGimAfaW
         68ZcymXd+nrbAL/zEHYVs1vY1hp8FgjFBkCTHJ+xeUkokO4xbDqHDnea5ToltfdtUR
         mFPtxTi0yL+cClPBr1OzaiHl1FC+4frPjI0Lw12Y=
Date:   Sun, 11 Sep 2022 20:30:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-list_head-to-define-a-list-head.patch removed from -mm tree
Message-Id: <20220912033043.21634C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: use LIST_HEAD() to define a list head
has been removed from the -mm tree.  Its filename was
     hugetlb-use-list_head-to-define-a-list-head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: use LIST_HEAD() to define a list head
Date: Thu, 1 Sep 2022 20:00:23 +0800

Use LIST_HEAD() directly to define a list head to simplify the code.
No functional change intended.

Link: https://lkml.kernel.org/r/20220901120030.63318-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-list_head-to-define-a-list-head
+++ a/mm/hugetlb.c
@@ -456,14 +456,12 @@ static int allocate_file_region_entries(
 					int regions_needed)
 	__must_hold(&resv->lock)
 {
-	struct list_head allocated_regions;
+	LIST_HEAD(allocated_regions);
 	int to_allocate = 0, i = 0;
 	struct file_region *trg = NULL, *rg = NULL;
 
 	VM_BUG_ON(regions_needed < 0);
 
-	INIT_LIST_HEAD(&allocated_regions);
-
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
 	 * the number of in progress add operations plus regions_needed.
@@ -2336,7 +2334,7 @@ struct page *alloc_huge_page_vma(struct
 static int gather_surplus_pages(struct hstate *h, long delta)
 	__must_hold(&hugetlb_lock)
 {
-	struct list_head surplus_list;
+	LIST_HEAD(surplus_list);
 	struct page *page, *tmp;
 	int ret;
 	long i;
@@ -2351,7 +2349,6 @@ static int gather_surplus_pages(struct h
 	}
 
 	allocated = 0;
-	INIT_LIST_HEAD(&surplus_list);
 
 	ret = -ENOMEM;
 retry:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

