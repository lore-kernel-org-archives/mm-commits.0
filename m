Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DE0C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jan 2021 00:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1AC20888
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jan 2021 00:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbhAAANg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 19:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbhAAANf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 19:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC1D52158C;
        Fri,  1 Jan 2021 00:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609459975;
        bh=LGCoNrthLc2ZyIl5zxKdnOhWm3UAvN8mU45WhVYSqGQ=;
        h=Date:From:To:Subject:From;
        b=WbvpkFGS/yhQ7AnnAw+bX/fj7Kity2+pZRqN+hYB9r9DKT5hotxT0+i2MnrQXKufc
         vPaqdm5zEeA4j0CkG7bM//7tP1h4tI0Si8YRwWiRn6+j2TVZle5IuwiVRrb4bYB0mn
         fcmXEiNBDZix442Ytan1W1t2LEdAAn6EyKK761wI=
Date:   Thu, 31 Dec 2020 16:12:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
        rdunlap@infradead.org, guro@fb.com, akpm@linux-foundation.org
Subject:  + mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch added
 to -mm tree
Message-ID: <20210101001254.BnAID%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3-fix
has been added to the -mm tree.  Its filename is
     mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3-fix

build fix

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-3-fix
+++ a/mm/cma.c
@@ -344,7 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-#if CONFIG_PHYS_ADDR_T_64BIT
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

