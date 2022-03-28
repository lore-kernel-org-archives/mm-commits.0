Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D46EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiC1WRe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiC1WQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:16:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E876338C
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41909CE1757
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D694C340F0;
        Mon, 28 Mar 2022 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648505583;
        bh=FOMZRTY0oK9FzML2gTNFDA6OkF+uHEuyLC76fZwMHws=;
        h=Date:To:From:Subject:From;
        b=ffJQz1j7x5OmhVCQmOjJ4bnlJxS5U1+lhXUrrh+QwWndq/D6PsNPblTQyR8bI5fzw
         kOY/IirBWGSQJeYCJ7EzW1+rnX7rczk3ousmncaw6il/XPRyaK44BD9FRymwIX6Xsm
         1+M3UxRUUo2h6JfV9EFTfOV9btRiZBUaAed+wqKU=
Date:   Mon, 28 Mar 2022 15:13:03 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        songmuchun@bytedance.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch added to -mm tree
Message-Id: <20220328221303.9D694C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: fix potential page refcounts leak in migrate_pages
has been added to the -mm tree.  Its filename is
     mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages.patch

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
Subject: mm/migration: fix potential page refcounts leak in migrate_pages

In -ENOMEM case, there might be some subpages of fail-to-migrate THPs left
in thp_split_pages list.  We should move them back to migration list so
that they could be put back to the right list by the caller otherwise the
page refcnt will be leaked here.  Also adjust nr_failed and nr_thp_failed
accordingly to make vm events account more accurate.

Link: https://lkml.kernel.org/r/20220318111709.60311-10-linmiaohe@huawei.com
Fixes: b5bade978e9b ("mm: migrate: fix the return value of migrate_pages()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c~mm-migration-fix-potential-page-refcounts-leak-in-migrate_pages
+++ a/mm/migrate.c
@@ -1434,6 +1434,14 @@ retry:
 				}
 
 				nr_failed_pages += nr_subpages;
+				/*
+				 * There might be some subpages of fail-to-migrate THPs
+				 * left in thp_split_pages list. Move them back to migration
+				 * list so that they could be put back to the right list by
+				 * the caller otherwise the page refcnt will be leaked.
+				 */
+				list_splice_init(&thp_split_pages, from);
+				nr_thp_failed += thp_retry;
 				goto out;
 			case -EAGAIN:
 				if (is_thp)
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

