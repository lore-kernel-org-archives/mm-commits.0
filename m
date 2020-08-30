Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DEAC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D7620738
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598826008;
	bh=19qjQlpB2wxRoPKCCk2sTYfb/LeJtv+HP7lamvRxXGA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1XgRWgtIKR5WnvpxjUzL0WQHxSKhpDARIbXW3ZieK8iA52M5wtM79MSAn0LNYu6rS
	 FTPqtSIRPLAnC3+Kgv1ilJOJrXkBXO8mezu3wu4kAgf2DEhZRewQd7tOa42+b14dkc
	 SpcKhdQPyC5BOsgTzsVQex60IjanYGQ1hu0Jb36k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgH3WUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:20:07 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D437120693;
        Sun, 30 Aug 2020 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598826007;
        bh=19qjQlpB2wxRoPKCCk2sTYfb/LeJtv+HP7lamvRxXGA=;
        h=Date:From:To:Subject:From;
        b=FIcip3buhFQMlycLJU3IvxR8xScnX9xj2/uBDyqbq8JfSgDwDEyo7PJBuDjswl2l9
         RsCPT5cCGtPjrfhwaYI8Nte2jYJSLvnrMZGAE0QkaUh159FWyZclLyPY51KYzV0goL
         bUCLsY+2ZsweVay561dQzwFA5MYOaCS013YprzpQ=
Date:   Sun, 30 Aug 2020 15:20:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        jglisse@redhat.com, jgg@nvidia.com, hch@lst.de,
        rcampbell@nvidia.com
Subject:  +
 mm-migrate-remove-obsolete-comment-about-device-public.patch added to -mm
 tree
Message-ID: <20200830222006.3Dx-T%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove obsolete comment about device public
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-obsolete-comment-about-device-public.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-obsolete-comment-about-device-public.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-obsolete-comment-about-device-public.patch

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

mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

