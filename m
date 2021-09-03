Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC62C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE4B610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350164AbhICU5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350167AbhICU5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90302610F7;
        Fri,  3 Sep 2021 20:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702591;
        bh=N/tibs6t5TZFJQrvc7oo4vIIUfCGgXjFqA4DDNgR3Lc=;
        h=Date:From:To:Subject:From;
        b=WFbEcHtK9TNudXEFY+GPepaaguaz0nfD2yTRDCOcf1lq2h7ZOwwvLLAh8GDUqN2X5
         dLXtT6irlquq4eSgUa/EXGgzxLNlBBsvPZMS5t0zplRSX1cr+8VJWALHUCUZZ2VKMU
         4vQiwATxyAD/Rul9Fip0Xu9BThOncLPhl9JX65w0=
Date:   Fri, 03 Sep 2021 13:56:31 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@lst.de, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-gup-small-refactoring-simplify-try_grab_page.patch removed from -mm tree
Message-ID: <20210903205631.601bZV_1_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: small refactoring: simplify try_grab_page()
has been removed from the -mm tree.  Its filename was
     mm-gup-small-refactoring-simplify-try_grab_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: small refactoring: simplify try_grab_page()

try_grab_page() does the same thing as try_grab_compound_head(..., refs=1,
...), just with a different API.  So there is a lot of code duplication
there.

Change try_grab_page() to call try_grab_compound_head(), while keeping the
API contract identical for callers.

Also, now that try_grab_compound_head() always has a caller, remove the
__maybe_unused annotation.

Link: https://lkml.kernel.org/r/20210813044133.1536842-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/gup.c           |   35 +++++------------------------------
 2 files changed, 7 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h~mm-gup-small-refactoring-simplify-try_grab_page
+++ a/include/linux/mm.h
@@ -1214,8 +1214,8 @@ static inline void get_page(struct page
 }
 
 bool __must_check try_grab_page(struct page *page, unsigned int flags);
-__maybe_unused struct page *try_grab_compound_head(struct page *page, int refs,
-						   unsigned int flags);
+struct page *try_grab_compound_head(struct page *page, int refs,
+				    unsigned int flags);
 
 
 static inline __must_check bool try_get_page(struct page *page)
--- a/mm/gup.c~mm-gup-small-refactoring-simplify-try_grab_page
+++ a/mm/gup.c
@@ -124,8 +124,8 @@ static inline struct page *try_get_compo
  * considered failure, and furthermore, a likely bug in the caller, so a warning
  * is also emitted.
  */
-__maybe_unused struct page *try_grab_compound_head(struct page *page,
-						   int refs, unsigned int flags)
+struct page *try_grab_compound_head(struct page *page,
+				    int refs, unsigned int flags)
 {
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
@@ -208,35 +208,10 @@ static void put_compound_head(struct pag
  */
 bool __must_check try_grab_page(struct page *page, unsigned int flags)
 {
-	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == (FOLL_GET | FOLL_PIN));
+	if (!(flags & (FOLL_GET | FOLL_PIN)))
+		return true;
 
-	if (flags & FOLL_GET)
-		return try_get_page(page);
-	else if (flags & FOLL_PIN) {
-		int refs = 1;
-
-		page = compound_head(page);
-
-		if (WARN_ON_ONCE(page_ref_count(page) <= 0))
-			return false;
-
-		if (hpage_pincount_available(page))
-			hpage_pincount_add(page, 1);
-		else
-			refs = GUP_PIN_COUNTING_BIAS;
-
-		/*
-		 * Similar to try_grab_compound_head(): even if using the
-		 * hpage_pincount_add/_sub() routines, be sure to
-		 * *also* increment the normal page refcount field at least
-		 * once, so that the page really is pinned.
-		 */
-		page_ref_add(page, refs);
-
-		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED, 1);
-	}
-
-	return true;
+	return try_grab_compound_head(page, 1, flags);
 }
 
 /**
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


