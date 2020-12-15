Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226A4C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19BD2078B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgLOCVD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgLOCU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:20:57 -0500
Date:   Mon, 14 Dec 2020 18:20:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998816;
        bh=9NcLC+zPeRJWdEAoM8htujwnPMaP1i4J0b6XIhcF6Xc=;
        h=From:To:Subject:From;
        b=D9BIYnmKeHCGTsr0KkUJ83z/olv05qy2xl4/YAwsNJrQrH/WtIG5TgWnT0ZJHaCoc
         Dg3g57L4Fb4UZ5Xl37TiL2sWI3zjbVl7M7XnyxejIiDKAGRm2sEKdf+4WH4u1DHJRJ
         g5l14wPW0jdugmGaVQl1M0QipNAS7zu1dPS3k1yg=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        david@redhat.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  [folded-merged]
 mm-cma-improve-pr_debug-log-in-cma_release-fix.patch removed from -mm tree
Message-ID: <20201215022015.OUO3tO376%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-improve-pr_debug-log-in-cma_release-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-improve-pr_debug-log-in-cma_release-fix.patch

This patch was dropped because it was folded into mm-cma-improve-pr_debug-log-in-cma_release.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-improve-pr_debug-log-in-cma_release-fix

fix printk warning

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-improve-pr_debug-log-in-cma_release-fix
+++ a/mm/cma.c
@@ -510,7 +510,7 @@ bool cma_release(struct cma *cma, const
 	if (!cma || !pages)
 		return false;
 
-	pr_debug("%s(page %p, count %zu)\n", __func__, (void *)pages, count);
+	pr_debug("%s(page %p, count %u)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release.patch
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

