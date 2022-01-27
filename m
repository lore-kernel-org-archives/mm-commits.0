Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECCFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiA0WPn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbiA0WPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44A6C06173B
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591D061BAD
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AF8C340E4;
        Thu, 27 Jan 2022 22:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643321741;
        bh=gld6zwrUHBAyY76X0byHNC7HT1ie9r8ukIKPXl8pFDU=;
        h=Date:From:To:Subject:From;
        b=rku6SUbu6mzeAVWNF6xIzvhCc/stnefxTY41VqkouA/SyawF8uNL7pMZFZmfJQDx/
         mxXv74V3ojYFC2p3yQYpjkVnO273+/fxu4537n04/aALehFkTE9TE7iX/Q7SHnnirn
         U4ETseK46LJk43pREDoQCzmBBYeXkSJP+gErJ+MM=
Date:   Thu, 27 Jan 2022 14:15:41 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  +
 mm-sparse-make-mminit_validate_memmodel_limits-static.patch added to -mm
 tree
Message-ID: <20220127221541.ah_1QVFQA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: make mminit_validate_memmodel_limits() static
has been added to the -mm tree.  Its filename is
     mm-sparse-make-mminit_validate_memmodel_limits-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-make-mminit_validate_memmodel_limits-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-make-mminit_validate_memmodel_limits-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

