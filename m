Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35C9C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBD522200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633080;
	bh=t5WCwEhglmhyy4sXMYUYr6UXtfeh6qqiUBKJNpt16IQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jeMiKELZDhMxvbsjQKEmX5EJ3dkyOB8I15oo0UhBdEMLWmmHxDzOD68keWcYU8bnZ
	 P6cLi3Flp6WRmeVq7gUa6eIleEV9hkGIx6g0fK1IzjnwOL664hZ6xNmmdDmHez0DjK
	 MaQ2c5sNm2AeHJpKkhx+XeN4PSV5k8xKMNujf3E4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgJMXvT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730409AbgJMXvP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D22E221D7B;
        Tue, 13 Oct 2020 23:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633075;
        bh=t5WCwEhglmhyy4sXMYUYr6UXtfeh6qqiUBKJNpt16IQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KjbjgLnDLRufbFvr07IBKY7LukoQaiDwW9jqrEwdUtX6Geb5atW1maG802E1G/aTu
         gdi9kwAs+qxiwdH5dWVPiFLGtJo94uqjuJTfmDdSCiKir7vZ2XofEjfrDiwcoe5V30
         8h596QkjwZdl42o0AhclZx3pKX28Ur/6Y7MbM0wQ=
Date:   Tue, 13 Oct 2020 16:51:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 053/181] mm, dump_page: rename head_mapcount() -->
 head_compound_mapcount()
Message-ID: <20201013235114.fKAgeWbIV%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm, dump_page: rename head_mapcount() --> head_compound_mapcount()

Rename head_pincount() --> head_compound_pincount().  These names are more
accurate (or less misleading) than the original ones.

Link: https://lkml.kernel.org/r/20200807183358.105097-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/debug.c         |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/include/linux/mm.h
@@ -791,7 +791,7 @@ static inline void *kvcalloc(size_t n, s
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
-static inline int head_mapcount(struct page *head)
+static inline int head_compound_mapcount(struct page *head)
 {
 	return atomic_read(compound_mapcount_ptr(head)) + 1;
 }
@@ -805,7 +805,7 @@ static inline int compound_mapcount(stru
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
-	return head_mapcount(page);
+	return head_compound_mapcount(page);
 }
 
 /*
@@ -918,7 +918,7 @@ static inline bool hpage_pincount_availa
 	return PageCompound(page) && compound_order(page) > 1;
 }
 
-static inline int head_pincount(struct page *head)
+static inline int head_compound_pincount(struct page *head)
 {
 	return atomic_read(compound_pincount_ptr(head));
 }
@@ -927,7 +927,7 @@ static inline int compound_pincount(stru
 {
 	VM_BUG_ON_PAGE(!hpage_pincount_available(page), page);
 	page = compound_head(page);
-	return head_pincount(page);
+	return head_compound_pincount(page);
 }
 
 static inline void set_compound_order(struct page *page, unsigned int order)
--- a/mm/debug.c~mm-dump_page-rename-head_mapcount-head_compound_mapcount
+++ a/mm/debug.c
@@ -102,12 +102,12 @@ void __dump_page(struct page *page, cons
 		if (hpage_pincount_available(page)) {
 			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head),
-					head_pincount(head));
+					head_compound_mapcount(head),
+					head_compound_pincount(head));
 		} else {
 			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
-					head_mapcount(head));
+					head_compound_mapcount(head));
 		}
 	}
 	if (PageKsm(page))
_
