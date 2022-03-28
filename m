Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33569C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiC1WRe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiC1WQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CDD433A6
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C021FB81253
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F5DC34100;
        Mon, 28 Mar 2022 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505585;
        bh=RG3jJ9mRRE4A77DvbFhRmf0v7A3UhsAPactm6mrITUM=;
        h=Date:To:From:Subject:From;
        b=hi5ijwgZYs7TWfvXLrVTnPkh8f6kyzfcSl29dNf8R5SkdN7+w9g5yR2aWDbQu4SrA
         tKOjfpHnaB8mvuJ5FAwxOnUhBqF6mCfjp/h4tVTfJaEcTkLE0m1M3GqxmxQd7tQS9+
         JCmMz92/UJkMdzA0q/iz0zfNYY7t11PvTu1g+QA0=
Date:   Mon, 28 Mar 2022 15:13:04 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch added to -mm tree
Message-Id: <20220328221305.73F5DC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: fix potential invalid node access for reclaim-based migration
has been added to the -mm tree.  Its filename is
     mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration.patch

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
Subject: mm/migration: fix potential invalid node access for reclaim-based migration

If we failed to setup hotplug state callbacks for mm/demotion:online in
some corner cases, node_demotion will be left uninitialized.  Invalid node
might be returned from the next_demotion_node() when doing reclaim-based
migration.  Use kcalloc to allocate node_demotion to fix the issue.

Link: https://lkml.kernel.org/r/20220318111709.60311-11-linmiaohe@huawei.com
Fixes: ac16ec835314 ("mm: migrate: support multiple target nodes demotion")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migration-fix-potential-invalid-node-access-for-reclaim-based-migration
+++ a/mm/migrate.c
@@ -2504,9 +2504,9 @@ static int __meminit migrate_on_reclaim_
 
 void __init migrate_on_reclaim_init(void)
 {
-	node_demotion = kmalloc_array(nr_node_ids,
-				      sizeof(struct demotion_nodes),
-				      GFP_KERNEL);
+	node_demotion = kcalloc(nr_node_ids,
+				sizeof(struct demotion_nodes),
+				GFP_KERNEL);
 	WARN_ON(!node_demotion);
 
 	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
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

