Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DCCC433E0
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57A464E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhCCNVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhCBXwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:52:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAE7364F42;
        Tue,  2 Mar 2021 23:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728631;
        bh=1SlVK/NGorLIyVj22Rv0nDKN6NVCS1CaPiM+PAB534I=;
        h=Date:From:To:Subject:From;
        b=jXxI3VGFv8cDFv4u+5HZXXi09dQngQfSN1/ifulIPtSzkLHZQgw6nOPYnG2wAjdS6
         inmtBkSKa587q//dK45tH+FJCacsLTLW0ETNyhGUMTozbQlgSb9rZo/FOUCrk9qkzS
         5wE1tWweUrkSyxzH2lEGECKSZZjDO+IQ8l4PderM=
Date:   Tue, 02 Mar 2021 15:43:50 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, jack@suse.cz, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch added to -mm
 tree
Message-ID: <20210302234350.n3j8cd8pj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use filemap_range_needs_writeback() for O_DIRECT reads
has been added to the -mm tree.  Its filename is
     mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch

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
@@ -2614,8 +2614,8 @@ generic_file_read_iter(struct kiocb *ioc
 
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

swap-fix-swapfile-read-write-offset.patch
mm-provide-filemap_range_needs_writeback-helper.patch
mm-use-filemap_range_needs_writeback-for-o_direct-reads.patch
iomap-use-filemap_range_needs_writeback-for-o_direct-reads.patch

