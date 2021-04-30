Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47874C43462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2924A61463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhD3Fzv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3Fzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA646145D;
        Fri, 30 Apr 2021 05:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762103;
        bh=8D4gNOIYDEDhSzprmBpt40R424WSNEhW20WBBf9cNEs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JEZ+o79r7lvEIRfwKOSpQ/LGsqhCUxLYCa+8TZH78lTKlCjDcu6A3QvaScmuD0Aor
         0B2uMgx8HeOxI9MmyRTBHgE6C4ptBscChJ5AgVT4a7v6czq2K0yp+1Oud6LYLREIkw
         WQYN+M+jKOvMBu9AA4rNqB6Uvkt69sv1ZGnOFSNg=
Date:   Thu, 29 Apr 2021 22:55:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, slyfox@gentoo.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 036/178] mm: page_owner: fetch backtrace only for
 tracked pages
Message-ID: <20210430055502.pQRjf3uAC%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: fetch backtrace only for tracked pages

Very minor optimization.

Link: https://lkml.kernel.org/r/20210401212445.3534721-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-fetch-backtrace-only-for-tracked-pages
+++ a/mm/page_owner.c
@@ -147,15 +147,15 @@ void __reset_page_owner(struct page *pag
 {
 	int i;
 	struct page_ext *page_ext;
-	depot_stack_handle_t handle = 0;
+	depot_stack_handle_t handle;
 	struct page_owner *page_owner;
 	u64 free_ts_nsec = local_clock();
 
-	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
-
 	page_ext = lookup_page_ext(page);
 	if (unlikely(!page_ext))
 		return;
+
+	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
 	for (i = 0; i < (1 << order); i++) {
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 		page_owner = get_page_owner(page_ext);
_
