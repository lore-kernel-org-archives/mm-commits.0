Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55C5C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiCVVq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbiCVVqT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919F5F8C0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC6EB81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8208FC340F2;
        Tue, 22 Mar 2022 21:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985488;
        bh=SYcvGt1UY10z+cDuh9Pcwxy8R8rN3AVQY2fMIIcccC4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=RO0xYNQq/fynKFosGwVl29RIdRZ2gmQMj6UvZfAjyF1fdhmH1/7hP3g5E8xt517/t
         48EIg5xQRuYJAzUwFri+f9Dgdb7q3CnLK6BRvu7Xt/hipk1kXDL2PNAvWQ3hd73ZCO
         rkEs5WldUkuJXgMtvUu1Eb9V5DJD8Yuw77iU1N7E=
Date:   Tue, 22 Mar 2022 14:44:47 -0700
To:     tony.luck@intel.com, shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 124/227] mm/memory-failure.c: avoid calling invalidate_inode_page() with unexpected pages
Message-Id: <20220322214448.8208FC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
