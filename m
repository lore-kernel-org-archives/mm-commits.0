Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAD5C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E813321D81
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633524;
	bh=cEamUjqfNKEZmFeTdhB9G4sZGjRYYVa4fdLoH3vapJU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hJ8sndKsZMvlJ8Z9zjXgQRGPWqsAoDY9rWugSGHWvHSr8HJgp8icAx97W3vlMHHRQ
	 vIwiw8mt7EwqrIIJXgn2mtjElOp7HzU+S2UyH3HMnnKNocAeRrBBcTXRWGWSp9eKHs
	 u9+VPmn60b1u3DjXpoCGRKiZzEDQIsQ4btVp/6Ks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbgJMX6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39702222F;
        Tue, 13 Oct 2020 23:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633523;
        bh=cEamUjqfNKEZmFeTdhB9G4sZGjRYYVa4fdLoH3vapJU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zyTGG/p8eRaM/rZNXshaMSmAEPxAD/2AjYEDvU9YkZpc2EhsqnBJy1NNQ26JH6Bue
         DnPBFcNg9zjA23bJsut4Tdqp+nNRmxTQlwRIL2YYGKcJMuf/7GcBGaSZ6jMsdIy85c
         g92uFO05DlRkX79QPi6NMPyveZQKbAk+V9QSSsbA=
Date:   Tue, 13 Oct 2020 16:58:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org
Subject:  [patch 181/181] mm/migrate: remove obsolete comment about
 device public
Message-ID: <20201013235842.QUnG0zK3Y%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: remove obsolete comment about device public

Device public memory never had an in tree consumer and was removed in
commit 25b2995a35b6 ("mm: remove MEMORY_DEVICE_PUBLIC support").  Delete
the obsolete comment.

Link: http://lkml.kernel.org/r/20200827190735.12752-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-remove-obsolete-comment-about-device-public
+++ a/mm/migrate.c
@@ -381,7 +381,7 @@ static int expected_page_refs(struct add
 	int expected_count = 1;
 
 	/*
-	 * Device public or private pages have an extra refcount as they are
+	 * Device private pages have an extra refcount as they are
 	 * ZONE_DEVICE pages.
 	 */
 	expected_count += is_device_private_page(page);
_
