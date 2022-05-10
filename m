Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6186C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiEJEZA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiEJEXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A988A2DAB4
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8956B61758
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC958C385C5;
        Tue, 10 May 2022 04:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156276;
        bh=h7ds5Wn3/55em76WawB7HbDPIrUQ1ttI9UYe0cv4Two=;
        h=Date:To:From:Subject:From;
        b=ZVlrCxIPLspdt2iyHM18G41Y49D1Sdp4imeRpvda76qbDfGADYPMEIEz7lFZXfrWq
         wILG+thIc+gUdysbCBCnyuSsEFmAZ01h0VyUcrrA3XRYvmxRkWvE9WqjvSWsr+q3eA
         PrUaECB6p6SRB7Ygbw3wbx8eB7azzxNkddB+rIkw=
Date:   Mon, 09 May 2022 21:17:55 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        mporter@kernel.crashing.org, keescook@chromium.org,
        jhubbard@nvidia.com, h.j.bos@vu.nl, c.giuffrida@vu.nl,
        bjohannesmeyer@gmail.com, alex.bou9@gmail.com,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-remove-unnecessary-use-of-list-iterator.patch removed from -mm tree
Message-Id: <20220510041755.DC958C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rapidio: remove unnecessary use of list iterator
has been removed from the -mm tree.  Its filename was
     rapidio-remove-unnecessary-use-of-list-iterator.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Koschel <jakobkoschel@gmail.com>
Subject: rapidio: remove unnecessary use of list iterator

req->map is set in the valid case and always equals 'map' if the break was
hit.  It therefore is unnecessary to use the list iterator variable and
the use of 'map' can be replaced with req->map.

This is done in preparation to limit the scope of a list iterator to the
list traversal loop [1].

Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
Link: https://lkml.kernel.org/r/20220319203344.2547702-1-jakobkoschel@gmail.com
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-remove-unnecessary-use-of-list-iterator
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -915,7 +915,7 @@ rio_dma_transfer(struct file *filp, u32
 			goto err_req;
 		}
 
-		if (xfer->length + xfer->offset > map->size) {
+		if (xfer->length + xfer->offset > req->map->size) {
 			ret = -EINVAL;
 			goto err_req;
 		}
@@ -927,7 +927,7 @@ rio_dma_transfer(struct file *filp, u32
 		}
 
 		sg_set_buf(req->sgt.sgl,
-			   map->virt_addr + (baddr - map->phys_addr) +
+			   req->map->virt_addr + (baddr - req->map->phys_addr) +
 				xfer->offset, xfer->length);
 	}
 
_

Patches currently in -mm which might be from jakobkoschel@gmail.com are


