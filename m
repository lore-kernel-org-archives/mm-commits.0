Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD5CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAB561434
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhD3FdI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 983FC61423;
        Fri, 30 Apr 2021 05:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760740;
        bh=p2CAeA8Yd76JCvm+OvyouZ3wwKYQKFaeisWqDv+XnRg=;
        h=Date:From:To:Subject:From;
        b=HajspkREqDY5Tp6k+A6p2S6cAaJuT42Sgx3pWgRfUb3MBnj4RB6bo8/UcWAlRiZgL
         yWfoXE/7lsNazN6IEsjsVATP6wNaeHPHgEDsEjTsuBGXZuW7iSz6Y6SNGqFbTftY1d
         DhCbugp35mXG0Cn80V2RBl26dwKUcKkV1pxoTGUc=
Date:   Thu, 29 Apr 2021 22:32:20 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, slyfox@gentoo.org, vbabka@suse.cz
Subject:  [folded-merged]
 kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch removed from -mm
 tree
Message-ID: <20210430053220.6OsPEqf2H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix for "integrate page_alloc init with HW_TAGS"
has been removed from the -mm tree.  Its filename was
     kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch

This patch was dropped because it was folded into kasan-mm-integrate-page_alloc-init-with-hw_tags.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm, kasan: fix for "integrate page_alloc init with HW_TAGS"

My commit "integrate page_alloc init with HW_TAGS" changed the order of
kernel_unpoison_pages() and kernel_init_free_pages() calls.  This leads to
complaints from the page unpoisoning code, as the poison pattern gets
overwritten for __GFP_ZERO allocations.

Fix by restoring the initial order. Also add a warning comment.

Link: https://lkml.kernel.org/r/65b6028dea2e9a6e8e2cb779b5115c09457363fc.1617122211.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sergei Trofimovich <slyfox@gentoo.org>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~kasan-mm-integrate-page_alloc-init-with-hw_tags-fix
+++ a/mm/page_alloc.c
@@ -2331,6 +2331,13 @@ inline void post_alloc_hook(struct page
 	debug_pagealloc_map_pages(page, 1 << order);
 
 	/*
+	 * Page unpoisoning must happen before memory initialization.
+	 * Otherwise, the poison pattern will be overwritten for __GFP_ZERO
+	 * allocations and the page unpoisoning code will complain.
+	 */
+	kernel_unpoison_pages(page, 1 << order);
+
+	/*
 	 * As memory initialization might be integrated into KASAN,
 	 * kasan_alloc_pages and kernel_init_free_pages must be
 	 * kept together to avoid discrepancies in behavior.
@@ -2340,7 +2347,6 @@ inline void post_alloc_hook(struct page
 	if (init && !kasan_has_integrated_init())
 		kernel_init_free_pages(page, 1 << order);
 
-	kernel_unpoison_pages(page, 1 << order);
 	set_page_owner(page, order, gfp_flags);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch
kasan-detect-false-positives-in-tests.patch

