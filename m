Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A31BC433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1AF20738
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598826005;
	bh=aSdFd1ZkRK9yYILTsIzVBH7xaAJgHuPDTO+dyLp8YX8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BxYf6UPJl20QwrIwwjGyEgyLeTbgNNMliEpER89GcVNIpSrPQQuEEBTyGBBxPqajc
	 bKGX3xh2FrCII/qdTngm6AxrDo23zlfloV2k3gcA5wLwMDmAbQpe1r8ypsCV0OZjOb
	 X1gDLNOkaEmf3z4UhwZKLSc67WieM7xbqTH02YwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgH3WUE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:20:04 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279B120693;
        Sun, 30 Aug 2020 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598826003;
        bh=aSdFd1ZkRK9yYILTsIzVBH7xaAJgHuPDTO+dyLp8YX8=;
        h=Date:From:To:Subject:From;
        b=W3BcyKB1ENYFkvFlR6OzX7KI0EVGDM/hXH1JN/SOIZ5Xo7QngAyNERimiIXyWFWRc
         pb9+VtSVXkRG+QG2mIbA7dN8mjqdTnOxDDbLo65Vqr+gmrcWY38I9SCNj9Swhx7/de
         d2VGHExZ6jLSOyzqzxjGFX6zSftArYqacX2usxNw=
Date:   Sun, 30 Aug 2020 15:20:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        jglisse@redhat.com, jgg@nvidia.com, hch@lst.de,
        rcampbell@nvidia.com
Subject:  + mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
 added to -mm tree
Message-ID: <20200830222002.4OCMT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove cpages-- in migrate_vma_finalize()
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-cpages-in-migrate_vma_finalize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-cpages-in-migrate_vma_finalize.patch

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

mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

