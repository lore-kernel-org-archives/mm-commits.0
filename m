From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch added to
 -mm tree
Date: Mon, 18 May 2020 14:37:37 -0700
Message-ID: <20200518213737.wQv6yFzC8%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERVhi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:37:38 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.bou9@gmail.com, dan.carpenter@oracle.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, stable@vger.kernel.org, sumit.semwal@linaro.org


The patch titled
     Subject: rapidio: fix an error in get_user_pages_fast() error handling
has been added to the -mm tree.  Its filename is
     rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: rapidio: fix an error in get_user_pages_fast() error handling

In the case of get_user_pages_fast() returning fewer pages than requested,
rio_dma_transfer() does not quite do the right thing.  It attempts to
release all the pages that were requested, rather than just the pages that
were pinned.

Fix the error handling so that only the pages that were successfully
pinned are released.

Link: http://lkml.kernel.org/r/20200517235620.205225-2-jhubbard@nvidia.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-fix-an-error-in-get_user_pages_fast-error-handling
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -877,6 +877,11 @@ rio_dma_transfer(struct file *filp, u32
 				rmcd_error("pinned %ld out of %ld pages",
 					   pinned, nr_pages);
 			ret = -EFAULT;
+			/*
+			 * Set nr_pages up to mean "how many pages to unpin, in
+			 * the error handler:
+			 */
+			nr_pages = pinned;
 			goto err_pg;
 		}
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

rapidio-fix-an-error-in-get_user_pages_fast-error-handling.patch
mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
rapidio-convert-get_user_pages-pin_user_pages.patch
