Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E12C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD6D64F3A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhB0Caz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhB0Ca1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7131564F2F;
        Sat, 27 Feb 2021 02:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392996;
        bh=Wxkt/F1f/t3ATuZRV1c87qEzOnzgU+djWo6SXlQlMYs=;
        h=Date:From:To:Subject:From;
        b=feu9sVFSp948pQwuuHFRy7k6fVmx3eV9GvZFTDx6xBBQ4rv228BetnPrSAKpWhOxq
         HuBl+1jkJ7jCU6ahzC8EUzk+dvZUXoh2kVBBK/Jr2ZhfKX7H8MTSslGmRhs8zzg9Zv
         oiuA0NZihqVIk9ZuL97LbeIAOa7QoSXWQzQ+FX7Y=
Date:   Fri, 26 Feb 2021 18:29:56 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-rmap-use-page_not_mapped-in-try_to_unmap.patch removed from -mm tree
Message-ID: <20210227022956.R811B7HsW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: use page_not_mapped in try_to_unmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-page_not_mapped-in-try_to_unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: use page_not_mapped in try_to_unmap()

page_mapcount_is_zero() calculates accurately how many mappings a hugepage
has in order to check against 0 only.  This is a waste of cpu time.  We
can do this via page_not_mapped() to save some possible atomic_read
cycles.  Remove the function page_mapcount_is_zero() as it's not used
anymore and move page_not_mapped() above try_to_unmap() to avoid
identifier undeclared compilation error.

Link: https://lkml.kernel.org/r/20210130084904.35307-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-page_not_mapped-in-try_to_unmap
+++ a/mm/rmap.c
@@ -1736,9 +1736,9 @@ static bool invalid_migration_vma(struct
 	return vma_is_temporary_stack(vma);
 }
 
-static int page_mapcount_is_zero(struct page *page)
+static int page_not_mapped(struct page *page)
 {
-	return !total_mapcount(page);
+	return !page_mapped(page);
 }
 
 /**
@@ -1756,7 +1756,7 @@ bool try_to_unmap(struct page *page, enu
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_mapcount_is_zero,
+		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
 
@@ -1780,11 +1780,6 @@ bool try_to_unmap(struct page *page, enu
 	return !page_mapcount(page) ? true : false;
 }
 
-static int page_not_mapped(struct page *page)
-{
-	return !page_mapped(page);
-}
-
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


