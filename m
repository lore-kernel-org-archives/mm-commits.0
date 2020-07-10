Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B6DC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5E6207BB
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594415963;
	bh=cFTvTAlcJPaqT5QAeE8IxsKH0goWcdmaXuMhlukCkZI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Y8IABRmNRTNMtG+WDAlrAgtCBc8m/ZWxH+0Ty/RT/Cr2hKA/mBzCVWffqbGCgAXtG
	 YZb+BlmwRQp46y6RJg9lmjh9vrgetEGH6ktm4SEeQhtPLGryAmC+FHWokTonmF+47M
	 xXTeSYSMx9UjTkorh9Sdckz14NOP6orB9Sy82ObQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGJVTW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgGJVTW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:19:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A0092075D;
        Fri, 10 Jul 2020 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594415961;
        bh=cFTvTAlcJPaqT5QAeE8IxsKH0goWcdmaXuMhlukCkZI=;
        h=Date:From:To:Subject:From;
        b=PvAZ7l56xw+9qeq4ADUdpxjXr4QpWM7J8r3BjSCoSekAgufpMfBEfmnmrB5oZXwfW
         kpZ4Vedg2XprKU5XtNfRVAPBJbrKN7lheIbbAWiimEmKpMqIWbZtfCvVB3dgJsCEb9
         QaSw32X6z8Losvy3xYOcBdfBIr/MM7O7yfUIxFKs=
Date:   Fri, 10 Jul 2020 14:19:21 -0700
From:   akpm@linux-foundation.org
To:     bharata@linux.ibm.com, hch@lst.de, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  +
 mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch added to -mm tree
Message-ID: <20200710211921.iuu0-i4dd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-optimize-migrate_vma_setup-for-holes-v2
has been added to the -mm tree.  Its filename is
     mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm-migrate-optimize-migrate_vma_setup-for-holes-v2

Do the same check for vma_is_anonymous() for pte_none().
Don't increment cpages if the page isn't migrating.

Link: http://lkml.kernel.org/r/20200710194840.7602-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Bharata B Rao" <bharata@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migrate-optimize-migrate_vma_setup-for-holes-v2
+++ a/mm/migrate.c
@@ -2167,13 +2167,19 @@ static int migrate_vma_collect_hole(unsi
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
-	unsigned long flags;
 
 	/* Only allow populating anonymous memory. */
-	flags = vma_is_anonymous(walk->vma) ? MIGRATE_PFN_MIGRATE : 0;
+	if (!vma_is_anonymous(walk->vma)) {
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			migrate->src[migrate->npages] = 0;
+			migrate->dst[migrate->npages] = 0;
+			migrate->npages++;
+		}
+		return 0;
+	}
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = flags;
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
 		migrate->npages++;
 		migrate->cpages++;
@@ -2264,8 +2270,10 @@ again:
 		pte = *ptep;
 
 		if (pte_none(pte)) {
-			mpfn = MIGRATE_PFN_MIGRATE;
-			migrate->cpages++;
+			if (vma_is_anonymous(vma)) {
+				mpfn = MIGRATE_PFN_MIGRATE;
+				migrate->cpages++;
+			}
 			goto next;
 		}
 
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-remove-redundant-check-non_swap_entry.patch
mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

