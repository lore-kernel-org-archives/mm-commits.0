Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C843C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835186024A
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHVWVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 18:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234232AbhHVWVm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 18:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 703AA6135F;
        Sun, 22 Aug 2021 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629670860;
        bh=Hd6qWMmbjfF9v/t1oMh9jR74KgvAOYdVMRAI6QQQHEU=;
        h=Date:From:To:Subject:From;
        b=QwSOfsyzIjRvY3HZIcrU9nD2288CNHrPpe2cUtATpCYiVHN3rnL8/zpF0GLaE18pY
         poPIir1b48n9FZBnMx0vBrw3uHfOb9o40uOWaDKN5oNbnttRyKsnuheZDUIpWyrAAE
         fNXjEHdTBs2qFmCutILp/Xrn+XL1hqMOUMsMa8Vg=
Date:   Sun, 22 Aug 2021 15:21:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        minchan@kernel.org, mhocko@suse.com, cgoldswo@codeaurora.org,
        linmiaohe@huawei.com
Subject:  +
 mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch added
 to -mm tree
Message-ID: <20210822222100.ISVF5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: make HWPoisoned dirty swapcache pages unmovable
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch

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
Subject: mm/memory_hotplug: make HWPoisoned dirty swapcache pages unmovable

HWPoisoned dirty swapcache pages are kept for killing owner processes.  We
should not offline these pages or do_swap_page() would access the offline
pages and lead to bad ending.

Link: https://lkml.kernel.org/r/20210821094246.10149-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable
+++ a/mm/memory_hotplug.c
@@ -1664,6 +1664,12 @@ static int scan_movable_pages(unsigned l
 		 */
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
+		/*
+		 * HWPoisoned dirty swapcache pages are definitely unmovable
+		 * because they are kept for killing owner processes.
+		 */
+		if (PageHWPoison(page) && PageSwapCache(page))
+			return -EBUSY;
 
 		if (!PageHuge(page))
 			continue;
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

