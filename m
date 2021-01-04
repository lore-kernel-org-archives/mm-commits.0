Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85122C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394FD22225
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADUPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADUPq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 15:15:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F96221F8;
        Mon,  4 Jan 2021 20:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609791305;
        bh=zhr9dpQOLXFb/dC8dWzJE8q8PAEy5TfxCqC3OAyjxIc=;
        h=Date:From:To:Subject:From;
        b=LCLU2OMTVGD/w2bgOD2vUE1n5tLGYwQwg2qK6M97jNv3v8hPlMzP1Yhy+/4x/r0Yf
         fgQEY41YLT5ekphKHy5lnhbwt6quvVupe5ZAqpgyzs1QIw5vUs0MgM9QvKRKE81Yo/
         XqWeAVca6N6HcVh+uM8QScw+KHm1LoBY3giVIlRs=
Date:   Mon, 04 Jan 2021 12:15:04 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-fix-initialization-of-struct-page-for-holes-in-memory-l?=
 =?US-ASCII?Q?ayout-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20210104201504.7XSk61GST%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes

WARNING: Unknown commit id '73a6e474cb37', maybe rebased or not pulled?
#36: 
Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather

WARNING: 'becuase' may be misspelled - perhaps 'because'?
#67: FILE: mm/page_alloc.c:6256:
+ * do not correspond to physical page frames becuase the actual memory bank

total: 0 errors, 2 warnings, 184 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -6259,7 +6259,7 @@ static void __meminit zone_init_free_lis
  * Only struct pages that are backed by physical memory available to the
  * kernel are zeroed and initialized by memmap_init_zone().
  * But, there are some struct pages that are either reserved by firmware or
- * do not correspond to physical page frames becuase the actual memory bank
+ * do not correspond to physical page frames because the actual memory bank
  * is not a multiple of SECTION_SIZE.
  * Fields of those struct pages may be accessed (for example page_to_pfn()
  * on some configuration accesses page flags) so we must explicitly
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

