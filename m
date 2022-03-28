Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B3BC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiC1WRA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiC1WQh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59310887A1
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE527CE1757
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA11C340F0;
        Mon, 28 Mar 2022 22:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505571;
        bh=iY8KsdClzuIXJmALUU1AlmwFe0GToprV2iB4PP1JM5Y=;
        h=Date:To:From:Subject:From;
        b=m+6TZ3qvk4fwc4twSbfqz+Yjp/tUq5Hx/6hEVB3Nz22F3LB9aKvd4ioNcl5Ytgvoh
         MJ1W7cFW9TlOQuc+Yib82ykc1XTO9FftZ9BoHFisRqA0TsAMYJY59/V4nv/ouxngV2
         tJvIws+2Uwu8V4U3PmjfGkqNwLf8NnwC+bwtIjBk=
Date:   Mon, 28 Mar 2022 15:12:50 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-remove-unneeded-out-label.patch added to -mm tree
Message-Id: <20220328221251.2BA11C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: remove unneeded out label
has been added to the -mm tree.  Its filename is
     mm-migration-remove-unneeded-out-label.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-remove-unneeded-out-label.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-remove-unneeded-out-label.patch

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
Subject: mm/migration: remove unneeded out label

We can do prep_transhuge_page when newpage is not NULL.  Thus we can
remove out label to simplify the code.

Link: https://lkml.kernel.org/r/20220318111709.60311-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migration-remove-unneeded-out-label
+++ a/mm/migrate.c
@@ -2016,12 +2016,9 @@ static struct page *alloc_misplaced_dst_
 
 	newpage = alloc_pages_node(nid, (GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 				   HPAGE_PMD_ORDER);
-	if (!newpage)
-		goto out;
+	if (newpage)
+		prep_transhuge_page(newpage);
 
-	prep_transhuge_page(newpage);
-
-out:
 	return newpage;
 }
 
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

