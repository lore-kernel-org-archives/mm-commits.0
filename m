Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D26C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7BE61074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbhIBVTm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232446AbhIBVTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 814A361059;
        Thu,  2 Sep 2021 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617520;
        bh=Q3ZwgtMc04xCt7Orp6P052lcb0qdbLKC78bBaperRSQ=;
        h=Date:From:To:Subject:From;
        b=nptS3dzwdDfs05Nw2Utj0/TFEnT8H20O+0JVEoiwr2zpLoUdLcK8LoxTyzXSnlh11
         Ti9PmcwFQJVCIxlCBdXbmRou4lUIDDW3L0vVP7QFDJf+rMu++5i3kdmKkTsUKq54lq
         rQ42TYwZ8Q3cQKzXV7D64eY/1l0iVNojaSQyIa3g=
Date:   Thu, 02 Sep 2021 14:18:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, shy828301@gmail.com, willy@infradead.org
Subject:  [folded-merged]
 mm-hwpoison-dump-page-for-unhandlable-page-v3.patch removed from -mm tree
Message-ID: <20210902211840.ONB3ZDDEh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: dump page for unhandlable page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dump-page-for-unhandlable-page-v3.patch

This patch was dropped because it was folded into mm-hwpoison-dump-page-for-unhandlable-page.patch

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: dump page for unhandlable page

remove redundant pr_info per Noaya Horiguchi

Link: https://lkml.kernel.org/r/20210824020946.195257-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-dump-page-for-unhandlable-page-v3
+++ a/mm/memory-failure.c
@@ -2208,9 +2208,6 @@ retry:
 			try_again = false;
 			goto retry;
 		}
-	} else if (ret == -EIO) {
-		pr_info("%s: %#lx: unknown page type: %lx (%pGp)\n",
-			 __func__, pfn, page->flags, &page->flags);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-dont-drop-slab-caches-for-offlining-non-lru-page.patch
doc-hwpoison-correct-the-support-for-hugepage.patch
mm-hwpoison-dump-page-for-unhandlable-page.patch

