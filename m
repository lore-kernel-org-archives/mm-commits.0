Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB11DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9909D20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266135;
	bh=gJIVLD0XlwDTq6OYstRgNqsd2D2jxlXGXGlfZaJf0CU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cv26M/3TiDTa7P9oAprRHKWbJ2IVtaDCfrzX7G+ZoMakRpSnEswQ+ohzLwfFM/e6c
	 rC6ebb5k6zdFrzWWl9SFzDhbivd+zUqnh4pRIz4TqtLo91K4Z09jAmj73uZewBtaik
	 KoAHyjx2caNO0ecLKslkRxRjF4HlLoi+aFKD0sLs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLVCP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D5372078B;
        Wed, 12 Aug 2020 21:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266134;
        bh=gJIVLD0XlwDTq6OYstRgNqsd2D2jxlXGXGlfZaJf0CU=;
        h=Date:From:To:Subject:From;
        b=DG6cv5FUYj/Rdxmeb3WRMYLLMRz+6hgVYQCjmUkYja9DsTwRtqc1tS0AWbPnG1eCO
         0irWs4K+X90Hnrv1hJ0qPU7ukv99CC1ls6HiSkvjEP8FxW8BPJZzKVen6ZjzmW4Tkr
         1EqHe5EwQi2lP3dpNTq+0y2ncV+CA/9Ww1Dr4WEY=
Date:   Wed, 12 Aug 2020 14:02:14 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, song.bao.hua@hisilicon.com
Subject:  [merged] mm-cma-fix-the-name-of-cma-areas.patch removed
 from -mm tree
Message-ID: <20200812210214.tgRzv_Ewn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix the name of CMA areas
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-the-name-of-cma-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm: cma: fix the name of CMA areas

Patch series "mm: fix the names of general cma and hugetlb cma", v2.

The current code of CMA can only work when users pass a const string as
name parameter.  we need to fix the way to handle names in CMA.  On the
other hand, to avoid name conflicts after enabling CMA_DEBUGFS, each
hugetlb should get a different CMA name.


This patch (of 2):

If users give a name saved in stack, the current code will generate magic
pointer.  if users don't give a name(NULL), kasprintf() will always return
NULL as we are at the early stage.  that means cma_init_reserved_mem()
will return -ENOMEM if users set name parameter as NULL.

[natechancellor@gmail.com: return cma->name directly in cma_get_name]
  Link: https://github.com/ClangBuiltLinux/linux/issues/1063
  Link: http://lkml.kernel.org/r/20200623015840.621964-1-natechancellor@gmail.com
Link: http://lkml.kernel.org/r/20200616223131.33828-2-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 +++++++--------
 mm/cma.h |    4 +++-
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/cma.c~mm-cma-fix-the-name-of-cma-areas
+++ a/mm/cma.c
@@ -52,7 +52,7 @@ unsigned long cma_get_size(const struct
 
 const char *cma_get_name(const struct cma *cma)
 {
-	return cma->name ? cma->name : "(undefined)";
+	return cma->name;
 }
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
@@ -202,13 +202,12 @@ int __init cma_init_reserved_mem(phys_ad
 	 * subsystems (like slab allocator) are available.
 	 */
 	cma = &cma_areas[cma_area_count];
-	if (name) {
-		cma->name = name;
-	} else {
-		cma->name = kasprintf(GFP_KERNEL, "cma%d\n", cma_area_count);
-		if (!cma->name)
-			return -ENOMEM;
-	}
+
+	if (name)
+		snprintf(cma->name, CMA_MAX_NAME, name);
+	else
+		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+
 	cma->base_pfn = PFN_DOWN(base);
 	cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
--- a/mm/cma.h~mm-cma-fix-the-name-of-cma-areas
+++ a/mm/cma.h
@@ -4,6 +4,8 @@
 
 #include <linux/debugfs.h>
 
+#define CMA_MAX_NAME 64
+
 struct cma {
 	unsigned long   base_pfn;
 	unsigned long   count;
@@ -15,7 +17,7 @@ struct cma {
 	spinlock_t mem_head_lock;
 	struct debugfs_u32_array dfs_bitmap;
 #endif
-	const char *name;
+	char name[CMA_MAX_NAME];
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


