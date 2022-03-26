Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936FCC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiCZDbI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiCZDbH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ADC3AA62
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B71F760C58
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EEDC004DD;
        Sat, 26 Mar 2022 03:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648265371;
        bh=PStEooqFqEHBGqBAAaQYQkh1zNEys2QalFf2TBoEobs=;
        h=Date:To:From:Subject:From;
        b=H4Pqtp9EJfHJbJTDM9xfX7GBSjaptBtEjiN0gQgAPKwePsdqLLu4e2CBJyb2fKB8K
         wgvSncYt7MrYum4iIRWyWZm2X34X3bAH+giMo0hz+CQnKxpLNPUJ7wXjAFI2C4xkRh
         qVsOh5Yf16gv8IqBDjbWSzVDcy7oszmIeJE44HT4=
Date:   Fri, 25 Mar 2022 20:29:30 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        mporter@kernel.crashing.org, keescook@chromium.org,
        jhubbard@nvidia.com, h.j.bos@vu.nl, c.giuffrida@vu.nl,
        bjohannesmeyer@gmail.com, alex.bou9@gmail.com,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-remove-unnecessary-use-of-list-iterator.patch added to -mm tree
Message-Id: <20220326032931.07EEDC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: remove unnecessary use of list iterator
has been added to the -mm tree.  Its filename is
     rapidio-remove-unnecessary-use-of-list-iterator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rapidio-remove-unnecessary-use-of-list-iterator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rapidio-remove-unnecessary-use-of-list-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch
ocfs2-remove-usage-of-list-iterator-variable-after-the-loop-body.patch
rapidio-remove-unnecessary-use-of-list-iterator.patch

