Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3132C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95C1F206F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgLOCPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgLOCPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:15:10 -0500
Date:   Mon, 14 Dec 2020 18:14:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998469;
        bh=GzUmo+E2Xry7z8W6YQWgrhuR/8poBOQiu2wcZktH9vc=;
        h=From:To:Subject:From;
        b=LsIMJ3hJU9Zr1A4wldmSoXBWZuLcGm9ic0RKwuNClt1P3IemWBsfDcAcpWxbYM7wy
         owJ+cDBtOPvdj7bZoGjTRmLfz107Mc91LHGWsiHg23LKMwu0bWKOA9IGc58BjLnqHy
         lRYPHz5K+yfyp4cDt6ZVfttA2ssWa7rCzY7DH6FE=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-swap=5Fstate-skip-meaningless-swap-cache-readahead-when-r?=
 =?US-ASCII?Q?a=5Finfowin-=3D=3D-0-fix.patch?= removed from -mm tree
Message-ID: <20201215021429.2lmZmhrd2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix
has been removed from the -mm tree.  Its filename was
     mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch

This patch was dropped because it was folded into mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix

clean up struct init

Cc: Hugh Dickins <hughd@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix
+++ a/mm/swap_state.c
@@ -839,7 +839,9 @@ static struct page *swap_vma_readahead(s
 	swp_entry_t entry;
 	unsigned int i;
 	bool page_allocated;
-	struct vma_swap_readahead ra_info = {1,};
+	struct vma_swap_readahead ra_info = {
+		.win = 1,
+	};
 
 	swap_ra_info(vmf, &ra_info);
 	if (ra_info.win == 1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0.patch
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

