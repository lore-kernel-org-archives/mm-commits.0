Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B73C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154E161C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhGFTWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhGFTWf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB79E61C91;
        Tue,  6 Jul 2021 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599196;
        bh=il+kXPtZmYgDVTd8DLrzSzzLwj8CQJHRZ40FIVjzRLc=;
        h=Date:From:To:Subject:From;
        b=iwltPLrAkHD8LywQM3zVxILMzpI0L4dNQwDaXpFLLHsaExNeJ6R4TxKysN38KpL18
         tYCBKzigPE7+U8AtPFMWIZGnwJzl+lZt4Ti614izRACAQ3X9azMJ5EzEuz0731ZdC6
         wj15VHHCbWBxJAkL+pDA0gZcGPAO+DSttOkne1xY=
Date:   Tue, 06 Jul 2021 12:19:55 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch removed from -mm
 tree
Message-ID: <20210706191955.cmAebO8QP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: remap_page() is only needed on anonymous THP
has been removed from the -mm tree.  Its filename was
     mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: remap_page() is only needed on anonymous THP

THP splitting's unmap_page() only sets TTU_SPLIT_FREEZE when PageAnon, and
migration entries are only inserted when TTU_MIGRATION (unused here) or
TTU_SPLIT_FREEZE is set: so it's just a waste of time for remap_page() to
search for migration entries to remove when !PageAnon.

Link: https://lkml.kernel.org/r/f987bc44-f28e-688d-2424-b4722153ed8@google.com
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/huge_memory.c~mm-thp-remap_page-is-only-needed-on-anonymous-thp
+++ a/mm/huge_memory.c
@@ -2307,6 +2307,7 @@ static void unmap_page(struct page *page
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
+	/* If TTU_SPLIT_FREEZE is ever extended to file, update remap_page() */
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
@@ -2318,6 +2319,10 @@ static void unmap_page(struct page *page
 static void remap_page(struct page *page, unsigned int nr)
 {
 	int i;
+
+	/* If TTU_SPLIT_FREEZE is ever extended to file, remove this check */
+	if (!PageAnon(page))
+		return;
 	if (PageTransHuge(page)) {
 		remove_migration_ptes(page, page, true);
 	} else {
_

Patches currently in -mm which might be from hughd@google.com are


