Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B39C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiLLCQs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiLLCOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90DB65C5
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FD760E77
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702A5C433F0;
        Mon, 12 Dec 2022 02:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811279;
        bh=xCQN30a5561hEglfxuAMSFNGNTbPEhxTqNLz4PrXkH0=;
        h=Date:To:From:Subject:From;
        b=fEQ3Ez1CR9nnSHY3Y4WUok/OzreeTk9/eGKHzA8g+A0sKMhNTqfJpVfiPZ9F31YZG
         psKAIQeKkVoutywvf3KxADSq5k6tu6dicOcBI84UpA3IuGqJsw2Bwkz42i2uY00qPK
         htf8veYYB9vavikO8Bif7tXh6tdYASmBMGY9FWU0=
Date:   Sun, 11 Dec 2022 18:14:38 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-remove-restrictions-for-fsdax-and-reflink.patch removed from -mm tree
Message-Id: <20221212021439.702A5C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: remove restrictions for fsdax and reflink
has been removed from the -mm tree.  Its filename was
     xfs-remove-restrictions-for-fsdax-and-reflink.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: xfs: remove restrictions for fsdax and reflink
Date: Thu, 1 Dec 2022 15:32:53 +0000

Since the basic function for fsdax and reflink has been implemented,
remove the restrictions of them for widly test.

Link: https://lkml.kernel.org/r/1669908773-207-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_ioctl.c |    4 ----
 fs/xfs/xfs_iops.c  |    4 ----
 2 files changed, 8 deletions(-)

--- a/fs/xfs/xfs_ioctl.c~xfs-remove-restrictions-for-fsdax-and-reflink
+++ a/fs/xfs/xfs_ioctl.c
@@ -1138,10 +1138,6 @@ xfs_ioctl_setattr_xflags(
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
 		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 
-	/* Don't allow us to set DAX mode for a reflinked file for now. */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
-		return -EINVAL;
-
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 	if (i_flags2 && !xfs_has_v3inodes(mp))
--- a/fs/xfs/xfs_iops.c~xfs-remove-restrictions-for-fsdax-and-reflink
+++ a/fs/xfs/xfs_iops.c
@@ -1185,10 +1185,6 @@ xfs_inode_supports_dax(
 	if (!S_ISREG(VFS_I(ip)->i_mode))
 		return false;
 
-	/* Only supported on non-reflinked files. */
-	if (xfs_is_reflink_inode(ip))
-		return false;
-
 	/* Block size must match page size */
 	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
 		return false;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


