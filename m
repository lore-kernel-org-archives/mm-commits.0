Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F49AC4361B
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 23:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E04A23B99
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 23:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbgLIXLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 18:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbgLIXLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 18:11:33 -0500
Date:   Wed, 09 Dec 2020 15:10:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607555452;
        bh=TtV9k3FYa3puuw8TKCAuRTut+bZ8bL8jFUiuUvfTgjo=;
        h=From:To:Subject:From;
        b=Nk1HjUBxEXuHiRebVJRINtxdU7g8ocJ//xl9OOcNl3gaIou+BbvXZcEtQ8zSZuSvV
         Go1qoMxGN6ziFYlTWpJ7/nCzxjXbAyyx8NCIpwSsNZ8Nzo9TfRNDzf5yM9SAHljvvC
         6DYz9hLtz7VNkbEO27Z5KYbCCLl9cMdNfPjt1DPk=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        akpm@linux-foundation.org
Subject:  +
 =?us-ascii?Q?mm-fix-initialization-of-struct-page-for-holes-in-memory-l?=
 =?us-ascii?Q?ayout-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20201209231051.MCkcy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch

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
@@ -6253,7 +6253,7 @@ static void __meminit zone_init_free_lis
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

revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

