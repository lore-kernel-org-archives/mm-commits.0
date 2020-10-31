Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F2FC5517A
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A98EF206E9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173575;
	bh=sN0QqVjDOT1HA92M+OekPMnfmTpqfZbsUGQ9yPWqfUA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OLMMg8bgOHQwsfkhC5HmBawIrWe2kHMD6EyFRrBbydStYVwWCKmELX2KGJYcJXBFM
	 yZTYsVSY1HL5vyBvOYDAjYQhzMid4dvveTJ04aXimuyY89nfgD27o4+PtlqwcuxFnP
	 0MnL/XJm8eQD6ntKar6pmeZph+93cNH5JjW0ugHc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgJaTqO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgJaTqM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:46:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 984F5206E3;
        Sat, 31 Oct 2020 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173571;
        bh=sN0QqVjDOT1HA92M+OekPMnfmTpqfZbsUGQ9yPWqfUA=;
        h=Date:From:To:Subject:From;
        b=bgWyw0eT+eRlS74vJ3s63uCPei4MLx6BPiIveLMvg0TtF6M5KSKnDDAXAdtsLYNoO
         /TyjbFDiSrdYAXF7MCowluwmh4zNFqy3UV/kFHUBKWlHTrj1ITnypAWN1agnvIFoI2
         d8bXske8ZcY0hW+wfMnfUfkznZhhr6IBgAZXfCag=
Date:   Sat, 31 Oct 2020 12:46:11 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, imbrenda@linux.ibm.com,
        ira.weiny@intel.com, jack@suse.cz, jgg@nvidia.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch added to
 -mm tree
Message-ID: <20201031194611.slgOhggX7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: use unpin_user_pages() in check_and_migrate_cma_pages()
has been added to the -mm tree.  Its filename is
     mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: use unpin_user_pages() in check_and_migrate_cma_pages()

When FOLL_PIN is passed to __get_user_pages() the page list must be put
back using unpin_user_pages() otherwise the page pin reference persists in
a corrupted state.

Link: https://lkml.kernel.org/r/0-v1-976effcd4468+d4-gup_cma_fix_jgg@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages
+++ a/mm/gup.c
@@ -1647,8 +1647,11 @@ check_again:
 		/*
 		 * drop the above get_user_pages reference.
 		 */
-		for (i = 0; i < nr_pages; i++)
-			put_page(pages[i]);
+		if (gup_flags & FOLL_PIN)
+			unpin_user_pages(pages, nr_pages);
+		else
+			for (i = 0; i < nr_pages; i++)
+				put_page(pages[i]);
 
 		if (migrate_pages(&cma_page_list, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-always-have-io_remap_pfn_range-set-pgprot_decrypted.patch
mm-gup-use-unpin_user_pages-in-check_and_migrate_cma_pages.patch

