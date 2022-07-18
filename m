Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6B8CCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbiGRARo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiGRARH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0AB1277C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ABB4B80EEC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9D5C3411E;
        Mon, 18 Jul 2022 00:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103415;
        bh=90plcCaCBDqQz6qT2QpMSin2ro736mRhCYF3l3r9jks=;
        h=Date:To:From:Subject:From;
        b=us3QElWX724v620NMCSLteZ92ynUa+rFeCEm99ZS0nuoJ0vOC6I/81FuubUPRBL2m
         838ZXAxdFV8paRiASUIQ+Q841Oj3o7dB6conibOx8YmLIAg0PzYlxAERAf2/1a6Q9Z
         m7VU+CMYyNM6a72rauEgz5z7Ip3m8/+vMEXd7uys=
Date:   Sun, 17 Jul 2022 17:16:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-support-cow-in-fsdax-mode.patch removed from -mm tree
Message-Id: <20220718001655.CD9D5C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: support CoW in fsdax mode
has been removed from the -mm tree.  Its filename was
     xfs-support-cow-in-fsdax-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: xfs: support CoW in fsdax mode
Date: Fri, 3 Jun 2022 13:37:37 +0800

In fsdax mode, WRITE and ZERO on a shared extent need CoW performed. 
After that, new allocated extents needs to be remapped to the file.  So,
add a CoW identification in ->iomap_begin(), and implement ->iomap_end()
to do the remapping work.

[akpm@linux-foundation.org: make xfs_dax_fault() static]
Link: https://lkml.kernel.org/r/20220603053738.1218681-14-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
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

 fs/xfs/xfs_file.c  |   33 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iomap.c |   30 +++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.h |    1 +
 3 files changed, 58 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_file.c~xfs-support-cow-in-fsdax-mode
+++ a/fs/xfs/xfs_file.c
@@ -25,6 +25,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 
+#include <linux/dax.h>
 #include <linux/falloc.h>
 #include <linux/backing-dev.h>
 #include <linux/mman.h>
@@ -669,7 +670,7 @@ xfs_file_dax_write(
 	pos = iocb->ki_pos;
 
 	trace_xfs_file_dax_write(iocb, from);
-	ret = dax_iomap_rw(iocb, from, &xfs_direct_write_iomap_ops);
+	ret = dax_iomap_rw(iocb, from, &xfs_dax_write_iomap_ops);
 	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
 		i_size_write(inode, iocb->ki_pos);
 		error = xfs_setfilesize(ip, pos, ret);
@@ -1254,6 +1255,31 @@ xfs_file_llseek(
 	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 }
 
+#ifdef CONFIG_FS_DAX
+static int
+xfs_dax_fault(
+	struct vm_fault		*vmf,
+	enum page_entry_size	pe_size,
+	bool			write_fault,
+	pfn_t			*pfn)
+{
+	return dax_iomap_fault(vmf, pe_size, pfn, NULL,
+			(write_fault && !vmf->cow_page) ?
+				&xfs_dax_write_iomap_ops :
+				&xfs_read_iomap_ops);
+}
+#else
+static int
+xfs_dax_fault(
+	struct vm_fault		*vmf,
+	enum page_entry_size	pe_size,
+	bool			write_fault,
+	pfn_t			*pfn)
+{
+	return 0;
+}
+#endif
+
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
  * ordering of:
@@ -1285,10 +1311,7 @@ __xfs_filemap_fault(
 		pfn_t pfn;
 
 		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL,
-				(write_fault && !vmf->cow_page) ?
-				 &xfs_direct_write_iomap_ops :
-				 &xfs_read_iomap_ops);
+		ret = xfs_dax_fault(vmf, pe_size, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
--- a/fs/xfs/xfs_iomap.c~xfs-support-cow-in-fsdax-mode
+++ a/fs/xfs/xfs_iomap.c
@@ -773,7 +773,8 @@ xfs_direct_write_iomap_begin(
 
 		/* may drop and re-acquire the ilock */
 		error = xfs_reflink_allocate_cow(ip, &imap, &cmap, &shared,
-				&lockmode, flags & IOMAP_DIRECT);
+				&lockmode,
+				(flags & IOMAP_DIRECT) || IS_DAX(inode));
 		if (error)
 			goto out_unlock;
 		if (shared)
@@ -868,6 +869,33 @@ const struct iomap_ops xfs_direct_write_
 };
 
 static int
+xfs_dax_write_iomap_end(
+	struct inode		*inode,
+	loff_t			pos,
+	loff_t			length,
+	ssize_t			written,
+	unsigned		flags,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	if (!xfs_is_cow_inode(ip))
+		return 0;
+
+	if (!written) {
+		xfs_reflink_cancel_cow_range(ip, pos, length, true);
+		return 0;
+	}
+
+	return xfs_reflink_end_cow(ip, pos, written);
+}
+
+const struct iomap_ops xfs_dax_write_iomap_ops = {
+	.iomap_begin	= xfs_direct_write_iomap_begin,
+	.iomap_end	= xfs_dax_write_iomap_end,
+};
+
+static int
 xfs_buffered_write_iomap_begin(
 	struct inode		*inode,
 	loff_t			offset,
--- a/fs/xfs/xfs_iomap.h~xfs-support-cow-in-fsdax-mode
+++ a/fs/xfs/xfs_iomap.h
@@ -51,5 +51,6 @@ extern const struct iomap_ops xfs_direct
 extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
+extern const struct iomap_ops xfs_dax_write_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


