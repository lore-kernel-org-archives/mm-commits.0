Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFD7C4743D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 21:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D6C611AD
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 21:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhFDVYb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 17:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhFDVYa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 17:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0EB611AD;
        Fri,  4 Jun 2021 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622841748;
        bh=adhqiYFtmcCTAq5J2FPFkDocmuFUCEWtJvYQD3xImqI=;
        h=Date:From:To:Subject:From;
        b=Fiy+RhJZ5XfGdlo84he9UP4W2J+Q11fuXzLjxRFhzs0ZrowcX733cszU9n8L8+8L+
         fsUYlEp9fqF1h1kMEIbebho1tRYhjjXDNDqnSboGQ0gK3q+h6Gp6p898GWWFzrAiWf
         YewlsMjp+tGCnibn9XxLChiWRHVGWTBh9nOAHzyQ=
Date:   Fri, 04 Jun 2021 14:22:27 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, nao.horiguchi@gmail.com,
        shy828301@gmail.com, ziy@nvidia.com
Subject:  +
 mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch added to -mm
 tree
Message-ID: <20210604212227.CcqhKgNSW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: don't have to split pmd for huge zero page
has been added to the -mm tree.  Its filename is
     mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch

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
Subject: mm: mempolicy: don't have to split pmd for huge zero page

When trying to migrate pages to obey mempolicy, the huge zero page is
split then the page table walk at PTE level just skips zero page.  So it
seems pointless to split huge zero page, it could be just skipped like
base zero page.

Set ACTION_CONTINUE to prevent the walk_page_range() split the pmd for
this case.

Link: https://lkml.kernel.org/r/20210604203513.240709-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page
+++ a/mm/mempolicy.c
@@ -437,7 +437,8 @@ static inline bool queue_pages_required(
 
 /*
  * queue_pages_pmd() has four possible return values:
- * 0 - pages are placed on the right node or queued successfully.
+ * 0 - pages are placed on the right node or queued successfully, or
+ *     special page is met, i.e. huge zero page.
  * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
  * 2 - THP was split.
@@ -461,8 +462,7 @@ static int queue_pages_pmd(pmd_t *pmd, s
 	page = pmd_page(*pmd);
 	if (is_huge_zero_page(page)) {
 		spin_unlock(ptl);
-		__split_huge_pmd(walk->vma, pmd, addr, false, NULL);
-		ret = 2;
+		walk->action = ACTION_CONTINUE;
 		goto out;
 	}
 	if (!queue_pages_required(page, qp))
@@ -489,7 +489,8 @@ out:
  * and move them to the pagelist if they do.
  *
  * queue_pages_pte_range() has three possible return values:
- * 0 - pages are placed on the right node or queued successfully.
+ * 0 - pages are placed on the right node or queued successfully, or
+ *     special page is met, i.e. zero page.
  * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
  * -EIO - only MPOL_MF_STRICT was specified and an existing page was already
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

