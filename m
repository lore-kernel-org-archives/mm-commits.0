Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F31C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiGRARR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbiGRAQv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE2C101CE
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AF0460F40
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBC7C341CA;
        Mon, 18 Jul 2022 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103409;
        bh=rn/3pNGUW7wz7lrgzblyRMynd9Spx0lJyjI2Q3WrcF0=;
        h=Date:To:From:Subject:From;
        b=k/IuApm8JAJvs8/QpP6xNR4v+m7CvTRpDDL1kw9mZOfvEBmisWggdPd7JactjD8kL
         8la2I6pJ14DmbPghEO/RBbsAnraDP4ZLLQzD0DOfs01UNRlOxnnS/91cVRewP7HPxh
         1Hfvex6OpBrh14i7RqaGBQhYvlmr2zMW4BzXoqdw=
Date:   Sun, 17 Jul 2022 17:16:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch removed from -mm tree
Message-Id: <20220718001649.CDBC7C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: output address in dax_iomap_pfn() and rename it
has been removed from the -mm tree.  Its filename was
     fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: output address in dax_iomap_pfn() and rename it
Date: Fri, 3 Jun 2022 13:37:32 +0800

Add address output in dax_iomap_pfn() in order to perform a memcpy() in
CoW case.  Since this function both output address and pfn, rename it to
dax_iomap_direct_access().

[ruansy.fnst@fujitsu.com: initialize `rc', per Dan]
  Link: https://lore.kernel.org/linux-fsdevel/Yp8FUZnO64Qvyx5G@kili/
  Link: https://lkml.kernel.org/r/20220607143837.161174-1-ruansy.fnst@fujitsu.com
Link: https://lkml.kernel.org/r/20220603053738.1218681-9-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/dax.c~fsdax-output-address-in-dax_iomap_pfn-and-rename-it
+++ a/fs/dax.c
@@ -1026,20 +1026,22 @@ int dax_writeback_mapping_range(struct a
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
+		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc;
+	int id, rc = 0;
 	long length;
 
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   DAX_ACCESS, NULL, pfnp);
+				   DAX_ACCESS, kaddr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
 	}
+	if (!pfnp)
+		goto out_check_addr;
 	rc = -EINVAL;
 	if (PFN_PHYS(length) < size)
 		goto out;
@@ -1049,6 +1051,12 @@ static int dax_iomap_pfn(const struct io
 	if (length > 1 && !pfn_t_devmap(*pfnp))
 		goto out;
 	rc = 0;
+
+out_check_addr:
+	if (!kaddr)
+		goto out;
+	if (!*kaddr)
+		rc = -EFAULT;
 out:
 	dax_read_unlock(id);
 	return rc;
@@ -1456,7 +1464,7 @@ static vm_fault_t dax_fault_iter(struct
 		return pmd ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
 	}
 
-	err = dax_iomap_pfn(&iter->iomap, pos, size, &pfn);
+	err = dax_iomap_direct_access(&iter->iomap, pos, size, NULL, &pfn);
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


