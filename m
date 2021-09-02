Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA9AC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EFD603E9
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347961AbhIBV7j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347960AbhIBV7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 274166056B;
        Thu,  2 Sep 2021 21:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619918;
        bh=piZortkQXwoz+YfmAK1spc0tqsTFZiYILU3W8nlBiyQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k3DNQhPYzqtiE89Qx30ufQVXQp27R21HlFZv58oReqLk6ZcPGXpkSbUqKnmOcEm2l
         wzq7WrwBERZKvFZdc6sj7C7MYazrHSapsvQTDNxzfMCGIONZX4riNy/htH/Xb+cGfR
         FXjI2hOoysSfkb+oNyKnOYoPlBCd7DwZ5R68ZDiE=
Date:   Thu, 02 Sep 2021 14:58:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        tdmackey@twitter.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 164/212] mm: hwpoison: dump page for unhandlable
 page
Message-ID: <20210902215837.TzkiuaPQH%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: dump page for unhandlable page

Currently just very simple message is shown for unhandlable page, e.g. 
non-LRU page, like: soft_offline: 0x1469f2: unknown non LRU page type
5ffff0000000000 ()

It is not very helpful for further debug, calling dump_page() could show
more useful information.

Calling dump_page() in get_any_page() in order to not duplicate the call
in a couple of different places.  It may be called with pcp disabled and
holding memory hotplug lock, it should be not a big deal since hwpoison
handler is not called very often.

[shy828301@gmail.com: remove redundant pr_info per Noaya Horiguchi]
  Link: https://lkml.kernel.org/r/20210824020946.195257-3-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20210819054116.266126-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Mackey <tdmackey@twitter.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-dump-page-for-unhandlable-page
+++ a/mm/memory-failure.c
@@ -1228,6 +1228,9 @@ try_again:
 		ret = -EIO;
 	}
 out:
+	if (ret == -EIO)
+		dump_page(p, "hwpoison: unhandlable page");
+
 	return ret;
 }
 
@@ -2205,9 +2208,6 @@ retry:
 			try_again = false;
 			goto retry;
 		}
-	} else if (ret == -EIO) {
-		pr_info("%s: %#lx: unknown page type: %lx (%pGp)\n",
-			 __func__, pfn, page->flags, &page->flags);
 	}
 
 	return ret;
_
