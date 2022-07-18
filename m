Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A6DC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiGRARn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiGRARF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4208F120B2
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF2A6B80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800B1C341C0;
        Mon, 18 Jul 2022 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103413;
        bh=qGd6y1krD+9khR91Qo+BaSAoAsgfY9rS6PrrPY/uYPo=;
        h=Date:To:From:Subject:From;
        b=V1C7WzDR3JsI+2fsN/QTZSHshszrD25xovhjK1ZzOkJBJ0zHF39Ntuxn4b2kAb5Cd
         KZcxjxXXj42bozcFKQ98vT+13I/kV0mPMiM19AWfUBSXWcWKNmwCfAZ5gRTK7MFSaK
         dIHNXrQHiXXHh8L06M3LyaEfuINFbPoNpCre36n8=
Date:   Sun, 17 Jul 2022 17:16:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch removed from -mm tree
Message-Id: <20220718001653.800B1C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: add dax_iomap_cow_copy() for dax zero
has been removed from the -mm tree.  Its filename was
     fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: add dax_iomap_cow_copy() for dax zero
Date: Fri, 3 Jun 2022 13:37:35 +0800

Punch hole on a reflinked file needs dax_iomap_cow_copy() too.  Otherwise,
data in not aligned area will be not correct.  So, add the CoW operation
for not aligned case in dax_memzero().

Link: https://lkml.kernel.org/r/20220603053738.1218681-12-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/fs/dax.c~fsdax-add-dax_iomap_cow_copy-for-dax-zero
+++ a/fs/dax.c
@@ -1221,17 +1221,28 @@ static vm_fault_t dax_pmd_load_hole(stru
 }
 #endif /* CONFIG_FS_DAX_PMD */
 
-static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
-		unsigned int offset, size_t size)
+static int dax_memzero(struct iomap_iter *iter, loff_t pos, size_t size)
 {
+	const struct iomap *iomap = &iter->iomap;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
+	unsigned offset = offset_in_page(pos);
+	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
 	void *kaddr;
 	long ret;
 
-	ret = dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
-	if (ret > 0) {
-		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, kaddr + offset, size);
-	}
+	ret = dax_direct_access(iomap->dax_dev, pgoff, 1, DAX_ACCESS, &kaddr,
+				NULL);
+	if (ret < 0)
+		return ret;
+	memset(kaddr + offset, 0, size);
+	if (srcmap->addr != iomap->addr) {
+		ret = dax_iomap_cow_copy(pos, size, PAGE_SIZE, srcmap,
+					 kaddr);
+		if (ret < 0)
+			return ret;
+		dax_flush(iomap->dax_dev, kaddr, PAGE_SIZE);
+	} else
+		dax_flush(iomap->dax_dev, kaddr + offset, size);
 	return ret;
 }
 
@@ -1258,7 +1269,7 @@ static s64 dax_zero_iter(struct iomap_it
 		if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
 			rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
 		else
-			rc = dax_memzero(iomap->dax_dev, pgoff, offset, size);
+			rc = dax_memzero(iter, pos, size);
 		dax_read_unlock(id);
 
 		if (rc < 0)
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


