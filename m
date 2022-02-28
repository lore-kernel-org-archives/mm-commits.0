Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6005FC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240827AbiB1SpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiB1Sou (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B980835DC8
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50ABA61555
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9B5C340F1;
        Mon, 28 Feb 2022 18:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646073795;
        bh=grPMR2OLj62HnSf5oYwDccWSHOFV+dimh4dx7jzT/3M=;
        h=Date:To:From:Subject:From;
        b=cw2/jrXySrYg9kdLlnByuROwzYKQA3F7cqSZ201ibusLwQtvJ4mnkxe1Fh7AGvcLw
         UNPNVINSPe3YhSDKWekjhRSn7tg6iaAdiqGIrt4oKciGNuvrNvTkygl/afgrVI784D
         g2clSOjy3fH50pty9ZAM2kMtYswmk3nvGKVKrSxE=
Date:   Mon, 28 Feb 2022 10:43:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, kirill@shutemov.name, hch@infradead.org,
        dhowells@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-export-pageheadhuge.patch added to -mm tree
Message-Id: <20220228184315.9B9B5C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: export PageHeadHuge()
has been added to the -mm tree.  Its filename is
     mm-export-pageheadhuge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-export-pageheadhuge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-export-pageheadhuge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm/hugetlb.c: export PageHeadHuge()

Export PageHeadHuge() - it's used by folio_test_hugetlb() and thence by
such as folio_file_page() and folio_contains().  Matthew suggested I use
the first of those instead of doing the same calculation manually - but I
can't call it from a module.

Kirill suggested rearranging things to put it in a header, but that
introduces header dependencies because of where constants are defined.

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
+EXPORT_SYMBOL(PageHeadHuge);
 
 /*
  * Find and lock address space (mapping) in write mode.
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-export-pageheadhuge.patch
mutex-subsystem-synchro-test-module.patch

