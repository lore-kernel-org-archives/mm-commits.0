Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE015C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiEJATa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiEJAT3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:19:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A22262706
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C90C76149C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234C4C385C5;
        Tue, 10 May 2022 00:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652141733;
        bh=1eTyrZsS4kRsSp7N4Pz1dxMvTZeuHEIzBGh3f7I3NmY=;
        h=Date:To:From:Subject:From;
        b=VMtFwLTiZq8Ly1pnVcTOBjZ7s6iwgfD8Xi76bQZucKPpljs1OH5+mx9Xkd1bZrA8t
         oLRKdxCQB7ALoH26lpIjXgycfuGPXMPW2IO6GE4BT258sBqMF87PiPFiCdxufqQXEM
         34oU5YEhglwzYFQDBXE+mlf/w73AyvvcSSi/75kA=
Date:   Mon, 09 May 2022 17:15:32 -0700
To:     mm-commits@vger.kernel.org, kvalo@codeaurora.org, hch@lst.de,
        axboe@kernel.dk, colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + relay-remove-redundant-assignment-to-pointer-buf.patch added to mm-nonmm-unstable branch
Message-Id: <20220510001533.234C4C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: relay: remove redundant assignment to pointer buf
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     relay-remove-redundant-assignment-to-pointer-buf.patch

This patch should soon appear in the mm-nonmm-unstable branch at
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
Subject: relay: remove redundant assignment to pointer buf

Pointer buf is being assigned a value that is not being read, buf is being
re-assigned in the next starement.  The assignment is redundant and can be
removed.

Cleans up clang scan build warning:
kernel/relay.c:443:8: warning: Although the value stored to 'buf' is
used in the enclosing expression, the value is never actually read
from 'buf' [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220508212152.58753-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/relay.c~relay-remove-redundant-assignment-to-pointer-buf
+++ a/kernel/relay.c
@@ -440,7 +440,7 @@ int relay_prepare_cpu(unsigned int cpu)
 
 	mutex_lock(&relay_channels_mutex);
 	list_for_each_entry(chan, &relay_channels, list) {
-		if ((buf = *per_cpu_ptr(chan->buf, cpu)))
+		if (*per_cpu_ptr(chan->buf, cpu))
 			continue;
 		buf = relay_open_buf(chan, cpu);
 		if (!buf) {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

relay-remove-redundant-assignment-to-pointer-buf.patch

