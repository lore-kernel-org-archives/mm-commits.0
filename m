Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB655C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9693120704
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595018768;
	bh=1qRP6EezsK6ueW2LZlXmvWRw9GenvAH4odxF0OxDedg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HIR/PYAVw92oRpXMo+3zCPhGizCyQnO0UI/ChVqVfHzWOMpHXcGimYIDAGmtyIaUW
	 fhJILiqhj2blHloMJ3wdeW0qb+XpQDfwA9rxNG8lMbCXIq2sGLuFaywFZ/+wWs157o
	 pd8dE4So/ErV6Ilv4HYdtHan9dsXwGwsGG0BFsyo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgGQUqI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgGQUqI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 16:46:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E458F20691;
        Fri, 17 Jul 2020 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595018767;
        bh=1qRP6EezsK6ueW2LZlXmvWRw9GenvAH4odxF0OxDedg=;
        h=Date:From:To:Subject:From;
        b=UNqvncTXNcW5ctPZvFU0ayBvGsxu+FIWgZkM2RsVPdCz+HBxBoRgT33p85fKArTA1
         WBtAXNi2scDHwhI5gqAO9QoUixViYmUUlUFB0Kfn7Sw5bC0xIk414tqioj+PfaoU2m
         ZSNtI5EMu0p6v6ShZDgzrW9h9X0PWw1Sa7yQLi38=
Date:   Fri, 17 Jul 2020 13:46:06 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, rdunlap@infradead.org
Subject:  +
 mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch added to -mm tree
Message-ID: <20200717204606.yahy9RhBV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-rework-soft-offline-for-in-use-pages-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-rework-soft-offline-for-in-use-pages-fix

fix build

../mm/hugetlb.c:1302:20: error: redefinition of `destroy_compound_gigantic_page'
 static inline void destroy_compound_gigantic_page(struct hstate *h,
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../mm/hugetlb.c:1223:13: note: previous definition of `destroy_compound_gigantic_page' was here
 static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: http://lkml.kernel.org/r/267a50e8-b7b2-b095-d62e-6e95313bc4c2@infradead.org
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- a/mm/hugetlb.c~mmhwpoison-rework-soft-offline-for-in-use-pages-fix
+++ a/mm/hugetlb.c
@@ -1231,30 +1231,6 @@ static inline void ClearPageHugePoisoned
 	page[3].mapping = NULL;
 }
 
-static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
-					   unsigned int order)
-{
-	int i;
-	int nr_pages = 1 << order;
-	struct page *p = page + 1;
-
-	atomic_set(compound_mapcount_ptr(page), 0);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
-
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		if (!hstate_is_gigantic(h))
-			 p->mapping = NULL;
-		clear_compound_head(p);
-		set_page_refcounted(p);
-	}
-
-	if (PageHugePoisoned(page))
-		ClearPageHugePoisoned(page);
-	set_compound_order(page, 0);
-	__ClearPageHead(page);
-}
-
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
@@ -1310,11 +1286,32 @@ static struct page *alloc_gigantic_page(
 	return NULL;
 }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
-static inline void destroy_compound_gigantic_page(struct hstate *h,
-						  struct page *page,
-						  unsigned int order) { }
 #endif
 
+static void destroy_compound_gigantic_page(struct hstate *h, struct page *page,
+					   unsigned int order)
+{
+	int i;
+	int nr_pages = 1 << order;
+	struct page *p = page + 1;
+
+	atomic_set(compound_mapcount_ptr(page), 0);
+	if (hpage_pincount_available(page))
+		atomic_set(compound_pincount_ptr(page), 0);
+
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		if (!hstate_is_gigantic(h))
+			 p->mapping = NULL;
+		clear_compound_head(p);
+		set_page_refcounted(p);
+	}
+
+	if (PageHugePoisoned(page))
+		ClearPageHugePoisoned(page);
+	set_compound_order(page, 0);
+	__ClearPageHead(page);
+}
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

