Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D25DC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC00364F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhBYTfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhBYTdS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:33:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DCBD64FBA;
        Thu, 25 Feb 2021 19:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280713;
        bh=WsVI7YkXkBI2ibsTIYpRbbsSb1O1mSY2ntsGkzUVbYQ=;
        h=Date:From:To:Subject:From;
        b=i5JNN8e3TeDWxZEPxKLaqjFNspZP2P6Gcaw+reoPN57SzOuao54xBVfdASyU2Hybe
         uhJQWoeZtuZLNrdjZr8SP29wocBcZqpPexNCJ2BygLJeVA9hZYHXvhwNxxtSYP5ndd
         P3Bh8nk81kUN7oyNqu2pt1FxdDdwsIWzuwym2l0c=
Date:   Thu, 25 Feb 2021 11:18:33 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  [merged]
 z3fold-remove-unused-attribute-for-release_z3fold_page.patch removed from
 -mm tree
Message-ID: <20210225191833.MT4CKZZr3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: remove unused attribute for release_z3fold_page
has been removed from the -mm tree.  Its filename was
     z3fold-remove-unused-attribute-for-release_z3fold_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: z3fold: remove unused attribute for release_z3fold_page

Since commit dcf5aedb24f8 ("z3fold: stricter locking and more careful
reclaim"), release_z3fold_page() is used again.  So we can drop the unused
attribute safely.

Link: https://lkml.kernel.org/r/20210120084008.58432-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~z3fold-remove-unused-attribute-for-release_z3fold_page
+++ a/mm/z3fold.c
@@ -541,8 +541,7 @@ static void __release_z3fold_page(struct
 	spin_unlock(&pool->stale_lock);
 }
 
-static void __attribute__((__unused__))
-			release_z3fold_page(struct kref *ref)
+static void release_z3fold_page(struct kref *ref)
 {
 	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
 						refcount);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

