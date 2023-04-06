Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C56C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjDFCdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjDFCdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAB75FDB
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3538164218
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E5C433D2;
        Thu,  6 Apr 2023 02:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748416;
        bh=e7ByiimVacfbBmN5SDnwRfGJV9cO/Tvk5+UNNZggUvA=;
        h=Date:To:From:Subject:From;
        b=1ney9Hb/nX+y1biMBWyMz9e01AsE7mbFmVNcFAtgF4s+VIpe5vWL4xh0oCGPqy4jI
         RU7JZEO1KDA5ta60XemPkXOFS4STvUwDcOIFWcvZMxT4SQ6VrDcIXKc/E4HwlM3Q5J
         tyhAMO5cOE2LKDn/IGvY294l7E4MOftRHW/+6skI=
Date:   Wed, 05 Apr 2023 19:33:35 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, kirill@shutemov.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-redefine-max_order-sanely-fix-3.patch removed from -mm tree
Message-Id: <20230406023336.8B8E5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-3
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix-3.patch

This patch was dropped because it was folded into mm-treewide-redefine-max_order-sanely.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-treewide-redefine-max_order-sanely-fix-3
Date: Fri, 17 Mar 2023 02:21:44 +0300

fixups per Zi Yan

Link: https://lkml.kernel.org/r/20230316232144.b7ic4cif4kjiabws@box.shutemov.name
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 kernel/events/ring_buffer.c                    |    2 +-
 mm/Kconfig                                     |    4 ++--
 mm/slub.c                                      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -189,7 +189,7 @@ Offsets of the vmap_area's members. They
 information. Makedumpfile gets the start address of the vmalloc region
 from this.
 
-(zone.free_area, MAX_ORDER)
+(zone.free_area, MAX_ORDER + 1)
 ---------------------------
 
 Free areas descriptor. User-space tools use this value to iterate the
--- a/kernel/events/ring_buffer.c~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/kernel/events/ring_buffer.c
@@ -814,7 +814,7 @@ struct perf_buffer *rb_alloc(int nr_page
 	size = sizeof(struct perf_buffer);
 	size += nr_pages * sizeof(void *);
 
-	if (order_base_2(size) >= PAGE_SHIFT+MAX_ORDER)
+	if (order_base_2(size) > PAGE_SHIFT+MAX_ORDER)
 		goto fail;
 
 	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
--- a/mm/Kconfig~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/mm/Kconfig
@@ -666,8 +666,8 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 	  HUGETLB_PAGE_ORDER when there are multiple HugeTLB page sizes available
 	  on a platform.
 
-	  Note that the pageblock_order cannot exceed MAX_ORDER - 1 and will be
-	  clamped down to MAX_ORDER - 1.
+	  Note that the pageblock_order cannot exceed MAX_ORDER and will be
+	  clamped down to MAX_ORDER.
 
 config CONTIG_ALLOC
 	def_bool (MEMORY_ISOLATION && COMPACTION) || CMA
--- a/mm/slub.c~mm-treewide-redefine-max_order-sanely-fix-3
+++ a/mm/slub.c
@@ -4697,7 +4697,7 @@ __setup("slub_min_order=", setup_slub_mi
 static int __init setup_slub_max_order(char *str)
 {
 	get_option(&str, (int *)&slub_max_order);
-	slub_max_order = min(slub_max_order, (unsigned int)MAX_ORDER);
+	slub_max_order = min_t(unsigned int, slub_max_order, MAX_ORDER);
 
 	return 1;
 }
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-treewide-redefine-max_order-sanely.patch

