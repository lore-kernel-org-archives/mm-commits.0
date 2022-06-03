Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81260C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347107AbiFCST0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346996AbiFCSRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E2D663DB
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 858E6B82369
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1674DC385A9;
        Fri,  3 Jun 2022 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654279470;
        bh=kfq0JSDRsDGFpmDl2Nm1INvdM+IlX1ut4sXRlh8RjD0=;
        h=Date:To:From:Subject:From;
        b=D4kohHfCIQKP5TYGrGBJn2A+7IDtL65Bzl1DzfyNxpwMGxHYhOLwg3bddI/UAFSKJ
         yKsPA9IMi+90S5z8h6Avk+PWBGSabWriRBWB9ygb2SYsc4+FyHTSwqqqEuqIjBEsax
         +s9BhUapMSvg15X/hbQPOoMEfGe0QKCZ0eKWiMiQ=
Date:   Fri, 03 Jun 2022 11:04:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-add-dax-dedupe-support.patch added to mm-unstable branch
Message-Id: <20220603180430.1674DC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: add dax dedupe support
has been added to the -mm mm-unstable branch.  Its filename is
     xfs-add-dax-dedupe-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-add-dax-dedupe-support.patch

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
Subject: xfs: add dax dedupe support
Date: Fri, 3 Jun 2022 13:37:38 +0800

Introduce xfs_mmaplock_two_inodes_and_break_dax_layout() for dax files who
are going to be deduped.  After that, call compare range function only
when files are both DAX or not.

Link: https://lkml.kernel.org/r/20220603053738.1218681-15-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c    |    2 -
 fs/xfs/xfs_inode.c   |   69 ++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h   |    1 
 fs/xfs/xfs_reflink.c |    4 +-
 4 files changed, 69 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_file.c~xfs-add-dax-dedupe-support
+++ a/fs/xfs/xfs_file.c
@@ -808,7 +808,7 @@ xfs_wait_dax_page(
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 }
 
-static int
+int
 xfs_break_dax_layouts(
 	struct inode		*inode,
 	bool			*retry)
--- a/fs/xfs/xfs_inode.c~xfs-add-dax-dedupe-support
+++ a/fs/xfs/xfs_inode.c
@@ -3767,6 +3767,50 @@ retry:
 	return 0;
 }
 
+static int
+xfs_mmaplock_two_inodes_and_break_dax_layout(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	int			error;
+	bool			retry;
+	struct page		*page;
+
+	if (ip1->i_ino > ip2->i_ino)
+		swap(ip1, ip2);
+
+again:
+	retry = false;
+	/* Lock the first inode */
+	xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
+	error = xfs_break_dax_layouts(VFS_I(ip1), &retry);
+	if (error || retry) {
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+		if (error == 0 && retry)
+			goto again;
+		return error;
+	}
+
+	if (ip1 == ip2)
+		return 0;
+
+	/* Nested lock the second inode */
+	xfs_ilock(ip2, xfs_lock_inumorder(XFS_MMAPLOCK_EXCL, 1));
+	/*
+	 * We cannot use xfs_break_dax_layouts() directly here because it may
+	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
+	 * for this nested lock case.
+	 */
+	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
+	if (page && page_ref_count(page) != 1) {
+		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+		goto again;
+	}
+
+	return 0;
+}
+
 /*
  * Lock two inodes so that userspace cannot initiate I/O via file syscalls or
  * mmap activity.
@@ -3781,8 +3825,19 @@ xfs_ilock2_io_mmap(
 	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
 	if (ret)
 		return ret;
-	filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
-				    VFS_I(ip2)->i_mapping);
+
+	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
+		ret = xfs_mmaplock_two_inodes_and_break_dax_layout(ip1, ip2);
+		if (ret) {
+			inode_unlock(VFS_I(ip2));
+			if (ip1 != ip2)
+				inode_unlock(VFS_I(ip1));
+			return ret;
+		}
+	} else
+		filemap_invalidate_lock_two(VFS_I(ip1)->i_mapping,
+					    VFS_I(ip2)->i_mapping);
+
 	return 0;
 }
 
@@ -3792,8 +3847,14 @@ xfs_iunlock2_io_mmap(
 	struct xfs_inode	*ip1,
 	struct xfs_inode	*ip2)
 {
-	filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
-				      VFS_I(ip2)->i_mapping);
+	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
+		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+		if (ip1 != ip2)
+			xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+	} else
+		filemap_invalidate_unlock_two(VFS_I(ip1)->i_mapping,
+					      VFS_I(ip2)->i_mapping);
+
 	inode_unlock(VFS_I(ip2));
 	if (ip1 != ip2)
 		inode_unlock(VFS_I(ip1));
--- a/fs/xfs/xfs_inode.h~xfs-add-dax-dedupe-support
+++ a/fs/xfs/xfs_inode.h
@@ -467,6 +467,7 @@ xfs_itruncate_extents(
 }
 
 /* from xfs_file.c */
+int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
--- a/fs/xfs/xfs_reflink.c~xfs-add-dax-dedupe-support
+++ a/fs/xfs/xfs_reflink.c
@@ -1363,8 +1363,8 @@ xfs_reflink_remap_prep(
 	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
-	/* Don't share DAX file data for now. */
-	if (IS_DAX(inode_in) || IS_DAX(inode_out))
+	/* Don't share DAX file data with non-DAX file. */
+	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
 	if (!IS_DAX(inode_in))
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

dax-introduce-holder-for-dax_device.patch
mm-factor-helpers-for-memory_failure_dev_pagemap.patch
pagemappmem-introduce-memory_failure.patch
fsdax-introduce-dax_lock_mapping_entry.patch
mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch
xfs-implement-notify_failure-for-xfs.patch
fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch
fsdax-introduce-dax_iomap_cow_copy.patch
fsdax-replace-mmap-entry-in-case-of-cow.patch
fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch
fsdax-dedup-file-range-to-use-a-compare-function.patch
xfs-support-cow-in-fsdax-mode.patch
xfs-add-dax-dedupe-support.patch

