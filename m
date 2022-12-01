Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3850BC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiLAWII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLAWID (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:08:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AEE26579
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:08:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F047B82038
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5421C433C1;
        Thu,  1 Dec 2022 22:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669932480;
        bh=7DVQnN0H4xXS4ruy4mfC3ALBh89Be3HZS6IUJzagZ8U=;
        h=Date:To:From:Subject:From;
        b=S85f4cyg6vB1oG9MsZ4WmT3x1PPsw5AE6h0tSjqah+dShoMQMtnyufuLtprYfwEIx
         cxr3/m5akxVMjyDaxsRX5KNxOZcFeVIbvp37l2JuZHCWyLB7Gpco8hK1Ub3q7+M0H5
         m9XD3hQXHBPoePa/IWQTL51t1/R0ZAqFsmhMDOhE=
Date:   Thu, 01 Dec 2022 14:07:59 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-invalidate-pages-when-cow.patch added to mm-unstable branch
Message-Id: <20221201220759.D5421C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: invalidate pages when CoW
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-invalidate-pages-when-cow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-invalidate-pages-when-cow.patch

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
Subject: fsdax: invalidate pages when CoW
Date: Thu, 1 Dec 2022 15:28:52 +0000

CoW changes the share state of a dax page, but the share count of the page
isn't updated.  The next time access this page, it should have been a
newly accessed, but old association exists.  So, we need to clear the
share state when CoW happens, in both dax_iomap_rw() and dax_zero_iter().

Link: https://lkml.kernel.org/r/1669908538-55-3-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/dax.c~fsdax-invalidate-pages-when-cow
+++ a/fs/dax.c
@@ -1264,6 +1264,15 @@ static s64 dax_zero_iter(struct iomap_it
 	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
 		return length;
 
+	/*
+	 * invalidate the pages whose sharing state is to be changed
+	 * because of CoW.
+	 */
+	if (iomap->flags & IOMAP_F_SHARED)
+		invalidate_inode_pages2_range(iter->inode->i_mapping,
+					      pos >> PAGE_SHIFT,
+					      (pos + length - 1) >> PAGE_SHIFT);
+
 	do {
 		unsigned offset = offset_in_page(pos);
 		unsigned size = min_t(u64, PAGE_SIZE - offset, length);
@@ -1324,12 +1333,13 @@ static loff_t dax_iomap_iter(const struc
 		struct iov_iter *iter)
 {
 	const struct iomap *iomap = &iomi->iomap;
-	const struct iomap *srcmap = &iomi->srcmap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iomi);
 	loff_t length = iomap_length(iomi);
 	loff_t pos = iomi->pos;
 	struct dax_device *dax_dev = iomap->dax_dev;
 	loff_t end = pos + length, done = 0;
 	bool write = iov_iter_rw(iter) == WRITE;
+	bool cow = write && iomap->flags & IOMAP_F_SHARED;
 	ssize_t ret = 0;
 	size_t xfer;
 	int id;
@@ -1356,7 +1366,7 @@ static loff_t dax_iomap_iter(const struc
 	 * into page tables. We have to tear down these mappings so that data
 	 * written by write(2) is visible in mmap.
 	 */
-	if (iomap->flags & IOMAP_F_NEW) {
+	if (iomap->flags & IOMAP_F_NEW || cow) {
 		invalidate_inode_pages2_range(iomi->inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
@@ -1390,8 +1400,7 @@ static loff_t dax_iomap_iter(const struc
 			break;
 		}
 
-		if (write &&
-		    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {
+		if (cow) {
 			ret = dax_iomap_cow_copy(pos, length, PAGE_SIZE, srcmap,
 						 kaddr);
 			if (ret)
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

