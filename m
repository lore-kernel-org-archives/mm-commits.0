Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C5DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A6ED61164
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhIOD6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbhIOD61 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7C660FED;
        Wed, 15 Sep 2021 03:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678229;
        bh=Sl1C7wCT9WqfRcGUSVclqZac169/WNbjFZGBcjvjtSw=;
        h=Date:From:To:Subject:From;
        b=LF85PnVgJpQwJzb2Zu6rI5EPThxizusXdMrS1V9L0DdctNjJLPShZipDrvzO8zheM
         v+GNLBW1RiiHkn+LpZaQ61Y9eT4q9RiKPKBZJMWjdXje7YbQeYSLWrZk/Ks0cyAOqq
         04NCy9ynCj+QYFBPuPub1NfA/z4GtaZpV80RbD/c=
Date:   Tue, 14 Sep 2021 20:57:08 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  +
 coda-check-for-async-upcall-request-using-local-state.patch added to -mm
 tree
Message-ID: <20210915035708.fD04hBKay%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: check for async upcall request using local state
has been added to the -mm tree.  Its filename is
     coda-check-for-async-upcall-request-using-local-state.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-check-for-async-upcall-request-using-local-state.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-check-for-async-upcall-request-using-local-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

coda-avoid-null-pointer-dereference-from-a-bad-inode.patch
coda-check-for-async-upcall-request-using-local-state.patch
coda-avoid-flagging-null-inodes.patch
coda-avoid-hidden-code-duplication-in-rename.patch
coda-avoid-doing-bad-things-on-inode-type-changes-during-revalidation.patch
coda-bump-module-version-to-72.patch

