Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20984C43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiCVVod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiCVVo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C855F4F7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28DF061179
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E61AC340EE;
        Tue, 22 Mar 2022 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985365;
        bh=mPKzudlzJ9FrbxOIvBg6s/Z3UnRNW3NEEw4AvYzkQms=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=V2vzQDFCGt6BdNeVyLtyGfOfFwl1eE6jujWz4746NaHZdloDZWbIHhQJOEFAZHF90
         2O2gF3qI1svoSXUn38kuraatY6afo6ieEKeH65kzjMjrULICUg5v9ILgU9o1yQO0y4
         4e/g4AoLBWP/HiGWf4JeDScVsWJKwRFhVpbJT5fk=
Date:   Tue, 22 Mar 2022 14:42:44 -0700
To:     rppt@linux.ibm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 083/227] mm/sparse: make mminit_validate_memmodel_limits() static
Message-Id: <20220322214245.7E61AC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
