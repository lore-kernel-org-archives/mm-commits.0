Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593CDC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346788AbiFCSTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbiFCSRA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78F666221
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40DF5B82373
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A8DC385A9;
        Fri,  3 Jun 2022 18:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654279464;
        bh=AVuU9Wfk0r/LBu/GsAPafpNUVlDuwRV7HTZrT7g+aaQ=;
        h=Date:To:From:Subject:From;
        b=Ye1DpIdzzG7vgFM3DHUsRWzXgl/tFcKcm1begWCEWesY2APFvDG6J6HDJQhTKU3Tq
         H3AlPmFVC/mj3KIXMpiWDEfd54uvzhIA0lrLJdYiaOLb4GKMZxxy7wtbYFHwNI+5V7
         yzrFqOCtRkiL//apNxh8PGjtSbTCUOzSa8V73xvw=
Date:   Fri, 03 Jun 2022 11:04:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-dedup-file-range-to-use-a-compare-function.patch added to mm-unstable branch
Message-Id: <20220603180424.02A8DC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: dedup file range to use a compare function
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-dedup-file-range-to-use-a-compare-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-dedup-file-range-to-use-a-compare-function.patch

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
Subject: fsdax: dedup file range to use a compare function
Date: Fri, 3 Jun 2022 13:37:36 +0800

With dax we cannot deal with readpage() etc.  So, we create a dax
comparison function which is similar with vfs_dedupe_file_range_compare().
And introduce dax_remap_file_range_prep() for filesystem use.

Link: https://lkml.kernel.org/r/20220603053738.1218681-13-ruansy.fnst@fujitsu.com
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c             |   82 +++++++++++++++++++++++++++++++++++++++++
 fs/remap_range.c     |   31 +++++++++++++--
 fs/xfs/xfs_reflink.c |    8 +++-
 include/linux/dax.h  |    8 ++++
 include/linux/fs.h   |   12 ++++--
 5 files changed, 130 insertions(+), 11 deletions(-)

--- a/fs/dax.c~fsdax-dedup-file-range-to-use-a-compare-function
+++ a/fs/dax.c
@@ -1873,3 +1873,85 @@ vm_fault_t dax_finish_sync_fault(struct
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
+		struct iomap_iter *it_dest, u64 len, bool *same)
+{
+	const struct iomap *smap = &it_src->iomap;
+	const struct iomap *dmap = &it_dest->iomap;
+	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
+	void *saddr, *daddr;
+	int id, ret;
+
+	len = min(len, min(smap->length, dmap->length));
+
+	if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE) {
+		*same = true;
+		return len;
+	}
+
+	if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
+		*same = false;
+		return 0;
+	}
+
+	id = dax_read_lock();
+	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
+				      &saddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
+				      &daddr, NULL);
+	if (ret < 0)
+		goto out_unlock;
+
+	*same = !memcmp(saddr, daddr, len);
+	if (!*same)
+		len = 0;
+	dax_read_unlock(id);
+	return len;
+
+out_unlock:
+	dax_read_unlock(id);
+	return -EIO;
+}
+
+int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dst, loff_t dstoff, loff_t len, bool *same,
+		const struct iomap_ops *ops)
+{
+	struct iomap_iter src_iter = {
+		.inode		= src,
+		.pos		= srcoff,
+		.len		= len,
+		.flags		= IOMAP_DAX,
+	};
+	struct iomap_iter dst_iter = {
+		.inode		= dst,
+		.pos		= dstoff,
+		.len		= len,
+		.flags		= IOMAP_DAX,
+	};
+	int ret;
+
+	while ((ret = iomap_iter(&src_iter, ops)) > 0) {
+		while ((ret = iomap_iter(&dst_iter, ops)) > 0) {
+			dst_iter.processed = dax_range_compare_iter(&src_iter,
+						&dst_iter, len, same);
+		}
+		if (ret <= 0)
+			src_iter.processed = ret;
+	}
+	return ret;
+}
+
+int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      loff_t *len, unsigned int remap_flags,
+			      const struct iomap_ops *ops)
+{
+	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
+					       pos_out, len, remap_flags, ops);
+}
+EXPORT_SYMBOL_GPL(dax_remap_file_range_prep);
--- a/fs/remap_range.c~fsdax-dedup-file-range-to-use-a-compare-function
+++ a/fs/remap_range.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/dax.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -271,9 +272,11 @@ out_error:
  * If there's an error, then the usual negative error code is returned.
  * Otherwise returns 0 with *len set to the request length.
  */
-int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
-				  struct file *file_out, loff_t pos_out,
-				  loff_t *len, unsigned int remap_flags)
+int
+__generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				loff_t *len, unsigned int remap_flags,
+				const struct iomap_ops *dax_read_ops)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -333,8 +336,18 @@ int generic_remap_file_range_prep(struct
 	if (remap_flags & REMAP_FILE_DEDUP) {
 		bool		is_same = false;
 
-		ret = vfs_dedupe_file_range_compare(file_in, pos_in,
-				file_out, pos_out, *len, &is_same);
+		if (*len == 0)
+			return 0;
+
+		if (!IS_DAX(inode_in))
+			ret = vfs_dedupe_file_range_compare(file_in, pos_in,
+					file_out, pos_out, *len, &is_same);
+		else if (dax_read_ops)
+			ret = dax_dedupe_file_range_compare(inode_in, pos_in,
+					inode_out, pos_out, *len, &is_same,
+					dax_read_ops);
+		else
+			return -EINVAL;
 		if (ret)
 			return ret;
 		if (!is_same)
@@ -352,6 +365,14 @@ int generic_remap_file_range_prep(struct
 
 	return ret;
 }
+
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  loff_t *len, unsigned int remap_flags)
+{
+	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
+					       pos_out, len, remap_flags, NULL);
+}
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
--- a/fs/xfs/xfs_reflink.c~fsdax-dedup-file-range-to-use-a-compare-function
+++ a/fs/xfs/xfs_reflink.c
@@ -1367,8 +1367,12 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+	if (!IS_DAX(inode_in))
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags);
+	else
+		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags, &xfs_read_iomap_ops);
 	if (ret || *len == 0)
 		goto out_unlock;
 
--- a/include/linux/dax.h~fsdax-dedup-file-range-to-use-a-compare-function
+++ a/include/linux/dax.h
@@ -246,6 +246,14 @@ vm_fault_t dax_finish_sync_fault(struct
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+				  struct inode *dest, loff_t destoff,
+				  loff_t len, bool *is_same,
+				  const struct iomap_ops *ops);
+int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      loff_t *len, unsigned int remap_flags,
+			      const struct iomap_ops *ops);
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
--- a/include/linux/fs.h~fsdax-dedup-file-range-to-use-a-compare-function
+++ a/include/linux/fs.h
@@ -74,6 +74,7 @@ struct fsverity_operations;
 struct fs_context;
 struct fs_parameter_spec;
 struct fileattr;
+struct iomap_ops;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -2072,10 +2073,13 @@ extern ssize_t vfs_copy_file_range(struc
 extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 				       struct file *file_out, loff_t pos_out,
 				       size_t len, unsigned int flags);
-extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
-					 struct file *file_out, loff_t pos_out,
-					 loff_t *count,
-					 unsigned int remap_flags);
+int __generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				    struct file *file_out, loff_t pos_out,
+				    loff_t *len, unsigned int remap_flags,
+				    const struct iomap_ops *dax_read_ops);
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  loff_t *count, unsigned int remap_flags);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t len, unsigned int remap_flags);
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

