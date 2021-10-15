Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8038CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B026120D
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhJOU2k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238545AbhJOU2k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F094861208;
        Fri, 15 Oct 2021 20:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634329593;
        bh=+3oqkR95N6OZEqZ4UI5MflY6sdaonMod1wRW6odaQLw=;
        h=Date:From:To:Subject:From;
        b=NAkIzNLkvn2alpM38RGkY2kR7l9cbdawEfBBMjp3wyziI2cXEdMD+ooZDeu5l4Q7v
         npibj7piPuZs9qEolOgXef1n5pqE1IP4WX6hDCU8Ufl71mSpgC9cRzrKI2vfEb7lCR
         O8nr8biIwUuTsPdPDY3B4r/kQff/sHljgLBQhaPk=
Date:   Fri, 15 Oct 2021 13:26:32 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  + mm-hwpoison-handle-non-anonymous-thp-correctly.patch
 added to -mm tree
Message-ID: <20211015202632.nYkzIlEE_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: handle non-anonymous THP correctly
has been added to the -mm tree.  Its filename is
     mm-hwpoison-handle-non-anonymous-thp-correctly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-handle-non-anonymous-thp-correctly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-handle-non-anonymous-thp-correctly.patch

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
Subject: mm: hwpoison: handle non-anonymous THP correctly

Currently hwpoison doesn't handle non-anonymous THP, but since v4.8 THP
support for tmpfs and read-only file cache has been added.  They could be
offlined by split THP, just like anonymous THP.

Link: https://lkml.kernel.org/r/20211014191615.6674-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-handle-non-anonymous-thp-correctly
+++ a/mm/memory-failure.c
@@ -1444,14 +1444,11 @@ static int identify_page_state(unsigned
 static int try_to_split_thp_page(struct page *page, const char *msg)
 {
 	lock_page(page);
-	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
+	if (unlikely(split_huge_page(page))) {
 		unsigned long pfn = page_to_pfn(page);
 
 		unlock_page(page);
-		if (!PageAnon(page))
-			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
-		else
-			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+		pr_info("%s: %#lx: thp split failed\n", msg, pfn);
 		put_page(page);
 		return -EBUSY;
 	}
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

