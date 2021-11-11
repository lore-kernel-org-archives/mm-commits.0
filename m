Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105BCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76D161075
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhKKC4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97EA660F46;
        Thu, 11 Nov 2021 02:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599194;
        bh=8c5jm0RITQEt+ErittymOhkRr2JMrhoeNjSIrBJ6E0o=;
        h=Date:From:To:Subject:From;
        b=bBXMqqwM4YTJwKBl9ry6jNqAVtWmPlXlcVc4PfG4BO4ic4FvWn4n8rLC/SVGHapc+
         gNjI2i5v8oi0BYnAOY4c0quCTKhK8ls0O00tG+cHyWMiqbEnql1387LIuYu88u596p
         3ht2jCohGuTAfEyMhHEF34iDoY8Bnivk9EUnt/cg=
Date:   Wed, 10 Nov 2021 18:53:14 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged]
 coda-check-for-async-upcall-request-using-local-state.patch removed from
 -mm tree
Message-ID: <20211111025314.txTZ8x_90%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: check for async upcall request using local state
has been removed from the -mm tree.  Its filename was
     coda-check-for-async-upcall-request-using-local-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: check for async upcall request using local state

Originally flagged by Smatch because the code implicitly assumed outSize
is not NULL for non-async upcalls because of a flag that was (not) set in
req->uc_flags.

However req->uc_flags field is in shared state and although the current
code will not allow it to be changed before the async request check the
code is more robust when it tests against the local outSize variable.

Link: https://lkml.kernel.org/r/20210908140308.18491-3-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coda/upcall.c~coda-check-for-async-upcall-request-using-local-state
+++ a/fs/coda/upcall.c
@@ -744,7 +744,8 @@ static int coda_upcall(struct venus_comm
 	list_add_tail(&req->uc_chain, &vcp->vc_pending);
 	wake_up_interruptible(&vcp->vc_waitq);
 
-	if (req->uc_flags & CODA_REQ_ASYNC) {
+	/* We can return early on asynchronous requests */
+	if (outSize == NULL) {
 		mutex_unlock(&vcp->vc_mutex);
 		return 0;
 	}
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are


