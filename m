Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09591C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E348861466
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3F4K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhD3F4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D7461466;
        Fri, 30 Apr 2021 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762121;
        bh=ZJzsqEPxdBwxeD2jUY1X6y10A3iwrzdYXJcRtkgJY9M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R8/xsWCvE3L5tcV4CcPm4Ysic6FiDaNpPvQlLM7VfAIg1IRqGuLDohlafU7i8r4Hv
         +lWwTFSf0pwmlEKzff4Im78MLz8roCVyDEH1/b9XhPAHxD4BCY+c/w5O5GWXqkvA2Y
         eQqKSk8vV5pftGT9WYqEwyw434bbbEmLD7XZuj2A=
Date:   Thu, 29 Apr 2021 22:55:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 042/178] mm: use filemap_range_needs_writeback()
 for O_DIRECT reads
Message-ID: <20210430055521.9-3zLBs9H%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Subject: mm: use filemap_range_needs_writeback() for O_DIRECT reads

For the generic page cache read helper, use the better variant of checking
for the need to call filemap_write_and_wait_range() when doing O_DIRECT
reads.  This avoids falling back to the slow path for IOCB_NOWAIT, if
there are no pages to wait for (or write out).

Link: https://lkml.kernel.org/r/20210224164455.1096727-3-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-use-filemap_range_needs_writeback-for-o_direct-reads
+++ a/mm/filemap.c
@@ -2681,8 +2681,8 @@ generic_file_read_iter(struct kiocb *ioc
 
 		size = i_size_read(inode);
 		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (filemap_range_has_page(mapping, iocb->ki_pos,
-						   iocb->ki_pos + count - 1))
+			if (filemap_range_needs_writeback(mapping, iocb->ki_pos,
+						iocb->ki_pos + count - 1))
 				return -EAGAIN;
 		} else {
 			retval = filemap_write_and_wait_range(mapping,
_
