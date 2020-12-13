Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B8AC4361B
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C5A2313B
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgLMGFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Dec 2020 01:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgLMGFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Dec 2020 01:05:47 -0500
Date:   Sat, 12 Dec 2020 22:05:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607839506;
        bh=YCQmwGPd8yp7gErXfKY+TWPfpRT8M7wvItqcCc6n4ko=;
        h=From:To:Subject:From;
        b=AyQlo9N0tvseffLcYeDQ0Cjq8SkAc46L4mJ9eNsGo1kWAxwbMKw+26d9cpGl4jDly
         v1KMA9YiYrRy690ARH7npCycCHN4hppUN9ToRNis+Oc5tXmlWzIw12RokQdJdHK131
         W7HhwrdLJbn/Jw22qb6OqXr1yN+GYypPImNoqVgw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        ast@kernel.org, daniel@iogearbox.net, gthelen@google.com,
        jmforbes@linuxtx.org, josef@toxicpanda.com, jrdr.linux@gmail.com,
        mkubecek@suse.cz, mm-commits@vger.kernel.org, tony.luck@gmail.com
Subject:  [merged]
 revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
 removed from -mm tree
Message-ID: <20201213060505.QLKNUNBXo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
has been removed from the -mm tree.  Its filename was
     revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"

Revert 3351b16af494 ("mm/filemap: add static for function
__add_to_page_cache_locked") due to incompatibility with
ALLOW_ERROR_INJECTION which result in build errors.

Link: https://lkml.kernel.org/r/CAADnVQJ6tmzBXvtroBuEH6QA0H+q7yaSKxrVvVxhqr3KBZdEXg@mail.gmail.com
Tested-by: Justin Forbes <jmforbes@linuxtx.org>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static noinline int __add_to_page_cache_locked(struct page *page,
+noinline int __add_to_page_cache_locked(struct page *page,
 					struct address_space *mapping,
 					pgoff_t offset, gfp_t gfp,
 					void **shadowp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

