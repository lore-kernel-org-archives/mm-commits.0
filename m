Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F439C5479D
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 23:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbjAFX4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjAFX4A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 18:56:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495B73AB29
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 15:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1874B815E2
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 23:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF39C433EF;
        Fri,  6 Jan 2023 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673049354;
        bh=7VGAr9gRJdBHld2YjCVvd0SwPlX5M5klquZvniDzyhw=;
        h=Date:To:From:Subject:From;
        b=gu0AnBiFeMr8yZIshMSxwlLzk6w35lDWnoxmnvKQ0KuUh7AiGEMtU0QXkkpj8nUVV
         gq5MxYkNw5Dyqrrq720c7lPxzbM2Ta0fA8sa47cwsmGw+RYsVYxDhnYctr5USCIywh
         ZBioBpzap3jlhU52HEbqmIRoxeEdGuKz7xgf8xFk=
Date:   Fri, 06 Jan 2023 15:55:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sj@kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-folio_is_pfmemalloc.patch added to mm-unstable branch
Message-Id: <20230106235554.9BF39C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce folio_is_pfmemalloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-folio_is_pfmemalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-folio_is_pfmemalloc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm: introduce folio_is_pfmemalloc
Date: Fri, 6 Jan 2023 15:52:51 -0600

Add a folio equivalent for page_is_pfmemalloc. This removes two instances
of page_is_pfmemalloc(folio_page(folio, 0)) so the folio can be used
directly.

Link: https://lkml.kernel.org/r/20230106215251.599222-1-sidhartha.kumar@oracle.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++++
 mm/slab.c          |    2 +-
 mm/slub.c          |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-introduce-folio_is_pfmemalloc
+++ a/include/linux/mm.h
@@ -1965,6 +1965,21 @@ static inline bool page_is_pfmemalloc(co
 }
 
 /*
+ * Return true only if the folio has been allocated with
+ * ALLOC_NO_WATERMARKS and the low watermark was not
+ * met implying that the system is under some pressure.
+ */
+static inline bool folio_is_pfmemalloc(const struct folio *folio)
+{
+	/*
+	 * lru.next has bit 1 set if the page is allocated from the
+	 * pfmemalloc reserves.  Callers may simply overwrite it if
+	 * they do not need to preserve that information.
+	 */
+	return (uintptr_t)folio->lru.next & BIT(1);
+}
+
+/*
  * Only to be called by the page allocator on a freshly allocated
  * page.
  */
--- a/mm/slab.c~mm-introduce-folio_is_pfmemalloc
+++ a/mm/slab.c
@@ -1373,7 +1373,7 @@ static struct slab *kmem_getpages(struct
 	/* Make the flag visible before any changes to folio->mapping */
 	smp_wmb();
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
-	if (sk_memalloc_socks() && page_is_pfmemalloc(folio_page(folio, 0)))
+	if (sk_memalloc_socks() && folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
--- a/mm/slub.c~mm-introduce-folio_is_pfmemalloc
+++ a/mm/slub.c
@@ -1859,7 +1859,7 @@ static inline struct slab *alloc_slab_pa
 	__folio_set_slab(folio);
 	/* Make the flag visible before any changes to folio->mapping */
 	smp_wmb();
-	if (page_is_pfmemalloc(folio_page(folio, 0)))
+	if (folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch

