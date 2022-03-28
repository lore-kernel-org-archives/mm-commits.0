Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D390FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiC1WRf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiC1WQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404F21385A8
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D44FF61477
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A63FC340F0;
        Mon, 28 Mar 2022 22:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505587;
        bh=XyHl3obvLAt/Xu4p8yJiyjaJh6wKfaC94RQfz+o3ytM=;
        h=Date:To:From:Subject:From;
        b=m4fL3emNyOKnk0k434pD7qv8nVM8WtOKrTf1jqv9SaPLjIYEtRFGCnxV8HlZoOfED
         pK8hGT2g3qN4yuPQqHMYO6nl753FXXnWm6VsIBpK3iLkvjGIRk4NORDADmFSximGe4
         pIft+gGjEg0LJSTWT2fgSDCKHtLMufwfy3fY/oC8=
Date:   Mon, 28 Mar 2022 15:13:06 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch added to -mm tree
Message-Id: <20220328221307.3A63FC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: fix possible do_pages_stat_array racing with memory offline
has been added to the -mm tree.  Its filename is
     mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

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
Subject: mm/migration: fix possible do_pages_stat_array racing with memory offline

When follow_page peeks a page, the page could be migrated and then be
offlined while it's still being used by the do_pages_stat_array().  Use
FOLL_GET to hold the page refcnt to fix this potential race.

Link: https://lkml.kernel.org/r/20220318111709.60311-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline
+++ a/mm/migrate.c
@@ -1798,13 +1798,18 @@ static void do_pages_stat_array(struct m
 			goto set_status;
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_DUMP);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto set_status;
 
-		err = page ? page_to_nid(page) : -ENOENT;
+		if (page) {
+			err = page_to_nid(page);
+			put_page(page);
+		} else {
+			err = -ENOENT;
+		}
 set_status:
 		*status = err;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-compaction-use-helper-isolation_suitable.patch
mm-migration-remove-unneeded-local-variable-mapping_locked.patch
mm-migration-remove-unneeded-out-label.patch
mm-migration-remove-unneeded-local-variable-page_lru.patch
mm-migration-fix-the-confusing-pagetranshuge-check.patch
mm-migration-use-helper-function-vma_lookup-in-add_page_for_migration.patch
mm-migration-use-helper-macro-min-in-do_pages_stat.patch
mm-migration-avoid-unneeded-nodemask_t-initialization.patch
mm-migration-remove-some-duplicated-codes-in-migrate_pages.patch
mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
mm-migration-fix-possible-do_pages_stat_array-racing-with-memory-offline.patch

