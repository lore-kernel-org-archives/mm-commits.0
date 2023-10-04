Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BF9E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjJDUWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244853AbjJDUW0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623821712
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D4EC433C8;
        Wed,  4 Oct 2023 20:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450878;
        bh=Lj8+cZKIflgBRWDTSyAV7NhSBWwDV1Zq4rC9y9+IA6Y=;
        h=Date:To:From:Subject:From;
        b=Q+qReUvyHSXaGj9Jhbg5BVoRX+Vzi2MFX1M+n01MdcKXX3Y9vMEm6DKNDy48mb2ZC
         psS20tMgvb1PvAKa/BBMYWkSFyFqMIgDh5SZH0FzceSwmuh/ecGB+MB7sNFvzKltTM
         XThB/vnVYZRFgFw206fPX6ioNnlgP+oILcIhG8mo=
Date:   Wed, 04 Oct 2023 13:21:16 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch removed from -mm tree
Message-Id: <20231004202117.B1D4EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: remove isolated variable in add_page_for_migration()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: remove isolated variable in add_page_for_migration()
Date: Wed, 13 Sep 2023 17:51:31 +0800

Directly check the return of isolate_hugetlb() and folio_isolate_lru() to
remove isolated variable, also setup err = -EBUSY in advance before
isolation, and update err only when successfully queued for migration,
which could help us to unify and simplify code a bit.

Link: https://lkml.kernel.org/r/20230913095131.2426871-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-isolated-variable-in-add_page_for_migration
+++ a/mm/migrate.c
@@ -2062,7 +2062,6 @@ static int add_page_for_migration(struct
 	struct page *page;
 	struct folio *folio;
 	int err;
-	bool isolated;
 
 	mmap_read_lock(mm);
 	addr = (unsigned long)untagged_addr_remote(mm, p);
@@ -2095,15 +2094,13 @@ static int add_page_for_migration(struct
 	if (page_mapcount(page) > 1 && !migrate_all)
 		goto out_putfolio;
 
+	err = -EBUSY;
 	if (folio_test_hugetlb(folio)) {
-		isolated = isolate_hugetlb(folio, pagelist);
-		err = isolated ? 1 : -EBUSY;
+		if (isolate_hugetlb(folio, pagelist))
+			err = 1;
 	} else {
-		isolated = folio_isolate_lru(folio);
-		if (!isolated) {
-			err = -EBUSY;
+		if (!folio_isolate_lru(folio))
 			goto out_putfolio;
-		}
 
 		err = 1;
 		list_add_tail(&folio->lru, pagelist);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

