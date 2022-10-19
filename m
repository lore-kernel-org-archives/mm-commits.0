Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3C6C43217
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 19:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiJSTzc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiJSTz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 15:55:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E6160F4
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 12:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96881CE2161
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 19:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0152AC43470;
        Wed, 19 Oct 2022 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666209323;
        bh=rBdSkDoOe31+uHZD/+jU333MzNkPDVYD4D+b0eVnpVI=;
        h=Date:To:From:Subject:From;
        b=erF6PNIzj5sB3WGDN4XjNquVx4V5o97Ezf+Cblrbs/VuObgad8TqixdqXnz3fp1P3
         yoK5PCRkAtM3suYUg4g3aYyGsG3S14xjGFiRMbGK2zFg6Jtr//rSGelJejFcDDVNyQ
         MYGllh+Idx6Ipq6w0OWHbgVXeD3Vk3C5gCXJMBiI=
Date:   Wed, 19 Oct 2022 12:55:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch added to mm-unstable branch
Message-Id: <20221019195523.0152AC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
Date: Tue, 31 May 2022 09:20:51 -0400

Try to avoid using the left over split page on the next request for a page
by calling __free_pages_ok() with FPI_TO_TAIL.  This increases the
potential of defragmenting memory when it's used for a short period of
time.

Link: https://lkml.kernel.org/r/20220531185626.yvlmymbxyoe5vags@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact
+++ a/mm/page_alloc.c
@@ -5784,14 +5784,18 @@ static void *make_alloc_exact(unsigned l
 		size_t size)
 {
 	if (addr) {
-		unsigned long alloc_end = addr + (PAGE_SIZE << order);
-		unsigned long used = addr + PAGE_ALIGN(size);
+		unsigned long nr = DIV_ROUND_UP(size, PAGE_SIZE);
+		struct page *page = virt_to_page((void *)addr);
+		struct page *last = page + nr;
 
-		split_page(virt_to_page((void *)addr), order);
-		while (used < alloc_end) {
-			free_page(used);
-			used += PAGE_SIZE;
-		}
+		split_page_owner(page, 1 << order);
+		split_page_memcg(page, 1 << order);
+		while (page < --last)
+			set_page_refcounted(last);
+
+		last = page + (1UL << order);
+		for (page += nr; page < last; page++)
+			__free_pages_ok(page, 0, FPI_TO_TAIL);
 	}
 	return (void *)addr;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

