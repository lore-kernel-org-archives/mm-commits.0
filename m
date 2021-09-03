Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA1AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88AC61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350144AbhICVBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350172AbhICVBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A53461107;
        Fri,  3 Sep 2021 20:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702799;
        bh=LmT9TIBeT2kZKPo4P5m74rckBoPaBCnP9Si/IWxtu2M=;
        h=Date:From:To:Subject:From;
        b=ehPa44416aoPmYRFqWSXxG/WnUVXwAlzicCW4qC1Ixw0uPRDke3TEhfP37QozqGcV
         pXQwhShR6CneYcFSpWX3zcvXL+x4UcPjp+piRL2o3zU/rLOmF/76Jzled3JISqgddG
         hbVLvF5B2rvL94EqBQWawR+ygZu4fR5CIJ78HbcE=
Date:   Fri, 03 Sep 2021 13:59:59 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        tdmackey@twitter.com, willy@infradead.org
Subject:  [merged] mm-hwpoison-dump-page-for-unhandlable-page.patch
 removed from -mm tree
Message-ID: <20210903205959.BV0-Q4Em8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: dump page for unhandlable page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-dump-page-for-unhandlable-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shy828301@gmail.com are


