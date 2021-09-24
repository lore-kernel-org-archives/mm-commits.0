Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1B6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9464061090
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbhIXCwf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243955AbhIXCwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 22:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7A79610C9;
        Fri, 24 Sep 2021 02:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632451862;
        bh=FVAyD/jG7xLhj7K8yHOHPyMD1ERJ9rdpUvpCFaR+q4A=;
        h=Date:From:To:Subject:From;
        b=Cv3QWdK8s+CQKxSjZ/2l2fbF3cUXEEVkwkPN+KfsmKKwfHI9kPXtdo0iG55XjxLRd
         Pk5GNyIBnRh4FXiLBOC7MHrtgdlvUcYZ/lGMZbpbsp0XlbHkurdYwnlgqpegO0/aJK
         P+U4H6iYm4Ns+vOWIHAjhf84sVCAX+sMhuy/9oT8=
Date:   Thu, 23 Sep 2021 19:51:02 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, liwang@redhat.com, mm-commits@vger.kernel.org,
        namit@vmware.com, peterx@redhat.com, stable@vger.kernel.org
Subject:  +
 userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch added to
 -mm tree
Message-ID: <20210924025102.VpqO80l0_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: fix a race between writeprotect and exit_mmap()
has been added to the -mm tree.  Its filename is
     userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: fix a race between writeprotect and exit_mmap()

A race is possible when a process exits, its VMAs are removed by
exit_mmap() and at the same time userfaultfd_writeprotect() is called.

The race was detected by KASAN on a development kernel, but it appears to
be possible on vanilla kernels as well.

Use mmget_not_zero() to prevent the race as done in other userfaultfd
operations.

Link: https://lkml.kernel.org/r/20210921200247.25749-1-namit@vmware.com
Fixes: 63b2d4174c4ad ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Nadav Amit <namit@vmware.com>
Tested-by: Li  Wang <liwang@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap
+++ a/fs/userfaultfd.c
@@ -1827,9 +1827,15 @@ static int userfaultfd_writeprotect(stru
 	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
-	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, mode_wp,
-				  &ctx->mmap_changing);
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+					  uffdio_wp.range.len, mode_wp,
+					  &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-fix-a-race-between-writeprotect-and-exit_mmap.patch

