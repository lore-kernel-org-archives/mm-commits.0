Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D2BC49EAB
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D5A61220
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFYBdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBdw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1958613B7;
        Fri, 25 Jun 2021 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624584691;
        bh=8X1ncahrHLFih02xxZJA5RIXAoA4KpE7/OKB8IHwQrE=;
        h=Date:From:To:Subject:From;
        b=D0hQuwTNGuRriEwxi4YwHV9aHbfr86rnpOxGYs6g1Vs6CvITAOJYD97BM4oZHuYuH
         23vaovFHJzNCy/inIPH5aWV0uJfssX8g/F5sTaPZNZqCnWX0n/JtSyBZQzaRjV+f9N
         mkAuRe5aAAwBlILowGnlNwVpA0tBLPI4P8tvqT9M=
Date:   Thu, 24 Jun 2021 18:31:30 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        david@redhat.com, hch@infradead.org, imbrenda@linux.ibm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        rientjes@google.com, tglx@linutronix.de, urezki@gmail.com
Subject:  [folded-merged] mm-vmalloc-add-vmalloc_no_huge-fix.patch
 removed from -mm tree
Message-ID: <20210625013130.Y07uSTQs2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-add-vmalloc_no_huge-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-vmalloc_no_huge-fix.patch

This patch was dropped because it was folded into mm-vmalloc-add-vmalloc_no_huge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-add-vmalloc_no_huge-fix

whitespace fixes, per Christoph

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-vmalloc_no_huge-fix
+++ a/mm/vmalloc.c
@@ -3009,8 +3009,9 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vmalloc_no_huge(unsigned long size)
 {
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
-				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
+	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
+				    GFP_KERNEL, PAGE_KERNEL, VM_NO_HUGE_VMAP,
+				    NUMA_NO_NODE, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_no_huge);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-add-vmalloc_no_huge.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-page_alloc-fix-memory-map-initialization-for-descending-nodes-checkpatch-fixes.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
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
linux-next-git-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

