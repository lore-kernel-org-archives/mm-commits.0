Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7221EC43217
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJUEfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJUEfI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:35:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FA548A29
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD75B826C4
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2FBC433D6;
        Fri, 21 Oct 2022 04:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326895;
        bh=FqpMgjFxLwS7Sxa39nVsXezF920RMiAEQO5Kumcb4Hc=;
        h=Date:To:From:Subject:From;
        b=zlPAoERDzQEnH7UL9fY5enOcEwRB0gsiRcIKkRGrNGVQppJlwfrTlZ4LcGXmG08ep
         k5d2bqHgkineqRjUWXpfzu3ZpKRnCx1+chzlG1zwnqLK4jNlR1f2wDBvStUcHdWQ7u
         ax8bBq4ZYHOaRj6GrHH/SIFWhD0QjpGI9llBwdyU=
Date:   Thu, 20 Oct 2022 21:34:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch removed from -mm tree
Message-Id: <20221021043455.3C2FBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


