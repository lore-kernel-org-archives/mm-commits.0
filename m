Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17572C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiLLCQj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiLLCOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC8DF5A
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B81DB80B6A
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC33C433EF;
        Mon, 12 Dec 2022 02:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811276;
        bh=1kj3oFUSPFRnF//CxFg+wQ/RkfYzH/dOdxRVfF/zN1Y=;
        h=Date:To:From:Subject:From;
        b=K5f2/UJf9QbC6ovJHtomaxpNj+LK7kSB02/wXBs99YV/LpTP1H37bE6cXEKONOA5v
         fRnbjBazj1H44uRKe6NwAnsa7YB/95OOZ99SFsXEHl2DeNTH5FJKqk4VJoOlOrw6eE
         3JXMx8DE7II3d7JAGF8ukwuUTG25z9XFrxfWKuC0=
Date:   Sun, 11 Dec 2022 18:14:35 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdax-dedupe-iter-two-files-at-the-same-time.patch removed from -mm tree
Message-Id: <20221212021435.DFC33C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: dedupe: iter two files at the same time
has been removed from the -mm tree.  Its filename was
     fsdax-dedupe-iter-two-files-at-the-same-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: dedupe: iter two files at the same time
Date: Thu, 1 Dec 2022 15:31:41 +0000

The iomap_iter() on a range of one file may loop more than once.  In this
case, the inner dst_iter can update its iomap but the outer src_iter
can't.  This may cause the wrong remapping in filesystem.  Let them called
at the same time.

Link: https://lkml.kernel.org/r/1669908701-93-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-dedupe-iter-two-files-at-the-same-time
+++ a/fs/dax.c
@@ -1965,15 +1965,15 @@ int dax_dedupe_file_range_compare(struct
 		.len		= len,
 		.flags		= IOMAP_DAX,
 	};
-	int ret;
+	int ret, compared = 0;
 
-	while ((ret = iomap_iter(&src_iter, ops)) > 0) {
-		while ((ret = iomap_iter(&dst_iter, ops)) > 0) {
-			dst_iter.processed = dax_range_compare_iter(&src_iter,
-						&dst_iter, len, same);
-		}
-		if (ret <= 0)
-			src_iter.processed = ret;
+	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
+	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
+		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
+						  same);
+		if (compared < 0)
+			return ret;
+		src_iter.processed = dst_iter.processed = compared;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


