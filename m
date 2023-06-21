Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F12DEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 19:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjFUT4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 15:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjFUTz7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 15:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AE0186
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 12:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9830B616A9
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 19:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E881EC433C0;
        Wed, 21 Jun 2023 19:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687377358;
        bh=Gv5JILXv4jjX88kAk2AvElyDOPXwWTar2J+IfCz1ENo=;
        h=Date:To:From:Subject:From;
        b=j6lrLmcNrUMcj5MlFRyPOaQO1i37nzaLnlmWl2G1mzz3h9SIHOUF7h2MICJ/hpFi/
         RmyXOkRHCZUZcUy4WAs3/Rdz/35MQVbYXq8Gx3QRHqRhIcYy7MwMIvxNpnt8uz8MNX
         bMzCQlNzFXEKf24ZE9WPv+KIEgdT70i4NBNBCd6Q=
Date:   Wed, 21 Jun 2023 12:55:57 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-the-correct-type-of-list-for-free-pages.patch added to mm-unstable branch
Message-Id: <20230621195557.E881EC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: use the correct type of list for free pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-the-correct-type-of-list-for-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-the-correct-type-of-list-for-free-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: page_alloc: use the correct type of list for free pages
Date: Wed, 21 Jun 2023 16:14:28 +0800

Commit bf75f200569d ("mm/page_alloc: add page->buddy_list and
page->pcp_list") introduces page->buddy_list and page->pcp_list as a union
with page->lru, but missed to change get_page_from_free_area() to use
page->buddy_list to clarify the correct type of list for a free page.

Link: https://lkml.kernel.org/r/7e7ab533247d40c0ea0373c18a6a48e5667f9e10.1687333557.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-the-correct-type-of-list-for-free-pages
+++ a/mm/page_alloc.c
@@ -727,7 +727,7 @@ static inline struct page *get_page_from
 					    int migratetype)
 {
 	return list_first_entry_or_null(&area->free_list[migratetype],
-					struct page, lru);
+					struct page, buddy_list);
 }
 
 /*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch
mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch
mm-page_alloc-use-the-correct-type-of-list-for-free-pages.patch

