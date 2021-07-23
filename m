Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8370C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C918960F26
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhGWTvu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhGWTvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 936F460E94;
        Fri, 23 Jul 2021 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627072341;
        bh=cQbok902AL+8vubg3ZAcwC82azM70zMH7asNDT4NRBM=;
        h=Date:From:To:Subject:From;
        b=ne7abWWjzbkpRY4Ax1/6k8s34ddTbi1B3f1YOiotXNxxNCs8ANPokWsacrRkM5VcH
         /G4QwzZkYHyrUW8z4ABulUq8eZObJL9BeOEBIZuNoWN0YmRKmph8Igqb4V3RB74jFL
         0tytx1XgiDq18A48G+OpHNX8gOjuMlQv1eTE1Vvg=
Date:   Fri, 23 Jul 2021 13:32:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rdunlap@xenotime.net, corbet@lwn.net, willy@infradead.org
Subject:  [failures] mm-doc-include-highmemh-in-kernel-doc.patch
 removed from -mm tree
Message-ID: <20210723203220.IN7gB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: include highmem.h in kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-doc-include-highmemh-in-kernel-doc.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: include highmem.h in kernel-doc

There is lots of good documentation in highmem.h that isn't being pulled
into the html documentation.  Fix up a couple of minor glitches and
include it.

Link: https://lkml.kernel.org/r/20210722021843.2336117-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 +
 include/linux/highmem.h           |   17 +++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-doc-include-highmemh-in-kernel-doc
+++ a/Documentation/core-api/mm-api.rst
@@ -54,6 +54,7 @@ Virtually Contiguous Mappings
 
 .. kernel-doc:: mm/vmalloc.c
    :export:
+.. kernel-doc:: include/linux/highmem.h
 
 File Mapping and Page Cache
 ===========================
--- a/include/linux/highmem.h~mm-doc-include-highmemh-in-kernel-doc
+++ a/include/linux/highmem.h
@@ -37,8 +37,8 @@
 static inline void *kmap(struct page *page);
 
 /**
- * kunmap - Unmap the virtual address mapped by kmap()
- * @addr:	Virtual address to be unmapped
+ * kunmap - Unmap the page mapped by kmap()
+ * @page: Page to be unmapped
  *
  * Counterpart to kmap(). A NOOP for CONFIG_HIGHMEM=n and for mappings of
  * pages in the low memory area.
@@ -69,13 +69,13 @@ static inline void kmap_flush_unused(voi
  *
  * Requires careful handling when nesting multiple mappings because the map
  * management is stack based. The unmap has to be in the reverse order of
- * the map operation:
+ * the map operation::
  *
- * addr1 = kmap_local_page(page1);
- * addr2 = kmap_local_page(page2);
- * ...
- * kunmap_local(addr2);
- * kunmap_local(addr1);
+ *   addr1 = kmap_local_page(page1);
+ *   addr2 = kmap_local_page(page2);
+ *   ...
+ *   kunmap_local(addr2);
+ *   kunmap_local(addr1);
  *
  * Unmapping addr1 before addr2 is invalid and causes malfunction.
  *
@@ -119,6 +119,7 @@ static inline void *kmap_atomic(struct p
  * the side effects of kmap_atomic(), i.e. reenabling pagefaults and
  * preemption.
  */
+static inline void kunmap_atomic(void *addr);
 
 /* Highmem related interfaces for management code */
 static inline unsigned int nr_free_highpages(void);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-mark-idle-page-tracking-as-broken.patch
avoid-a-warning-in-sparse-memory-support.patch

