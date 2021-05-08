Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9023CC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725DA6141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhEHWl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C436141D;
        Sat,  8 May 2021 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513626;
        bh=XjqQu+Yt3cvSjdQKUanZpTOSN5L9KZhgaeQ4/8gvZIY=;
        h=Date:From:To:Subject:From;
        b=YuFbUR7an4IJRQp5+d9Q3U3nucuhyrYLy9DC2VtH0x6FacgaIO37gKbHxDsVeNzze
         lFZylby0F7lS1z7liCg2AqPCEHOlvWz2U4kN6wwmDgTDVpbhZx2W56+dKPWW4PpD/y
         fsV1hkWnGhfXFHEBn4mWfkYt4fLf2/rxU50wiR2I=
Date:   Sat, 08 May 2021 15:40:26 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch removed from
 -mm tree
Message-ID: <20210508224026.ZqVVy2Rdp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use filemap_range_needs_writeback() for O_DIRECT reads
has been removed from the -mm tree.  Its filename was
     mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from axboe@kernel.dk are


