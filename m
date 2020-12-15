Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4513C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A680D223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgLODPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgLODNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:00 -0500
Date:   Mon, 14 Dec 2020 19:11:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001909;
        bh=Lw1/k2xehFo/+jFeojB9G/herfyQAxgwBP0HikYKmq0=;
        h=From:To:Subject:In-Reply-To:From;
        b=XuLETQgnKwJeRdekMQ5D5HjAFZQwoffp6xFc3utJOkpcEC/sxZkOAIfOQS/XN5um5
         cQsfEXS5oxZ8pzD71+GXUOkJeN6/0ZZlvWuk+QmYB7rBztAXp2wJHvVv/UQHvSUdch
         6JdM+8jxflnaCw4lLcWGx9mz8nh1Y1TMCLUeJ7HU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 144/200] mm,memory_failure: always pin the page in
 madvise_inject_error
Message-ID: <20201215031148.G2lE81l-O%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_failure: always pin the page in madvise_inject_error

madvise_inject_error() uses get_user_pages_fast to translate the address
we specified to a page.  After [1], we drop the extra reference count for
memory_failure() path.  That commit says that memory_failure wanted to
keep the pin in order to take the page out of circulation.

The truth is that we need to keep the page pinned, otherwise the page
might be re-used after the put_page() and we can end up messing with
someone else's memory.

E.g:

CPU0
process X					CPU1
 madvise_inject_error
  get_user_pages
   put_page
					page gets reclaimed
					process Y allocates the page
  memory_failure
   // We mess with process Y memory

madvise() is meant to operate on a self address space, so messing with
pages that do not belong to us seems the wrong thing to do.
To avoid that, let us keep the page pinned for memory_failure as well.

Pages for DAX mappings will release this extra refcount in
memory_failure_dev_pagemap.

[1] ("23e7b5c2e271: mm, madvise_inject_error:
      Let memory_failure() optionally take a page reference")

Link: https://lkml.kernel.org/r/20201207094818.8518-1-osalvador@suse.de
Fixes: 23e7b5c2e271 ("mm, madvise_inject_error: Let memory_failure() optionally take a page reference")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c        |    9 +--------
 mm/memory-failure.c |    6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/mm/madvise.c~mmmemory_failure-always-pin-the-page-in-madvise_inject_error
+++ a/mm/madvise.c
@@ -907,14 +907,7 @@ static int madvise_inject_error(int beha
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			/*
-			 * Drop the page reference taken by get_user_pages_fast(). In
-			 * the absence of MF_COUNT_INCREASED the memory_failure()
-			 * routine is responsible for pinning the page to prevent it
-			 * from being released back to the page allocator.
-			 */
-			put_page(page);
-			ret = memory_failure(pfn, 0);
+			ret = memory_failure(pfn, MF_COUNT_INCREASED);
 		}
 
 		if (ret)
--- a/mm/memory-failure.c~mmmemory_failure-always-pin-the-page-in-madvise_inject_error
+++ a/mm/memory-failure.c
@@ -1302,6 +1302,12 @@ static int memory_failure_dev_pagemap(un
 	loff_t start;
 	dax_entry_t cookie;
 
+	if (flags & MF_COUNT_INCREASED)
+		/*
+		 * Drop the extra refcount in case we come from madvise().
+		 */
+		put_page(page);
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
_
