Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5480C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjDFW37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbjDFW3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073FCB764
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63ED6645B9
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0410C433D2;
        Thu,  6 Apr 2023 22:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680820191;
        bh=e6wdD1vlQS++UsSGr9H8CtQq81lbHr5V5vB8VpUeT/Q=;
        h=Date:To:From:Subject:From;
        b=jMAXtKU2+B44/JgU+QXQnSAJEezHhG8/QaLpbwLseU7XV3dgxMB2PmVaZI62t58rw
         ldCU2X/994V1sjCIAdEuxp0W2g5QOkNGhFsp8KQUiwIeOSxmGgpP7QDP0nn4JrczpM
         dmrqPZWu0H9bgxsvpabatIPTQRy6KaViW3+k5KhE=
Date:   Thu, 06 Apr 2023 15:29:51 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-remove-redundant-initialization-of-new_order.patch added to mm-unstable branch
Message-Id: <20230406222951.B0410C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: truncate: remove redundant initialization of new_order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-remove-redundant-initialization-of-new_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-remove-redundant-initialization-of-new_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm: truncate: remove redundant initialization of new_order
Date: Thu, 6 Apr 2023 10:58:17 +0100

Variable new_order is being initialized with a value that is not read, the
variable is being re-assigned later.  Remove the initialization.

Link: https://lkml.kernel.org/r/20230406095817.703426-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/truncate.c~mm-truncate-remove-redundant-initialization-of-new_order
+++ a/mm/truncate.c
@@ -213,7 +213,7 @@ bool truncate_inode_partial_folio(struct
 {
 	loff_t pos = folio_pos(folio);
 	unsigned int offset, length, remaining;
-	unsigned int new_order = folio_order(folio);
+	unsigned int new_order;
 
 	if (pos < start)
 		offset = start - pos;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-truncate-remove-redundant-initialization-of-new_order.patch

