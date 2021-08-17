Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E757AC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C323060ED5
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhHQBSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 21:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhHQBSn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 21:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE3C60EE5;
        Tue, 17 Aug 2021 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629163090;
        bh=ysil2JFzteW9GOCnC5RKjCCiyApbHOYu2oFTpJmFeTE=;
        h=Date:From:To:Subject:From;
        b=QWezmkdXgcdLMWL6zvOst3R9Z/MlTqOEjLk/s49dzmTBFm+K3uY/nmqxoMRZDifYu
         3xO3k1nhfv3QaV4V0TOeFbThoPsn9As2Pk7fHBJtnAbsk+ePiEqT1RU8hT86bZzQ47
         I08MWJ/JIj9bJr/VHj8U1Fb522y3AK9rpaIl/X2o=
Date:   Mon, 16 Aug 2021 18:18:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com
Subject:  + mm-hwpoison-remove-unneeded-variable-unmap_success.patch
 added to -mm tree
Message-ID: <20210817011810.vyRh3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: remove unneeded variable unmap_success
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-unneeded-variable-unmap_success.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-unneeded-variable-unmap_success.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-unneeded-variable-unmap_success.patch

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
Subject: mm/hwpoison: remove unneeded variable unmap_success

Patch series "Cleanups and fixup for hwpoison"

This series contains cleanups to remove unneeded variable, fix some
obsolete comments and so on.  Also we fix potential pte_unmap_unlock on
wrong pte.  More details can be found in the respective changelogs.


This patch (of 4):

unmap_success is used to indicate whether page is successfully unmapped
but it's irrelated with ZONE_DEVICE page and unmap_success is always true
here.  Remove this unneeded one.

Link: https://lkml.kernel.org/r/20210814105131.48814-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210814105131.48814-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-unneeded-variable-unmap_success
+++ a/mm/memory-failure.c
@@ -1512,7 +1512,6 @@ static int memory_failure_dev_pagemap(un
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
-	const bool unmap_success = true;
 	unsigned long size = 0;
 	struct to_kill *tk;
 	LIST_HEAD(tokill);
@@ -1584,7 +1583,7 @@ static int memory_failure_dev_pagemap(un
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
+	kill_procs(&tokill, flags & MF_MUST_KILL, false, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
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
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

