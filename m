Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFB2C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA47A61241
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbhGABxh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238468AbhGABxh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D61161469;
        Thu,  1 Jul 2021 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104267;
        bh=wRLv2R4QkVRlU9cMNpyvXuwwWaXnK1gjWRMys2tx4m4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YHJTdK7r+SzJpFm3Nh46cN7R4Na9264fbXr8eE3g+D80zpp7+4Gffu3e5tDDA+E4G
         9dePyASu7qcMkf/QshB6gNhpZ7lv0cbQwUpUWgq9/h5EqIrRjkm3E5kK5ootxYoS0s
         AU0KQinEnniGljgw5Y4OuRZfOe3vHCLiLHyFQ0wY=
Date:   Wed, 30 Jun 2021 18:51:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        nao.horiguchi@gmail.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 074/192] mm: mempolicy: don't have to split pmd
 for huge zero page
Message-ID: <20210701015107.mLNtftQiK%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: mempolicy: don't have to split pmd for huge zero page

When trying to migrate pages to obey mempolicy, the huge zero page is
split by inserting base zero pfn to all PTEs, then the page table walk
fallback to PTE level and just skips zero page.  Skipping zero page for
mempolicy has been the behavior of kernel since v2.6.16 due to commit
f4598c8b3678 ("[PATCH] migration: make sure there is no attempt to migrate
reserved pages.").  So it seems pointless to split huge zero page, it
could be just skipped like base zero page.

Set ACTION_CONTINUE to prevent the walk_page_range() split the pmd for
this case.

Link: https://lkml.kernel.org/r/20210609172146.3594-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20210604203513.240709-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
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
