Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C567C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9F361090
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEJEhu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhEJEhu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CCE46101E;
        Mon, 10 May 2021 04:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621406;
        bh=Rt7wnOIOfzt0zgmy+o4rHOnlfjp1RNum5vQB4x3lczM=;
        h=Date:From:To:Subject:From;
        b=Pont5uCn/8ZgzFZ1JLIJTUeEE3NM8tHjOp6ggobd5yvkQkLWSWSc/MebGWLNO9FP2
         AnasliY8s2+cv628DeQXQYnKGFPVZTy5uIPdVLBNqB6BVlW+rAI50wHSpd+sZM23vZ
         /EoWLel+ji0DinFPcUNxRzgvd5Ty91c9n5B7YWBE=
Date:   Sun, 09 May 2021 21:36:45 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-make-__dump_page-static.patch added to -mm tree
Message-ID: <20210510043645.DmxDoB7NJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make __dump_page static
has been added to the -mm tree.  Its filename is
     mm-make-__dump_page-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-__dump_page-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-__dump_page-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make __dump_page static

Patch series "Constify struct page arguments".

While working on various solutions to the 32-bit struct page size
regression, one of the problems I found was the networking stack expects
to be able to pass const struct page pointers around, and the mm doesn't
provide a lot of const-friendly functions to call.  The root tangle of
problems is that a lot of functions call VM_BUG_ON_PAGE(), which calls
dump_page(), which calls a lot of functions which don't take a const
struct page (but could be const).


This patch (of 6):

The only caller of __dump_page() now opencodes dump_page(), so remove it
as an externally visible symbol.

Link: https://lkml.kernel.org/r/20210416231531.2521383-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20210416231531.2521383-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    3 +--
 mm/debug.c              |    2 +-
 mm/page_alloc.c         |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/mmdebug.h~mm-make-__dump_page-static
+++ a/include/linux/mmdebug.h
@@ -9,8 +9,7 @@ struct page;
 struct vm_area_struct;
 struct mm_struct;
 
-extern void dump_page(struct page *page, const char *reason);
-extern void __dump_page(struct page *page, const char *reason);
+void dump_page(struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
--- a/mm/debug.c~mm-make-__dump_page-static
+++ a/mm/debug.c
@@ -42,7 +42,7 @@ const struct trace_print_flags vmaflag_n
 	{0, NULL}
 };
 
-void __dump_page(struct page *page, const char *reason)
+static void __dump_page(struct page *page, const char *reason)
 {
 	struct page *head = compound_head(page);
 	struct address_space *mapping;
--- a/mm/page_alloc.c~mm-make-__dump_page-static
+++ a/mm/page_alloc.c
@@ -658,8 +658,7 @@ static void bad_page(struct page *page,
 
 	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	__dump_page(page, reason);
-	dump_page_owner(page);
+	dump_page(page, reason);
 
 	print_modules();
 	dump_stack();
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch

