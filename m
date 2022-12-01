Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BC6C3A5A7
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiLAWIg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLAWIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:08:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6522AE02
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 86D5ACE1DC8
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E46C433C1;
        Thu,  1 Dec 2022 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669932493;
        bh=lpO8uVNU20Qk1tAO1kPE4HZVHVm5Pufj+aRsx8dFl3A=;
        h=Date:To:From:Subject:From;
        b=gPOV2LmwiZ2OhcR87goOqR7/kCv68g4H7PAe/kLW5M7nSEGyrmWOw0nzGbadEVtaN
         2o63scGgFWP9C3qG+6qizQPAkkft32jxlXSObW84c08LQUeQd5QI4UaZL4bQBlOj0W
         voa5YdNIDwIiDcpI53bYQZ35JueCldWLJPW1dY68=
Date:   Thu, 01 Dec 2022 14:08:12 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-remove-restrictions-for-fsdax-and-reflink.patch added to mm-unstable branch
Message-Id: <20221201220813.90E46C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: remove restrictions for fsdax and reflink
has been added to the -mm mm-unstable branch.  Its filename is
     xfs-remove-restrictions-for-fsdax-and-reflink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-remove-restrictions-for-fsdax-and-reflink.patch

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
Subject: xfs: remove restrictions for fsdax and reflink
Date: Thu, 1 Dec 2022 15:32:53 +0000

Since the basic function for fsdax and reflink has been implemented,
remove the restrictions of them for widly test.

Link: https://lkml.kernel.org/r/1669908773-207-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Darrick J. Wong <djwong@kernel.org>
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

fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

