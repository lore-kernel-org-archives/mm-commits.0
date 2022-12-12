Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B86C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiLLCQw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiLLCOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB46DECA
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 098FACE0B8F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E2FC433EF;
        Mon, 12 Dec 2022 02:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811278;
        bh=Vz9Dgapt7ns7xzYr5KyQQttyLXw50ThQIF8jKxHPr4g=;
        h=Date:To:From:Subject:From;
        b=NojmD58hJog0hGFZgoAbDZiTlu5vesmXwbtVAJUHjaaWVgvBOzDCmU8jQPNXhLJBR
         E1A46ARN8rsMmJrnVXHz1ZkgKiokGcFmva3A4+AWJzrafD+NGz41s+R3pgBVk0PXv7
         dCb8hZ9txAEuEDiGJwK2WYf7AesrI9mJvAco2aBs=
Date:   Sun, 11 Dec 2022 18:14:37 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdaxxfs-port-unshare-to-fsdax.patch removed from -mm tree
Message-Id: <20221212021438.43E2FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax,xfs: port unshare to fsdax
has been removed from the -mm tree.  Its filename was
     fsdaxxfs-port-unshare-to-fsdax.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax,xfs: port unshare to fsdax
Date: Thu, 1 Dec 2022 15:32:33 +0000

Implement unshare in fsdax mode: copy data from srcmap to iomap.

Link: https://lkml.kernel.org/r/1669908753-169-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c             |   52 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.c |    8 ++++--
 include/linux/dax.h  |    2 +
 3 files changed, 60 insertions(+), 2 deletions(-)

--- a/fs/dax.c~fsdaxxfs-port-unshare-to-fsdax
+++ a/fs/dax.c
@@ -1245,6 +1245,58 @@ static vm_fault_t dax_pmd_load_hole(stru
 }
 #endif /* CONFIG_FS_DAX_PMD */
 
+static s64 dax_unshare_iter(struct iomap_iter *iter)
+{
+	struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	int id = 0;
+	s64 ret = 0;
+	void *daddr = NULL, *saddr = NULL;
+
+	/* don't bother with blocks that are not shared to start with */
+	if (!(iomap->flags & IOMAP_F_SHARED))
+		return length;
+	/* don't bother with holes or unwritten extents */
+	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+		return length;
+
+	id = dax_read_lock();
+	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = copy_mc_to_kernel(daddr, saddr, length);
+	if (ret)
+		ret = -EIO;
+
+out_unlock:
+	dax_read_unlock(id);
+	return ret;
+}
+
+int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
+		const struct iomap_ops *ops)
+{
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
+	};
+	int ret;
+
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = dax_unshare_iter(&iter);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_file_unshare);
+
 static int dax_memzero(struct iomap_iter *iter, loff_t pos, size_t size)
 {
 	const struct iomap *iomap = &iter->iomap;
--- a/fs/xfs/xfs_reflink.c~fsdaxxfs-port-unshare-to-fsdax
+++ a/fs/xfs/xfs_reflink.c
@@ -1693,8 +1693,12 @@ xfs_reflink_unshare(
 
 	inode_dio_wait(inode);
 
-	error = iomap_file_unshare(inode, offset, len,
-			&xfs_buffered_write_iomap_ops);
+	if (IS_DAX(inode))
+		error = dax_file_unshare(inode, offset, len,
+				&xfs_dax_write_iomap_ops);
+	else
+		error = iomap_file_unshare(inode, offset, len,
+				&xfs_buffered_write_iomap_ops);
 	if (error)
 		goto out;
 
--- a/include/linux/dax.h~fsdaxxfs-port-unshare-to-fsdax
+++ a/include/linux/dax.h
@@ -205,6 +205,8 @@ static inline void dax_unlock_mapping_en
 }
 #endif
 
+int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
+		const struct iomap_ops *ops);
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops);
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


