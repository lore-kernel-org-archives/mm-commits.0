Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED1BC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821A5206EC
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLOCPI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgLOCOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:14:39 -0500
Date:   Mon, 14 Dec 2020 18:13:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998438;
        bh=p7uYnCt3falvBH4UZ/D4dNuUHAh9KhmxHJWTy6f+Gho=;
        h=From:To:Subject:From;
        b=pkhKgsfxV3C00aHeDLx29trCuSPrvy8hFSu0ULUB4IV6NRIZNqAbalRY1GAVEn43/
         WmAZcMMzSREFbG55bA8UO3XYndwHDR7on/BrATyTv+E88NgozWoL/SaXx4s0WOaAak
         wuz5fx4EtHaC+yyp6hYcucewNwUOFB++5slLm3xw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jgg@nvidia.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20201215021357.ZSfUt84pZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes

WARNING: Unknown commit id '70e806e4e645', maybe rebased or not pulled?
#4: 
Since commit 70e806e4e645 ("mm: Do early cow for pinned pages during

WARNING: Unknown commit id 'f3c64eda3e50', maybe rebased or not pulled?
#34: 
problems (and was missing a barrrier), see commit f3c64eda3e50 ("mm: avoid

WARNING: Unknown commit id 'f3c64eda3e50', maybe rebased or not pulled?
#46: 
Fixes: f3c64eda3e50 ("mm: avoid early COW write protect games during fork()")

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#136: FILE: mm/gup.c:2687:
+	unsigned seq;

WARNING: Block comments should align the * on each line
#191: FILE: mm/memory.c:1180:
+		 * lockdep complaining about preemptibility.
+		*/

total: 0 errors, 5 warnings, 109 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes
+++ a/mm/memory.c
@@ -1177,7 +1177,7 @@ copy_page_range(struct vm_area_struct *d
 		 *
 		 * Use the raw variant of the seqcount_t write API to avoid
 		 * lockdep complaining about preemptibility.
-		*/
+		 */
 		mmap_assert_write_locked(src_mm);
 		raw_write_seqcount_begin(&src_mm->write_protect_seq);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

