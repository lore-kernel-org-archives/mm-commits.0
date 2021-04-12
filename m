Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D037EC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 02:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E43460FD8
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 02:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhDLCSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 22:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235768AbhDLCSF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 22:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F9860FD8;
        Mon, 12 Apr 2021 02:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618193868;
        bh=HY+2jcE3wNl0rxRiDpPDMEp3Ex+Kjf1cp3lychiiaVY=;
        h=Date:From:To:Subject:From;
        b=UGkLAUYytkDPZ7hlRpxpEphsO41lTiX3GAzXLV2wtF7k0V+A09UpuegOeJWjmRFhM
         5/ZNSMd1dnlbdgKXSW2tHzsLr0Ia+1+eNXmXdjvLlY6c4cQrwaVzwtSpd4R5AVl/Eb
         UuBwmmWlKbP/mJIJjMzkSnL999qE6UunbH4On4d8=
Date:   Sun, 11 Apr 2021 19:17:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, axboe@kernel.dk
Subject:  + fs-io_uringc-fix-build.patch added to -mm tree
Message-ID: <20210412021748.X7M8F%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-io_uringc-fix-build
has been added to the -mm tree.  Its filename is
     fs-io_uringc-fix-build.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-io_uringc-fix-build.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-io_uringc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-io_uringc-fix-build.patch

