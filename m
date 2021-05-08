Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B438BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBD261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWlO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEHWlO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736F86140E;
        Sat,  8 May 2021 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513612;
        bh=a9UvWi29cMErdA5QG1Zzt1UaLHZisyWqzntqSs4tk0E=;
        h=Date:From:To:Subject:From;
        b=GMrM567zhiFmEfx3fgNFrQcU62Kqd6I23FcIEc8o6FVb6GPjKl1SInHmrqbVtpcym
         fnmEmyIr1tne0vMzHl3HyiMMd0y7nc0fU4UHSe766JKnVqzctKMKbHXIT1gPhnLMVC
         tKmfVzKL6ub9S00QvQT4+8obgThRGNKGL0a9FlFU=
Date:   Sat, 08 May 2021 15:40:12 -0700
From:   akpm@linux-foundation.org
To:     iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        slyfox@gentoo.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch removed from -mm
 tree
Message-ID: <20210508224012.CRs0qYCPC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: fetch backtrace only for tracked pages
has been removed from the -mm tree.  Its filename was
     mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from slyfox@gentoo.org are


