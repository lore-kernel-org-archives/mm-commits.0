Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1455C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30AE613B7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345776AbhDMRTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345762AbhDMRTp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51A0D611AD;
        Tue, 13 Apr 2021 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618334365;
        bh=gdzJQKc0Lrtilhmr0DIvdfqKKzCAATcx5tmYvfmwKEc=;
        h=Date:From:To:Subject:From;
        b=cIhCinDFb9l8rAcueIzBEa7Y8hJfDC0SAnZt8dXnKVhcv0oQ0IdQnwRMVCg/I5AHk
         EQWH8a8z2WOLSDstzb/Y8NmX+jsnTF1RXdS0ZUbI4WQwxVdj4a4NzS+E7TsaVdgavA
         cX6dRWf8gY781UAjZRm2Z/EVvlJjBck9fa6JUyIc=
Date:   Tue, 13 Apr 2021 10:19:24 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, mm-commits@vger.kernel.org
Subject:  [obsolete] fs-io_uringc-fix-build.patch removed from -mm
 tree
Message-ID: <20210413171924.PraR1DZP9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-io_uringc-fix-build
has been removed from the -mm tree.  Its filename was
     fs-io_uringc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: fs-io_uringc-fix-build

Here's the bit from the incremental:

Link: https://lkml.kernel.org/r/8bf7c0e9-5ba8-9f35-cefa-4c7b1055eaa0@kernel.dk

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/io_uring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c~fs-io_uringc-fix-build
+++ a/fs/io_uring.c
@@ -2762,7 +2762,11 @@ static void kiocb_done(struct kiocb *kio
 
 	if (check_reissue && req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
-		if (!io_rw_reissue(req)) {
+
+		if (io_resubmit_prep(req)) {
+			req_ref_get(req);
+			io_queue_async_work(req);
+		} else {
 			int cflags = 0;
 
 			req_set_fail_links(req);
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-provide-filemap_range_needs_writeback-helper.patch
mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

