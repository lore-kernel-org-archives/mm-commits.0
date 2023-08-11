Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C350C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbjHKXBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbjHKXA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF9A3C06
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E659967AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCF3C433C8;
        Fri, 11 Aug 2023 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794809;
        bh=ltayZq2EyrrUAD1sKc6blRZW+9okkepapZ7ztoUj0ic=;
        h=Date:To:From:Subject:From;
        b=dfrevmVnSkqRcSNyJKkrfccIPVtyLIfIDsX6W0Qx/AG1B5pJP5zpyW27828fv3UmS
         O4wYGi/cgd5F/jSJ0Cia1JldtN6SDF9DxyNsw77C9t3ihZB6Kj/W3KJU132t3LjuhE
         il08Ks7X1xpO/qRIeDGDWhqqsCTLNMfxQA6fki1Q=
Date:   Fri, 11 Aug 2023 16:00:08 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch removed from -mm tree
Message-Id: <20230811230009.4BCF3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: use local variable huge to check hugetlb page
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2617,7 +2617,7 @@ static int soft_offline_in_use_page(stru
 	}
 
 	lock_page(page);
-	if (!PageHuge(page))
+	if (!huge)
 		wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
@@ -2626,7 +2626,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (!PageHuge(page) && PageLRU(page) && !PageSwapCache(page))
+	if (!huge && PageLRU(page) && !PageSwapCache(page))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
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

