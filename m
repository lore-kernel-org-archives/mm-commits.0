Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0652C432BE
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3E461356
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 20:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhHVUMJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 16:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhHVUMJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 16:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0D061284;
        Sun, 22 Aug 2021 20:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629663087;
        bh=QDlMJHqzv71+up46d4MR1w71msstUat4Z8BoL2XXHyA=;
        h=Date:From:To:Subject:From;
        b=CPGLpSBCGG67WZsF7ZJ+R6NJzRUwGPAZm7VKTnBPC6aJMkj/A4llq2sEMbD5Pm4K/
         gkJkCj9aYt2SbFWE5K95HMbpD/m3EKo/c1tnXtVA/IfDUFcWUvN5gCg8H4xhDIiGRM
         RS8ePNdSg7ARD078J08z6vJjaQHqqdVa/IGFrMoM=
Date:   Sun, 22 Aug 2021 13:11:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        minchan@kernel.org, mhocko@suse.com, cgoldswo@codeaurora.org,
        linmiaohe@huawei.com
Subject:  +
 mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch added to
 -mm tree
Message-ID: <20210822201127.zNXNk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix potential permanent lru cache disable
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch

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
Subject: mm/memory_hotplug: fix potential permanent lru cache disable

If offline_pages failed after lru_cache_disable(), it forgot to do
lru_cache_enable() in error path.  So we would have lru cache disabled
permanently in this case.

Link: https://lkml.kernel.org/r/20210821094246.10149-3-linmiaohe@huawei.com
Fixes: d479960e44f2 ("mm: disable LRU pagevec during the migration temporarily")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-potential-permanent-lru-cache-disable
+++ a/mm/memory_hotplug.c
@@ -2033,6 +2033,7 @@ failed_removal_isolated:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-fix-potential-permanent-lru-cache-disable.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

