Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050CFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354112AbiCYBej (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352982AbiCYBdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2355C667
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF0960AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BD5C340ED;
        Fri, 25 Mar 2022 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171924;
        bh=O64T7y6TsqWZkLCNNDmClsNY0aVpJzzG5SlwZvV7XIs=;
        h=Date:To:From:Subject:From;
        b=O4ak7QrRsu85lpz/KU4TvLbmISA6TCYGAq0Tg7X2HBLmxhvy+ss8K3Z1qYn0oLKBS
         tQ3L1xeF7D4BNfAT13hkRp7sXQUYlV2PwXQHt2gZUp1mfsGMlQk83Xfy0/mgjlOxaE
         +HYtE7bakalLdJfD6kNWx3++LlStAY3JSxWeiydE=
Date:   Thu, 24 Mar 2022 18:32:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, kirill@shutemov.name, hch@infradead.org,
        dhowells@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-export-pageheadhuge.patch removed from -mm tree
Message-Id: <20220325013204.84BD5C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: export PageHeadHuge()
has been removed from the -mm tree.  Its filename was
     mm-export-pageheadhuge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dhowells@redhat.com are

mutex-subsystem-synchro-test-module.patch

