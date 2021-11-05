Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF4BC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E3F61279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhKEUnz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233656AbhKEUny (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898FC611C0;
        Fri,  5 Nov 2021 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144874;
        bh=2sbxwZv0ZvcIIZZ5F7BXAbHE67nAS2XyR/CDD0yDCU8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YxVD7wu5cyEWNbVpoM05FULHPkuQ9l/RzGdzsj/MGjyf9LpGkIvhhyO7+BfvkQudS
         m2fzDKFxWifm6cdS+adZdL1GboPNQPtNZ1FmEeF9DZrciPw5sqLJCXifJK7kaD+yFW
         Tw+KbqbvLwx2xTQsEGkgPJCYsyAnKUjw+DdL5ggE=
Date:   Fri, 05 Nov 2021 13:41:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 126/262] mm: hwpoison: handle non-anonymous THP
 correctly
Message-ID: <20211105204114.oqF4Oa0js%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
