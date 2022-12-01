Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4758AC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiLAWIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiLAWIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:08:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D2528E0D
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E1DEB82038
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D45C433C1;
        Thu,  1 Dec 2022 22:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669932486;
        bh=Fi/QpkvFCVKIzYCoA5gCxuSWBk+RyVYKrtLIK/3MJKY=;
        h=Date:To:From:Subject:From;
        b=GTLwcmJ9ABTxdTD15tx889o7YwoM8edtqFNlgM3pUPV8MnJulwL/0DHXA/THocgP6
         eExyjFjSJBjjSM+HYkH+8pRjrUs3/cIXrF7ej1yNBkLO1YptQRMgxRIjP85sRaF1lu
         j0I6JZKuRh7BNGRBcCzpH4ZMCJ4hOD+31Yj/7dKU=
Date:   Thu, 01 Dec 2022 14:08:06 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-dedupe-iter-two-files-at-the-same-time.patch added to mm-unstable branch
Message-Id: <20221201220806.C0D45C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: dedupe: iter two files at the same time
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-dedupe-iter-two-files-at-the-same-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-dedupe-iter-two-files-at-the-same-time.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-dedupe-iter-two-files-at-the-same-time
+++ a/fs/dax.c
@@ -1964,15 +1964,15 @@ int dax_dedupe_file_range_compare(struct
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

fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

