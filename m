Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53870C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 141B7208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262569;
	bh=XFcbUquuVZKhTfux06RZiOgOdM1c4My4s7e0Hn0J5B0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FkQAb79UysM7waX8+Jzy3UdsCOPmX2zuwDIH/0kDx3GZidZ3DtWwWkrfTbr8rjQS0
	 6fodB+ARZ13NTBm8QzfUk6QgSKRzDOsMO0gHTkKNOyvHy5WOLzLaPfFYffEYb2ouhu
	 0AEVM2l2h/DFE7D8yACmVHXnKWk2iL5LoHRTD21A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgIDXgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FB42087C;
        Fri,  4 Sep 2020 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262567;
        bh=XFcbUquuVZKhTfux06RZiOgOdM1c4My4s7e0Hn0J5B0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b7snsfFoaWJK1OYU07GjQ2/9oz2fIWzKHdRSevSIG23efeE1iNQt5y9n3yR6rvLhX
         Fl2+h0xHSE9bz6nhLt13KXjuLPS6Y6X4/mvZEERTECYzq148X9e9kbUxxlVe8Kw6sJ
         iPG+rhtlJbRy7SJPwWdFwMHAruhhBttWygjW5/iU=
Date:   Fri, 04 Sep 2020 16:36:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bharata@linux.ibm.com, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org
Subject:  [patch 15/19] mm/migrate: preserve soft dirty in
 remove_migration_pte()
Message-ID: <20200904233607.3awgBCtEU%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: preserve soft dirty in remove_migration_pte()

The code to remove a migration PTE and replace it with a device private
PTE was not copying the soft dirty bit from the migration entry.  This
could lead to page contents not being marked dirty when faulting the page
back from device private memory.

Link: https://lkml.kernel.org/r/20200831212222.22409-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/migrate.c~mm-migrate-preserve-soft-dirty-in-remove_migration_pte
+++ a/mm/migrate.c
@@ -249,6 +249,8 @@ static bool remove_migration_pte(struct
 		if (unlikely(is_device_private_page(new))) {
 			entry = make_device_private_entry(new, pte_write(pte));
 			pte = swp_entry_to_pte(entry);
+			if (pte_swp_soft_dirty(*pvmw.pte))
+				pte = pte_swp_mksoft_dirty(pte);
 			if (pte_swp_uffd_wp(*pvmw.pte))
 				pte = pte_swp_mkuffd_wp(pte);
 		}
_
