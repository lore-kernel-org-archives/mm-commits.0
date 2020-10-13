Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AA5C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004D122246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633522;
	bh=uLMJqaG2fSzmDqcISfOMh5TCXCS4J0HwSuFKKKnjR74=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=I4RSci8+utgb5v5YUIbaiczV6+fRXOvq3d0zK66y2HhFLe+eUye29dfNubdJwImTU
	 f6ThDeHrz92RZSbG7ERhrJiKxSnX53UFHJd+Ypvz7n3nchAkt+Eeq46eg9iP9q+R8i
	 orN6Z+kwmIHrXMD+UufLkH2hJJ9ef7GFK9ULxhb8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbgJMX6l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4D122244;
        Tue, 13 Oct 2020 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633520;
        bh=uLMJqaG2fSzmDqcISfOMh5TCXCS4J0HwSuFKKKnjR74=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LIPppHOW03glEGggRm427zlbw0G3r4tOQ1BIltRzL/q6nCMBJm3JzTkFJhvZY1Akb
         v9FCW8UD/LlHW/RBfwXlaqcS06rfOL84qRP9pD+9Tj4W6JdZl2GIJ6oSfA7x3AmENJ
         RxlCw0gfjPBWb+7qPucuTvmQJiH1PPDcPrwdu7V4=
Date:   Tue, 13 Oct 2020 16:58:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org
Subject:  [patch 180/181] mm/migrate: remove cpages-- in
 migrate_vma_finalize()
Message-ID: <20201013235839.lCcrWFxQM%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: remove cpages-- in migrate_vma_finalize()

The variable struct migrate_vma->cpages is only used in
migrate_vma_setup().  There is no need to decrement it in
migrate_vma_finalize() since it is never checked.

Link: http://lkml.kernel.org/r/20200827190735.12752-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-remove-cpages-in-migrate_vma_finalize
+++ a/mm/migrate.c
@@ -3077,7 +3077,6 @@ void migrate_vma_finalize(struct migrate
 
 		remove_migration_ptes(page, newpage, false);
 		unlock_page(page);
-		migrate->cpages--;
 
 		if (is_zone_device_page(page))
 			put_page(page);
_
