Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9A7C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80AF02078E
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262566;
	bh=msfXqepze92yeINjidUwrLrJpQZasnraHgdbgGMoUzc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cxVge1ww46nTb9VFM71DWDySPbE8wgy7S3fJ26CLRRksFYPXVnvouyA0vpxZLjHZb
	 kY+qdFN3mHoxHxtNacNnR45ULRW3BeG8/1fgrVA4XxXUioJ4XqbGkL5gzfrZ7xdDY4
	 ySNV72jF2cD6crA5iByYxLMRs1ygXzfF6VcWntnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgIDXgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9321D208FE;
        Fri,  4 Sep 2020 23:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262564;
        bh=msfXqepze92yeINjidUwrLrJpQZasnraHgdbgGMoUzc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A8ttgF46Ek4kbIX3lp3IMjTbfDpZbCsgKJ1Cb8VVKZxiJehAx7T3zyeJ8V1JGJZtA
         8mhdap9ju8KG3Zf4hY368uUKnui0Edf4J6E05U6PzhH8MbfKasDRkN5M8QAQts0kjX
         oNXHcJbWTVikzCQMWjBc/fUeIpor1vPoAaOEV+XM=
Date:   Fri, 04 Sep 2020 16:36:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bharata@linux.ibm.com, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org
Subject:  [patch 14/19] mm/migrate: remove unnecessary
 is_zone_device_page() check
Message-ID: <20200904233604.NcA1bsFWe%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: remove unnecessary is_zone_device_page() check

Patch series "mm/migrate: preserve soft dirty in remove_migration_pte()".

I happened to notice this from code inspection after seeing Alistair
Popple's patch ("mm/rmap: Fixup copying of soft dirty and uffd ptes").


This patch (of 2):

The check for is_zone_device_page() and is_device_private_page() is
unnecessary since the latter is sufficient to determine if the page is a
device private page.  Simplify the code for easier reading.

Link: https://lkml.kernel.org/r/20200831212222.22409-1-rcampbell@nvidia.com
Link: https://lkml.kernel.org/r/20200831212222.22409-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-unnecessary-is_zone_device_page-check
+++ a/mm/migrate.c
@@ -246,13 +246,11 @@ static bool remove_migration_pte(struct
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
 
-		if (unlikely(is_zone_device_page(new))) {
-			if (is_device_private_page(new)) {
-				entry = make_device_private_entry(new, pte_write(pte));
-				pte = swp_entry_to_pte(entry);
-				if (pte_swp_uffd_wp(*pvmw.pte))
-					pte = pte_swp_mkuffd_wp(pte);
-			}
+		if (unlikely(is_device_private_page(new))) {
+			entry = make_device_private_entry(new, pte_write(pte));
+			pte = swp_entry_to_pte(entry);
+			if (pte_swp_uffd_wp(*pvmw.pte))
+				pte = pte_swp_mkuffd_wp(pte);
 		}
 
 #ifdef CONFIG_HUGETLB_PAGE
_
