Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F61BC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41F820731
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgLOD3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:29:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgLODIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:43 -0500
Date:   Mon, 14 Dec 2020 19:08:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001683;
        bh=n55zNOr9oqZSvIg5+OmRSYnjZ1OZtQ8fAs9dJf8AG+U=;
        h=From:To:Subject:In-Reply-To:From;
        b=UHhgiuYB9nO1siXmzMQsuoYTWvREIRkGngy52q8DZrqI5S72BM/XWH24CXGAI2pQE
         +sVMmuY+Kyqi4/ErW/zz5P40GKwTNrpe5Y1DOGp9L6dnnJS93+iLH9lz0GGx8G3OfR
         k+Ot7EYUaa18aczv+GdVaBUrWun3rqicvtdNV96k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 083/200] mm: move free_unref_page to mm/internal.h
Message-ID: <20201215030802._cFqcgvwa%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move free_unref_page to mm/internal.h

Code outside mm/ should not be calling free_unref_page().  Also move
free_unref_page_list().

Link: https://lkml.kernel.org/r/20201125034655.27687-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 mm/internal.h       |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-move-free_unref_page-to-mm-internalh
+++ a/include/linux/gfp.h
@@ -580,8 +580,6 @@ void * __meminit alloc_pages_exact_nid(i
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_unref_page(struct page *page);
-extern void free_unref_page_list(struct list_head *list);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
--- a/mm/internal.h~mm-move-free_unref_page-to-mm-internalh
+++ a/mm/internal.h
@@ -199,6 +199,9 @@ extern void post_alloc_hook(struct page
 					gfp_t gfp_flags);
 extern int user_min_free_kbytes;
 
+extern void free_unref_page(struct page *page);
+extern void free_unref_page_list(struct list_head *list);
+
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 
_
