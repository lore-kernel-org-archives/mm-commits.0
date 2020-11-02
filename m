Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E955C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67CE206E5
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279245;
	bh=ka5xjbfpq5X+yy69PexjPHyqZDsQG07VUHHeWKKGtf4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=W5NgU1/SHmfh7XAASEOI05wSRFuMHj5I9UTb/qKQtS1FKv5fejuf8a8C1qOPPkKI5
	 64vyp5opOHKuMV9nvBuIB1kBlouuuEB+PCTSrTBJacJ+T1Bl0JbJTpeDr0N4E7XrPi
	 QfyQrF5aQobdjl/aspUCvaLpf5WG+dlqW9vV4Paw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKBBHZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E57B206A4;
        Mon,  2 Nov 2020 01:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279244;
        bh=ka5xjbfpq5X+yy69PexjPHyqZDsQG07VUHHeWKKGtf4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LqFLx2rGcGVkQ2cQL1mP8BI0YPB2huIiixDBi9qfKe+ZYSjDpxcSBU5jQhfVHSr0M
         ga2RAlfjKLS149Mpo7Ed37VTc1AambzI3TtI7MJP4kM6i043RnThObC7TMV0Isv9gr
         68wherUznXpvsE1NDpbWGXt7X7/9JQOnRLhwzjxY=
Date:   Sun, 01 Nov 2020 17:07:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        dan.j.williams@intel.com, hch@lst.de, ira.weiny@intel.com,
        jgg@mellanox.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, sachinp@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/15] mm/mremap_pages: fix static key
 devmap_managed_key updates
Message-ID: <20201102010723.iGXwcvhDY%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/mremap_pages: fix static key devmap_managed_key updates

commit 6f42193fd86e ("memremap: don't use a separate devm action for
devmap_managed_enable_get") changed the static key updates such that we
now call devmap_managed_enable_put() without doing the equivalent
devmap_managed_enable_get().

devmap_managed_enable_get() is only called for MEMORY_DEVICE_PRIVATE and
MEMORY_DEVICE_FS_DAX, But memunmap_pages() get called for other pgmap
types too.  This results in the below warning when switching between
system-ram and devdax mode for devdax namespace.

 jump label: negative count!
 WARNING: CPU: 52 PID: 1335 at kernel/jump_label.c:235 static_key_slow_try_dec+0x88/0xa0
 Modules linked in:
 ....

 NIP [c000000000433318] static_key_slow_try_dec+0x88/0xa0
 LR [c000000000433314] static_key_slow_try_dec+0x84/0xa0
 Call Trace:
 [c000000025c1f660] [c000000000433314] static_key_slow_try_dec+0x84/0xa0
 [c000000025c1f6d0] [c000000000433664] __static_key_slow_dec_cpuslocked+0x34/0xd0
 [c000000025c1f700] [c0000000004337a4] static_key_slow_dec+0x54/0xf0
 [c000000025c1f770] [c00000000059c49c] memunmap_pages+0x36c/0x500
 [c000000025c1f820] [c000000000d91d10] devm_action_release+0x30/0x50
 [c000000025c1f840] [c000000000d92e34] release_nodes+0x2f4/0x3e0
 [c000000025c1f8f0] [c000000000d8b15c] device_release_driver_internal+0x17c/0x280
 [c000000025c1f930] [c000000000d883a4] bus_remove_device+0x124/0x210
 [c000000025c1f9b0] [c000000000d80ef4] device_del+0x1d4/0x530
 [c000000025c1fa70] [c000000000e341e8] unregister_dev_dax+0x48/0xe0
 [c000000025c1fae0] [c000000000d91d10] devm_action_release+0x30/0x50
 [c000000025c1fb00] [c000000000d92e34] release_nodes+0x2f4/0x3e0
 [c000000025c1fbb0] [c000000000d8b15c] device_release_driver_internal+0x17c/0x280
 [c000000025c1fbf0] [c000000000d87000] unbind_store+0x130/0x170
 [c000000025c1fc30] [c000000000d862a0] drv_attr_store+0x40/0x60
 [c000000025c1fc50] [c0000000006d316c] sysfs_kf_write+0x6c/0xb0
 [c000000025c1fc90] [c0000000006d2328] kernfs_fop_write+0x118/0x280
 [c000000025c1fce0] [c0000000005a79f8] vfs_write+0xe8/0x2a0
 [c000000025c1fd30] [c0000000005a7d94] ksys_write+0x84/0x140
 [c000000025c1fd80] [c00000000003a430] system_call_exception+0x120/0x270
 [c000000025c1fe20] [c00000000000c540] system_call_common+0xf0/0x27c

Link: https://lkml.kernel.org/r/20201023183222.13186-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/mm/memremap.c~mm-mremap_pages-fix-static-key-devmap_managed_key-updates
+++ a/mm/memremap.c
@@ -41,28 +41,24 @@ EXPORT_SYMBOL_GPL(memremap_compat_align)
 DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);
 
-static void devmap_managed_enable_put(void)
+static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 {
-	static_branch_dec(&devmap_managed_key);
+	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
+	    pgmap->type == MEMORY_DEVICE_FS_DAX)
+		static_branch_dec(&devmap_managed_key);
 }
 
-static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
+static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE &&
-	    (!pgmap->ops || !pgmap->ops->page_free)) {
-		WARN(1, "Missing page_free method\n");
-		return -EINVAL;
-	}
-
-	static_branch_inc(&devmap_managed_key);
-	return 0;
+	if (pgmap->type == MEMORY_DEVICE_PRIVATE ||
+	    pgmap->type == MEMORY_DEVICE_FS_DAX)
+		static_branch_inc(&devmap_managed_key);
 }
 #else
-static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
+static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
-	return -EINVAL;
 }
-static void devmap_managed_enable_put(void)
+static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
 {
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
@@ -169,7 +165,7 @@ void memunmap_pages(struct dev_pagemap *
 		pageunmap_range(pgmap, i);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
-	devmap_managed_enable_put();
+	devmap_managed_enable_put(pgmap);
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -307,7 +303,6 @@ void *memremap_pages(struct dev_pagemap
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
-	bool need_devmap_managed = true;
 	int error, i;
 
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
@@ -323,6 +318,10 @@ void *memremap_pages(struct dev_pagemap
 			WARN(1, "Missing migrate_to_ram method\n");
 			return ERR_PTR(-EINVAL);
 		}
+		if (!pgmap->ops->page_free) {
+			WARN(1, "Missing page_free method\n");
+			return ERR_PTR(-EINVAL);
+		}
 		if (!pgmap->owner) {
 			WARN(1, "Missing owner\n");
 			return ERR_PTR(-EINVAL);
@@ -336,11 +335,9 @@ void *memremap_pages(struct dev_pagemap
 		}
 		break;
 	case MEMORY_DEVICE_GENERIC:
-		need_devmap_managed = false;
 		break;
 	case MEMORY_DEVICE_PCI_P2PDMA:
 		params.pgprot = pgprot_noncached(params.pgprot);
-		need_devmap_managed = false;
 		break;
 	default:
 		WARN(1, "Invalid pgmap type %d\n", pgmap->type);
@@ -364,11 +361,7 @@ void *memremap_pages(struct dev_pagemap
 		}
 	}
 
-	if (need_devmap_managed) {
-		error = devmap_managed_enable_get(pgmap);
-		if (error)
-			return ERR_PTR(error);
-	}
+	devmap_managed_enable_get(pgmap);
 
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
_
