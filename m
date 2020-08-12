Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB48C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2CC206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195920;
	bh=DOlQuN3MBpcieoHqPbvVQHLTa9MQMT8htktr790psHc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ASXb+AZsFqxtR26lwcwjaVho53DT1YsBVwiLknpx7K2pzGGEItRIw0odhzlqnQeAl
	 hL1nhKiejRTnlcI0G7yPHwoH2Oj7mkzn4SGNM45XedJRS/OsHVsUgJ0jv2rxmRg6io
	 CE4x7ml/YL/aJ6MN5plNe4+qAzUJy/+lwhlwkcfc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgHLBb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60F9207DA;
        Wed, 12 Aug 2020 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195918;
        bh=DOlQuN3MBpcieoHqPbvVQHLTa9MQMT8htktr790psHc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BhvqcVojRC6TzZFL9Re1gh91T/vi78uk4IrFHO7Sc0X/urrHn5SbfZHBsaOE6CdBX
         h305GjjxJz1sKGPTy+jD0HqBlGlv1lNPGVjq/DAzPjwhlg1hXXPdAAHd/k77ZCBHkv
         pzZix5F2sSqSJqOgkcrD9OPb1XoN7LpxAfkSrdcg=
Date:   Tue, 11 Aug 2020 18:31:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org
Subject:  [patch 032/165] mm: cma: fix the name of CMA areas
Message-ID: <20200812013157.V_PQIH6TB%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
