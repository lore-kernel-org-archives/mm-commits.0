Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AE9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiEJEQp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiEJEPr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5D3F68B5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963A361738
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB864C385A6;
        Tue, 10 May 2022 04:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155894;
        bh=RclJq+uv2kCvc6r2wxzvCg9kt0ApbnqoBcDLRIkY8e0=;
        h=Date:To:From:Subject:From;
        b=pYPcAFqd6A1dPRK3P6NIwtHDn0jR3ysXBxkzhtVPlQcIAfxi7uvdk02hAqcZ8U/Ew
         ZdCZeE9X4U6fbjTsHTRBS0TxTmnhSVZIxJLIVhOY7kOvuip4Kguv2HXeN6wkOgS/F1
         ifi56f5PzTqdwM8h5QLjGhwQQ1Y4tsoDDS0UcbpY=
Date:   Mon, 09 May 2022 21:11:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch removed from -mm tree
Message-Id: <20220510041133.EB864C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: simplify the refcount validation when migrating hugetlb mapping
has been removed from the -mm tree.  Its filename was
     mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: simplify the refcount validation when migrating hugetlb mapping

There is no need to validate the hugetlb page's refcount before trying to
freeze the hugetlb page's expected refcount, instead we can just rely on
the page_ref_freeze() to simplify the validation.

Moreover we are always under the page lock when migrating the hugetlb page
mapping, which means nowhere else can remove it from the page cache, so we
can remove the xas_load() validation under the i_pages lock.

Link: https://lkml.kernel.org/r/eb2fbbeaef2b1714097b9dec457426d682ee0635.1649676424.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-the-refcount-validation-when-migrating-hugetlb-mapping
+++ a/mm/migrate.c
@@ -471,11 +471,6 @@ int migrate_huge_page_move_mapping(struc
 
 	xas_lock_irq(&xas);
 	expected_count = 2 + page_has_private(page);
-	if (page_count(page) != expected_count || xas_load(&xas) != page) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
 	if (!page_ref_freeze(page, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


