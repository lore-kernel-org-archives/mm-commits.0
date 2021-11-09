Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66705C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B44561288
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhKIChT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E813F611CC;
        Tue,  9 Nov 2021 02:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425274;
        bh=WwFR3rIm6XQ1aH7yHt0Nz4PdUE3HDn+BQ9cj2W3mm28=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WZFXDSooH0yKZfm4s79i0TUoTXyjCv1u9LQ/Pff+iJWmVORNk34LOItctTOMfwf24
         x44HeDBJlilErmyqEReSpYbvuZrR3riSV12be2cUyn16Lg88zFPHid0quZNYuQzWTn
         9emqYsKN6zZa6AuIq2joTvAUJ1Q60brC8m+OJbfE=
Date:   Mon, 08 Nov 2021 18:34:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        jaharkes@cs.cmu.edu, jing.yangyang@zte.com.cn, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tanxin.ctf@gmail.com,
        torvalds@linux-foundation.org, xiyuyang19@fudan.edu.cn,
        zealci@zte.com.cn
Subject:  [patch 58/87] coda: check for async upcall request using
 local state
Message-ID: <20211109023433.ihghnWvdN%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
