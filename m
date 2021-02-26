Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D4BC4332B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F5E64F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZBTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZBTQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E251C64F17;
        Fri, 26 Feb 2021 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302316;
        bh=SfXijCR48bBYI6Gf4vvIlkixwDQ6x7Few/KoBmfVHaA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E5XK3q6bRdvQb/hgMUraAGY3GB+CCt0aZEarFtf1RcmngMmG7oL6WQ/UIwKCB6veY
         rHNIog/41g8Il8eCUeRmU6hQor+GL5vBdQjzavNvR1TPCRbjWXmPT+SrJLUo2hQrV2
         Ue5J718TANTkt2lwbengEGLI4FMUcMD429STS2O0=
Date:   Thu, 25 Feb 2021 17:18:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        ngupta@vflare.org, torvalds@linux-foundation.org
Subject:  [patch 051/118] mm/zsmalloc.c: use page_private() to
 access page->private
Message-ID: <20210226011834.J5GGxvqIY%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
