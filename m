Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA9DC64E69
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C48292415B
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tj5SddBl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgKTX7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbgKTX7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:59:09 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D360524137;
        Fri, 20 Nov 2020 23:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916749;
        bh=QTpavpJtwojcUvLOYcTt8WfL0WYk1BJ9i0hVH6N2L3Q=;
        h=Date:From:To:Subject:From;
        b=tj5SddBlAP0dbqFogyD7mh7sxGvfqhWOMEzb2ggCTWmcwITeGtPpiga3F88sxG5y6
         O3vOxwgEsslZDkJXRd9Jol0zMu+t32951XlDzFDMRvMPVy6OkBQwtPUJvWuJK1D7Fs
         pq+KLHNhMN5tJPkcpa3Ei04Lh0sonE4Ohw2jVU4g=
Date:   Fri, 20 Nov 2020 15:59:08 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  + mmhwpoison-remove-drain_all_pages-from-shake_page.patch
 added to -mm tree
Message-ID: <20201120235908.pud3iODSc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove drain_all_pages from shake_page
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-drain_all_pages-from-shake_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-drain_all_pages-from-shake_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-drain_all_pages-from-shake_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: remove drain_all_pages from shake_page

get_hwpoison_page already drains pcplists, previously disabling them when
trying to grab a refcount.  We do not need shake_page to take care of it
anymore.

Link: https://lkml.kernel.org/r/20201119105716.5962-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-remove-drain_all_pages-from-shake_page
+++ a/mm/memory-failure.c
@@ -263,8 +263,8 @@ static int kill_proc(struct to_kill *tk,
 }
 
 /*
- * When a unknown page type is encountered drain as many buffers as possible
- * in the hope to turn the page into a LRU or free page, which we can handle.
+ * Unknown page type encountered. Try to check whether it can turn PageLRU by
+ * lru_add_drain_all, or a free page by reclaiming slabs when possible.
  */
 void shake_page(struct page *p, int access)
 {
@@ -275,9 +275,6 @@ void shake_page(struct page *p, int acce
 		lru_add_drain_all();
 		if (PageLRU(p))
 			return;
-		drain_all_pages(page_zone(p));
-		if (PageLRU(p) || is_free_buddy_page(p))
-			return;
 	}
 
 	/*
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-drop-pfn-parameter.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmhugetlb-remove-unneded-initialization.patch

