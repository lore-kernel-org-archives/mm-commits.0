Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61883C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2CA61131
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDBAH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBAH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F5860FED;
        Fri,  2 Apr 2021 00:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617322077;
        bh=NIy2NNhy8YMG064EEwAKwstVZnKkvbjtVe9QcuHOmxE=;
        h=Date:From:To:Subject:From;
        b=o2U7YzccI1ZvQbw1AkBd4Kz6i0ashwyEVBIVU2OXFUwMe6hreGl1YM6Mkxf+P1sHk
         W0zl1vMZ1IC5zSjjEuOjJ7Xac1mCznZL9G5UanIKKqwaJwdK94Pzn5IQsitNWAg/LL
         wtiOoVjffIQuzHzzHcQmGqK3Bijv54cUVmG1sZoY=
Date:   Thu, 01 Apr 2021 17:07:56 -0700
From:   akpm@linux-foundation.org
To:     iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        slyfox@gentoo.org, tglx@linutronix.de
Subject:  +
 mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch added to -mm
 tree
Message-ID: <20210402000756.v2rIoeq_N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: fetch backtrace only for tracked pages
has been added to the -mm tree.  Its filename is
     mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: fetch backtrace only for tracked pages

Very minor optimization.

Link: https://lkml.kernel.org/r/20210401212445.3534721-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
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

ia64-fix-user_stack_pointer-for-ptrace.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch
mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

