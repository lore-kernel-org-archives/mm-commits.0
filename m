Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10F1C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiC1WR1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiC1WQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6A215AAF1
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AAF8DCE1110
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCACC34100;
        Mon, 28 Mar 2022 22:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505580;
        bh=1EJaNKpV3Tnrz0HyfSiCqyhJozs/0tFXNWbC4KWqEoo=;
        h=Date:To:From:Subject:From;
        b=c4jiNTTDRYEYFo4iQzz4FY7vaE/CxPgMx8ghXkOUVHM3ABul10zhLzrh9eKihUs2+
         GA4lY7BpByIHTzk8yWc6kdyD/Z4snXfBrff3lU15zJxlT2icNElmlrWYNoNbZrbvQc
         s3X5W4CfFzo8iMWs+fXTGByz2d40oli5CrEnJiDI=
Date:   Mon, 28 Mar 2022 15:12:59 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-avoid-unneeded-nodemask_t-initialization.patch added to -mm tree
Message-Id: <20220328221300.0FCACC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: avoid unneeded nodemask_t initialization
has been added to the -mm tree.  Its filename is
     mm-migration-avoid-unneeded-nodemask_t-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-avoid-unneeded-nodemask_t-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-avoid-unneeded-nodemask_t-initialization.patch

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
Subject: mm/migration: avoid unneeded nodemask_t initialization

Avoid unneeded next_pass and this_pass initialization as they're always
set before using to save possible cpu cycles when there are plenty of
nodes in the system.

Link: https://lkml.kernel.org/r/20220318111709.60311-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-avoid-unneeded-nodemask_t-initialization
+++ a/mm/migrate.c
@@ -2370,8 +2370,8 @@ out_clear:
  */
 static void __set_migration_target_nodes(void)
 {
-	nodemask_t next_pass	= NODE_MASK_NONE;
-	nodemask_t this_pass	= NODE_MASK_NONE;
+	nodemask_t next_pass;
+	nodemask_t this_pass;
 	nodemask_t used_targets = NODE_MASK_NONE;
 	int node, best_distance;
 
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

