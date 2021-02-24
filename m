Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F886C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D3E264F27
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhBXUDR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhBXUC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4132D64E7A;
        Wed, 24 Feb 2021 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196906;
        bh=G/hO3Rnc1ew2BsKhMRd+zRTTHSdeEe5zj0NmD4Ixw64=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EQYjTzH+iKQGk53pf7Zsh36awevfIq5t1FcXGf6MmQMD0ybpgBHfLFwtRl2LU4Tv0
         cad4VzJnxt+ALywiAqXycpdT92itcCh7z0nBpuTS4kcXYsPNKCTfoCyPcwM/8NJ1+Z
         sa2p3yiTIIaoOF9G16lRd3JYtCwvfiesDWdGSdUU=
Date:   Wed, 24 Feb 2021 12:01:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk,
        hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 029/173] mm/filemap: don't revert iter on
 -EIOCBQUEUED
Message-ID: <20210224200145.tzDYWtTYF%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
