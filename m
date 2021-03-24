Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6308C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BB661A2D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhCXX3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhCXX3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C12CC619BB;
        Wed, 24 Mar 2021 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628554;
        bh=SKp5sx0qXL7GSx5OWKHvjB1V1jeueo9rz35nTD2YO7k=;
        h=Date:From:To:Subject:From;
        b=BAjRP9t2ayCiVvOdTFu917oD6qprMEPYKRDivW+sOnTwvmEolQhnb2bycbXwhbeG2
         /zfN63vNYF0IkKNffwyeSBhtVuUuB1G1rMaeftRWXM7+wxuBkxlpjrydD4//ypRfXM
         dp3YX9t7Xt8PMGGoXE9JGUcHXFvNeaoVBLXPRyK4=
Date:   Wed, 24 Mar 2021 16:29:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        jhubbard@nvidia.com, corbet@lwn.net, willy@infradead.org
Subject:  + mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
 added to -mm tree
Message-ID: <20210324232913.a0BEi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: add mm.h and mm_types.h to the mm-api document
has been added to the -mm tree.  Its filename is
     mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: add mm.h and mm_types.h to the mm-api document

kerneldoc in include/linux/mm.h and include/linux/mm_types.h wasn't being
included in the html build.

Link: https://lkml.kernel.org/r/20210322195022.2143603-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/core-api/mm-api.rst~mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document
+++ a/Documentation/core-api/mm-api.rst
@@ -92,3 +92,7 @@ More Memory Management Functions
    :export:
 
 .. kernel-doc:: mm/page_alloc.c
+.. kernel-doc:: include/linux/mm_types.h
+   :internal:
+.. kernel-doc:: include/linux/mm.h
+   :internal:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-move-page_mapping_file-to-pagemaph.patch
mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
mm-doc-turn-fault-flags-into-an-enum.patch
mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

