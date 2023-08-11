Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC164C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbjHKXBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85B03593
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60DC26738D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0BEC433C7;
        Fri, 11 Aug 2023 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794812;
        bh=9wlIIouZWHLGvJMnzOTSznqRmcY4qHs/e6PBvUh9a6k=;
        h=Date:To:From:Subject:From;
        b=PErBkwHwCQILndhgYLVaTCSF5EQTWtzrrdq+cSt12dKrnbBgJEmTlWSITbbPwIqMT
         NLJ3S8ZSstggkl1q5HabzOX6pECdnmipOPSVKqJHJGUa1XYTvOBMmLG/viCEl04Rhl
         sICOxVZxfygRxjyLoSJZ3qKdtEfK2w+6iW8APWHk=
Date:   Fri, 11 Aug 2023 16:00:12 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch removed from -mm tree
Message-Id: <20230811230012.BC0BEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: fetch compound head after extra page refcnt is held
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: fetch compound head after extra page refcnt is held
Date: Tue, 11 Jul 2023 13:50:15 +0800

Page might become thp, huge page or being splited after compound head is
fetched but before page refcnt is bumped.  So hpage might be a tail page
leading to VM_BUG_ON_PAGE(PageTail(page)) in PageTransHuge().

Link: https://lkml.kernel.org/r/20230711055016.2286677-8-linmiaohe@huawei.com
Fixes: 415c64c1453a ("mm/memory-failure: split thp earlier in memory error handling")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held
+++ a/mm/memory-failure.c
@@ -2175,8 +2175,6 @@ try_again:
 		goto unlock_mutex;
 	}
 
-	hpage = compound_head(p);
-
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
@@ -2215,6 +2213,7 @@ try_again:
 		}
 	}
 
+	hpage = compound_head(p);
 	if (PageTransHuge(hpage)) {
 		/*
 		 * The flag must be set after the refcount is bumped
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

