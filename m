Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D559EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88E26192B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGFTWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhGFTWi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A9B61C7A;
        Tue,  6 Jul 2021 19:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599199;
        bh=3THk27moUvogbaNh6bk90ZBr+jXHKSk4gqLRQ4TS4hg=;
        h=Date:From:To:Subject:From;
        b=BlBMRvkqPujB6nqIhvMhFyznAsY3S7uUMP3HRkHk+jYMeSA5p+0gWrwxuK/i48Psg
         blwuciLIJfTXm9iuYHclJXVUKRolzDfWLMCeo1DSLM9qGJYJGrfq2X+24/WYB4vlsK
         uGcjn3n60yuPZOV/M9RxSd+i5+3u1EV/uWWWkboI=
Date:   Tue, 06 Jul 2021 12:19:58 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch removed from -mm
 tree
Message-ID: <20210706191958.arghH247M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison_user_mappings() try_to_unmap() with TTU_SYNC
has been removed from the -mm tree.  Its filename was
     mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: hwpoison_user_mappings() try_to_unmap() with TTU_SYNC

TTU_SYNC prevents an unlikely race, when try_to_unmap() returns shortly
before the page is accounted as unmapped.  It is unlikely to coincide with
hwpoisoning, but now that we have the flag, hwpoison_user_mappings() would
do well to use it.

Link: https://lkml.kernel.org/r/329c28ed-95df-9a2c-8893-b444d8a6d340@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync
+++ a/mm/memory-failure.c
@@ -1266,7 +1266,7 @@ static int get_hwpoison_page(struct page
 static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
_

Patches currently in -mm which might be from hughd@google.com are


