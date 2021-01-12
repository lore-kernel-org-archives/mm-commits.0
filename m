Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E10C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 05:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52CF6225AC
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 05:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbhALFCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 00:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbhALFCS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 00:02:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B885F225AB;
        Tue, 12 Jan 2021 05:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610427698;
        bh=jRPUHLXZX6OdHMRGXo7k9l1m1kc6VB0BMGOcopV8jV4=;
        h=Date:From:To:Subject:From;
        b=GtPhc0CQBUR8WGmJ0DuZ/9DgLuqm2N8BLy7lRKS+27ZIBu2Hcq0fuy/G7h+Qpuh3j
         afu3tasKzUzNvm6HpgN1dbuRPBGL8tBwyYokZrLmmpXFHdSwg4krOHzGOrqFkXixIH
         dD0c00WXpfMqxJBPY8mR36Jzpd0jT4du/5rBHUBc=
Date:   Mon, 11 Jan 2021 21:01:37 -0800
From:   akpm@linux-foundation.org
To:     asml.silence@gmail.com, axboe@kernel.dk, hch@lst.de,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + mm-filemap-dont-revert-iter-on-eiocbqueued.patch added
 to -mm tree
Message-ID: <20210112050137.Fbc-dsYz9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: don't revert iter on -EIOCBQUEUED
has been added to the -mm tree.  Its filename is
     mm-filemap-dont-revert-iter-on-eiocbqueued.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-dont-revert-iter-on-eiocbqueued.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-dont-revert-iter-on-eiocbqueued.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: mm/filemap: don't revert iter on -EIOCBQUEUED

Currently, if I/O is enqueued for async execution direct paths of
generic_file_{read,write}_iter() will always revert the iter.  There are
no users expecting that, and that is also costly.  Leave iterators as is
on -EIOCBQUEUED.

Link: https://lkml.kernel.org/r/f5247b60e7abbd2ff850cd108491f53a2e0c501a.1610207781.git.asml.silence@gmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-dont-revert-iter-on-eiocbqueued
+++ a/mm/filemap.c
@@ -2609,7 +2609,8 @@ generic_file_read_iter(struct kiocb *ioc
 			iocb->ki_pos += retval;
 			count -= retval;
 		}
-		iov_iter_revert(iter, count - iov_iter_count(iter));
+		if (retval != -EIOCBQUEUED)
+			iov_iter_revert(iter, count - iov_iter_count(iter));
 
 		/*
 		 * Btrfs can have a short DIO read if we encounter
@@ -3331,7 +3332,8 @@ generic_file_direct_write(struct kiocb *
 		}
 		iocb->ki_pos = pos;
 	}
-	iov_iter_revert(from, write_len - iov_iter_count(from));
+	if (written != -EIOCBQUEUED)
+		iov_iter_revert(from, write_len - iov_iter_count(from));
 out:
 	return written;
 }
_

Patches currently in -mm which might be from asml.silence@gmail.com are

mm-filemap-dont-revert-iter-on-eiocbqueued.patch

