Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0162DC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiCVVrJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiCVVrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB805FF1A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F24A6119A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F8DC340EC;
        Tue, 22 Mar 2022 21:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985527;
        bh=OetOeqPdLI4ZR8ZX+aYpyGdrzB+LenaHlloTwIB5/zo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=0NRfyC9mVWsQ2z6NwepGE44iY/ttwFuM+IrsGtJazjJ6psqb4bLNkayertwW2EDcl
         BR9wLLR5fjUE6S87h21iXE7NLN8iIqEyMYiYw1FiTtRec3eh4sPlnAbHrJ007Pr9MB
         AQzdyigSVQbmWHLVsP49D+3n0Ud1+NFIRRv0Eo3A=
Date:   Tue, 22 Mar 2022 14:45:26 -0700
To:     willy@infradead.org, mike.kravetz@oracle.com, kirill@shutemov.name,
        hch@infradead.org, dhowells@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 136/227] mm/hugetlb.c: export PageHeadHuge()
Message-Id: <20220322214527.05F8DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Subject: mm/hugetlb.c: export PageHeadHuge()

Export PageHeadHuge() - it's used by folio_test_hugetlb() and thence by
such as folio_file_page() and folio_contains().  Matthew suggested I use
the first of those instead of doing the same calculation manually - but I
can't call it from a module.

Kirill suggested rearranging things to put it in a header, but that
introduces header dependencies because of where constants are defined.

[akpm@linux-foundation.org: s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/, per Christoph]
Link: https://lkml.kernel.org/r/2494562.1646054576@warthog.procyon.org.uk
Link: https://lore.kernel.org/r/163707085314.3221130.14783857863702203440.stgit@warthog.procyon.org.uk/
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-export-pageheadhuge
+++ a/mm/hugetlb.c
@@ -1855,6 +1855,7 @@ int PageHeadHuge(struct page *page_head)
 
 	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
+EXPORT_SYMBOL_GPL(PageHeadHuge);
 
 /*
  * Find and lock address space (mapping) in write mode.
_
