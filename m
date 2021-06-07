Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8ED4C47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB5B6124C
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhFHAAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhFHAAw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC94D60FE9;
        Mon,  7 Jun 2021 23:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623110340;
        bh=o7kCxTchQJI3Yd3ma6YqbDPb3UebxpzmfVWXxzlxY4c=;
        h=Date:From:To:Subject:From;
        b=rRJirGShuvABQ1yWesVhDHw9vlTNpUBNMfN/o/S/55ZfnHkCTtr29iISVY6HdmMfz
         /rCFrj05bUYdRP1Uz82wsm5xRX6xDQ5U5YBNKaF6O4ZV6zuS+eJz71w3VDseILTX7W
         /tGm8is42w3+A9PTBv+rfFjyT6mkBCFZRAI8o74I=
Date:   Mon, 07 Jun 2021 16:58:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anton@ozlabs.org,
        benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  +
 lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch added
 to -mm tree
Message-ID: <20210607235859.kkloE2G-w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix
has been added to the -mm tree.  Its filename is
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch

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
Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix

fix comment

Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix
+++ a/include/linux/sched/mm.h
@@ -63,7 +63,8 @@ static inline void mmdrop_lazy_tlb(struc
 	} else {
 		/*
 		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
-		 * membarrier comment finish_task_switch which relies on this.
+		 * membarrier comment in finish_task_switch which relies on
+		 * this.
 		 */
 		smp_mb();
 	}
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
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
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

