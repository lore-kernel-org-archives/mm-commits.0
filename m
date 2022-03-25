Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1620C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357402AbiCYBe2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357560AbiCYBdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F489BF035
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B96161929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F300C340EC;
        Fri, 25 Mar 2022 01:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171907;
        bh=3ctPoFfHOfIrLdWabx1zEVvpYWwbmB/5dD0JXcM5nxI=;
        h=Date:To:From:Subject:From;
        b=HBOA2+inyXEMRrpXqdmTWwORfGWhOgkupRoSOKoiP1hOqmjLKkJv8KKoepHS3lkwB
         SYqsSFv8ld9SEAKqE2JVk8U2aE/uAmccJ+F884bqx4aDmEwRoIpljwtQxdMc0JQzld
         3aF/iSAuBq+XSEfaSpIDZvFSCIZCJzf3m5V84t2M=
Date:   Thu, 24 Mar 2022 18:31:46 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch removed from -mm tree
Message-Id: <20220325013147.5F300C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison-inject: support injecting hwpoison to free page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison-inject: support injecting hwpoison to free page

memory_failure() can handle free buddy page.  Support injecting hwpoison
to free page by adding is_free_buddy_page check when hwpoison filter is
disabled.

[akpm@linux-foundation.org: export is_free_buddy_page() to modules]
Link: https://lkml.kernel.org/r/20220218092052.3853-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 mm/page_alloc.c      |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hwpoison-inject.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page
+++ a/mm/hwpoison-inject.c
@@ -32,9 +32,9 @@ static int hwpoison_inject(void *data, u
 
 	shake_page(hpage);
 	/*
-	 * This implies unable to support non-LRU pages.
+	 * This implies unable to support non-LRU pages except free page.
 	 */
-	if (!PageLRU(hpage) && !PageHuge(p))
+	if (!PageLRU(hpage) && !PageHuge(p) && !is_free_buddy_page(p))
 		return 0;
 
 	/*
--- a/mm/page_alloc.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page
+++ a/mm/page_alloc.c
@@ -9417,6 +9417,7 @@ bool is_free_buddy_page(struct page *pag
 
 	return order < MAX_ORDER;
 }
+EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

