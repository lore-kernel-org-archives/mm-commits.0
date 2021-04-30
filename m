Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F625C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3997761574
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3GCJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhD3GCH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32E5A6148E;
        Fri, 30 Apr 2021 06:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762479;
        bh=UFaV5MKznP3GUAejwJzTTW1kuDyASk/kJvnPf9PWbP8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WBa3wYuYpIvX8wdrWwnbVA6niNTTPw1GHTAbmb5Z0gKRGTqDTCI7vqt8MfJpMAEV9
         K+1ORlANQAh6PYqFwONyA0B6+LqgYUpA+5QPwn+AEhgXzsurGtmeCnmpzsC21G1LBu
         VMhP05oP7Q2PtWELNDbanHoztCg8ORcCHtYUkBvA=
Date:   Thu, 29 Apr 2021 23:01:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 158/178] mm/mempolicy: rename alloc_pages_current
 to alloc_pages
Message-ID: <20210430060118.jphjkAkkl%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: rename alloc_pages_current to alloc_pages

When CONFIG_NUMA is enabled, alloc_pages() is a wrapper around
alloc_pages_current().  This is pointless, just implement alloc_pages()
directly.

Link: https://lkml.kernel.org/r/20210225150642.2582252-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 +-------
 mm/mempolicy.c      |    6 +++---
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/linux/gfp.h~mm-mempolicy-rename-alloc_pages_current-to-alloc_pages
+++ a/include/linux/gfp.h
@@ -546,13 +546,7 @@ static inline struct page *alloc_pages_n
 }
 
 #ifdef CONFIG_NUMA
-extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
-
-static inline struct page *
-alloc_pages(gfp_t gfp_mask, unsigned int order)
-{
-	return alloc_pages_current(gfp_mask, order);
-}
+struct page *alloc_pages(gfp_t gfp, unsigned int order);
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
 			int node, bool hugepage);
--- a/mm/mempolicy.c~mm-mempolicy-rename-alloc_pages_current-to-alloc_pages
+++ a/mm/mempolicy.c
@@ -2245,7 +2245,7 @@ out:
 EXPORT_SYMBOL(alloc_pages_vma);
 
 /**
- * 	alloc_pages_current - Allocate pages.
+ * 	alloc_pages - Allocate pages.
  *
  *	@gfp:
  *		%GFP_USER   user allocation,
@@ -2259,7 +2259,7 @@ EXPORT_SYMBOL(alloc_pages_vma);
  *	interrupt context and apply the current process NUMA policy.
  *	Returns NULL when no page can be allocated.
  */
-struct page *alloc_pages_current(gfp_t gfp, unsigned order)
+struct page *alloc_pages(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
 	struct page *page;
@@ -2280,7 +2280,7 @@ struct page *alloc_pages_current(gfp_t g
 
 	return page;
 }
-EXPORT_SYMBOL(alloc_pages_current);
+EXPORT_SYMBOL(alloc_pages);
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
 {
_
