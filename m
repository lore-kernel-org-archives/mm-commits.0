Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A1EC433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0913222210
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600300172;
	bh=e4k+GPY+g4nMplr1NpQxBc9kxCpp/HNpdML6P3uRR/M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=d5rCVr5qgg0E6e4Xogpc57e45QkBH0EpPyaSRh7lpL6OGdy2xOX0CCLR/ClYe2jAe
	 DDhNha32G6mja+NnA3pBZpxiw6e6vMksgnf2XcJZ7HI0eu2q3hQ/LJlQH/JhGQoMiz
	 2WbbzpQ1PaLRtQloBttYNzwFi5uiujo7Oa/uI31w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIPXtb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:49:30 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294702220B;
        Wed, 16 Sep 2020 23:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600300169;
        bh=e4k+GPY+g4nMplr1NpQxBc9kxCpp/HNpdML6P3uRR/M=;
        h=Date:From:To:Subject:From;
        b=j3WemaqX6LwWlKTJ4+KCGbeS9jHC03C5NOcUWlOe8ohgJeiboBzS7OKxSp035t1al
         5sQh75XRZps5BJiQIer1sN4afhoU08dJy+dejuTLLQdauh1nOR7yQ/vakNMZhf5A62
         Bp9A9p/Dbx54460Mlv3mqBHLm0LRsshiE4U753zs=
Date:   Wed, 16 Sep 2020 16:49:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mporter@kernel.crashing.org, madhuparnabhowmik10@gmail.com,
        jhubbard@nvidia.com, ira.weiny@intel.com, gustavoars@kernel.org,
        dan.carpenter@oracle.com, alex.bou9@gmail.com, jrdr.linux@gmail.com
Subject:  + rapidio-fix-error-handling-path.patch added to -mm tree
Message-ID: <20200916234928.f1YPh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix error handling path
has been added to the -mm tree.  Its filename is
     rapidio-fix-error-handling-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-error-handling-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-error-handling-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: rapidio: fix error handling path

rio_dma_transfer() attempts to clamp the return value of
pin_user_pages_fast() to be >= 0.  However, the attempt fails because
nr_pages is overridden a few lines later, and restored to the undesirable
-ERRNO value.

The return value is ultimately stored in nr_pages, which in turn is passed
to unpin_user_pages(), which expects nr_pages >= 0, else, disaster.

Fix this by fixing the nesting of the assignment to nr_pages: nr_pages
should be clamped to zero if pin_user_pages_fast() returns -ERRNO, or set
to the return value of pin_user_pages_fast(), otherwise.

[jhubbard@nvidia.com: new changelog]
Link: https://lkml.kernel.org/r/1600227737-20785-1-git-send-email-jrdr.linux@gmail.com
Fixes: e8de370188d09 ("rapidio: add mport char device driver")
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-error-handling-path
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -871,15 +871,16 @@ rio_dma_transfer(struct file *filp, u32
 				rmcd_error("pin_user_pages_fast err=%ld",
 					   pinned);
 				nr_pages = 0;
-			} else
+			} else {
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
+				/*
+				 * Set nr_pages up to mean "how many pages to unpin, in
+				 * the error handler:
+				 */
+				nr_pages = pinned;
+			}
 			ret = -EFAULT;
-			/*
-			 * Set nr_pages up to mean "how many pages to unpin, in
-			 * the error handler:
-			 */
-			nr_pages = pinned;
 			goto err_pg;
 		}
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

rapidio-fix-error-handling-path.patch

