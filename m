Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F3CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEFB221EB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881701;
	bh=r2QYkHBpLG82L5FTqg8boJTfrpvcz7nN4w6yfip/ztg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1QbyqrxpK0TtZ8Pz7lzvPh/vBzG//YSc0QIh3bz7ixbI8+k0ujdLle3y7KWTayJwl
	 MeZ1uTc1QWGopOF4ywcRV2X98xGPKXVH7Bf6xR2kjpfMUZ+77M2ZsScFCAuayUw3LH
	 LIIw+hGWTDHTMO2Nk1R2wK/POpIDowzpqDPBpVXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393311AbgJPUzB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE5112145D;
        Fri, 16 Oct 2020 20:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881700;
        bh=r2QYkHBpLG82L5FTqg8boJTfrpvcz7nN4w6yfip/ztg=;
        h=Date:From:To:Subject:From;
        b=iDdKZUUM5w/BSwLHNfWlC5eUVP+orK11H2blZ1ZJP+fqAVAIv9Q16rzp0t/bHTMRa
         xHazLirQPJhrmJtnl6NNMWo8HQ4w4U+Q7d2n2bog0kGSX/wJVlY6vyP5wPToDBUleC
         zA2Bv+2N9ELub3MWUCoyoT9mytBIs+4Z4QD7HtLM=
Date:   Fri, 16 Oct 2020 13:54:59 -0700
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, dan.carpenter@oracle.com,
        gustavoars@kernel.org, ira.weiny@intel.com, jhubbard@nvidia.com,
        jrdr.linux@gmail.com, madhuparnabhowmik10@gmail.com,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        willy@infradead.org
Subject:  [merged] rapidio-fix-error-handling-path.patch removed
 from -mm tree
Message-ID: <20201016205459.tYsWYWd8O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix error handling path
has been removed from the -mm tree.  Its filename was
     rapidio-fix-error-handling-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from jrdr.linux@gmail.com are


