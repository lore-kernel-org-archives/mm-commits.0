Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB63C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiLAWIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiLAWIP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:08:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA09E29C9A
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8253462135
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DD4C433C1;
        Thu,  1 Dec 2022 22:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669932490;
        bh=QQJdrZ/D1LQHgBr+tkrEiFPhf874Kmoc+pgnEekgTTY=;
        h=Date:To:From:Subject:From;
        b=uk8tpVoWmyM6n/0/u2LOADumMRdaWupSe83z+LhbPru6QBjM/SqR6UGtc/in+TcbZ
         w2n4QqEshhgFEHDNjTYPgV8r3YPNwAeXGtjgQ4eHhamqWRK5JwwmhP0zOPT4pQpruR
         yy+iphemieaX73VSJvwlXICVOfVcnhWwiNerBJ+M=
Date:   Thu, 01 Dec 2022 14:08:10 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdaxxfs-port-unshare-to-fsdax.patch added to mm-unstable branch
Message-Id: <20221201220810.D9DD4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax,xfs: port unshare to fsdax
has been added to the -mm mm-unstable branch.  Its filename is
     fsdaxxfs-port-unshare-to-fsdax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdaxxfs-port-unshare-to-fsdax.patch

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
@@ -1244,6 +1244,58 @@ static vm_fault_t dax_pmd_load_hole(stru
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

fsdax-introduce-page-share-for-fsdax-in-reflink-mode.patch
fsdax-invalidate-pages-when-cow.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch
fsdax-dedupe-iter-two-files-at-the-same-time.patch
xfs-use-dax-ops-for-zero-and-truncate-in-fsdax-mode.patch
fsdaxxfs-port-unshare-to-fsdax.patch
xfs-remove-restrictions-for-fsdax-and-reflink.patch

