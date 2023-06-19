Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A869EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 19:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjFST3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 15:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjFST3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 15:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E74106
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 12:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A45B860E0B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 19:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07D2C433C8;
        Mon, 19 Jun 2023 19:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687202981;
        bh=y26MVIl2mOzxfd4btBT3QwjDspzZvvkFktX/ym70Tmg=;
        h=Date:To:From:Subject:From;
        b=W4LSTODiGqHKRCVIkbkwsCUkty22BlkO2+IwKG16Hpyttzgur+9xphwBlChFzOjQM
         BLAGmxqAIMA6mu0dOlIVbsQFhiQxlr2EYpeoK4KtKZKgrqTG7ut1GcdXHdcGJ1yIwj
         xJP+NenSQ23RhVOAoRITEiRAAOffWwjffZ/B3E8U=
Date:   Mon, 19 Jun 2023 12:29:40 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        jhubbard@nvidia.com, jgg@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch added to mm-unstable branch
Message-Id: <20230619192940.F07D2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: do not return 0 from pin_user_pages_fast() for bad args
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: do not return 0 from pin_user_pages_fast() for bad args
Date: Mon, 19 Jun 2023 15:27:25 -0300

These routines are not intended to return zero, the callers cannot do
anything sane with a 0 return.  They should return an error which means
future calls to GUP will not succeed, or they should return some non-zero
number of pinned pages which means GUP should be called again.

If start + nr_pages overflows it should return -EOVERFLOW to signal the
arguments are invalid.

Syzkaller keeps tripping on this when fuzzing GUP arguments.

Link: https://lkml.kernel.org/r/0-v1-3d5ed1f20d50+104-gup_overflow_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: syzbot+353c7be4964c6253f24a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000094fdd05faa4d3a4@google.com
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args
+++ a/mm/gup.c
@@ -3080,7 +3080,7 @@ static int internal_get_user_pages_fast(
 	start = untagged_addr(start) & PAGE_MASK;
 	len = nr_pages << PAGE_SHIFT;
 	if (check_add_overflow(start, len, &end))
-		return 0;
+		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
 	if (unlikely(!access_ok((void __user *)start, len)))
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch

