Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEB6C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208E061469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhGAByj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGAByj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78AE661468;
        Thu,  1 Jul 2021 01:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104329;
        bh=2dZWw63BUDFoIX03mW6b/itp6jdWGNjUtM9R8vs/XTg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s+LYQvHSQlqg+3J09xpPnX0w9v/EVNA1+l0Xl+VO/JhOptpQHG3qsptan03fTlhiY
         1rKczMnSSBYNwH/LdHOSjdJvm1kpiGLF54vdCMJdqsKueVSJku1U3qVfr6Mcy3vNkE
         ILOi29TwUYfQjo/zIO2QARrVoJGznmctyJf8WpNM=
Date:   Wed, 30 Jun 2021 18:52:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        jack@suse.cz, juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 093/192] mm: hwpoison_user_mappings()
 try_to_unmap() with TTU_SYNC
Message-ID: <20210701015208.xKgFl8Tfb%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
