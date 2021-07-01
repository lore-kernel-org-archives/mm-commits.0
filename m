Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AC7C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B745C61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbhGAByf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238418AbhGAByf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F6AC61474;
        Thu,  1 Jul 2021 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104325;
        bh=YB2daD+Wi9X9GUd02UzY33OL+VvqiKaf8fIYoCEIhWI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XQjRMY9NR1mTaY75pRRee5NtCerDPlMRm5CeNigaZsL6V6o7/3Nw6gtgqAHtaB/Gy
         BBxpPXQW6Ymk0Q4MMBo09JbOx+5J8T/5hgT+Vf5wTnS9vg1DellVu6cqMaqVfmnib6
         Mi8+9Z7Mb55Suwh5zPgs3pa2scO8kHWkWmUS4ANw=
Date:   Wed, 30 Jun 2021 18:52:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        jack@suse.cz, juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 092/192] mm/thp: remap_page() is only needed on
 anonymous THP
Message-ID: <20210701015204.PUckIgqJ6%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
