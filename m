From: akpm@linux-foundation.org
Subject: [folded-merged] mm-catch-memory-commitment-underflow-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:47:15 -0700
Message-ID: <53e2b073.P8F6c6rtXds6IA9G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:43059 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaHFWrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:47:16 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so436137yha.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:47:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, hughd@google.com, koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-catch-memory-commitment-underflow-fix
has been removed from the -mm tree.  Its filename was
     mm-catch-memory-commitment-underflow-fix.patch

This patch was dropped because it was folded into mm-catch-memory-commitment-underflow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-catch-memory-commitment-underflow-fix

Use VM_WARN_ONCE, per Dave.

Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-catch-memory-commitment-underflow-fix mm/mmap.c
--- a/mm/mmap.c~mm-catch-memory-commitment-underflow-fix
+++ a/mm/mmap.c
@@ -31,6 +31,7 @@
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
+#include <linux/mmdebug.h>
 #include <linux/perf_event.h>
 #include <linux/audit.h>
 #include <linux/khugepaged.h>
@@ -134,11 +135,9 @@ int __vm_enough_memory(struct mm_struct
 {
 	unsigned long free, allowed, reserve;
 
-#ifdef CONFIG_DEBUG_VM
-	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
 			-(s64)vm_committed_as_batch * num_online_cpus(),
 			"memory commitment underflow");
-#endif
 
 	vm_acct_memory(pages);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

