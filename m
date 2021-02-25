Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162D7C4332B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A06FC64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhBYTUw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhBYTRf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D4864F35;
        Thu, 25 Feb 2021 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280352;
        bh=eT/N1/PcEWwoT10Nj2rLsfxL9c0CwkMchR3jEuk+kMY=;
        h=Date:From:To:Subject:From;
        b=VZhsMhAnYsht3PwfMvl9diRnohev1O99IUQXEAK7JWn2DSza7dZ077nkqghcF+h4W
         fQ1EpoQhqlfpxP3FhZZxXxwSfAW4KzvT+D/pUso/NY597VU+XfwZS7rh5naMi8V93E
         H39RBAowM1stS3IPNI9lq+btfinfr9g61fJacnRU=
Date:   Thu, 25 Feb 2021 11:12:32 -0800
From:   akpm@linux-foundation.org
To:     asml.silence@gmail.com, axboe@kernel.dk, hch@lst.de,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] mm-filemap-dont-revert-iter-on-eiocbqueued.patch
 removed from -mm tree
Message-ID: <20210225191232.kNMIwmpUM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: don't revert iter on -EIOCBQUEUED
has been removed from the -mm tree.  Its filename was
     mm-filemap-dont-revert-iter-on-eiocbqueued.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2615,7 +2615,8 @@ generic_file_read_iter(struct kiocb *ioc
 			iocb->ki_pos += retval;
 			count -= retval;
 		}
-		iov_iter_revert(iter, count - iov_iter_count(iter));
+		if (retval != -EIOCBQUEUED)
+			iov_iter_revert(iter, count - iov_iter_count(iter));
 
 		/*
 		 * Btrfs can have a short DIO read if we encounter
@@ -3426,7 +3427,8 @@ generic_file_direct_write(struct kiocb *
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


