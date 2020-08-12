Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0935FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03E620829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193968;
	bh=DzjmM77l+KFaqUFjLnyyzGqJ4/p20LPJnTJzQJ1xgr4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gnfIE5bVjXZ0bLubD1/Eer2NuvIdlxysFVtsmxNBPafTTA0yx5qgE7bIVHH68JaO3
	 EnBld5SaqWpGWH2X7eagu8fzBp9SQts2oEwwn/3qVn67HUwu1fp9nPKIi5gPEo+J9K
	 WZoK+o5zwGnExD59bEcaAjjaiJ4NJGNs4FeQ8tPc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgHLA72 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLA72 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:59:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5616C207DA;
        Wed, 12 Aug 2020 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193967;
        bh=DzjmM77l+KFaqUFjLnyyzGqJ4/p20LPJnTJzQJ1xgr4=;
        h=Date:From:To:Subject:From;
        b=qVJsnVZfi3xBcK3Kp9bkmWvpCizZXv2talxe7I8KQ44mhRE0qe8Zwq4AbVN0QWyTl
         UYHG+n3bPgNFuDKO+jwTN5SXlFV3reRX2HGuV2yJyhvDWt42PzmrLEZnZQCnr+bBVE
         E9XtZ6hkFkPZ4K5AuKwTFw0OZjKBA9I544AiVWqg=
Date:   Tue, 11 Aug 2020 17:59:26 -0700
From:   akpm@linux-foundation.org
To:     bharata@linux.ibm.com, hch@lst.de, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [folded-merged]
 mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch removed from -mm
 tree
Message-ID: <20200812005926.Jz8jwge8X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-optimize-migrate_vma_setup-for-holes-v2
has been removed from the -mm tree.  Its filename was
     mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch

This patch was dropped because it was folded into mm-migrate-optimize-migrate_vma_setup-for-holes.patch

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

mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch

