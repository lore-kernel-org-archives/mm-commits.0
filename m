Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF37C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76EC520E65
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817997;
	bh=0vxT0TaEu9U9WVcK60eRtCjDsU02x/Ngknbajo/CPqc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WO42n64OO5Glfe/pQrBGEDJIUbOEgnJwJtrzsrk2BVc1dqkIzOJc6lMZZGMPL9CBq
	 hQEaeToRm2kPDMHilhObA1CLHZZi3Bcjbsh70NHnyebrorQAs8o0W8BrYTNKvkGKb5
	 dfVcdCcYFTtcRWrJCEGCdQHkxS9a0hXOmA3pXgxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393956AbgJPDNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54AC2083B;
        Fri, 16 Oct 2020 03:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817996;
        bh=0vxT0TaEu9U9WVcK60eRtCjDsU02x/Ngknbajo/CPqc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iBuv+pqHs2SlaoUA7TojcJ4x9tzHUJUUFRxE32ibbuD6SnUrBWOsPdU28QvAU8oSk
         k6Vl9jsGPb0HyNQkXW+64wTNNv2Gcl+elutvuJeTxyzVNn/sqn24EqI/f7qIfqL8UK
         pEa1u1ZNrRYkcCKg8M76z4O5x5lhkFtx4yNyESrc=
Date:   Thu, 15 Oct 2020 20:13:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        dan.carpenter@oracle.com, gustavoars@kernel.org,
        ira.weiny@intel.com, jhubbard@nvidia.com, jrdr.linux@gmail.com,
        madhuparnabhowmik10@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 146/156] rapidio: fix error handling path
Message-ID: <20201016031315.8XH5AQe8g%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
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
