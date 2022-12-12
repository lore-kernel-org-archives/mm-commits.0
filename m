Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CDCC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiLLCQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiLLCOk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A55116D
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 947A8B80B69
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E272C433EF;
        Mon, 12 Dec 2022 02:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811273;
        bh=QtjNMMITobjn+cIAWuxhyZzT0QeWngD9zcvLPuXB5GE=;
        h=Date:To:From:Subject:From;
        b=uhdTqFfUmNZGX71H8J59W7pyE9ARFOJjqE0puOc12IxfUE0g6hdYAkmmxU/KiF0u+
         00BMvJvMi02juN9lNx1xDIf61BeDhFgPe2RNddAiC47ghDSJon3+X+qyMt12ZvuLol
         RlSY7rLylkvNFMkJjJcecYM0OSUNKfOQ5qyVs5V4=
Date:   Sun, 11 Dec 2022 18:14:32 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, allison.henderson@oracle.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch removed from -mm tree
Message-Id: <20221212021433.4E272C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: zero the edges if source is HOLE or UNWRITTEN
has been removed from the -mm tree.  Its filename was
     fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: zero the edges if source is HOLE or UNWRITTEN
Date: Thu, 1 Dec 2022 15:28:53 +0000

If srcmap contains invalid data, such as HOLE and UNWRITTEN, the dest page
should be zeroed.  Otherwise, since it's a pmem, old data may remains on
the dest page, the result of CoW will be incorrect.

The function name is also not easy to understand, rename it to
"dax_iomap_copy_around()", which means it copies data around the range.

[akpm@linux-foundation.org: update dax_iomap_copy_around() kerneldoc, per Darrick]
Link: https://lkml.kernel.org/r/1669973145-318-1-git-send-email-ruansy.fnst@fujitsu.com
Link: https://lkml.kernel.org/r/1669908538-55-4-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   79 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 30 deletions(-)

--- a/fs/dax.c~fsdax-zero-the-edges-if-source-is-hole-or-unwritten
+++ a/fs/dax.c
@@ -1092,7 +1092,8 @@ out:
 }
 
 /**
- * dax_iomap_cow_copy - Copy the data from source to destination before write
+ * dax_iomap_copy_around - Prepare for an unaligned write to a shared/cow page
+ * by copying the data before and after the range to be written.
  * @pos:	address to do copy from.
  * @length:	size of copy operation.
  * @align_size:	aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
@@ -1101,35 +1102,50 @@ out:
  *
  * This can be called from two places. Either during DAX write fault (page
  * aligned), to copy the length size data to daddr. Or, while doing normal DAX
- * write operation, dax_iomap_actor() might call this to do the copy of either
+ * write operation, dax_iomap_iter() might call this to do the copy of either
  * start or end unaligned address. In the latter case the rest of the copy of
- * aligned ranges is taken care by dax_iomap_actor() itself.
+ * aligned ranges is taken care by dax_iomap_iter() itself.
+ * If the srcmap contains invalid data, such as HOLE and UNWRITTEN, zero the
+ * area to make sure no old data remains.
  */
-static int dax_iomap_cow_copy(loff_t pos, uint64_t length, size_t align_size,
+static int dax_iomap_copy_around(loff_t pos, uint64_t length, size_t align_size,
 		const struct iomap *srcmap, void *daddr)
 {
 	loff_t head_off = pos & (align_size - 1);
 	size_t size = ALIGN(head_off + length, align_size);
 	loff_t end = pos + length;
 	loff_t pg_end = round_up(end, align_size);
+	/* copy_all is usually in page fault case */
 	bool copy_all = head_off == 0 && end == pg_end;
+	/* zero the edges if srcmap is a HOLE or IOMAP_UNWRITTEN */
+	bool zero_edge = srcmap->flags & IOMAP_F_SHARED ||
+			 srcmap->type == IOMAP_UNWRITTEN;
 	void *saddr = 0;
 	int ret = 0;
 
-	ret = dax_iomap_direct_access(srcmap, pos, size, &saddr, NULL);
-	if (ret)
-		return ret;
+	if (!zero_edge) {
+		ret = dax_iomap_direct_access(srcmap, pos, size, &saddr, NULL);
+		if (ret)
+			return ret;
+	}
 
 	if (copy_all) {
-		ret = copy_mc_to_kernel(daddr, saddr, length);
-		return ret ? -EIO : 0;
+		if (zero_edge)
+			memset(daddr, 0, size);
+		else
+			ret = copy_mc_to_kernel(daddr, saddr, length);
+		goto out;
 	}
 
 	/* Copy the head part of the range */
 	if (head_off) {
-		ret = copy_mc_to_kernel(daddr, saddr, head_off);
-		if (ret)
-			return -EIO;
+		if (zero_edge)
+			memset(daddr, 0, head_off);
+		else {
+			ret = copy_mc_to_kernel(daddr, saddr, head_off);
+			if (ret)
+				return -EIO;
+		}
 	}
 
 	/* Copy the tail part of the range */
@@ -1137,12 +1153,19 @@ static int dax_iomap_cow_copy(loff_t pos
 		loff_t tail_off = head_off + length;
 		loff_t tail_len = pg_end - end;
 
-		ret = copy_mc_to_kernel(daddr + tail_off, saddr + tail_off,
-					tail_len);
-		if (ret)
-			return -EIO;
+		if (zero_edge)
+			memset(daddr + tail_off, 0, tail_len);
+		else {
+			ret = copy_mc_to_kernel(daddr + tail_off,
+						saddr + tail_off, tail_len);
+			if (ret)
+				return -EIO;
+		}
 	}
-	return 0;
+out:
+	if (zero_edge)
+		dax_flush(srcmap->dax_dev, daddr, size);
+	return ret ? -EIO : 0;
 }
 
 /*
@@ -1241,13 +1264,10 @@ static int dax_memzero(struct iomap_iter
 	if (ret < 0)
 		return ret;
 	memset(kaddr + offset, 0, size);
-	if (srcmap->addr != iomap->addr) {
-		ret = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
-					 kaddr);
-		if (ret < 0)
-			return ret;
-		dax_flush(iomap->dax_dev, kaddr, PAGE_SIZE);
-	} else
+	if (iomap->flags & IOMAP_F_SHARED)
+		ret = dax_iomap_copy_around(pos, size, PAGE_SIZE, srcmap,
+					    kaddr);
+	else
 		dax_flush(iomap->dax_dev, kaddr + offset, size);
 	return ret;
 }
@@ -1401,8 +1421,8 @@ static loff_t dax_iomap_iter(const struc
 		}
 
 		if (cow) {
-			ret = dax_iomap_cow_copy(pos, length, PAGE_SIZE, srcmap,
-						 kaddr);
+			ret = dax_iomap_copy_around(pos, length, PAGE_SIZE,
+						    srcmap, kaddr);
 			if (ret)
 				break;
 		}
@@ -1547,7 +1567,7 @@ static vm_fault_t dax_fault_iter(struct
 		struct xa_state *xas, void **entry, bool pmd)
 {
 	const struct iomap *iomap = &iter->iomap;
-	const struct iomap *srcmap = &iter->srcmap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
 	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
 	bool write = iter->flags & IOMAP_WRITE;
@@ -1578,9 +1598,8 @@ static vm_fault_t dax_fault_iter(struct
 
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
 
-	if (write &&
-	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {
-		err = dax_iomap_cow_copy(pos, size, size, srcmap, kaddr);
+	if (write && iomap->flags & IOMAP_F_SHARED) {
+		err = dax_iomap_copy_around(pos, size, size, srcmap, kaddr);
 		if (err)
 			return dax_fault_return(err);
 	}
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


