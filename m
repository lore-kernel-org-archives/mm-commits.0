Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D49C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6A72225C
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709527;
	bh=qDYbh0FguCuOop/47gm6X+YQVdHwJdWX8FbVU4KowW8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NWloUGGFOedCEjwdKtHI3H/s8z2sUe+FEvJJUOCqXWrgDdL2rrJzT38vPl1q6xe9h
	 QR1VDFQQlLx84KMBZt6iDKiIyebjH1J3H/94xqrs59Jb1kNADVz8t0AlgZ683sqqtN
	 p6gbbZxLzoHu720K2NUHw7NApNkbYf3jTKDtgbfw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgJNVF0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgJNVF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:05:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B6C02226B;
        Wed, 14 Oct 2020 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709524;
        bh=qDYbh0FguCuOop/47gm6X+YQVdHwJdWX8FbVU4KowW8=;
        h=Date:From:To:Subject:From;
        b=nXXCfyUf9m8gYjhHNP4PtecRX2BwGmPaZU6ZchwIfhOOhbQCTjogSosY05QMCa7jN
         eqRWVKFW/8SErBGp8YjIsu+uiiD9SZsQkrYrmws7csX5ri+lF81iJaQpo758IQio/A
         mEUyeGkreHgXVY0N2dgwWt7YurJnJTxuCyuECpkI=
Date:   Wed, 14 Oct 2020 14:05:24 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged]
 mm-migrate-remove-cpages-in-migrate_vma_finalize.patch removed from -mm
 tree
Message-ID: <20201014210524.Pv6eTy8ce%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove cpages-- in migrate_vma_finalize()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-cpages-in-migrate_vma_finalize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rcampbell@nvidia.com are


