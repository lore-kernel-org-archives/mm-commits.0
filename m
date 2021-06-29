Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6CBC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 698C261D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2Cng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhF2Cnf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D4C061D0B;
        Tue, 29 Jun 2021 02:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934468;
        bh=K3LeKY3vda3ZBL04yIqO3LwN4P+mLpj8Mvc5zCugGu8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LtAFO/1juoPvSOAWrR+JcSte1fpP5a5X2MYeZ3owgmMaU3WK4fX7Nics/e06HMrsM
         cQD1AzlEeksuoUHHgWSJIUku6BEg0z5dRZEbUhYnWVnEdLakLfANIINb76T+N9D/a7
         hoN82QIXeMN8A3xgP45zsCTKUh3gEK4XWxgsUGmo=
Date:   Mon, 28 Jun 2021 19:41:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 150/192] mm: make __dump_page static
Message-ID: <20210629024107.3Yi8edGwO%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
