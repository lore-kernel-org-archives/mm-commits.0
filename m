Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F01EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 22:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352739AbiD1WGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352711AbiD1WGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 18:06:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D40580EA
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 15:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9594AB830A8
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 22:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9F1C385A9;
        Thu, 28 Apr 2022 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651183399;
        bh=fvRxJg0GfnrBxVbD4lOKiSA2neSKCpFYsZPRryKYYi8=;
        h=Date:To:From:Subject:From;
        b=iRW/7f2U4UWJ5pQRqwjf9ejwZYlLix9aK+2E0IFNO3fUoVtcRKGpqX6RbE1N77NnP
         N4ZIlRf4yWxW73tcavg2+a5M21mQXrAxwRFQg2QqVrDi9Aj/PaJzhj2SCIv5+vTq8E
         XdA4dnZryuAJzFK/0Y1ZZNeBJKQ/DMgHeAsXXioQ=
Date:   Thu, 28 Apr 2022 15:03:18 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, iamjoonsoo.kim@lge.com, hch@lst.de,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-helper-folio_is_file_lru-fix.patch added to -mm tree
Message-Id: <20220428220319.4F9F1C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: use helper folio_is_file_lru()
has been added to the -mm tree.  Its filename is
     mm-vmscan-use-helper-folio_is_file_lru-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-use-helper-folio_is_file_lru-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-use-helper-folio_is_file_lru-fix.patch

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
Subject: mm/vmscan: use helper folio_is_file_lru()

Use helper folio_is_file_lru() to check whether folio is file lru.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220428105802.21389-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-helper-folio_is_file_lru-fix
+++ a/mm/vmscan.c
@@ -1414,7 +1414,7 @@ static enum page_references folio_check_
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if ((vm_flags & VM_EXEC) && !folio_test_swapbacked(folio))
+		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch

