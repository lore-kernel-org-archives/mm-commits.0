Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CF3C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 01:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 364C761027
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 01:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhDLB6T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235543AbhDLB6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 21:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4218D61027;
        Mon, 12 Apr 2021 01:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618192682;
        bh=cylVJBPNGeAeKk7QHTu34+XLKGtykYQ7MXO4ZxTmOGs=;
        h=Date:From:To:Subject:From;
        b=CmcnxIheMCGQMGbukUSf9e8nWBJEu0vfqEgzKm9FJkWe0jqBbIO6n5ZXUP+mk1hoG
         uI6eibLe72RmMq51s1d9x2hCBK7fzao/ULr2dBHi9bXQj7RjUvfq9HeWVoHVnFxJso
         n2KddEHbyTQ68E8EL9kvtpCFEj0ZrhJdpo9yXJvY=
Date:   Sun, 11 Apr 2021 18:58:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, axboe@kernel.dk,
        akpm@linux-foundation.org
Subject:  [obsolete] beats-the-shit-out-of-me.patch removed from -mm
 tree
Message-ID: <20210412015801.A8623%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: beats-the-shit-out-of-me
has been removed from the -mm tree.  Its filename was
     beats-the-shit-out-of-me.patch

This patch was dropped because it is obsolete

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
kernel-forkc-export-kernel_thread-to-modules.patch

