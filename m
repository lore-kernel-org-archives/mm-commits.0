Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D969AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CF261247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhKKCrc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EDDB61208;
        Thu, 11 Nov 2021 02:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598683;
        bh=bTSEdul74uzb+aTS+z2s6enikRlOqYGx8CF30N6fkbA=;
        h=Date:From:To:Subject:From;
        b=wquHyPEGM1h7Kd/zu4qAg1ujGS1JRao6EhRBYWvNivBKDIfUjNEq95C7ekH0v79p+
         aGAnEbMfeJlSpm0aY+dL85QQ0nMaXmd/etNrlznqO+LzP30QIIdtMbJKbe1i8152Dm
         637Y2QTLb6T3yv5Bq6NQqmE8kPJiXu/0IZftfh5k=
Date:   Wed, 10 Nov 2021 18:44:43 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-hwpoison-handle-non-anonymous-thp-correctly.patch removed from -mm tree
Message-ID: <20211111024443.u2S0zYqX3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: handle non-anonymous THP correctly
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-handle-non-anonymous-thp-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: hwpoison: handle non-anonymous THP correctly

Currently hwpoison doesn't handle non-anonymous THP, but since v4.8 THP
support for tmpfs and read-only file cache has been added.  They could be
offlined by split THP, just like anonymous THP.

Link: https://lkml.kernel.org/r/20211020210755.23964-7-shy828301@gmail.com
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


