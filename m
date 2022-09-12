Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51ECC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiILDcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiILDaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525A12E5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F106FB80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97302C433C1;
        Mon, 12 Sep 2022 03:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953364;
        bh=ehHMChULYRWMP3Am+FGkW+eKnP6b0mrqznqQ3yuLS5s=;
        h=Date:To:From:Subject:From;
        b=AJxTr5W/0Z5m5kRFNBqju8SLrROWVbt56x3AnfIqWp3HOrgZTKm/YsRXPj5UUyPa1
         kVZc2pu9kF67sdCE6XWhVVTvtxP1ZPZrajOKUis00BY2bVQtcj+WZnLZ2x0Xr2k+Fl
         wLtYUYYBvrzIJ5Yy8tqBlXMriABb9G8wmjkf8MYQ=
Date:   Sun, 11 Sep 2022 20:29:23 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch removed from -mm tree
Message-Id: <20220912032924.97302C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: fix page refcnt leaking in unpoison_memory()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: fix page refcnt leaking in unpoison_memory()
Date: Thu, 18 Aug 2022 21:00:12 +0800

When free_raw_hwp_pages() fails its work, the refcnt of the hugetlb page
would have been incremented if ret > 0.  Using put_page() to fix refcnt
leaking in this case.

Link: https://lkml.kernel.org/r/20220818130016.45313-3-linmiaohe@huawei.com
Fixes: debb6b9c3fdd ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2378,6 +2378,7 @@ int unpoison_memory(unsigned long pfn)
 			count = free_raw_hwp_pages(page, false);
 			if (count == 0) {
 				ret = -EBUSY;
+				put_page(page);
 				goto unlock_mutex;
 			}
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

