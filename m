Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02844C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiLLCQj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiLLCOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D309DEFC
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E8760EC3
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E0BC433D2;
        Mon, 12 Dec 2022 02:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811277;
        bh=0hNKonGqset/LvL4/s6xFuyXXGRlEgYw/js25COw6xs=;
        h=Date:To:From:Subject:From;
        b=ANeqeOmMFdDacvpJTG55oziScYVkOxAP6cp52VSZmrfqC14A4hE6SebEuZJJu7Zfc
         xaoTiejASdFeXKepfqSVdudhmUmqGhPuyVXbyIYI2ZJ7XWQh6iclBbIFbR1+7lcDAw
         fpkPqQAlHzyG+YbTRGfl3/zdqnDTsS0ErbzrXCNA=
Date:   Sun, 11 Dec 2022 18:14:36 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch removed from -mm tree
Message-Id: <20221212021437.15E0BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: use dax ops for zero and truncate in fsdax mode
has been removed from the -mm tree.  Its filename was
     xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: xfs: use dax ops for zero and truncate in fsdax mode
Date: Thu, 1 Dec 2022 15:32:10 +0000

Zero and truncate on a dax file may execute CoW.  So use dax ops which
contains end work for CoW.

Link: https://lkml.kernel.org/r/1669908730-131-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_iomap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_iomap.c~xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode
+++ a/fs/xfs/xfs_iomap.c
@@ -1370,7 +1370,7 @@ xfs_zero_range(
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
-				      &xfs_direct_write_iomap_ops);
+				      &xfs_dax_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
 				&xfs_buffered_write_iomap_ops);
 }
@@ -1385,7 +1385,7 @@ xfs_truncate_page(
 
 	if (IS_DAX(inode))
 		return dax_truncate_page(inode, pos, did_zero,
-					&xfs_direct_write_iomap_ops);
+					&xfs_dax_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
 				   &xfs_buffered_write_iomap_ops);
 }
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


