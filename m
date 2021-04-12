Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CCCC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 01:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BDAB6120A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhDLByC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235543AbhDLByC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 21:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1623461027;
        Mon, 12 Apr 2021 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618192425;
        bh=Sas//fy3bOvtsFl9JbiQ9lH4a4jdAHe45FNbn70tPwU=;
        h=Date:From:To:Subject:From;
        b=cA9OWg6PsbPBdjHZozQ0G5gebPj9rwvCBIJDykCHr5H1X9uHgK7hfmI8NeUeNKJS2
         45BEqK+ye6EJgPQbwgsHRkHZ0bQ2+KY5pDgRQa4NlKsVrPwaO1TEQw04XGN0DLL7F2
         LTK6zzjRfhEf5Am/e8U8/jSWDZbt+2OUcXoKqoAA=
Date:   Sun, 11 Apr 2021 18:53:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk,
        mm-commits@vger.kernel.org
Subject:  + beats-the-shit-out-of-me.patch added to -mm tree
Message-ID: <20210412015344.LHfLY8NqO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: beats-the-shit-out-of-me
has been added to the -mm tree.  Its filename is
     beats-the-shit-out-of-me.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/beats-the-shit-out-of-me.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/beats-the-shit-out-of-me.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: beats-the-shit-out-of-me

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c~beats-the-shit-out-of-me
+++ a/fs/io_uring.c
@@ -2760,6 +2760,7 @@ static void kiocb_done(struct kiocb *kio
 	else
 		io_rw_done(kiocb, ret);
 
+#if 0
 	if (check_reissue && req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (!io_rw_reissue(req)) {
@@ -2771,6 +2772,7 @@ static void kiocb_done(struct kiocb *kio
 			__io_req_complete(req, issue_flags, ret, cflags);
 		}
 	}
+#endif
 }
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
beats-the-shit-out-of-me.patch
kernel-forkc-export-kernel_thread-to-modules.patch

