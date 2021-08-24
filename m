Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BE9C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 21:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A1E6121E
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 21:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhHXVEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Aug 2021 17:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHXVEf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 24 Aug 2021 17:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE6DD610FD;
        Tue, 24 Aug 2021 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629839030;
        bh=CpjAUE43MhcFpUdm1sAHsRL3lgMb8dK09GKAxYBmi3k=;
        h=Date:From:To:Subject:From;
        b=snvrjMdJ68cPhaqaUPEi1mQ1F8BUGS456DSVfFfHPwdB1P5Q2+zFFa/+foMkeegQQ
         k3r3bbHlpN6J3rDvbtriLyrFHtxQ66ZgZfDFZFKy2XvSn+ILmnjhrGyDcr2aFtLv4l
         BBG8M97B14OpLPJW4uyxjB2Klh+1iJJH67yLk/xE=
Date:   Tue, 24 Aug 2021 14:03:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, shy828301@gmail.com
Subject:  + mm-hwpoison-dump-page-for-unhandlable-page-v3.patch added
 to -mm tree
Message-ID: <20210824210350.D4U9Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: dump page for unhandlable page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-dump-page-for-unhandlable-page-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-dump-page-for-unhandlable-page-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-dump-page-for-unhandlable-page-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-hwpoison-dump-page-for-unhandlable-page-v3.patch

