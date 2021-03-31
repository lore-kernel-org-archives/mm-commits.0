Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6332C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0E6619D9
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhCaEgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233600AbhCaEfe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4853619A7;
        Wed, 31 Mar 2021 04:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617165329;
        bh=zSE/iFjpy56lRUfXa/QJjNuGYSkxih/WzV/VwngT+Y4=;
        h=Date:From:To:Subject:From;
        b=QZEs+kvn5KatDtZpDU9ZCIbbv9+VmNSWIChTNuqx9KqF6Z4XHyPdNj20OLD05JX0k
         FhZoPnc4FPaTD0vxkk4Vsf5TLPvDFOYETvTx6fTdZEakOBXpKCKUOU3QNz6Ho9R3GR
         HFnnz6CwN5t/mtVGcs34HmrJtbzc39GSfN/XbOzo=
Date:   Tue, 30 Mar 2021 21:35:28 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, slyfox@gentoo.org, vbabka@suse.cz
Subject:  +
 kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch added to -mm tree
Message-ID: <20210331043528.r1i41QfFj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix for "integrate page_alloc init with HW_TAGS"
has been added to the -mm tree.  Its filename is
     kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch
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

