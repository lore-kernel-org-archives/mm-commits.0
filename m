From: akpm@linux-foundation.org
Subject: [folded-merged]
 ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch removed from -mm tree
Date: Fri, 01 Apr 2016 14:11:25 -0700
Message-ID: <56fee3fd.ZzOefPG3Y++JqWi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbcDAVL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 17:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2
has been removed from the -mm tree.  Its filename was
     ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch

This patch was dropped because it was folded into ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2

fix non-NUMA build

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2 mm/ksm.c
--- a/mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2
+++ a/mm/ksm.c
@@ -563,7 +563,7 @@ static struct stable_node *alloc_stable_
 		INIT_HLIST_HEAD(&chain->hlist);
 		chain->chain_prune_time = jiffies;
 		chain->rmap_hlist_len = STABLE_NODE_CHAIN;
-#ifdef CONFIG_DEBUG_VM
+#if defined (CONFIG_DEBUG_VM) && defined(CONFIG_NUMA)
 		chain->nid = -1; /* debug */
 #endif
 		ksm_stable_node_chains++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

