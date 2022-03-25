Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293D8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357398AbiCYBd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357437AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE9FBF02F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAF03B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA58C340EC;
        Fri, 25 Mar 2022 01:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171868;
        bh=fjNM8Pdei2tDJt/rkVe4djiTekFvzIE7jv2nDiEKdgc=;
        h=Date:To:From:Subject:From;
        b=QEWPxpx3gjIAqW8Q+xEgjlC2rOSGg1kfljJT4QAZyfw+ilPcefKcCQ9pEfXFZKKQR
         deDJfK2+7W1ZlTfu+Quro3Y0X7M04WDPJGq8MmYE5I+tmkVL3MzdVy06V+pPBdEwe/
         1tmokzNNlCz4tEc2MmCHeuQQDEhdZN41EVMzQmi0=
Date:   Thu, 24 Mar 2022 18:31:07 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-sparse-make-mminit_validate_memmodel_limits-static.patch removed from -mm tree
Message-Id: <20220325013108.8AA58C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: make mminit_validate_memmodel_limits() static
has been removed from the -mm tree.  Its filename was
     mm-sparse-make-mminit_validate_memmodel_limits-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/sparse: make mminit_validate_memmodel_limits() static

It's only used in the sparse.c now. So we can make it static and further
clean up the relevant code.

Link: https://lkml.kernel.org/r/20220127093221.63524-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   11 -----------
 mm/sparse.c   |    2 +-
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/mm/internal.h~mm-sparse-make-mminit_validate_memmodel_limits-static
+++ a/mm/internal.h
@@ -572,17 +572,6 @@ static inline void mminit_verify_zonelis
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-/* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
-#if defined(CONFIG_SPARSEMEM)
-extern void mminit_validate_memmodel_limits(unsigned long *start_pfn,
-				unsigned long *end_pfn);
-#else
-static inline void mminit_validate_memmodel_limits(unsigned long *start_pfn,
-				unsigned long *end_pfn)
-{
-}
-#endif /* CONFIG_SPARSEMEM */
-
 #define NODE_RECLAIM_NOSCAN	-2
 #define NODE_RECLAIM_FULL	-1
 #define NODE_RECLAIM_SOME	0
--- a/mm/sparse.c~mm-sparse-make-mminit_validate_memmodel_limits-static
+++ a/mm/sparse.c
@@ -126,7 +126,7 @@ static inline int sparse_early_nid(struc
 }
 
 /* Validate the physical addressing limitations of the model */
-void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
+static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
 						unsigned long *end_pfn)
 {
 	unsigned long max_sparsemem_pfn = 1UL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

