Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE34C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 02:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8FA4239D4
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 02:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgLHCYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 21:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHCYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 21:24:36 -0500
Date:   Mon, 07 Dec 2020 18:23:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607394229;
        bh=YdoO/02BFRm34489ul70e/OphnHnxeQjOA0IOZT7O7A=;
        h=From:To:Subject:From;
        b=czMMmgr9ZlylWeHECMltvJQq41o9XAi6DXLoto7z97V3FPr2xniOavXz8FuzkkvAB
         nDNRXKgDAewPi0XGWU06c1o4VZBGYDQmeDByJADi+s90mTALG4dwkQh8y5SO+mGkTg
         3/5MHQZGktIjNn1qBv5EaoaMcAuSDZtJaafeveXQ=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        n-horiguchi@ah.jp.nec.com, dan.j.williams@intel.com,
        osalvador@suse.de
Subject:  +
 mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch added to
 -mm tree
Message-ID: <20201208022348.Dskzw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_failure: always pin the page in madvise_inject_error
has been added to the -mm tree.  Its filename is
     mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch

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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch
mmhugetlb-remove-unneded-initialization.patch

