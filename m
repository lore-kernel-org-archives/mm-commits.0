Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EE5C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDAE92225E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709528;
	bh=yllUe/K/IFTfjF22wdDZzGBXd4Hz+rh8X93hATy3I7E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ha6QcE77mywlObHAZB379dEajEMdDx4N/SK+RVi/N26Ef5XIlVXqJKaXavtkahrL1
	 opbg1Hcdo38tAZRsWSkSB+b+k/8M529gJieVONmRsb7YkHizAkw27n475C2Y56Epwr
	 DTFB29EDp/Vhy9/NLNn69U81lwOLO2GGg6a/ShNo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbgJNVF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgJNVF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:05:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D80322258;
        Wed, 14 Oct 2020 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709527;
        bh=yllUe/K/IFTfjF22wdDZzGBXd4Hz+rh8X93hATy3I7E=;
        h=Date:From:To:Subject:From;
        b=Px1v/m/+O382IyihNu0+/F6uPJ8B2cl0jAIr7jVhsqmQ1XuqlRFk+RHTzgZIedX2z
         nGiBAJ907nOFqC6jQkenxZEUHu05W9hJL0VFEosKK3P3wRmK4p1WfzYye7ZJ0wPf1v
         0HusUwKkQEveztTCYzOHimvnsvC0hJYEZnol/ezs=
Date:   Wed, 14 Oct 2020 14:05:27 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged]
 mm-migrate-remove-obsolete-comment-about-device-public.patch removed from
 -mm tree
Message-ID: <20201014210527.Hzsn9Ur7q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove obsolete comment about device public
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-obsolete-comment-about-device-public.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rcampbell@nvidia.com are


