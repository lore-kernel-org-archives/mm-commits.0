Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6723EC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 00:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367BD61003
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 00:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhDLAMY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235229AbhDLAMX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 20:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FFFF61003;
        Mon, 12 Apr 2021 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618186325;
        bh=BUQmhRTIRT9qLnVfHGVuXFAXJXP+voRsAWfXbV8CINA=;
        h=Date:From:To:Subject:From;
        b=hUGmtfjTx/85he9MrmfGFBoQRiZl02ieBl9hBN8f6nFMo9e5HUpMoUc3bnhJtKySE
         5Fw7imJEosp9E9Lzlx4/is8A+V+eLXH3qE2Pq0t50D3+j0/MlLRVXJTRavERmkj4A2
         aw/Bi/kPXPI7xKGkVKfrSlQ+7fnNcJWF6PRFo67g=
Date:   Sun, 11 Apr 2021 17:12:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk,
        mm-commits@vger.kernel.org
Subject:  [obsolete] fs-io_uringc-fix-build.patch removed from -mm
 tree
Message-ID: <20210412001205.fIK5-ee6v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/io_uring.c: fix build
has been removed from the -mm tree.  Its filename was
     fs-io_uringc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/io_uring.c: fix build

hoping this is correct...

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c~fs-io_uringc-fix-build
+++ a/fs/io_uring.c
@@ -2762,7 +2762,7 @@ static void kiocb_done(struct kiocb *kio
 
 	if (check_reissue && req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
-		if (!io_rw_reissue(req)) {
+		if (!io_rw_should_reissue(req)) {
 			int cflags = 0;
 
 			req_set_fail_links(req);
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
kernel-forkc-export-kernel_thread-to-modules.patch

