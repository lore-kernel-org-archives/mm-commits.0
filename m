Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2DBC4743F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9A761185
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFGWjE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhFGWjC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C8661208;
        Mon,  7 Jun 2021 22:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105419;
        bh=WpdCcgVFgzrqseJOjnAJaue15sTEUYCuudXO1gjH5kg=;
        h=Date:From:To:Subject:From;
        b=c/f+uP6YaQqb36sJxSoc1gULRjVFwLMxUL8wGCRXrVUEPncH9ziXq/uLUmhz4Wgt2
         bCHfCqOmWf4dSbeKmCVsCHK4X22a3r/kElvgAT6JhN+waKQVfm4DIM07m+8z8z70Zt
         A7qsszdrUWr1PCM2s5ZkII+ZYB1GEfHMQ+0bSDy0=
Date:   Mon, 07 Jun 2021 15:36:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        christophe.leroy@csgroup.eu, joel@joelfernandes.org,
        kaleshsingh@google.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, naresh.kamboju@linaro.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [to-be-updated]
 mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
 removed from -mm tree
Message-ID: <20210607223658.4-xp2r2C9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix

fix build

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix
+++ a/mm/mremap.c
@@ -216,7 +216,7 @@ static inline void flush_pte_tlb_pwc_ran
 					   unsigned long start,
 					   unsigned long end)
 {
-	return flush_tlb_range(vma, start, end);
+	flush_tlb_range(vma, start, end);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

