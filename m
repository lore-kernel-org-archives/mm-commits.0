Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C3CC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BF1864E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhBYTX0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234664AbhBYTUF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 988DC64F5A;
        Thu, 25 Feb 2021 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280406;
        bh=kJVs6M3IvEEDTYW15gRDOSWOZky/CjxmHoDalB6JOE0=;
        h=Date:From:To:Subject:From;
        b=jtwEy6vpMf2xzhYIi6ohLHFTnbJ0wA8nD7C6Ji9+qce3bosLShSR6TJOzK/yIjF4t
         KmwDs/k96oRHoV7SJZzLCCP9ocTAXDNT21r+gmrZdRRAKs3zZFbdYexDA4xk4IGGp6
         S6XlrxL5jt5iWgKWRTsTK0WnBTaNxa/vFBa65vZI=
Date:   Thu, 25 Feb 2021 11:13:26 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-filemap-simplify-generic_file_read_iter.patch
 removed from -mm tree
Message-ID: <20210225191326.FBBzXTJXr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: simplify generic_file_read_iter
has been removed from the -mm tree.  Its filename was
     mm-filemap-simplify-generic_file_read_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/filemap: simplify generic_file_read_iter

Avoid the pointless goto out just for returning retval.

Link: https://lkml.kernel.org/r/20210122160140.223228-19-willy@infradead.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-simplify-generic_file_read_iter
+++ a/mm/filemap.c
@@ -2543,7 +2543,7 @@ generic_file_read_iter(struct kiocb *ioc
 	ssize_t retval = 0;
 
 	if (!count)
-		goto out; /* skip atime */
+		return 0; /* skip atime */
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct file *file = iocb->ki_filp;
@@ -2561,7 +2561,7 @@ generic_file_read_iter(struct kiocb *ioc
 						iocb->ki_pos,
 					        iocb->ki_pos + count - 1);
 			if (retval < 0)
-				goto out;
+				return retval;
 		}
 
 		file_accessed(file);
@@ -2585,12 +2585,10 @@ generic_file_read_iter(struct kiocb *ioc
 		 */
 		if (retval < 0 || !count || iocb->ki_pos >= size ||
 		    IS_DAX(inode))
-			goto out;
+			return retval;
 	}
 
-	retval = filemap_read(iocb, iter, retval);
-out:
-	return retval;
+	return filemap_read(iocb, iter, retval);
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
_

Patches currently in -mm which might be from hch@lst.de are


