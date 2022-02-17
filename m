Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8E0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 03:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiBQDDH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 22:03:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiBQDDH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 22:03:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25775FCB58
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 19:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7696761D06
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 03:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B50C004E1;
        Thu, 17 Feb 2022 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066971;
        bh=Tblw2/TqNjFNa9M/Z/kkdAkiijL4Ua9gaB0BWnapiA0=;
        h=Date:To:From:Subject:From;
        b=TCbQMIJ7F1tyNI/SV2t5H17u0/0MCe28Hv1cIspyYN3o7Zn8SVKeRA16kf02cvWFK
         rAbcHAzeHEUp+d4CFtuU4b4JmOnWFFxSm4Kv68aoMVg2pJGLvM5vrqdxOHgO2QsWbs
         5FnJgX6EdlPmL9OniArbTLtiDIkyfnZsz1lyUt6Q=
Date:   Wed, 16 Feb 2022 19:02:51 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch added to -mm tree
Message-Id: <20220217030251.C7B50C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix race with changing page more robustly
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch

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
Subject: mm/memory-failure.c: fix race with changing page more robustly

We're only intended to deal with the non-Compound page after we split thp
in memory_failure.  However, the page could have changed compound pages
due to race window.  If this happens, we could try again to hopefully
handle the page next round.  Also remove unneeded orig_head.  It's always
equal to the hpage.  So we can use hpage directly and remove this
redundant one.

Link: https://lkml.kernel.org/r/20220216091431.39406-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-more-robustly
+++ a/mm/memory-failure.c
@@ -1686,7 +1686,6 @@ int memory_failure(unsigned long pfn, in
 {
 	struct page *p;
 	struct page *hpage;
-	struct page *orig_head;
 	struct dev_pagemap *pgmap;
 	int res = 0;
 	unsigned long page_flags;
@@ -1732,7 +1731,7 @@ try_again:
 		goto unlock_mutex;
 	}
 
-	orig_head = hpage = compound_head(p);
+	hpage = compound_head(p);
 	num_poisoned_pages_inc();
 
 	/*
@@ -1813,13 +1812,18 @@ try_again:
 	lock_page(p);
 
 	/*
-	 * The page could have changed compound pages during the locking.
-	 * If this happens just bail out.
+	 * We're only intended to deal with the non-Compound page here.
+	 * However, the page could have changed compound pages due to
+	 * race window. If this happens, we could try again to hopefully
+	 * handle the page next round.
 	 */
-	if (PageCompound(p) && compound_head(p) != orig_head) {
-		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
-		res = -EBUSY;
-		goto unlock_page;
+	if (PageCompound(p)) {
+		if (TestClearPageHWPoison(p))
+			num_poisoned_pages_dec();
+		unlock_page(p);
+		put_page(p);
+		flags &= ~MF_COUNT_INCREASED;
+		goto try_again;
 	}
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

