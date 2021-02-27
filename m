Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AF4C43381
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADB7764F45
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhB0CbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhB0Cap (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C2A164F42;
        Sat, 27 Feb 2021 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393016;
        bh=Nq57BTy9C53X1Z22lQkqaAIFPfdFxlYgU8H3ezT3MNk=;
        h=Date:From:To:Subject:From;
        b=Vm4Wi8+HSqP+jzAoz6eMYgZjuBu/XoDPbJWdY063cpbBFWgmZkaFnq5vA6FXCTD1W
         PAG7gEQL/uibMen7zJ7WZ/O94J1YQ2tCuM4dQ5broh5K4LCKKdjWMbsdiBNakuGO7X
         mJkHcxhIfJyZt4GXE5afD5UmD0eZZAIIpADVDJgI=
Date:   Fri, 26 Feb 2021 18:30:16 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org
Subject:  [merged]
 mm-zsmallocc-use-page_private-to-access-page-private.patch removed from -mm
 tree
Message-ID: <20210227023016._Z-EJ17J4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: use page_private() to access page->private
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-use-page_private-to-access-page-private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: use page_private() to access page->private

It's recommended to use helper macro page_private() to access the private
field of page.  Use such helper to eliminate direct access.

Link: https://lkml.kernel.org/r/20210203091857.20017-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-use-page_private-to-access-page-private
+++ a/mm/zsmalloc.c
@@ -816,7 +816,7 @@ static int get_pages_per_zspage(int clas
 
 static struct zspage *get_zspage(struct page *page)
 {
-	struct zspage *zspage = (struct zspage *)page->private;
+	struct zspage *zspage = (struct zspage *)page_private(page);
 
 	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 	return zspage;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


