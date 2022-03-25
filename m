Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B7DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357410AbiCYBeV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357571AbiCYBdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B6BF50B
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42CD8618F6
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994F8C340ED;
        Fri, 25 Mar 2022 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171911;
        bh=o01O7BodjpYTSOt66mRusKxeOMLH9Mo07eQ75lJOJ9A=;
        h=Date:To:From:Subject:From;
        b=lmOgFzOkLV7oVCLeyfvjyje7XW+9JvuY7S5piztfDu9VgcZxx8dOd9yhZm5+ZCEK6
         RTmrNtoiU0UkbC8yg0rTgWMWrvRPIyta0rLEwN/XAJ2KT5+8eDrNXV5pIzIU29jHK7
         1OU0opb/N81isdJVBUXmFFD0gu9AbrP7jF2aZW78=
Date:   Thu, 24 Mar 2022 18:31:51 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch removed from -mm tree
Message-Id: <20220325013151.994F8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages

Since commit 042c4f32323b ("mm/truncate: Inline invalidate_complete_page()
into its one caller"), invalidate_inode_page() can invalidate the pages in
the swap cache because the check of page->mapping != mapping is removed. 
But invalidate_inode_page() is not expected to deal with the pages in swap
cache.  Also non-lru movable page can reach here too.  They're not page
cache pages.  Skip these pages by checking PageSwapCache and PageLRU.

Link: https://lkml.kernel.org/r/20220312074613.4798-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages
+++ a/mm/memory-failure.c
@@ -2184,7 +2184,7 @@ static int __soft_offline_page(struct pa
 		return 0;
 	}
 
-	if (!PageHuge(page))
+	if (!PageHuge(page) && PageLRU(page) && !PageSwapCache(page))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

