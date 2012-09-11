From: akpm@linux-foundation.org
Subject: [merged] mm-slab-remove-page_get_cache.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:19 -0700
Message-ID: <20120911193220.1AB195C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49126 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2IKTcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:22 -0400
Received: by weyr1 with SMTP id r1so66306wey.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: remove page_get_cache
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-page_get_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/slab.c: remove page_get_cache

page_get_cache() isn't called from anything, so remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-page_get_cache mm/slab.c
--- a/mm/slab.c~mm-slab-remove-page_get_cache
+++ a/mm/slab.c
@@ -515,12 +515,6 @@ EXPORT_SYMBOL(slab_buffer_size);
 static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
-static inline struct kmem_cache *page_get_cache(struct page *page)
-{
-	BUG_ON(!PageSlab(page));
-	return page->slab_cache;
-}
-
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
 	struct page *page = virt_to_head_page(obj);
_

Patches currently in -mm which might be from rientjes@google.com are

slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch
slab-fix-starting-index-for-finding-another-object.patch
slub-consider-pfmemalloc_match-in-get_partial_node.patch
include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
oom-remove-deprecated-oom_adj.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

