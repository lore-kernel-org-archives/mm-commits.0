Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02C9C07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiI2EJb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiI2EJa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE0127C9A
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC6BB8220A
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DFFC433D6;
        Thu, 29 Sep 2022 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424567;
        bh=76Seod3IZ0liSYJnJpl/4gwfdvZcqYIBOU/4WAlG9Rs=;
        h=Date:To:From:Subject:From;
        b=icgGpu2OTNfOP8GUoFQQpzz4ZKeldk6LDvUqBMDpXeojx04HhOSwsc/xdrGTiD+aU
         HTMSkhPXL8zPmyDl8loNv/CKsyQuqKcg4HvrOJu4LERRIq/869lHtRZiX2G3/uAUQt
         2TiwXbBmNtGM6RF4zY7pKNminvY6NMV/y+P7mZ0g=
Date:   Wed, 28 Sep 2022 21:09:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mhocko@suse.com, linmiaohe@huawei.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch removed from -mm tree
Message-Id: <20220929040927.01DFFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
has been removed from the -mm tree.  Its filename was
     hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3.patch

This patch was dropped because it was folded into hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
Date: Wed, 21 Sep 2022 13:27:02 -0700

fix NULL pointer dereference in alloc_buddy_huge_page caused by not
checking for page before attempting to freeze.  Thanks Naoya.

Link: https://lkml.kernel.org/r/20220921202702.106069-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages-v3
+++ a/mm/hugetlb.c
@@ -1957,7 +1957,7 @@ retry:
 	page = __alloc_pages(gfp_mask, order, nid, nmask);
 
 	/* Freeze head page */
-	if (!page_ref_freeze(page, 1)) {
+	if (page && !page_ref_freeze(page, 1)) {
 		__free_pages(page, order);
 		if (retry) {	/* retry once */
 			retry = false;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch
hugetlb-freeze-allocated-pages-before-creating-hugetlb-pages.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

