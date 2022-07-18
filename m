Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C3DC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGRARF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiGRAQs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C20E096
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BB360F24
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1208C341C0;
        Mon, 18 Jul 2022 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103403;
        bh=NpX5Hgn9C30IZl/fwiWIusUEwYlOuqy/nqGNLSaXVhw=;
        h=Date:To:From:Subject:From;
        b=g6s3bYTMS5kG0FeF3KMwB332w3b49EIDvVFlS8igI8enCdNwnTEPuBaIQUS/BpSOA
         PV51zdQBXingdomS9nO07kl02Ce3v42UmLmnNkKriDTUAmuDtnUe3yFE8pGLJHBxje
         A10WxhOnhwCQpRPqApkZWXNIhO9Cj3QMc1Q2z23Q=
Date:   Sun, 17 Jul 2022 17:16:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagemappmem-introduce-memory_failure.patch removed from -mm tree
Message-Id: <20220718001643.C1208C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pagemap,pmem: introduce ->memory_failure()
has been removed from the -mm tree.  Its filename was
     pagemappmem-introduce-memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: pagemap,pmem: introduce ->memory_failure()
Date: Fri, 3 Jun 2022 13:37:27 +0800

When memory-failure occurs, we call this function which is implemented by
each kind of devices.  For the fsdax case, pmem device driver implements
it.  Pmem device driver will find out the filesystem in which the
corrupted page located in.

With dax_holder notify support, we are able to notify the memory failure
from pmem driver to upper layers.  If there is something not support in
the notify routine, memory_failure will fall back to the generic hanlder.

Link: https://lkml.kernel.org/r/20220603053738.1218681-4-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c    |   17 +++++++++++++++++
 include/linux/memremap.h |   12 ++++++++++++
 mm/memory-failure.c      |   14 ++++++++++++++
 3 files changed, 43 insertions(+)

--- a/drivers/nvdimm/pmem.c~pagemappmem-introduce-memory_failure
+++ a/drivers/nvdimm/pmem.c
@@ -453,6 +453,21 @@ static void pmem_release_disk(void *__pm
 	blk_cleanup_disk(pmem->disk);
 }
 
+static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
+		unsigned long pfn, unsigned long nr_pages, int mf_flags)
+{
+	struct pmem_device *pmem =
+			container_of(pgmap, struct pmem_device, pgmap);
+	u64 offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
+	u64 len = nr_pages << PAGE_SHIFT;
+
+	return dax_holder_notify_failure(pmem->dax_dev, offset, len, mf_flags);
+}
+
+static const struct dev_pagemap_ops fsdax_pagemap_ops = {
+	.memory_failure		= pmem_pagemap_memory_failure,
+};
+
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns)
 {
@@ -514,6 +529,7 @@ static int pmem_attach_disk(struct devic
 	pmem->pfn_flags = PFN_DEV;
 	if (is_nd_pfn(dev)) {
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
@@ -527,6 +543,7 @@ static int pmem_attach_disk(struct devic
 		pmem->pgmap.range.end = res->end;
 		pmem->pgmap.nr_range = 1;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
+		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
 		bb_range = pmem->pgmap.range;
--- a/include/linux/memremap.h~pagemappmem-introduce-memory_failure
+++ a/include/linux/memremap.h
@@ -87,6 +87,18 @@ struct dev_pagemap_ops {
 	 * the page back to a CPU accessible page.
 	 */
 	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
+
+	/*
+	 * Handle the memory failure happens on a range of pfns.  Notify the
+	 * processes who are using these pfns, and try to recover the data on
+	 * them if necessary.  The mf_flags is finally passed to the recover
+	 * function through the whole notify routine.
+	 *
+	 * When this is not implemented, or it returns -EOPNOTSUPP, the caller
+	 * will fall back to a common handler called mf_generic_kill_procs().
+	 */
+	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
+			      unsigned long nr_pages, int mf_flags);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
--- a/mm/memory-failure.c~pagemappmem-introduce-memory_failure
+++ a/mm/memory-failure.c
@@ -1748,6 +1748,20 @@ static int memory_failure_dev_pagemap(un
 	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
 
+	/*
+	 * Call driver's implementation to handle the memory failure, otherwise
+	 * fall back to generic handler.
+	 */
+	if (pgmap->ops->memory_failure) {
+		rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
+		/*
+		 * Fall back to generic handler too if operation is not
+		 * supported inside the driver/device/filesystem.
+		 */
+		if (rc != -EOPNOTSUPP)
+			goto out;
+	}
+
 	rc = mf_generic_kill_procs(pfn, flags, pgmap);
 out:
 	/* drop pgmap ref acquired in caller */
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


