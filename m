From: akpm@linux-foundation.org
Subject: + mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch added to -mm tree
Date: Tue, 01 Jul 2014 15:35:43 -0700
Message-ID: <53b337bf.uAX2uGX4vg3MvWWk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:62009 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaGAWfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:35:44 -0400
Received: by mail-ie0-f201.google.com with SMTP id lx4so2379459iec.4
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:35:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: remove hugetlb_zero and hugetlb_infinity
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: remove hugetlb_zero and hugetlb_infinity

They are unnecessary: "zero" can be used in place of "hugetlb_zero" and
passing extra2 == NULL is equivalent to infinity.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 -
 kernel/sysctl.c         |    9 +++------
 mm/hugetlb.c            |    1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/include/linux/hugetlb.h
@@ -84,7 +84,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 #endif
 
 extern unsigned long hugepages_treat_as_movable;
-extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff -puN kernel/sysctl.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity kernel/sysctl.c
--- a/kernel/sysctl.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/kernel/sysctl.c
@@ -1240,8 +1240,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1250,8 +1249,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1274,8 +1272,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	{
diff -puN mm/hugetlb.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/mm/hugetlb.c
@@ -36,7 +36,6 @@
 #include <linux/node.h>
 #include "internal.h"
 
-const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 unsigned long hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
slub-fix-off-by-one-in-number-of-slab-tests.patch
proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
lib-add-size-unit-t-p-e-to-memparse.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

