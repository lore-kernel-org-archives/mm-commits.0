From: akpm@linux-foundation.org
Subject: + mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch added to -mm tree
Date: Tue, 13 Nov 2012 15:26:39 -0800
Message-ID: <20121113232640.04B85100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52248 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2KMX0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 18:26:41 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so429789qab.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 15:26:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@linux.intel.com, sfr@canb.auug.org.au


The patch titled
     Subject: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix fix fix
has been added to the -mm tree.  Its filename is
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch

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
Subject: MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7 fix fix fix fix

Move the definitions of MAP_HUGE_SHIFT and MAP_HUGE_MASK to mman-common.h
and fixup the architectures which do not use that file to fix the
following build failure:

mm/mmap.c: In function 'SYSC_mmap_pgoff':
mm/mmap.c:1271:15: error: 'MAP_HUGE_SHIFT' undeclared (first use in this function)
mm/mmap.c:1271:15: note: each undeclared identifier is reported only once for each function it appears in
mm/mmap.c:1271:33: error: 'MAP_HUGE_MASK' undeclared (first use in this function)

Tested on alpha, hppa, ia64, mips, powerpc, sparc, and x86.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h          |   11 +++++++++++
 arch/mips/include/uapi/asm/mman.h      |   11 +++++++++++
 arch/parisc/include/uapi/asm/mman.h    |   11 +++++++++++
 arch/xtensa/include/uapi/asm/mman.h    |   11 +++++++++++
 include/uapi/asm-generic/mman-common.h |   11 +++++++++++
 include/uapi/asm-generic/mman.h        |   13 +------------
 6 files changed, 56 insertions(+), 12 deletions(-)

diff -puN arch/alpha/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/arch/alpha/include/asm/mman.h
@@ -63,4 +63,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __ALPHA_MMAN_H__ */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -87,4 +87,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* _ASM_MMAN_H */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -70,4 +70,15 @@
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __PARISC_MMAN_H__ */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -93,4 +93,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */  
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* _XTENSA_MMAN_H */
diff -puN include/uapi/asm-generic/mman-common.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/include/uapi/asm-generic/mman-common.h
@@ -55,4 +55,15 @@
 /* compatibility flags */
 #define MAP_FILE	0
 
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */
+#define MAP_HUGE_SHIFT	26
+#define MAP_HUGE_MASK	0x3f
+
 #endif /* __ASM_GENERIC_MMAN_COMMON_H */
diff -puN include/uapi/asm-generic/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix
+++ a/include/uapi/asm-generic/mman.h
@@ -13,18 +13,7 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
-/* Bits [26:31] are reserved */
-
-/*
- * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
- * This gives us 6 bits, which is enough until someone invents 128 bit address
- * spaces.
- *
- * Assume these are all power of twos.
- * When 0 use the default page size.
- */
-#define MAP_HUGE_SHIFT  26
-#define MAP_HUGE_MASK   0x3f
+/* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-build-warning-for-uninitialized-value.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0.patch
memcg-oom-fix-totalpages-calculation-for-memoryswappiness==0-fix.patch
mips-arc-fix-build-failure.patch
linux-next.patch
irq-tsk-comm-is-an-array.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch
mm-mempolicy-remove-duplicate-code.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
mm-export-a-function-to-get-vm-committed-memory.patch

