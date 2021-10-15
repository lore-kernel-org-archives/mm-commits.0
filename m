Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E63C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9776120A
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbhJOU2f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238575AbhJOU2d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C1D611F0;
        Fri, 15 Oct 2021 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634329586;
        bh=MDw+2SfOI7hRzl8ENmSIU4hhscUTQy8hEw5+Ef5gTSg=;
        h=Date:From:To:Subject:From;
        b=Lpy7s/3xDWThw/+k5+WFpJiT1f8idxsKEU5JUvfoX061VtPSbqwEkcQGgtDOqmT5k
         seKQ4kzhjB9rJoQJR9xP39kGJmT3MWPnWMfvN3J8/Twz8p77faRR6/ip6R7LlOqkIa
         RYPbaFSSAl6PpmUgd3CRGg4hCFwBesWMTd1Veg+A=
Date:   Fri, 15 Oct 2021 13:26:25 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  +
 mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch added to -mm tree
Message-ID: <20211015202625.QOGHF-oOd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: coding style cleanup for filemap_map_pmd()
has been added to the -mm tree.  Its filename is
     mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch

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
Subject: mm: filemap: coding style cleanup for filemap_map_pmd()

A minor cleanup to the indent.

Link: https://lkml.kernel.org/r/20211014191615.6674-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-coding-style-cleanup-for-filemap_map_pmd
+++ a/mm/filemap.c
@@ -3202,12 +3202,12 @@ static bool filemap_map_pmd(struct vm_fa
 	}
 
 	if (pmd_none(*vmf->pmd) && PageTransHuge(page)) {
-	    vm_fault_t ret = do_set_pmd(vmf, page);
-	    if (!ret) {
-		    /* The page is mapped successfully, reference consumed. */
-		    unlock_page(page);
-		    return true;
-	    }
+		vm_fault_t ret = do_set_pmd(vmf, page);
+		if (!ret) {
+			/* The page is mapped successfully, reference consumed. */
+			unlock_page(page);
+			return true;
+		}
 	}
 
 	if (pmd_none(*vmf->pmd))
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

