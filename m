Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C49C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiLAAEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLAACd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC73087CA8
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FFC6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBEAC433D7;
        Thu,  1 Dec 2022 00:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852878;
        bh=5iX1bl0QO0rquX5qz3Scmip6uDlVWs+r/gx7awqLPjQ=;
        h=Date:To:From:Subject:From;
        b=eV8rL58B/q5XvmfGip9by+TcNdY4FwHCMGM+4rW8iWAFxJziNxBQVzF25SLXdxG3J
         rhCksTrfoiX0F4yWYKn56zof+EszmKLjHGh2Uhl0hNS4dqxbfOtpOFOBm2ZrbeC3A3
         Vj11ndpHuytW1HEkp5OU/N5yYly7Id30Z17epDMk=
Date:   Wed, 30 Nov 2022 16:01:17 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too.patch removed from -mm tree
Message-Id: <20221201000118.6EBEAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: teach release_pages() to take an array of encoded page pointers too
has been removed from the -mm tree.  Its filename was
     mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: teach release_pages() to take an array of encoded page pointers too
Date: Wed, 9 Nov 2022 12:30:49 -0800

release_pages() already could take either an array of page pointers, or an
array of folio pointers.  Expand it to also accept an array of encoded
page pointers, which is what both the existing mlock() use and the
upcoming mmu_gather use of encoded page pointers wants.

Note that release_pages() won't actually use, or react to, any extra
encoded bits.  Instead, this is very much a case of "I have walked the
array of encoded pages and done everything the extra bits tell me to do,
now release it all".

Also, while the "either page or folio pointers" dual use was handled with
a cast of the pointer in "release_folios()", this takes a slightly
different approach and uses the "transparent union" attribute to describe
the set of arguments to the function:

  https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html

which has been supported by gcc forever, but the kernel hasn't used
before.

That allows us to avoid using various wrappers with casts, and just use
the same function regardless of use.

Link: https://lkml.kernel.org/r/20221109203051.1835763-2-torvalds@linux-foundation.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++++++++++--
 mm/swap.c          |   16 ++++++++++++----
 2 files changed, 31 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too
+++ a/include/linux/mm.h
@@ -1245,7 +1245,24 @@ static inline void folio_put_refs(struct
 		__folio_put(folio);
 }
 
-void release_pages(struct page **pages, int nr);
+/**
+ * release_pages - release an array of pages or folios
+ *
+ * This just releases a simple array of multiple pages, and
+ * accepts various different forms of said page array: either
+ * a regular old boring array of pages, an array of folios, or
+ * an array of encoded page pointers.
+ *
+ * The transparent union syntax for this kind of "any of these
+ * argument types" is all kinds of ugly, so look away.
+ */
+typedef union {
+	struct page **pages;
+	struct folio **folios;
+	struct encoded_page **encoded_pages;
+} release_pages_arg __attribute__ ((__transparent_union__));
+
+void release_pages(release_pages_arg, int nr);
 
 /**
  * folios_put - Decrement the reference count on an array of folios.
@@ -1261,7 +1278,7 @@ void release_pages(struct page **pages,
  */
 static inline void folios_put(struct folio **folios, unsigned int nr)
 {
-	release_pages((struct page **)folios, nr);
+	release_pages(folios, nr);
 }
 
 static inline void put_page(struct page *page)
--- a/mm/swap.c~mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too
+++ a/mm/swap.c
@@ -981,22 +981,30 @@ void lru_cache_disable(void)
 
 /**
  * release_pages - batched put_page()
- * @pages: array of pages to release
+ * @arg: array of pages to release
  * @nr: number of pages
  *
- * Decrement the reference count on all the pages in @pages.  If it
+ * Decrement the reference count on all the pages in @arg.  If it
  * fell to zero, remove the page from the LRU and free it.
+ *
+ * Note that the argument can be an array of pages, encoded pages,
+ * or folio pointers. We ignore any encoded bits, and turn any of
+ * them into just a folio that gets free'd.
  */
-void release_pages(struct page **pages, int nr)
+void release_pages(release_pages_arg arg, int nr)
 {
 	int i;
+	struct encoded_page **encoded = arg.encoded_pages;
 	LIST_HEAD(pages_to_free);
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	unsigned int lock_batch;
 
 	for (i = 0; i < nr; i++) {
-		struct folio *folio = page_folio(pages[i]);
+		struct folio *folio;
+
+		/* Turn any of the argument types into a folio */
+		folio = page_folio(encoded_page_ptr(encoded[i]));
 
 		/*
 		 * Make sure the IRQ-safe lock-holding time does not get
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are


