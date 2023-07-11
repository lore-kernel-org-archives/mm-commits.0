Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947C0EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjGKTH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjGKTHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BD31705
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31082615C1
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8243FC433C7;
        Tue, 11 Jul 2023 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102469;
        bh=ZHXhSxkBMpJbK/PkCsm7tska92S8nuLY0motDhX/jUw=;
        h=Date:To:From:Subject:From;
        b=Ro335g2zmrmoeILFKQHLAjFGxoclM/BeSPGxr+1SGdOyGz82MMHYVOxXY3kwvJpmA
         3t7PfEUI4wjCNiXB3Tp4Ig4A5zB0lXNbVQSjz82aRJjJ+1XgMyJ/XyONbo30MdHnRU
         moDb0lZh9OgTWvblVwDWyE6zL2Q9aVTQ/h1CEVLM=
Date:   Tue, 11 Jul 2023 12:07:49 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch added to mm-unstable branch
Message-Id: <20230711190749.8243FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: use local variable huge to check hugetlb page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: use local variable huge to check hugetlb page
Date: Tue, 11 Jul 2023 13:50:12 +0800

Use local variable huge to check whether page is hugetlb page to avoid
calling PageHuge() multiple times to save cpu cycles.  PageHuge() will be
stable while extra page refcnt is held.

Link: https://lkml.kernel.org/r/20230711055016.2286677-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page
+++ a/mm/memory-failure.c
@@ -2628,7 +2628,7 @@ static int soft_offline_in_use_page(stru
 	}
 
 	lock_page(page);
-	if (!PageHuge(page))
+	if (!huge)
 		wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
@@ -2637,7 +2637,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (!PageHuge(page) && PageLRU(page) && !PageSwapCache(page))
+	if (!huge && PageLRU(page) && !PageSwapCache(page))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

